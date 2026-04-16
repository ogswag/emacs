;;; smol.el --- Misc, but very cool and needed packages -*- no-byte-compile: t; lexical-binding: t; -*-
;;; CODE:


;;; add russian-computer to input languages

(setq-default default-input-method 'russian-computer)

;;; reverse-im -- make shortcuts work with non-latin keyboard layouts

(use-package reverse-im :ensure t :demand t
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t)
  ;; On Linux with Fcitx/IBus, also configure native input method
  (when (eq system-type 'gnu/linux)
    ;; Try to use IBus if available
    (if-let* ((ibus-method (getenv "IBUS_ADDRESS")))
        (message "IBus detected, using native input method")
      ;; Fall back to reverse-im
      (message "Using reverse-im for Russian input"))))


;;; jinx -- spell check

(use-package jinx :ensure t
  :custom (jinx-languages "en_US ru-yo")
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))


;;; move to the beginning of comment, indentation, line (move where I mean)

(use-package mwim :ensure t)
(keymap-global-unset "C-a")
(keymap-global-unset "C-e")
(keymap-global-set "C-a" #'mwim-beginning)
(keymap-global-set "C-e" #'mwim-end)


;;; show colors in files

(use-package colorful-mode :ensure t
  :custom
  (colorful-only-strings 'only-prog)
  (css-fontify-colors nil)
  :config
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'helpful-mode))


;;; Quickly generate linear ranges in Emacs (tiny)

(use-package tiny :ensure t :defer t)


;;; minor mode that guesses the indentation offset

(use-package dtrt-indent :ensure t :defer t)


;;; lice.el (License and Header Template)

(use-package lice :ensure t)


;;; pulse after cursor jump

(use-package beacon :ensure t
  :config (beacon-mode t))


;;; pulse modified region

(use-package goggles :ensure t
  :hook ((prog-mode text-mode LaTeX-mode) . goggles-mode)
  :custom
  (goggles-pulse t)
  (goggles-pulse-delay 0.05)
  (goggles-pulse-iterations 20)
  :config
  (goggles-mode))


;;; minor mode to highlight the inactive region (between point and mark).

(use-package show-inactive-region :ensure t
  :commands (show-inactive-region-mode)
  :custom
  (show-inactive-region-fade-out 0.1)
  (show-inactive-region-face-dynamic-factor 0.1))
;; (require 'show-inactive-region)
;; (add-hook 'prog-mode-hook #'show-inactive-region-mode)
;; (add-hook 'text-mode-hook #'show-inactive-region-mode)
;; (add-hook 'LaTeX-mode-hook #'show-inactive-region-mode)


;;; Goto last cursor places (goto-change, goto-last-point)

(use-package goto-chg :ensure t)

(use-package goto-last-point :ensure t
  :config (goto-last-point-mode))


;;; Duplicate and Move lines

(use-package move-dup :ensure t)


;;; Surround

(use-package surround :ensure t
  :bind-keymap ("M-'" . surround-keymap))

 ;;; Pretty icons (nerd-icons)
(use-package nerd-icons :ensure t
  :demand t)

(use-package nerd-icons-completion :ensure t
  :demand t
  :config
  (nerd-icons-completion-mode t))

(use-package nerd-icons-corfu
  :demand t :ensure t)

;;; Rainbow-delimiters
(use-package rainbow-delimiters :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (LaTeX-mode . rainbow-delimiters-mode)
         (org-mode . rainbow-delimiters-mode)))

;;; golden ratio for window placement and auto-resizing windows
(use-package golden-ratio :ensure t)

;;; Outli
;; Simple comment-based outline folding for Emacs
(use-package outli :ensure t
  ;; :after lispy ; uncomment only if you use lispy; it also sets speed keys on headers!
  :bind (:map outli-mode-map ; convenience key to get back to containing heading
              ("C-c C-p" . (lambda () (interactive) (outline-back-to-heading))))
  :hook ((prog-mode text-mode LaTeX-mode) . outli-mode)) ; or whichever modes you prefer


;;; quickrun.el - quickly run most code files

(use-package quickrun :ensure t :defer t)
;; Configure it like this:
;; ;; Use this parameter as C++ default
;; (quickrun-add-command "c++/c1z"
;;   '((:command . "g++")
;;     (:exec    . ("%c -std=c++1z %o -o %e %s"
;;                  "%e %a"))
;;     (:remove  . ("%e")))
;;   :default "c++")
;;
;; ;; Use this parameter in pod-mode
;; (quickrun-add-command "pod"
;;   '((:command . "perldoc")
;;     (:exec    . "%c -T -F %s"))
;;   :mode 'pod-mode)
;;
;; ;; You can override existing command
;; (quickrun-add-command "c/gcc"
;;   '((:exec . ("%c -std=c++1z %o -o %e %s"
;;               "%e %a")))
;;   :override t)


;;; vterm

(use-package vterm
  :if (bound-and-true-p module-file-suffix)
  :commands (vterm
             vterm-send-string
             vterm-send-return
             vterm-send-key
             vterm-module-compile)

  :preface
  (when noninteractive
    ;; vterm unnecessarily triggers compilation of vterm-module.so upon loading.
    ;; This prevents that during byte-compilation (`use-package' eagerly loads
    ;; packages when compiling).
    (advice-add #'vterm-module-compile :override #'ignore))

  (defun my-vterm--setup ()
    ;; Hide the mode-line
    (setq mode-line-format nil)

    ;; Inhibit early horizontal scrolling
    (setq-local hscroll-margin 0)

    ;; Suppress prompts for terminating active processes when closing vterm
    (setq-local confirm-kill-processes nil))

  :init
  (add-hook 'vterm-mode-hook #'my-vterm--setup)

  (setq vterm-timer-delay 0.05)  ; Faster vterm
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-max-scrollback 5000))


;;; topsy.el (simple sticky header showing definition beyond top of window)

;; (use-package topsy :ensure t
;;   :hook (prog-mode LaTeX-mode))


;;; dogears.el (never lose your place in Emacs again)

(use-package dogears :ensure t
  :config (dogears-mode t)
  :bind (:map global-map
              ("M-g c" . dogears-go)
              ("M-g M-b" . dogears-back)
              ("M-g M-f" . dogears-forward)
              ("M-g M-d" . dogears-list)
              ("M-g M-D" . dogears-sidebar)))


;;; prism -- colorize code by indent level

(use-package prism :ensure t
  :demand t
  :hook (bufler-list-mode . prism-whitespace-mode))
(add-hook 'after-init-hook #'prism-randomize-colors)
;; (defun my-prism-after-theme (theme &rest _)
;;  (prism-randomize-colors))
;; (advice-add 'enable-theme :after #'my-prism-after-theme)


;;; bufler -- modern buffer menu

(use-package bufler :ensure
  :demand t
  :custom
  (bufler-vc-state t)
  (bufler-vc-remote t)
  (bufler-vc-refresh t)
  (bufler-column-name-modified-buffer-sigil "+")
  (bufler-column-Name-max-width 33)
  :bind
  (("M-9" . bufler-sidebar))
  :config
  ;; Bind mouse-1 in the bufler list mode to switch buffers
  (define-key bufler-list-mode-map (kbd "<double-mouse-1>") #'bufler-list-buffer-switch))


;;; SpeedBar

(use-package sr-speedbar :ensure t
  :demand t)
(setq speedbar-frame-parameters
      '((minibuffer)
	    (width . 40)
	    (border-width . 0)
	    (menu-bar-lines . 0)
	    (tool-bar-lines . 0)
	    (unsplittable . t)
	    (left-fringe . 0)))
(setq speedbar-hide-button-brackets-flag t)
(setq speedbar-show-unknown-files t)
(setq speedbar-smart-directory-expand-flag t)
(setq speedbar-use-images nil)
(setq speedbar-initial-expansion-list-name "buffers")


;;; ibuffer

(use-package ibuffer :ensure nil
  :config
  (setq ibuffer-expert t)
  (setq ibuffer-display-summary nil)
  (setq ibuffer-use-other-window nil)
  (setq ibuffer-show-empty-filter-groups nil)
  (setq ibuffer-default-sorting-mode 'filename/process)
  (setq ibuffer-sorting-mode 'alphabetic)
  (setq ibuffer-title-face 'font-lock-doc-face)
  (setq ibuffer-use-header-line t)
  (setq ibuffer-default-shrink-to-minimum-size nil)
  (setq ibuffer-formats
        '((mark modified read-only locked " "
                (name 30 30 :left :elide)
                " "
                (size 9 -1 :right)
                " "
                (mode 16 16 :left :elide)
                " " filename-and-process)
          (mark " "
                (name 16 -1)
                " " filename)))
  (setq ibuffer-saved-filter-groups
        '(("Main"
           ("Directories" (mode . dired-mode))
           ("C++" (or
                   (mode . c++-mode)
                   (mode . c++-ts-mode)
                   (mode . c-mode)
                   (mode . c-ts-mode)
                   (mode . c-or-c++-ts-mode)))
           ("Python" (or
                      (mode . python-ts-mode)
                      (mode . c-mode)
                      (mode . python-mode)))
           ("Build" (or
                     (mode . make-mode)
                     (mode . makefile-gmake-mode)
                     (name . "^Makefile$")
                     (mode . change-log-mode)))
           ("Scripts" (or
                       (mode . shell-script-mode)
                       (mode . shell-mode)
                       (mode . sh-mode)
                       (mode . lua-mode)
                       (mode . bat-mode)))
           ("Config" (or
                      (mode . conf-mode)
                      (mode . conf-toml-mode)
                      (mode . toml-ts-mode)
                      (mode . conf-windows-mode)
                      (name . "^\\.clangd$")
                      (name . "^\\.gitignore$")
                      (name . "^Doxyfile$")
                      (name . "^config\\.toml$")
                      (mode . yaml-mode)))
           ("Web" (or
                   (mode . mhtml-mode)
                   (mode . html-mode)
                   (mode . web-mode)
                   (mode . nxml-mode)))
           ("CSS" (or
                   (mode . css-mode)
                   (mode . sass-mode)))
           ("JS" (or
                  (mode . js-mode)
                  (mode . rjsx-mode)))
           ("Markup" (or
                      (mode . markdown-mode)
                      (mode . adoc-mode)))
           ("Org" (mode . org-mode))
           ("LaTeX" (name . "\.tex$"))
           ("Magit" (or
                     (mode . magit-blame-mode)
                     (mode . magit-cherry-mode)
                     (mode . magit-diff-mode)
                     (mode . magit-log-mode)
                     (mode . magit-process-mode)
                     (mode . magit-status-mode)))
           ("Apps" (or
                    (mode . elfeed-search-mode)
                    (mode . elfeed-show-mode)))
           ("Fundamental" (or
                           (mode . fundamental-mode)
                           (mode . text-mode)))
           ("Emacs" (or
                     (mode . emacs-lisp-mode)
                     (name . "^\\*Help\\*$")
                     (name . "^\\*Custom.*")
                     (name . "^\\*Org Agenda\\*$")
                     (name . "^\\*info\\*$")
                     (name . "^\\*scratch\\*$")
                     (name . "^\\*Backtrace\\*$")
                     (name . "^\\*Messages\\*$"))))))
  :hook
  (ibuffer-mode . (lambda ()
                    (ibuffer-switch-to-saved-filter-groups "Main"))))


;;; avy -- jump anywhere

(use-package avy :ensure t
  :commands (avy-goto-char
             avy-goto-char-2
             avy-next)
  :custom
  (avy-style 'at)           ;; labels replace the whole target “slot”
  (avy-background t)        ;; dim everything else
  (avy-all-windows t)
  :init
  (global-set-key (kbd "M-RET") 'avy-goto-subword-0))


;;; bufferfile.el package provides helper functions to delete, rename, or copy buffer files:

;;
;; bufferfile-rename: Renames the file visited by the current buffer, ensures
;; that the destination directory exists, and updates the buffer name for all
;; associated buffers, including clones/indirect buffers. It also ensures that
;; buffer-local features referencing the file, such as Eglot or dired buffers,
;; are correctly updated to reflect the new file name.
;;
;; bufferfile-delete: Delete the file associated with a buffer and kill all
;; buffers visiting the file, including clones/indirect buffers.
;;
;; bufferfile-copy: Ensures that the destination directory exists and copies
;; the file visited by the current buffer to a new file.
(use-package bufferfile :ensure t
  :commands (bufferfile-copy
             bufferfile-rename
             bufferfile-delete)
  :custom
  ;; If non-nil, display messages during file renaming operations
  (bufferfile-verbose nil)

  ;; If non-nil, enable using version control (VC) when available
  (bufferfile-use-vc nil)

  ;; Specifies the action taken after deleting a file and killing its buffer.
  (bufferfile-delete-switch-to 'parent-directory))


;;; undo-fu

(use-package undo-fu :ensure t
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

(use-package undo-fu-session :ensure t
  :commands undo-fu-session-global-mode
  :hook (after-init . undo-fu-session-global-mode))


;;; easysession - session manager

;; (use-package easysession :ensure t
;;   :commands (easysession-switch-to
;;              easysession-save-as
;;              easysession-save-mode
;;              easysession-load-including-geometry)
;;   :custom
;;   (easysession-mode-line-misc-info t)  ; Display the session in the modeline
;;   (easysession-save-interval (* 10 60))  ; Save every 10 minutes
;;   :init
;;   ;; Key mappings
;;   (global-set-key (kbd "C-c ss") #'easysession-save)
;;   (global-set-key (kbd "C-c sl") #'easysession-switch-to)
;;   (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
;;   (global-set-key (kbd "C-c sr") #'easysession-rename)
;;   (global-set-key (kbd "C-c sR") #'easysession-reset)
;;   (global-set-key (kbd "C-c sd") #'easysession-delete)
;;
;;   (if (fboundp 'easysession-setup)
;;       ;; The `easysession-setup' function adds hooks:
;;       ;; - To enable automatic session loading during `emacs-startup-hook', or
;;       ;;   `server-after-make-frame-hook' when running in daemon mode.
;;       ;; - To automatically save the session at regular intervals, and when
;;       ;;   Emacs exits.
;;       (easysession-setup)
;;     ;; Legacy
;;     ;; The depth 102 and 103 have been added to to `add-hook' to ensure that the
;;     ;; session is loaded after all other packages. (Using 103/102 is
;;     ;; particularly useful for those using minimal-emacs.d, where some
;;     ;; optimizations restore `file-name-handler-alist` at depth 101 during
;;     ;; `emacs-startup-hook`.)
;;     (add-hook 'emacs-startup-hook #'easysession-load-including-geometry 102)
;;     (add-hook 'emacs-startup-hook #'easysession-save-mode 103)))

;;; Dumb-Jump - "jump to definition" package for 60+ languages
(use-package dumb-jump
  :commands dumb-jump-xref-activate
  :init
  ;; Register `dumb-jump' as an xref backend so it integrates with
  ;; `xref-find-definitions'. A priority of 90 ensures it is used only when no
  ;; more specific backend is available.
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 90)
  (setq xref-show-definitions-function #'consult-xref)
  (setq dumb-jump-aggressive nil)
  ;; (setq dumb-jump-quiet t)

  ;; Number of seconds a rg/grep/find command can take before being warned to
  ;; use ag and config.
  (setq dumb-jump-max-find-time 3)

  ;; Use `completing-read' so that selection of jump targets integrates with the
  ;; active completion framework (e.g., Vertico, Ivy, Helm, Icomplete),
  ;; providing a consistent minibuffer-based interface whenever multiple
  ;; definitions are found.
  (setq dumb-jump-selector 'completing-read)

  ;; If ripgrep is available, force `dumb-jump' to use it because it is
  ;; significantly faster and more accurate than the default searchers (grep,
  ;; ag, etc.).
  (when (executable-find "rg")
    (setq dumb-jump-force-searcher 'rg)
    (setq dumb-jump-prefer-searcher 'rg)))
