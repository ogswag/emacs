;;; post-init.el --- post init -*- no-byte-compile: t; lexical-binding: t; -*-
;;; CODE:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;    ▄▄▄▄· ▄• ▄▌▪  ▄▄▌  ▄▄▄▄▄▪   ▐ ▄      ▄▄·        ▐ ▄ ·▄▄▄▪   ▄▄ •
;;    ▐█ ▀█▪█▪██▌██ ██•  •██  ██ •█▌▐█    ▐█ ▌▪▪     •█▌▐█▐▄▄·██ ▐█ ▀ ▪
;;    ▐█▀▀█▄█▌▐█▌▐█·██▪   ▐█.▪▐█·▐█▐▐▌    ██ ▄▄ ▄█▀▄ ▐█▐▐▌██▪ ▐█·▄█ ▀█▄
;;    ██▄▪▐█▐█▄█▌▐█▌▐█▌▐▌ ▐█▌·▐█▌██▐█▌    ▐███▌▐█▌.▐▌██▐█▌██▌.▐█▌▐█▄▪▐█
;;    ·▀▀▀▀  ▀▀▀ ▀▀▀.▀▀▀  ▀▀▀ ▀▀▀▀▀ █▪    ·▀▀▀  ▀█▄▀▪▀▀ █▪▀▀▀ ▀▀▀·▀▀▀▀
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load custom-file 'noerror 'no-message)

(setq display-buffer-base-action '((display-buffer-reuse-window display-buffer-use-some-window)))

(with-eval-after-load 'ibuffer
  (define-key ibuffer-mode-map [mouse-1] 'ibuffer-mouse-visit-buffer))

;; Enable automatic insertion and management of matching pairs of characters
;; (e.g., (), {}, "") globally using `electric-pair-mode'.
(use-package elec-pair :ensure nil
  :commands (electric-pair-mode
             electric-pair-local-mode
             electric-pair-delete-pair)
  :hook (after-init . electric-pair-mode))

;; Allow Emacs to upgrade built-in packages, such as Org mode
(setq package-install-upgrade-built-in t)

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(delete-selection-mode 1)

(use-package visual-line-mode :ensure nil
  :hook (LaTeX-mode latex-mode tex-mode eshell-mode text-mode helpful-mode help-mode))

;; (global-visual-wrap-prefix-mode t)
(global-goto-address-mode t)

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Display of line numbers in the buffer:
(use-package display-line-numbers :ensure nil
  :demand t
  :hook (prog-mode text-mode LaTeX-mode)
  :custom
  (display-line-numbers-grow-only t)
  (display-line-numbers-width-start t)
  ;; (display-line-numbers-type 'relative)
  )

(use-package which-key :ensure t ; builtin
  :commands which-key-mode
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))

;; Precise/smoother scrolling
(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))
  (setq ns-pop-up-frames nil)
  (setq pixel-scroll-precision-use-momentum nil)
  (pixel-scroll-precision-mode 1))

;; Display the time in the modeline
(add-hook 'after-init-hook #'display-time-mode)

;; Paren match highlighting
(add-hook 'after-init-hook #'show-paren-mode)

(cond
 ((eq system-type 'windows-nt)
  (when (member "Consolas" (font-family-list))
    (set-frame-font "Consolas" t t)))
 ((eq system-type 'darwin) ; macOS
  (when (member "Pragmasevka" (font-family-list))
    (set-frame-font "Pragmasevka 16" t t)
    (set-face-attribute 'fixed-pitch nil :family "Pragmasevka")
    (set-face-attribute 'variable-pitch nil :family "Verdana")))
 ((eq system-type 'gnu/linux)
  (when (member "JetBrains Mono" (font-family-list))
    (set-frame-font "JetBrains Mono 11" t t)
    (set-face-attribute 'fixed-pitch nil :family "JetBrains Mono")
    (set-face-attribute 'variable-pitch nil :family "Noto Sans"))))

(use-package ligature
  :ensure t
  :demand t
  :config
  (ligature-set-ligatures 'prog-mode '("--" "---" "==" "!=" "=!="
                                       "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++" "***" ";;" "!!"
                                       "??" "???" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<:<" "<>" "<<<" ">>>"
                                       "<<" ">>" "||" "-|" "_|_" "|-" "||-" "|=" "||=" "##" "###" "####"
                                       "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#=" "^=" "<$>" "<$"
                                       "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</" "</>" "/>" "<!--" "<#--"
                                       "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>"
                                       "==>" "=>" "=>>" ">=>" ">>=" ">>-" ">-" "-<" "-<<" ">->" "<-<" "<-|"
                                       "<=|" "|=>" "|->" "<->" "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~"
                                       "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]" "|>" "<|" "||>" "<||"
                                       "|||>" "<|||" "<|>" "..." ".." ".=" "..<" ".?" "::" ":::" ":=" "::="
                                       ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__" "???"
                                       "<:<" ";;;"))
  (global-ligature-mode t))

;; Track changes in the window configuration, allowing undoing actions such as
;; closing windows.
(setq winner-boring-buffers '("*Completions*"
                              "*Minibuf-0*"
                              "*Minibuf-1*"
                              "*Minibuf-2*"
                              "*Minibuf-3*"
                              "*Minibuf-4*"
                              "*Compile-Log*"
                              "*inferior-lisp*"
                              "*Fuzzy Completions*"
                              "*Apropos*"
                              "*Help*"
                              "*cvs*"
                              "*Buffer List*"
                              "*Ibuffer*"
                              "*esh command on file*"))
(add-hook 'after-init-hook #'winner-mode)

(use-package uniquify :ensure nil
  :custom
  (uniquify-buffer-name-style 'reverse)
  (uniquify-separator "✦")
  (uniquify-after-kill-buffer-p t))

;; dired: Group directories first
(with-eval-after-load 'dired
  (let ((args "--group-directories-first -ahlv"))
    (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
      (if-let* ((gls (executable-find "gls")))
          (setq insert-directory-program gls)
        (setq args nil)))
    (when args
      (setq dired-listing-switches args))))

;; Enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)

;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)

(setq tooltip-hide-delay 20)    ; Time in seconds before a tooltip disappears (default: 10)
(setq tooltip-delay 0.4)        ; Delay before showing a tooltip after mouse hover (default: 0.7)
(setq tooltip-short-delay 0.08) ; Delay before showing a short tooltip (Default: 0.1)
(tooltip-mode 1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'LaTeX-mode-hook
          (lambda () (setq-local show-trailing-whitespace t)))
(add-hook 'text-mode-hook
          (lambda () (setq-local show-trailing-whitespace t)))
(add-hook 'prog-mode-hook
          (lambda () (setq-local show-trailing-whitespace t)))

(global-hl-line-mode t)

(setq woman-cache-filename "~/.emacs.d/var/wmncach.el")
(setq woman-cache-level 3)

;; Use zsh for shell commands and make it interactive
(setq shell-file-name "zsh")
(setq shell-command-switch "-ic")
(defun my/shell-command-colorize ()
  (when (equal (buffer-name) "*Shell Command Output*")
    (ansi-color-apply-on-buffer)))
(add-hook 'shell-command-setup-hook #'my/shell-command-colorize)

;; "stretch" cursor to show the width of certain symbols (usually tabs)
(setq x-stretch-cursor t)

;;; Recentf, savehist, saveplace, autosave, auto-revert
(use-package recentf :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode)

  :init
  (setq recentf-auto-cleanup 'mode)
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

(use-package savehist :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :custom
  (savehist-save-minibuffer-history t)
  (savehist-additional-variables
   '(kill-ring                        ; clipboard
     register-alist                   ; macros
     mark-ring global-mark-ring       ; marks
     search-ring regexp-search-ring))
  :init
  (setq history-length 300))

(use-package saveplace :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))

(setq auto-save-default nil)
(setq make-backup-files nil)

(use-package autorevert :ensure nil
  :commands (auto-revert-mode global-auto-revert-mode)
  :hook
  (after-init . global-auto-revert-mode)
  :init
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil)
  (setq auto-revert-verbose t))

;; calendar info
(setq calendar-latitude 55.75     ; Moscow
      calendar-longitude 37.62)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;     ▄▄▄· ▄▄▄·  ▄▄· ▄ •▄  ▄▄▄·  ▄▄ • ▄▄▄ .     ▄▄·        ▐ ▄ ·▄▄▄▪   ▄▄ •     .▄▄ · ▄▄▄▄▄ ▄▄▄· ▄▄▄  ▄▄▄▄▄.▄▄ ·      ▄ .▄▄▄▄ .▄▄▄  ▄▄▄ .
;;    ▐█ ▄█▐█ ▀█ ▐█ ▌▪█▌▄▌▪▐█ ▀█ ▐█ ▀ ▪▀▄.▀·    ▐█ ▌▪▪     •█▌▐█▐▄▄·██ ▐█ ▀ ▪    ▐█ ▀. •██  ▐█ ▀█ ▀▄ █·•██  ▐█ ▀.     ██▪▐█▀▄.▀·▀▄ █·▀▄.▀·
;;     ██▀·▄█▀▀█ ██ ▄▄▐▀▀▄·▄█▀▀█ ▄█ ▀█▄▐▀▀▪▄    ██ ▄▄ ▄█▀▄ ▐█▐▐▌██▪ ▐█·▄█ ▀█▄    ▄▀▀▀█▄ ▐█.▪▄█▀▀█ ▐▀▀▄  ▐█.▪▄▀▀▀█▄    ██▀▐█▐▀▀▪▄▐▀▀▄ ▐▀▀▪▄
;;    ▐█▪·•▐█ ▪▐▌▐███▌▐█.█▌▐█ ▪▐▌▐█▄▪▐█▐█▄▄▌    ▐███▌▐█▌.▐▌██▐█▌██▌.▐█▌▐█▄▪▐█    ▐█▄▪▐█ ▐█▌·▐█ ▪▐▌▐█•█▌ ▐█▌·▐█▄▪▐█    ██▌▐▀▐█▄▄▌▐█•█▌▐█▄▄▌
;;    .▀    ▀  ▀ ·▀▀▀ ·▀  ▀ ▀  ▀ ·▀▀▀▀  ▀▀▀     ·▀▀▀  ▀█▄▀▪▀▀ █▪▀▀▀ ▀▀▀·▀▀▀▀      ▀▀▀▀  ▀▀▀  ▀  ▀ .▀  ▀ ▀▀▀  ▀▀▀▀     ▀▀▀ · ▀▀▀ .▀  ▀ ▀▀▀
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; exec-path-from-shell
(use-package exec-path-from-shell
  :if (and (or (display-graphic-p) (daemonp))
           (eq system-type 'darwin)) ; macOS only
  :ensure t
  :demand t
  :functions exec-path-from-shell-initialize
  :config
  (dolist (var '("TMPDIR"
                 "SSH_AUTH_SOCK" "SSH_AGENT_PID"
                 "GPG_AGENT_INFO"
                 ;; "FZF_DEFAULT_COMMAND" "FZF_DEFAULT_OPTS" ; fzf
                 ;; "VIRTUAL_ENV" ; Python
                 ;; "GOPATH" "GOROOT" "GOBIN" ; Go
                 ;; "CARGO_HOME" "RUSTUP_HOME" ; Rust
                 ;; "NVM_DIR" "NODE_PATH" ; Node/JS
                 "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var))
  ;; Initialize
  (exec-path-from-shell-initialize))

;;; Compile Angel
(use-package compile-angel :ensure t
  :demand t
  :config
  ;; The following disables compilation of packages during installation, compile-angel will handle it.
  (setq package-native-compile nil)

  ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
  ;; (When set to nil, compile-angel won't show which file is being compiled.)
  (setq compile-angel-verbose t)

  (push "/init.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/post-init.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)

  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; A global mode that compiles .el files prior to loading them via `load' or
  ;; `require'. Additionally, it compiles all packages that were loaded before
  ;; the mode `compile-angel-on-load-mode' was activated.
  (compile-angel-on-load-mode 1)
  )


;;; THEMES

(load (expand-file-name "themes.el" user-emacs-directory) t t)


;;; Treesitter

;; (use-package treesit-auto :ensure t
;;   :custom
;;   (treesit-auto-install 'prompt)
;;   (treesit-auto-langs '(awk bash bibtex blueprint c-sharp clojure cmake commonlisp css
;;                             dart dockerfile elixir glsl go gomod heex html janet java
;;                             javascript json julia kotlin latex lua magik make markdown nix
;;                             nu org perl proto python r ruby rust scala sql surface toml
;;                             tsx typescript typst verilog vhdl vue wast wat wgsl yaml))
;;   :config
;;   (global-treesit-auto-mode))

;; (require 'treesit)

;; (setq treesit-language-source-alist
;;       '((markdown
;;          "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
;;          "split_parser"
;;          "tree-sitter-markdown/src")
;;         (markdown_inline
;;          "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
;;          "split_parser"
;;          "tree-sitter-markdown-inline/src")))

;; ;; (dolist (lang '(markdown markdown_inline))
;; ;;   (unless (treesit-language-available-p lang)
;; ;;     (treesit-install-language-grammar lang)))

;; ;; Set the maximum level of syntax highlighting for Tree-sitter modes
;; (setq treesit-font-lock-level 4)

;; ;;;; treesitter code folding
;; (use-package treesit-fold
;;   :commands (treesit-fold-close
;;              treesit-fold-close-all
;;              treesit-fold-open
;;              treesit-fold-toggle
;;              treesit-fold-open-all
;;              treesit-fold-mode
;;              global-treesit-fold-mode
;;              treesit-fold-open-recursively
;;              treesit-fold-line-comment-mode)
;;   :custom
;;   (treesit-fold-line-count-show t))
;; (global-treesit-fold-indicators-mode t)
;; (add-hook 'python-ts-mode-hook #'treesit-fold-mode)

;;; Compilation setup
(use-package fancy-compilation :ensure t
  :commands (fancy-compilation-mode)
  :config
  (fancy-compilation-mode t))

;;;; Compile
(require 'compile)
(add-hook 'c-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (if (file-exists-p "Makefile")
                     ;; If Makefile exists, use "make -k" with current filename as target
                     (let ((target (file-name-sans-extension
                                    (file-name-nondirectory buffer-file-name))))
                       (format "make -k %s" target))
                   ;; Otherwise, use the default compilation command
                   (let ((file (file-name-nondirectory buffer-file-name)))
                     (format "%s -c -o %s.o %s %s %s"
                             (or (getenv "CC") "gcc")
                             (file-name-sans-extension file)
                             (or (getenv "CPPFLAGS") "-DDEBUG=9")
                             (or (getenv "CFLAGS") "-ansi -pedantic -Wall -g")
                             file))))))

;;; apheleia formatter
(use-package apheleia :ensure t
  :hook ((prog-mode . apheleia-mode))
  :config
  ;; Configure formatters after apheleia loads
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff))
  (setf (alist-get 'c++-mode apheleia-mode-alist)
        '(clang-format))
  (setf (alist-get 'c++-ts-mode apheleia-mode-alist)
        '(clang-format))

  ;; (push '(tex-fmt . ("tex-fmt" "--stdin")) apheleia-formatters)
  ;; (dolist (mode '(LaTeX-mode latex-mode TeX-latex-mode TeX-mode))
  ;;   (setf (alist-get mode apheleia-mode-alist) 'tex-fmt))
  (apheleia-global-mode t))

;;; Vertico + Orderless
(use-package vertico :ensure t
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 10) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous' :ensure t
  :config
  (vertico-mode))

;; Configure the directory extension
(use-package vertico-directory
  :after vertico
  :ensure nil  ; vertico-directory is included with vertico
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)      ; Enter directories
              ("DEL" . vertico-directory-delete-char) ; Smart backspace
              ("M-DEL" . vertico-directory-delete-word)) ; Delete whole directory
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;;;; Orderless + Vertico = flexible matching capabilities
;; allowing users to input multiple patterns separated by spaces, which
;; Orderless then matches in any order against the candidates.
(use-package orderless :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;;; Marginalia
;; allows Embark to offer you preconfigured actions in more contexts.
;; In addition to that, Marginalia also enhances Vertico by adding rich
;; annotations to the completion candidates displayed in Vertico's interface.
(use-package marginalia :ensure t
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

;;; Embark
(use-package embark
  ;; Embark is an Emacs package that acts like a context menu, allowing
  ;; users to perform context-sensitive actions on selected items
  ;; directly from the completion interface. :ensure t
  :commands (embark-act
             embark-dwim
             embark-export
             embark-collect
             embark-bindings
             embark-prefix-help-command)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;; Consult
;; offers a suite of commands for efficient searching, previewing, and
;; interacting with buffers, file contents, and more, improving various tasks.
(keymap-global-unset "M-c" t)
(use-package consult :ensure t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)

         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)

         ("M-c l" . consult-line)
         ("M-c i" . consult-imenu)
         ("M-c o" . consult-outline)

         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Aggressive asynchronous that yield instantaneous results. (suitable for
  ;; high-performance systems.)
  (setq consult-async-input-debouncex 0.02
        consult-async-input-throttle 0.05
        consult-async-refresh-delay 0.02)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;     ▌ ▐· ▄▄▄· ▄▄▄  ▪        ▄• ▄▌.▄▄ ·      ▄▄·        ▐ ▄ ·▄▄▄▪   ▄▄ •     ·▄▄▄▪  ▄▄▌  ▄▄▄ ..▄▄ ·
;;    ▪█·█▌▐█ ▀█ ▀▄ █·██ ▪     █▪██▌▐█ ▀.     ▐█ ▌▪▪     •█▌▐█▐▄▄·██ ▐█ ▀ ▪    ▐▄▄·██ ██•  ▀▄.▀·▐█ ▀.
;;    ▐█▐█•▄█▀▀█ ▐▀▀▄ ▐█· ▄█▀▄ █▌▐█▌▄▀▀▀█▄    ██ ▄▄ ▄█▀▄ ▐█▐▐▌██▪ ▐█·▄█ ▀█▄    ██▪ ▐█·██▪  ▐▀▀▪▄▄▀▀▀█▄
;;     ███ ▐█ ▪▐▌▐█•█▌▐█▌▐█▌.▐▌▐█▄█▌▐█▄▪▐█    ▐███▌▐█▌.▐▌██▐█▌██▌.▐█▌▐█▄▪▐█    ██▌.▐█▌▐█▌▐▌▐█▄▄▌▐█▄▪▐█
;;    . ▀   ▀  ▀ .▀  ▀▀▀▀ ▀█▄▀▪ ▀▀▀  ▀▀▀▀     ·▀▀▀  ▀█▄▀▪▀▀ █▪▀▀▀ ▀▀▀·▀▀▀▀     ▀▀▀ ▀▀▀.▀▀▀  ▀▀▀  ▀▀▀▀
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load (expand-file-name "smol.el" user-emacs-directory) t t)
(load (expand-file-name "lang.el" user-emacs-directory) t t)
(load (expand-file-name "complete.el" user-emacs-directory) t t)
;; (load (expand-file-name "orgmode.el" user-emacs-directory) t t)
;; (load (expand-file-name "latex-editor.el" user-emacs-directory) t t)

(load (expand-file-name "keyboard.el" user-emacs-directory) t t)
