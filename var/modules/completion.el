;;; completion.el --- completion in Emacs -*- no-byte-compile: t; lexical-binding: t; -*-
;;; CODE:

(defcustom +corfu-want-ret-to-confirm t
  "Configure how the user expects RET to behave.

Possible values are:
- t (default): Insert candidate if one is selected, pass-through otherwise;
- nil: Pass-through without inserting;
- `both': Insert candidate if one is selected, then pass-through;
- `minibuffer': Behaves like `both` in the minibuffer and `t` otherwise."
  :type '(choice (const :tag "Insert if selected, passthrough otherwise" t)
                 (const :tag "Passthrough without insertion" nil)
                 (const :tag "Insert if selected, then passthrough" both)
                 (const :tag "Behaves like `both' in minibuffer, `t' otherwise" minibuffer))
  :group '+corfu)

(defcustom +corfu-buffer-scanning-size-limit (* 1 1024 1024) ; 1 MB
  "Size limit in bytes for a buffer to be scanned by `cape-dabbrev'."
  :type 'integer
  :group '+corfu)

(defcustom +corfu-want-minibuffer-completion t
  "Whether to enable Corfu in the minibuffer.

Possible values are:
- t: enable Corfu only if `completion-at-point' is bound in the minibuffer's
  `current-local-map'.
- nil: Corfu is disabled in the minibuffer.
- aggressive: enable Corfu even when no recognized completion framework is
  active."
  :type '(choice (const :tag "Disabled" nil)
                 (const :tag "Aggressive" aggressive)
                 (const :tag "Only when bound" t))
  :group '+corfu)

(defcustom +corfu-want-tab-prefer-expand-snippets nil
  "If non-nil, expand snippets over cycling candidates with TAB."
  :type 'boolean
  :group '+corfu)

(defcustom +corfu-want-tab-prefer-navigating-snippets nil
  "If non-nil, navigate snippets over cycling candidates with TAB/S-TAB."
  :type 'boolean
  :group '+corfu)

(defcustom +corfu-want-tab-prefer-navigating-org-tables nil
  "If non-nil, navigate org tables over cycling candidates with TAB/S-TAB."
  :type 'boolean
  :group '+corfu)

(defcustom +corfu-inhibit-auto-functions ()
  "A list of predicate functions that take no arguments.

If any return non-nil, `corfu-auto' will not invoke as-you-type completion."
  :type 'hook
  :group '+corfu)


;;
;;; Packages

(use-package corfu :ensure t
  :config
  (setq corfu-auto t
        global-corfu-modes
        '((not erc-mode
               circe-mode
               help-mode
               gud-mode
               vterm-mode)
          t)
        corfu-cycle t
        corfu-preselect 'prompt
        corfu-count 16
        corfu-max-width 120
        corfu-on-exact-match nil
        corfu-quit-at-boundary (if (or (featurep 'vertico)
                                       (featurep 'orderless))
                                   'separator t)
        corfu-quit-no-match corfu-quit-at-boundary)

  (add-to-list 'completion-category-overrides `(lsp-capf (styles ,@completion-styles)))
  (add-to-list 'corfu-continue-commands #'+corfu/move-to-minibuffer)
  (add-to-list 'corfu-continue-commands #'+corfu/smart-sep-toggle-escape)
  (add-hook 'evil-insert-state-exit-hook #'corfu-quit)

  (defun +corfu--other-completion-active-p ()
    "Return non-nil if another completion framework is already active.

This checks for several completion systems such as mct, vertico,
auth-source’s read-passwd-map, helm, ido, and ivy. When one of these
systems is active, Corfu should not enable its own completion."
    (or (bound-and-true-p mct--active)
        (bound-and-true-p vertico--input)
        (and (featurep 'auth-source)
             (eq (current-local-map) read-passwd-map))
        (and (featurep 'helm-core)
             (helm--alive-p))
        (and (featurep 'ido)
             (ido-active))
        (where-is-internal 'minibuffer-complete (list (current-local-map)))
        (memq #'ivy--queue-exhibit post-command-hook)))

  (defun +corfu-enable-in-minibuffer-p ()
    "Return non-nil if Corfu should be enabled in the minibuffer.

See `+corfu-want-minibuffer-completion'."
    (pcase +corfu-want-minibuffer-completion
      ('nil nil)
      ('aggressive (not (+corfu--other-completion-active-p)))
      (_ (and (where-is-internal #'completion-at-point
                                 (list (current-local-map)))
              (not (+corfu--other-completion-active-p))))))

  (setq global-corfu-minibuffer #'+corfu-enable-in-minibuffer-p)

  ;; HACK: If you want to update the visual hints after completing minibuffer
  ;;   commands with Corfu and exiting, you have to do it manually.
  (defun +corfu--insert-before-exit-minibuffer ()
    (when (or (and (frame-live-p corfu--frame)
                   (frame-visible-p corfu--frame))
              (and (featurep 'corfu-terminal)
                   (popon-live-p corfu-terminal--popon)))
      (when (member isearch-lazy-highlight-timer timer-idle-list)
        (apply (timer--function isearch-lazy-highlight-timer)
               (timer--args isearch-lazy-highlight-timer)))
      (when (member (bound-and-true-p anzu--update-timer) timer-idle-list)
        (apply (timer--function anzu--update-timer)
               (timer--args anzu--update-timer)))
      (when (member (bound-and-true-p evil--ex-search-update-timer)
                    timer-idle-list)
        (apply (timer--function evil--ex-search-update-timer)
               (timer--args evil--ex-search-update-timer)))))
  (advice-add #'exit-minibuffer :before #'+corfu--insert-before-exit-minibuffer)

  ;; HACK: If your dictionaries aren't set up in text-mode buffers, ispell will
  ;;   continuously pester you about errors. This ensures it only happens once
  ;;   per session.
  (defun +corfu--auto-disable-ispell-capf (fn &rest args)
    "If ispell isn't properly set up, only complain once per session."
    (condition-case-unless-debug e
        (apply fn args)
      ('error
       (message "Error: %s" (error-message-string e))
       (message "Auto-disabling `text-mode-ispell-word-completion'")
       (setq text-mode-ispell-word-completion nil)
       (remove-hook 'completion-at-point-functions #'ispell-completion-at-point t))))
  (advice-add #'ispell-completion-at-point :around #'+corfu--auto-disable-ispell-capf))

(add-hook 'on-first-file-hook #'global-corfu-mode)

(use-package corfu-auto
  :ensure nil
  :defer t
  :config
  (setq corfu-auto-delay
        (if (eq system-type 'darwin)
            0.4   ; macOS is slower, so go easy on it
          0.24)
        corfu-auto-prefix 2)
  (add-to-list 'corfu-auto-commands #'lispy-colon)

  (when (featurep 'evil)
    ;; Modifying the buffer while in replace mode can be janky.
    (add-to-list '+corfu-inhibit-auto-functions #'evil-replace-state-p))

  ;; HACK: Augments Corfu to respect `+corfu-inhibit-auto-functions'.
  (defun +corfu--post-command-advice (fn &rest args)
    "Refresh Corfu after last command."
    (let ((corfu-auto
           (if corfu-auto
               (not (run-hook-with-args-until-success '+corfu-inhibit-auto-functions)))))
      (apply fn args)))
  (advice-add #'corfu--popup-support-p :around #'+corfu--post-command-advice))


(use-package cape
  :ensure t
  :init
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'completion-at-point-functions #'cape-file -10 t)))
  (add-hook 'org-mode-hook
            (lambda ()
              (add-hook 'completion-at-point-functions #'cape-elisp-block 0 t)))
  (add-hook 'markdown-mode-hook
            (lambda ()
              (add-hook 'completion-at-point-functions #'cape-elisp-block 0 t)))

  ;; Enable Dabbrev completion basically everywhere as a fallback.
  ;; Use a variable to control this feature (default: t)
  (when (bound-and-true-p +corfu-enable-dabbrev)  ; set this to t if you want dabbrev
    (setq cape-dabbrev-check-other-buffers t)
    (dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook
                                   comint-mode-hook minibuffer-setup-hook eshell-mode-hook))
      (add-hook hook
                (lambda ()
                  (add-hook 'completion-at-point-functions #'cape-dabbrev 20 t))))
    (with-eval-after-load 'dabbrev
      (setq dabbrev-friend-buffer-function #'+corfu-dabbrev-friend-buffer-p
            dabbrev-ignored-buffer-regexps
            '("\\` "
              "\\(?:\\(?:[EG]?\\|GR\\)TAGS\\|e?tags\\|GPATH\\)\\(<[0-9]+>\\)?")
            dabbrev-upcase-means-case-search t)
      (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
      (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
      (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode)))

  ;; Make these capfs composable.
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'comint-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'eglot-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'pcomplete-completions-at-point :around #'cape-wrap-nonexclusive)
  ;; From the `cape' readme. Without this, Eshell autocompletion is broken on
  ;; Emacs28.
  (when (< emacs-major-version 29)
    (advice-add #'pcomplete-completions-at-point :around #'cape-wrap-silent)
    (advice-add #'pcomplete-completions-at-point :around #'cape-wrap-purify))

  (when (featurep 'latex-mode)
    ;; Allow file completion on latex directives.
    (add-hook 'tex-mode-local-vars-hook #'set-cape-file-prefix)
    (add-hook 'latex-mode-local-vars-hook #'set-cape-file-prefix)
    (add-hook 'LaTeX-mode-local-vars-hook #'set-cape-file-prefix))
  (defun set-cape-file-prefix ()
    (setq-local cape-file-prefix "{")))


(use-package yasnippet-capf
  :ensure t
  :defer t
  :init
  (when (featurep 'yasnippet)
    (add-hook 'yas-minor-mode-hook
              (lambda ()
                (add-hook 'completion-at-point-functions #'yasnippet-capf 30 t)))))


(use-package corfu-terminal
  :ensure t
  :if (and (not (display-graphic-p))   ; :os tty
           (not (featurep 'tty-child-frames)))
  :hook ((corfu-mode . corfu-terminal-mode)))


;;; Extensions

(use-package corfu-history :ensure nil
  :hook ((corfu-mode . corfu-history-mode))
  :config
  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package corfu-popupinfo :ensure nil
  :hook ((corfu-mode . corfu-popupinfo-mode))
  :config
  (setq corfu-popupinfo-delay '(0.5 . 1.0)))

(use-package nerd-icons-corfu
  :ensure t
  :if (featurep 'nerd-icons-corfu)   ; or (boundp 'nerd-icons-corfu-formatter)
  :defer t
  :init
  (with-eval-after-load 'corfu
    (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)))

;; If vertico is not enabled, orderless will be installed but not configured.
;; That may break smart separator behavior, so we conditionally configure it.
(use-package orderless
  :ensure t
  :if (and (not (featurep 'vertico))
           (bound-and-true-p +corfu-use-orderless))   ; set this to t if you want orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles orderless partial-completion)))
        orderless-component-separator #'orderless-escapable-split-on-space))

;;; Mason - installs supplemetary packages for formatting, LSP, typechecking, etc.

;; (use-package mason :ensure t
;;   :config
;;   (mason-setup))
;;
;; (mason-setup
;;  (dolist (pkg '("basedpyright" "ruff" "clangd" "tex-fmt"))
;;    (unless (mason-installed-p pkg)
;;      (ignore-errors (mason-install pkg)))))
