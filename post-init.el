;;; post-init.el --- post init -*- no-byte-compile: t; lexical-binding: t; -*-
;;; CODE:

;;; General settings (mostly builtin)
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

(global-visual-wrap-prefix-mode t)
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

(use-package which-key :ensure nil ; builtin
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
  (when (member "JetBrainsMono Nerd Font" (font-family-list))
    (set-frame-font "JetBrainsMono Nerd Font 14" t t)
    (set-face-attribute 'fixed-pitch nil :family "JetBrainsMono Nerd Font")
    (set-face-attribute 'variable-pitch nil :family "Verdana")))
 ((eq system-type 'gnu/linux)
  (when (member "JetBrains Mono" (font-family-list))
    (set-frame-font "JetBrains Mono 11" t t)
    (set-face-attribute 'fixed-pitch nil :family "JetBrains Mono")
    (set-face-attribute 'variable-pitch nil :family "Noto Sans"))))


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

;; Enabled backups save your changes to a file intermittently
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 10)

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

;;; exec-path-from-shell
(use-package exec-path-from-shell
  :if (and (or (display-graphic-p) (daemonp))
           (eq system-type 'darwin)) ; macOS only :ensure t
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
(use-package compile-angel
  :demand t :ensure t
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
  ;; (compile-angel-on-load-mode 1)
  )

;;; Show where the cursor is interactively, inactive region and region changes (beacon, goggles, show-inactive-region)
(use-package beacon :ensure t
  :config (beacon-mode t))

(use-package goggles :ensure t
  :hook ((prog-mode text-mode LaTeX-mode) . goggles-mode)
  :custom
  (goggles-pulse t)
  (goggles-pulse-delay 0.05)
  (goggles-pulse-iterations 20)
  :config
  (goggles-mode))

(use-package show-inactive-region
  ;; Emacs minor mode to highlight the inactive region (between point and mark). :ensure t
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

;;; Duplicate lines
(use-package move-dup :ensure t)

;;; Surround
(use-package surround :ensure t
  :bind-keymap ("M-'" . surround-keymap))

;;; Install supplemetary packages for formatting, LSP, typechecking, etc. (mason)
(use-package mason :ensure t
  :config
  (mason-setup))

(mason-setup
  (dolist (pkg '("basedpyright" "ruff" "clangd" "tex-fmt"))
    (unless (mason-installed-p pkg)
      (ignore-errors (mason-install pkg)))))


;;; Treesitter
(use-package treesit-auto :ensure t
  :custom
  (treesit-auto-install 'prompt)
  (treesit-auto-langs '(awk bash bibtex blueprint c-sharp clojure cmake commonlisp css
                            dart dockerfile elixir glsl go gomod heex html janet java
                            javascript json julia kotlin latex lua magik make markdown nix
                            nu org perl proto python r ruby rust scala sql surface toml
                            tsx typescript typst verilog vhdl vue wast wat wgsl yaml))
  :config
  (global-treesit-auto-mode))

(require 'treesit)

(setq treesit-language-source-alist
      '((markdown
         "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
         "split_parser"
         "tree-sitter-markdown/src")
        (markdown_inline
         "https://github.com/tree-sitter-grammars/tree-sitter-markdown"
         "split_parser"
         "tree-sitter-markdown-inline/src")))

;; (dolist (lang '(markdown markdown_inline))
;;   (unless (treesit-language-available-p lang)
;;     (treesit-install-language-grammar lang)))

;; Set the maximum level of syntax highlighting for Tree-sitter modes
(setq treesit-font-lock-level 4)


;; Intelligent code folding by leveraging the structural understanding of the
;; built-in tree-sitter parser.
(use-package treesit-fold
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)
  :custom
  (treesit-fold-line-count-show t))
(global-treesit-fold-indicators-mode t)
(add-hook 'python-ts-mode-hook #'treesit-fold-mode)

;;; Themes
(use-package doom-modeline :ensure t
  :config (doom-modeline-mode t))

(setq modus-themes-italic-constructs nil
      modus-themes-bold-constructs nil
      modus-themes-disable-other-themes t)

(setq modus-operandi-palette-overrides
      '((bg-prose-block-contents bg-diff-context)
        (bg-prose-block-delimiter bg-tab-bar)
        (fg-prose-block-delimiter "gray22")
        (comment red)))

(setq modus-vivendi-palette-overrides
      '(;; Core Background and Foreground
        (bg-main "#1a1b26")        ;; Editor background (Night)
        (bg-dim "#13141c")         ;; Alternate/Dim background (bg-alt from source)
        (bg-active "#24283b")      ;; Editor background (Storm) / Active elements
        (bg-inactive "#16161e")    ;; Inactive panels
        (fg-main "#a9b1d6")        ;; Editor foreground
        (fg-alt "#c0caf5")         ;; Variables, Class names (base8)
        (fg-dim "#565f89")         ;; Comments (dark-blue)
        (fg-dim-alt "#9099c0")
        ;; --- Semantic Colors (From Provided List) ---
        (red                            "#f7768e")
        (red-warmer                     "#e6785e")
        (red-cooler                     "#e07888")
        (red-faint                      "#e8b8ab")
        (red-intense                    "#e65555")
        (green                          "#9ece6a")
        (green-warmer                   "#5ebc89")
        (green-cooler                   "#73daca")
        (green-faint                    "#7cc2a6")
        (green-intense                  "#3cc9a4")
        (yellow                         "#e0af68")
        (yellow-warmer                  "#f0b060")
        (yellow-cooler                  "#c0cf6a")
        (yellow-faint                   "#e0d38c")
        (yellow-intense                 "#f0c060")
        (blue                           "#7aa2f7")
        (blue-warmer                    "#9ab0f7")
        (blue-cooler                    "#7dcfff")
        (blue-faint                     "#c0d8eb")
        (blue-intense                   "#5a9aff")
        (magenta                        "#bb9af7")
        (magenta-warmer                 "#f7a8d0")
        (magenta-cooler                 "#9d7cd8")
        (magenta-faint                  "#d8c0e8")
        (magenta-intense                "#c07af7")
        (cyan                           "#b4f9f8")
        (cyan-warmer                    "#b3ffd9")
        (cyan-cooler                    "#7de5ff")
        (cyan-faint                     "#6ac4c3")
        (cyan-intense                   "#2ac3de")
        (orange                         "#ff9e64")
        (rust                           "#c07a5a")
        (gold                           "#c0a05b")
        (olive                          "#a3bfa3")
        (slate                          "#8099a0")
        (indigo                         "#857ec5")
        (maroon                         "#b569c0")
        (pink                           "#d8c0e8")
        (bg-red-intense                 "#9d1f1f")
        (bg-green-intense               "#2f822f")
        (bg-yellow-intense              "#7a6100")
        (bg-blue-intense                "#1640b0")
        (bg-magenta-intense             "#7030af")
        (bg-cyan-intense                "#2266ae")
        (bg-red-subtle                  "#620f2a")
        (bg-green-subtle                "#00422a")
        (bg-yellow-subtle               "#4a4000")
        (bg-blue-subtle                 "#242679")
        (bg-magenta-subtle              "#552f5f")
        (bg-cyan-subtle                 "#004065")
        (bg-red-nuanced                 "#3a0c14")
        (bg-green-nuanced               "#092f1f")
        (bg-yellow-nuanced              "#381d0f")
        (bg-blue-nuanced                "#12154a")
        (bg-magenta-nuanced             "#2f0c3f")
        (bg-cyan-nuanced                "#042837")
        (bg-clay                        "#3a1a1a")
        (fg-clay                        "#ffb090")
        (bg-ochre                       "#3a2a1a")
        (fg-ochre                       "#e0c080")
        (bg-lavender                    "#38325c")
        (fg-lavender                    "#dfc0f0")
        (bg-sage                        "#143e32")
        (fg-sage                        "#c3e7d4")
        (bg-graph-red-0                 "#f7768e")
        (bg-graph-red-1                 "#43242b")
        (bg-graph-green-0               "#9ece6a")
        (bg-graph-green-1               "#293e2b")
        (bg-graph-yellow-0              "#e0af68")
        (bg-graph-yellow-1              "#c0a05b")
        (bg-graph-blue-0                "#7aa2f7")
        (bg-graph-blue-1                "#1e2a3a")
        (bg-graph-magenta-0             "#bb9af7")
        (bg-graph-magenta-1             "#2f2a4a")
        (bg-graph-cyan-0                "#7dcfff")
        (bg-graph-cyan-1                "#1e3a4a")
        (bg-completion                  "#28344a")
        (bg-hover                       "#3a4a4a")
        (bg-hover-secondary             "#4a3a2a")
        (bg-hl-line                     "#292e42")
        (bg-region                      "#414868")
        (fg-region                      "#c0caf5")
        (bg-mode-line-active            "#1f2335")
        (fg-mode-line-active            "#c0caf5")
        (border-mode-line-active        "#565f89")
        (bg-mode-line-inactive          "#1f2335")
        (fg-mode-line-inactive          "#a9b1d6")
        (border-mode-line-inactive      "#3b4261")
        (modeline-err                   "#f7768e")
        (modeline-warning               "#e0af68")
        (modeline-info                  "#7dcfff")
        (bg-tab-bar                     "#1f2335")
        (bg-tab-current                 "#1a1b26")
        (bg-tab-other                   "#24283b")
        (bg-added                       "#273a2b")
        (bg-added-faint                 "#1a2a1a")
        (bg-added-refine                "#2a4a2a")
        (bg-added-fringe                "#3a6a3a")
        (fg-added                       "#c0e0c0")
        (fg-added-intense               "#6fcf6f")
        (bg-changed                     "#3a3a1a")
        (bg-changed-faint               "#2a2a0a")
        (bg-changed-refine              "#4a4a1a")
        (bg-changed-fringe              "#6a5a1a")
        (fg-changed                     "#e0c080")
        (fg-changed-intense             "#c0a05b")
        (bg-removed                     "#392a2e")
        (bg-removed-faint               "#2a1a1a")
        (bg-removed-refine              "#4a2a2a")
        (bg-removed-fringe              "#5a2a2a")
        (fg-removed                     "#ffb0b0")
        (fg-removed-intense             "#ff768e")
        (bg-diff-context                "#1a1b26")

        (rainbow-0 fg-main)
        (rainbow-1 blue)
        (rainbow-2 orange)
        (rainbow-3 green-cooler)
        (rainbow-4 cyan-cooler)
        (rainbow-5 yellow)
        (rainbow-6 cyan-intense)
        (rainbow-7 magenta-warmer)
        (rainbow-8 blue-warmer)

        (bg-paren-match magenta-intense)
        (fg-paren-match bg-main)

        (fg-prose-block-delimiter fg-dim)

        (fringe unspecified)
        (bg-line-number-inactive unspecified)
        (border-mode-line-active unspecified)
        (border-mode-line-inactive unspecified)

        (string green)
        (variable fg-main)
        (variable-use fg-main)
        (type fg-main)
        (name blue)
        (fname blue)
        (fname-call blue)
        (builtin red)
        (docstring fg-dim-alt)
        (keyword magenta)
        (property blue-cooler)

        (fg-prompt blue)
        (fg-prose-code blue)
        ;; headers -----------------------
        (fg-heading-1 "#CADAFF")
        (fg-heading-2 "#81ADFF")
        (fg-heading-3 "#FFC9DB")
        (fg-heading-4 "#FF79BA")
        (fg-heading-5 "#FFD474")
        (fg-heading-6 "#E0A200")
        (fg-heading-7 "#15FDD6")
        (fg-heading-8 "#00CBA2")
        ))

;; Fix org block extend
(defun my/fix-org-block-extend (&rest _args)
  (dolist (face '(org-block-begin-line org-block-end-line))
    (when (facep face)
      (set-face-attribute face nil :extend nil))))

(defun my/set-theme-by-time ()
  "Load a light theme between 6:00 and 18:00, and a dark theme otherwise."
  (interactive)
  (let* ((hour (string-to-number (format-time-string "%H")))
         (light-theme 'doom-tokyo-night)
         (dark-theme  'doom-tokyo-night)
         (now-light?  (and (>= hour 6) (< hour 18)))
         (target-theme (if now-light? light-theme dark-theme)))

    ;; Only reload if the target theme isn't already the top active one
    (unless (eq (car custom-enabled-themes) target-theme)
      ;; Disable all currently active themes to ensure a clean switch
      (mapc #'disable-theme custom-enabled-themes)
      (if (eq dark-theme target-theme)
          (progn
            (load-theme target-theme t)
            (my/fix-org-block-extend))
        (load-theme target-theme t))
      (message "Switched to %s theme" target-theme)
      )))
;; Run the check every N seconds
(run-at-time nil 300 #'my/set-theme-by-time)

;;; Git files support (.gitconfig, .gitignore, .gitattributes...)
(use-package git-modes :ensure t
  :commands (gitattributes-mode
             gitconfig-mode
             gitignore-mode)
  :mode (("/\\.gitignore\\'" . gitignore-mode)
         ("/info/exclude\\'" . gitignore-mode)
         ("/git/ignore\\'" . gitignore-mode)
         ("/.gitignore_global\\'" . gitignore-mode)  ; jc-dotfiles

         ("/\\.gitconfig\\'" . gitconfig-mode)
         ("/\\.git/config\\'" . gitconfig-mode)
         ("/modules/.*/config\\'" . gitconfig-mode)
         ("/git/config\\'" . gitconfig-mode)
         ("/\\.gitmodules\\'" . gitconfig-mode)
         ("/etc/gitconfig\\'" . gitconfig-mode)

         ("/\\.gitattributes\\'" . gitattributes-mode)
         ("/info/attributes\\'" . gitattributes-mode)
         ("/git/attributes\\'" . gitattributes-mode)))

;;; YAML support
;; NOTE: Prefer the tree-sitter-based yaml-ts-mode over yaml-mode when
;; available, as it provides more accurate syntax parsing and enhanced editing
;; features.
(use-package yaml-mode :ensure t
  :commands yaml-mode
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)))

;;; Dockerfile support
;; NOTE: Prefer the tree-sitter-based dockerfile-ts-mode over dockerfile-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package dockerfile-mode :ensure t
  :commands dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;;; Support for Gnuplot files
(use-package gnuplot :ensure t
  :commands gnuplot-mode
  :mode ("\\.gp\\'" . gnuplot-mode))

;;; Jinja2 template support for files commonly used in configuration management
;; systems and web frameworks. This mode enables syntax highlighting and basic
;; editing facilities for templates written using the Jinja2 templating
;; language.
(use-package jinja2-mode :ensure t
  :commands jinja2-mode
  :mode ("\\.j2\\'" . jinja2-mode))

;;; CSV file support with automatic column alignment. This configuration enables
;; csv-align-mode whenever a CSV file is opened, improving readability by
;; keeping columns visually aligned according to a configurable maximum width
;; and a set of recognized field separators.
(use-package csv-mode :ensure t
  :commands (csv-mode
             csv-align-mode
             csv-guess-set-separator)
  :mode ("\\.csv\\'" . csv-mode)
  :hook ((csv-mode . csv-align-mode)
         (csv-mode . csv-guess-set-separator))
  :custom
  (csv-align-max-width 100)
  (csv-separators '("," ";" " " "|" "\t")))

;;; Support for Go
;;
;; NOTE: Prefer the tree-sitter-based go-ts-mode over go-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package go-mode :ensure t
  :commands go-mode
  :mode ("\\.go\\'" . go-mode))

;;;; Configuring Eglot for Go
;;;;; Configuring project for Go modules in .emacs
(require 'project)

(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

;;;;; Configuring gopls via Eglot
(setq-default eglot-workspace-configuration
              '((:gopls .
                        ((staticcheck . t)
                         (matcher . "CaseSensitive")))))

;;;;; Organizing Go imports with Eglot
;; (add-hook 'before-save-hook
;;     (lambda ()
;;         (call-interactively 'eglot-code-action-organize-imports))
;;     nil t)

;;; Python
(defun my/setup-python-mode ()
  "Setup my personal setup for Python mode"
  (setq-local tab-width 8)
  (setq-local indent-tabs-mode t)     ; Use tabs, not spaces
  (setq-local fill-column 120)        ; Column limit
  )
(add-hook 'python-mode-hook 'my/setup-python-mode)
(add-hook 'python-ts-mode-hook 'my/setup-python-mode)

(use-package indent-bars :ensure t
  :hook ((python-mode python-ts-mode yaml-mode) . indent-bars-mode)) ; or whichever modes you prefer

;;; Support for Rust
(use-package rust-mode :ensure t
  :commands rust-mode
  :mode ("\\.rs\\'" . rust-mode)
  :custom
  (rust-indent-offset 2))

;;; Major mode for editing crontab files
(use-package crontab-mode :ensure t
  :commands crontab-mode
  :mode ("/crontab\\(\\.X*[[:alnum:]]+\\)?\\'"  . crontab-mode))

;;; Major mode for editing Nginx configuration files
(use-package nginx-mode :ensure t
  :commands nginx-mode
  :mode (("nginx\\.conf\\'" . nginx-mode)
         ("/nginx/.+\\.conf\\'" . nginx-mode)))

;;; Major mode for HashiCorp Configuration Language (HCL) files
(use-package hcl-mode :ensure t
  :commands hcl-mode
  :mode ("\\.hcl\\'" . hcl-mode))

;;; Major mode for Nix expression language files
(use-package nix-mode :ensure t
  :commands nix-mode
  :mode ("\\.nix\\'" . nix-mode))

;;; Major mode for editing Fish shell scripts
(use-package fish-mode :ensure t
  :commands fish-mode
  :mode ("\\.fish\\'" . fish-mode))

;;; Vim configuration file support. This mode provides syntax highlighting and
;; editing support for various Vim configuration files, including vimrc, gvimrc,
;; local overrides, and project-specific configuration files.
(use-package vimrc-mode :ensure t
  :commands vimrc-mode
  :mode ("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;;; Support for Jenkinsfile files
(use-package jenkinsfile-mode :ensure t
  :commands jenkinsfile-mode
  :mode ("Jenkinsfile\\'" . jenkinsfile-mode))

;;; Support for Haskell
(use-package haskell-mode :ensure t
  :commands haskell-mode
  :mode ("\\.hs\\'" . haskell-mode))


;;; GNU Octave
(add-to-list 'auto-mode-alist '("\\.m\\'". octave-mode))

;;; C/C++
(use-package doxymacs :ensure t)

;; Define a custom style matching your clang-format config
(defconst llvm-allman-style
  '((c-basic-offset . 4)
    (c-offsets-alist
     . ((access-label . -)
        (annotation-var-cont . 0)
        (arglist-close . 0)
        (arglist-intro . +)
        (block-close . 0)
        (block-open . 0)
        (brace-entry-open . 0)
        (brace-list-close . 0)
        (brace-list-open . 0)
        (case-label . +)
        (class-close . 0)
        (class-open . 0)
        (comment-intro . 0)
        (cpp-macro . -1000)
        (cpp-macro-cont . +)
        (defun-close . 0)
        (defun-open . 0)
        (extern-lang-close . 0)
        (extern-lang-open . 0)
        (friend . 0)
        (inclass . +)
        (inextern-lang . 0)
        (inher-cont . 0)
        (inher-intro . +)
        (inline-close . 0)
        (inline-open . 0)
        (innamespace . 0)           ; Inner namespace content at column 0
        (knr-argdecl-intro . 5)
        (label . 0)
        (member-init-cont . 0)
        (member-init-intro . +)
        (namespace-close . 0)       ; Close namespace at column 0
        (namespace-open . 0)        ; Start namespace at column 0
        (statement-case-open . +)
        (statement-cont . +)
        (substatement-label . 0)
        (substatement-open . 0)
        (template-args-cont c-lineup-template-args +) ; Template handling
        (topmost-intro . 0)
        (topmost-intro-cont . 0)
        ;; Brace placement for Allman style
        (statement-block-intro . +)))
    ;; Move cleanup list to style definition (optional)
    (c-cleanup-list . (brace-else-brace
                       brace-elseif-brace
                       empty-defun-braces
                       defun-close-semi
                       list-close-comma
                       scope-operator))
    ;; Move hanging braces to style definition
    (c-hanging-braces-alist . ((defun-open after)
                               (defun-close before after)
                               (class-open after)
                               (class-close before after)
                               (namespace-open after)
                               (namespace-close before after)
                               (inline-open after)
                               (inline-close before after)
                               (block-open after)
                               (block-close before after)
                               (extern-lang-open after)
                               (extern-lang-close before after)
                               (statement-case-open after)
                               (substatement-open after))))
  "My personal C/C++ style matching .clang-format configuration.")

;; Register style only for CC-mode
(c-add-style "llvm-allman" llvm-allman-style)

(defun my/setup-c-style ()
  "Setup my personal C/C++ style for all C-like modes."
  ;; Common settings for all C-like modes
  (setq-local tab-width 4)
  (setq-local indent-tabs-mode nil)   ; Use spaces, not tabs
  (setq-local fill-column 120)        ; Column limit
  (setq-local comment-column 40)      ; Align comments to column 40

  ;; Electric pair settings for Allman style braces
  (setq-local electric-pair-preserve-balance t)
  (setq-local electric-pair-open-newline-between-pairs t)

  ;; Set the style - this will apply all settings from llvm-allman-style
  (c-set-style "llvm-allman")

  (setq-local tab-always-indent 'complete)

  ;; Add operator highlighting to C/C++ modes.
  ;; (font-lock-add-keywords
  ;;  nil
  ;;  `(;; Multi-character operators (higher precedence)
  ;;    ("\\(<<\\|>>\\|<=\\|>=\\|==\\|!=\\|&&\\|||\\|\\+\\+\\|--\\)"
  ;;     1 'font-lock-operator-face prepend)
  ;;
  ;;    ;; Single-character operators
  ;;    ("\\([=+*/%&|^!<>?:~-]\\)"
  ;;     1 'font-lock-operator-face prepend))
  ;;  'append)
  )

;; Set default style for new buffers
(setq-default c-default-style '((c-mode . "llvm-allman")
                                (c++-mode . "llvm-allman")
                                (java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

;; Apply to existing buffers via hooks
(add-hook 'c-mode-hook 'my/setup-c-style)
(add-hook 'c++-mode-hook 'my/setup-c-style)

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

;;; Apheleia formatter
;; is an Emacs package designed to run code formatters (e.g., Shfmt,
;; Black and Prettier) asynchronously without disrupting the cursor position.
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

  (push '(tex-fmt . ("tex-fmt" "--stdin")) apheleia-formatters)
  (dolist (mode '(LaTeX-mode latex-mode TeX-latex-mode TeX-mode))
    (setf (alist-get mode apheleia-mode-alist) 'tex-fmt))
  (apheleia-global-mode t)
  )

;;; Rainbow-delimiters
(use-package rainbow-delimiters :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (LaTeX-mode . rainbow-delimiters-mode)))

;;; Window management (golden-ratio)
(use-package golden-ratio :ensure t)

;;; Outli
;; Simple comment-based outline folding for Emacs
(use-package outli :ensure t
  ;; :after lispy ; uncomment only if you use lispy; it also sets speed keys on headers!
  :bind (:map outli-mode-map ; convenience key to get back to containing heading
              ("C-c C-p" . (lambda () (interactive) (outline-back-to-heading))))
  :hook ((prog-mode text-mode) . outli-mode)) ; or whichever modes you prefer


;;; Recentf, savehist, saveplace, autosave, auto-revert
;; is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
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

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
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

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))


;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)

(setq auto-save-interval 300)
(setq auto-save-timeout 30)

;; autorevert is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
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


;;; Corfu
;; enhances in-buffer completion by displaying a compact popup with
;; current candidates, positioned either below or above the point. Candidates
;; can be selected by navigating up or down.
(use-package corfu :ensure t
  :commands (corfu-mode global-corfu-mode)

  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))

  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)

  ;; Enable Corfu
  :config
  (global-corfu-mode))

;;; Cape, or Completion At Point Extensions
;; extends the capabilities of
;; in-buffer completion. It integrates with Corfu or the default completion UI,
;; by providing additional backends through completion-at-point-functions.
(use-package cape :ensure t
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

;;; Vertico + Orderless
;; provides a vertical completion interface, making it easier to
;; navigate and select from completion candidates (e.g., when `M-x` is pressed).
(use-package vertico
  ;; (Note: It is recommended to also enable the savehist package.) :ensure t
  :custom
  ;; (Note: It is recommended to also enable the savehist package.)
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 10) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous' :ensure t
  :config
  (vertico-mode))

;; Configure the directory extension
(use-package vertico-directory
  :after vertico :ensure nil  ; vertico-directory is included with vertico
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
;; integrates with Consult and Vertico to provide context-sensitive
;; actions and quick access to commands based on the current selection, further
;; improving user efficiency and workflow within Emacs. Together, they create a
;; cohesive and powerful environment for managing completions and interactions.
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
  ;; high-performance systems.) Note: Minad, the author of Consult, does not
  ;; recommend aggressive values.
  ;; Read: https://github.com/minad/consult/discussions/951
  ;;
  ;; However, the author of minimal-emacs.d uses these parameters to achieve
  ;; immediate feedback from Consult.
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

;;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.
(use-package undo-fu :ensure t
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
(use-package undo-fu-session :ensure t
  :commands undo-fu-session-global-mode
  :hook (after-init . undo-fu-session-global-mode))


;;; easysession - session manager
;; for Emacs that can persist and restore file editing buffers, indirect
;; buffers/clones, Dired buffers, windows/splits, the built-in tab-bar
;; (including tabs, their buffers, and windows), and Emacs frames. It offers a
;; convenient and effortless way to manage Emacs editing sessions and utilizes
;; built-in Emacs functions to persist and restore frames.
(use-package easysession :ensure t
  :commands (easysession-switch-to
             easysession-save-as
             easysession-save-mode
             easysession-load-including-geometry)

  :custom
  (easysession-mode-line-misc-info t)  ; Display the session in the modeline
  (easysession-save-interval (* 10 60))  ; Save every 10 minutes

  :init
  ;; Key mappings
  (global-set-key (kbd "C-c ss") #'easysession-save)
  (global-set-key (kbd "C-c sl") #'easysession-switch-to)
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  (if (fboundp 'easysession-setup)
      ;; The `easysession-setup' function adds hooks:
      ;; - To enable automatic session loading during `emacs-startup-hook', or
      ;;   `server-after-make-frame-hook' when running in daemon mode.
      ;; - To automatically save the session at regular intervals, and when
      ;;   Emacs exits.
      (easysession-setup)
    ;; Legacy
    ;; The depth 102 and 103 have been added to to `add-hook' to ensure that the
    ;; session is loaded after all other packages. (Using 103/102 is
    ;; particularly useful for those using minimal-emacs.d, where some
    ;; optimizations restore `file-name-handler-alist` at depth 101 during
    ;; `emacs-startup-hook`.)
    (add-hook 'emacs-startup-hook #'easysession-load-including-geometry 102)
    (add-hook 'emacs-startup-hook #'easysession-save-mode 103)))


;;; markdown-mode package provides a major mode for Emacs for syntax
;; highlighting, editing commands, and preview support for Markdown documents.
;; It supports core Markdown syntax as well as extensions like GitHub Flavored
;; Markdown (GFM).
(use-package markdown-mode
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :bind
  (:map markdown-mode-map
        ("C-c C-e" . markdown-do)))

;; Automatically generate a table of contents when editing Markdown files
(use-package markdown-toc :ensure t
  :commands (markdown-toc-generate-toc
             markdown-toc-generate-or-refresh-toc
             markdown-toc-delete-toc
             markdown-toc--toc-already-present-p)
  :custom
  (markdown-toc-header-toc-title "**Table of Contents**"))

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


;;; Spell check
(use-package jinx :ensure t
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

;; Set multiple languages
(setq jinx-languages "en_US ru-yo")

;;; Git diffs (diff-hl)
(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))

;;; Org mode
;; Org mode is a major mode designed for organizing notes, planning, task
;; management, and authoring documents using plain text with a simple and
;; expressive markup syntax. It supports hierarchical outlines, TODO lists,
;; scheduling, deadlines, time tracking, and exporting to multiple formats
;; including HTML, LaTeX, PDF, and Markdown.
(use-package org :ensure t
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)
  :custom
  ;; (org-hide-leading-stars t)
  (org-export-backends '(ascii html icalendar latex beamer odt md))
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  (org-descriptive-links nil)
  (org-fontify-done-headline t)
  (org-fontify-todo-headline t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  (org-startup-truncated t))

(use-package org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode))

(use-package org-sticky-header :ensure t
  :hook (org-mode))

(use-package org-table-sticky-header :ensure t
  :hook (org-mode))

;;; Pretty icons
(use-package nerd-icons :ensure t
  :demand t)

(use-package nerd-icons-completion :ensure t
  :demand t
  :config
  (nerd-icons-completion-mode t))

(use-package nerd-icons-corfu
  :demand t :ensure t)

(use-package treemacs-nerd-icons :ensure t
  :demand t
  :config
  (treemacs-nerd-icons-config))

;;; topsy.el (simple sticky header showing definition beyond top of window)
(use-package topsy :ensure t
  :hook (prog-mode LaTeX-mode))

;;; dogears.el (never lose your place in Emacs again)
(use-package dogears :ensure t
  :config (dogears-mode t)
  :bind (:map global-map
              ("M-g c" . dogears-go)
              ("M-g M-b" . dogears-back)
              ("M-g M-f" . dogears-forward)
              ("M-g M-d" . dogears-list)
              ("M-g M-D" . dogears-sidebar)))

;;; Modern sidebar navigation for files and buffers (ibuffer-sidebar, treemacs, sr-speedbar)

;;;; bufler
(use-package prism :ensure t
  :demand t
  :hook (bufler-list-mode . prism-whitespace-mode))
(add-hook 'after-init-hook #'prism-randomize-colors)
(defun my-prism-after-theme (theme &rest _)
  (prism-randomize-colors))
(advice-add 'enable-theme :after #'my-prism-after-theme)

;; (prism-set-colors :num 16
;;   :desaturations (cl-loop for i from 0 below 16
;;                           collect (* i 2.5))
;;   :lightens (cl-loop for i from 0 below 16
;;                      collect (* i 2.5))
;;   :colors (list "dodgerblue" "medium sea green" "sandy brown")
;;
;;   :comments-fn
;;   (lambda (color)
;;     (prism-blend color
;;                  (face-attribute 'font-lock-comment-face :foreground) 0.25))
;;
;;   :strings-fn
;;   (lambda (color)
;;     (prism-blend color "white" 0.5)))

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

;;;; SpeedBar
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
;; (setq sr-speedbar-auto-refresh nil)
;; (setq sr-speedbar-max-width 70)
;; (setq sr-speedbar-width-console 40)
;; 1. Start Speedbar in buffers mode instead of files mode
(setq speedbar-initial-expansion-list-name "buffers")
;; 2. Disable Quick Buffers to ensure the standard buffer list is displayed.
(setq speedbar-show-quick-buffers nil)
;; 3. Prevent speedbar from reverting to directory/file display automatically.
;; This ensures the speedbar frame remains in buffer mode even when visiting files.
(setq speedbar-track-current-file nil)

;; 4. Disable the default sorting by usage time
;;    - Setting this to nil keeps the order given by `buffer-list`
;;      (which is most recently selected first).
;; (setq speedbar-buffers-sort-function nil)

;; 5. Advise the buffer list function to sort alphabetically.
;; By default, Emacs orders buffers by usage time. This advice enforces alphabetical order.
;; (advice-add 'speedbar-buffer-list :filter-return
;;             (lambda (buffer-list)
;;               (sort buffer-list
;;                     (lambda (a b)
;;                       (string< (buffer-name a) (buffer-name b))))))

(with-eval-after-load 'speedbar
  (define-key speedbar-mode-map (kbd "b") 'speedbar-buffers)
  (define-key speedbar-mode-map (kbd "f") 'speedbar-files))

(setq speedbar-buffers-group-function 'speedbar-group-buffers-by-mode)


;;;; iBuffer
(use-package ibuffer :ensure nil
  :config
  (setq ibuffer-expert t)
  (setq ibuffer-display-summary nil)
  (setq ibuffer-use-other-window nil)
  (setq ibuffer-show-empty-filter-groups nil)
  (setq ibuffer-default-sorting-mode 'filename/process)
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
                    (ibuffer-switch-to-saved-filter-groups "Main")))
  )

(use-package ibuffer-sidebar :ensure t
  :commands (ibuffer-sidebar-toggle-sidebar))

;;;; Treemacs
;; A file and project explorer for Emacs that displays a structured tree
;; layout, similar to file browsers in modern IDEs. It functions as a sidebar
;; in the left window, providing a persistent view of files, projects, and
;; other elements.
(use-package treemacs :ensure t
  :commands (treemacs
             treemacs-select-window
             treemacs-delete-other-windows
             treemacs-select-directory
             treemacs-bookmark
             treemacs-find-file
             treemacs-find-tag)

  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))

  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))

  :config
  (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
        treemacs-deferred-git-apply-delay        0.5
        treemacs-directory-name-transformer      #'identity
        treemacs-display-in-side-window          t
        treemacs-eldoc-display                   'simple
        treemacs-file-event-delay                2000
        treemacs-file-extension-regex            treemacs-last-period-regex-value
        treemacs-file-follow-delay               0.2
        treemacs-file-name-transformer           #'identity
        treemacs-follow-after-init               t
        treemacs-expand-after-init               t
        treemacs-find-workspace-method           'find-for-file-or-pick-first
        treemacs-git-command-pipe                ""
        treemacs-goto-tag-strategy               'refetch-index
        treemacs-header-scroll-indicators        '(nil . "^^^^^^")
        treemacs-hide-dot-git-directory          t
        treemacs-indentation                     2
        treemacs-indentation-string              " "
        treemacs-is-never-other-window           nil
        treemacs-max-git-entries                 5000
        treemacs-missing-project-action          'ask
        treemacs-move-files-by-mouse-dragging    nil
        treemacs-move-forward-on-expand          nil
        treemacs-no-png-images                   nil
        treemacs-no-delete-other-windows         t
        treemacs-project-follow-cleanup          nil
        treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
        treemacs-position                        'left
        treemacs-read-string-input               'from-child-frame
        treemacs-recenter-distance               0.1
        treemacs-recenter-after-file-follow      nil
        treemacs-recenter-after-tag-follow       nil
        treemacs-recenter-after-project-jump     'always
        treemacs-recenter-after-project-expand   'on-distance
        treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
        treemacs-project-follow-into-home        nil
        treemacs-show-cursor                     nil
        treemacs-show-hidden-files               t
        treemacs-silent-filewatch                nil
        treemacs-silent-refresh                  nil
        treemacs-sorting                         'alphabetic-asc
        treemacs-select-when-already-in-treemacs 'move-back
        treemacs-space-between-root-nodes        t
        treemacs-tag-follow-cleanup              t
        treemacs-tag-follow-delay                1.5
        treemacs-text-scale                      nil
        treemacs-user-mode-line-format           nil
        treemacs-user-header-line-format         nil
        treemacs-wide-toggle-width               70
        treemacs-width                           35
        treemacs-width-increment                 1
        treemacs-width-is-initially-locked       t
        treemacs-workspace-switch-cleanup        nil)

  ;; The default width and height of the icons is 22 pixels. If you are
  ;; using a Hi-DPI display, uncomment this to double the icon size.
  ;; (treemacs-resize-icons 44)

  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)

  ;;(when treemacs-python-executable
  ;;  (treemacs-git-commit-diff-mode t))

  (pcase (cons (not (null (executable-find "git")))
               (not (null treemacs-python-executable)))
    (`(t . t)
     (treemacs-git-mode 'deferred))
    (`(t . _)
     (treemacs-git-mode 'simple)))

  (treemacs-hide-gitignored-files-mode nil))

(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

;;; Modern tab bar for Emacs (centaur-tabs)
(use-package centaur-tabs :ensure t
  :custom
  (centaur-tabs-style "box")
  (centaur-tabs-plain-icons t)
  (centaur-tabs-gray-out-icons 'buffer)
  (setq centaur-tabs-set-modified-marker t)
  (centaur-tabs-modified-marker "+")
  (centaur-tabs-height 16)
  (centaur-tabs-set-icons t)
  (centaur-tabs-icon-type 'nerd-icons)
  :config
  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules.

	Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
	All buffer name start with * will group to \"Emacs\".
	Other buffer group by `centaur-tabs-get-group-name' with project name."
    (list
     (cond
      ;; ((not (eq (file-remote-p (buffer-file-name)) nil))
      ;; "Remote")
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(magit-process-mode
                              magit-status-mode
                              magit-diff-mode
                              magit-log-mode
                              magit-file-mode
                              magit-blob-mode
                              magit-blame-mode
                              )))
       "Emacs")
      ((derived-mode-p 'prog-mode)
       "Editing")
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(helpful-mode
                          help-mode))
       "Help")
      ((memq major-mode '(org-mode
                          org-agenda-clockreport-mode
                          org-src-mode
                          org-agenda-mode
                          org-beamer-mode
                          org-indent-mode
                          org-bullets-mode
                          org-cdlatex-mode
                          org-agenda-log-mode
                          diary-mode))
       "OrgMode")
      (t
       (centaur-tabs-get-group-name (current-buffer))))))

  :hook
  (dired-mode . centaur-tabs-local-mode)
  (term-mode . centaur-tabs-local-mode)
  (calendar-mode . centaur-tabs-local-mode)
  (org-agenda-mode . centaur-tabs-local-mode)
  (eshell-mode . centaur-tabs-local-mode)
  (bufler-mode . centaur-tabs-local-mode)
  (minibuffer-mode . centaur-tabs-local-mode)
  (help-mode . centaur-tabs-local-mode)
  (helpful-mode . centaur-tabs-local-mode)
  (woman-mode . centaur-tabs-local-mode)
  (Man-mode . centaur-tabs-local-mode)

  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward)
  ("C-S-<prior>" . centaur-tabs-move-current-tab-to-left)
  ("C-S-<next>" . centaur-tabs-move-current-tab-to-right))

(defun centaur-tabs-hide-tab (x)
  "Do no to show buffer X in tabs."
  (let ((name (format "%s" x)))
    (or
     ;; Current window is not dedicated window.
     (window-dedicated-p (selected-window))

     ;; Buffer name not match below blacklist.
     (string-prefix-p "*epc" name)
     (string-prefix-p "*helm" name)
     (string-prefix-p "*Helm" name)
     (string-prefix-p "*Compile-Log*" name)
     (string-prefix-p "*lsp" name)
     (string-prefix-p "*company" name)
     (string-prefix-p "*Flycheck" name)
     (string-prefix-p "*tramp" name)
     (string-prefix-p " *Mini" name)
     (string-prefix-p "*help" name)
     (string-prefix-p "*straight" name)
     (string-prefix-p " *temp" name)
     (string-prefix-p "*Help" name)
     (string-prefix-p "*mybuf" name)
     (string-prefix-p "*Messages*" name)

     ;; Is not magit buffer.
     (and (string-prefix-p "magit" name)
          (not (file-name-extension name)))
     )))
(centaur-tabs-mode t)

;;; Helpful
;; is an alternative to the built-in Emacs help that provides much more
;; contextual information.
(use-package helpful :ensure t
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-command
             helpful-at-point
             helpful-function)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  :custom
  (helpful-max-buffers 7))

;;; Avy
(use-package avy :ensure t
  :commands (avy-goto-char
             avy-goto-char-2
             avy-next)
  :init
  (global-set-key (kbd "M-RET") 'avy-goto-char))


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


;;; Enables automatic indentation of code while typing (aggressive-indent)
(use-package aggressive-indent :ensure t
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

;;; Elisp quality of life improvements
;;;; Highlights function and variable definitions in Emacs Lisp mode (highlight-defined)
(use-package highlight-defined :ensure t
  :commands highlight-defined-mode
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

;;;; Prevent parenthesis imbalance
(use-package paredit :ensure t
  :commands paredit-mode
  :hook
  (emacs-lisp-mode . paredit-mode)
  :config
  (define-key paredit-mode-map (kbd "RET") nil))

;;;; Displays visible indicators for page breaks
(use-package page-break-lines :ensure t
  :commands (page-break-lines-mode
             global-page-break-lines-mode)
  :hook
  (emacs-lisp-mode . page-break-lines-mode))

;;;; Provides functions to find references to functions, macros, variables,
;; special forms, and symbols in Emacs Lisp
(use-package elisp-refs :ensure t
  :commands (elisp-refs-function
             elisp-refs-macro
             elisp-refs-variable
             elisp-refs-special
             elisp-refs-symbol))

;;; `vterm'
;; is an Emacs terminal emulator that provides a fully interactive shell
;; experience within Emacs, supporting features such as color, cursor movement,
;; and advanced terminal capabilities. Unlike standard Emacs terminal modes,
;; `vterm' utilizes the libvterm C library for high-performance emulation. This
;; ensures accurate terminal behavior when running shell programs, text-based
;; applications, and REPLs.
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

;;; LaTeX setup
;;; latex.el --- fast latex input -*- no-byte-compile: t; lexical-binding: t; -*-
;; This elisp code uses use-package, a macro to simplify configuration. It will
;; install it if it's not available, so please edit the following code as
;; appropriate before running it.

;; AucTeX settings - almost no changes
(use-package latex :ensure auctex
  :hook ((LaTeX-mode . prettify-symbols-mode))
  :bind (:map LaTeX-mode-map
              ("C-S-e" . latex-math-from-calc))
  :custom
  (prettify-symbols-unprettify-at-point t)
  :config
  ;; Format math as a Latex string with Calc
  (defun latex-math-from-calc ()
    "Evaluate `calc' on the contents of line at point."
    (interactive)
    (cond ((region-active-p)
           (let* ((beg (region-beginning))
                  (end (region-end))
                  (string (buffer-substring-no-properties beg end)))
             (kill-region beg end)
             (insert (calc-eval `(,string calc-language latex
                                          calc-prefer-frac t
                                          calc-angle-mode rad)))))
          (t (let ((l (thing-at-point 'line)))
               (end-of-line 1) (kill-line 0)
               (insert (calc-eval `(,l
                                    calc-language latex
                                    calc-prefer-frac t
                                    calc-angle-mode rad))))))))


(use-package preview :ensure nil
  :after latex
  :hook ((LaTeX-mode . preview-larger-previews))
  :custom
  (preview-bb-filesize 4096)
  (preview-TeX-bb-border 2)
  ;; (preview-prefer-TeX-bb t)
  :config
  (defun preview-larger-previews ()
    (setq preview-scale-function
          (lambda () (* 0.7
                        (funcall (preview-scale-from-face)))))))

(setq org-preview-latex-default-process 'dvisvgm) ; No blur when scaling

(defun my/text-scale-adjust-latex-previews ()
  "Adjust the size of latex preview fragments when changing the
buffer's text scale."
  (pcase major-mode
    ('LaTeX-mode
     (dolist (ov (overlays-in (point-min) (point-max)))
       (if (eq (overlay-get ov 'category)
               'preview-overlay)
           (my/text-scale--resize-fragment ov))))
    ('org-mode
     (dolist (ov (overlays-in (point-min) (point-max)))
       (if (eq (overlay-get ov 'org-overlay-type)
               'org-latex-overlay)
           (my/text-scale--resize-fragment ov))))))

(defun my/text-scale--resize-fragment (ov)
  (overlay-put
   ov 'display
   (cons 'image
         (plist-put
          (cdr (overlay-get ov 'display))
          :scale (+ 1.0 (* 0.25 text-scale-mode-amount))))))

(add-hook 'text-scale-mode-hook #'my/text-scale-adjust-latex-previews)

;; CDLatex settings
(use-package cdlatex :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex)
  :bind (:map cdlatex-mode-map
              ("<tab>" . cdlatex-tab)))

;; Array/tabular input with org-tables and cdlatex
(use-package org-table :ensure nil
  :after cdlatex
  :bind (:map orgtbl-mode-map
              ("<tab>" . lazytab-org-table-next-field-maybe)
              ("TAB" . lazytab-org-table-next-field-maybe))
  :init
  (add-hook 'cdlatex-tab-hook 'lazytab-cdlatex-or-orgtbl-next-field 90)
  ;; Tabular environments using cdlatex
  (add-to-list 'cdlatex-command-alist '("smat" "Insert smallmatrix env"
                                        "\\left( \\begin{smallmatrix} ? \\end{smallmatrix} \\right)"
                                        lazytab-position-cursor-and-edit
                                        nil nil t))
  (add-to-list 'cdlatex-command-alist '("bmat" "Insert bmatrix env"
                                        "\\begin{bmatrix} ? \\end{bmatrix}"
                                        lazytab-position-cursor-and-edit
                                        nil nil t))
  (add-to-list 'cdlatex-command-alist '("pmat" "Insert pmatrix env"
                                        "\\begin{pmatrix} ? \\end{pmatrix}"
                                        lazytab-position-cursor-and-edit
                                        nil nil t))
  (add-to-list 'cdlatex-command-alist '("tbl" "Insert table"
                                        "\\begin{table}\n\\centering ? \\caption{}\n\\end{table}\n"
                                        lazytab-position-cursor-and-edit
                                        nil t nil))

  )
;; Tab handling in org tables
(defun lazytab-position-cursor-and-edit ()
  ;; (if (search-backward "\?" (- (point) 100) t)
  ;;     (delete-char 1))
  (cdlatex-position-cursor)
  (lazytab-orgtbl-edit))

(defun lazytab-orgtbl-edit ()
  (advice-add 'orgtbl-ctrl-c-ctrl-c :after #'lazytab-orgtbl-replace)
  (orgtbl-mode 1)
  (open-line 1)
  (insert "\n|"))

(defun lazytab-orgtbl-replace (_)
  (interactive "P")
  (unless (org-at-table-p) (user-error "Not at a table"))
  (let* ((table (org-table-to-lisp))
         params
         (replacement-table
          (if (texmathp)
              (lazytab-orgtbl-to-amsmath table params)
            (orgtbl-to-latex table params))))
    (kill-region (org-table-begin) (org-table-end))
    (open-line 1)
    (push-mark)
    (insert replacement-table)
    (align-regexp (region-beginning) (region-end) "\\([:space:]*\\)& ")
    (orgtbl-mode -1)
    (advice-remove 'orgtbl-ctrl-c-ctrl-c #'lazytab-orgtbl-replace)))

(defun lazytab-orgtbl-to-amsmath (table params)
  (orgtbl-to-generic
   table
   (org-combine-plists
    '(:splice t
              :lstart ""
              :lend " \\\\"
              :sep " & "
              :hline nil
              :llend "")
    params)))

(defun lazytab-cdlatex-or-orgtbl-next-field ()
  (when (and (bound-and-true-p orgtbl-mode)
             (org-table-p)
             (looking-at "[[:space:]]*\\(?:|\\|$\\)")
             (let ((s (thing-at-point 'sexp)))
               (not (and s (assoc s cdlatex-command-alist-comb)))))
    (call-interactively #'org-table-next-field)
    t))

(defun lazytab-org-table-next-field-maybe ()
  (interactive)
  (if (bound-and-true-p cdlatex-mode)
      (cdlatex-tab)
    (org-table-next-field)))

;;; Colorize strings that are plain-text colors (colorful mode)
(use-package colorful-mode :ensure t
  :custom
  (colorful-use-prefix t)
  (colorful-only-strings 'only-prog)
  (css-fontify-colors nil)
  :config
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'helpful-mode))

;;; quickrun.el - quickly run most code file
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

;;; casual.el - A collection of opinionated keyboard-driven user interfaces for various built-in Emacs modes.
(use-package casual :ensure t)

;;; russian language
(setq calendar-latitude 55.75     ; Moscow
      calendar-longitude 37.62)

;;;; Language input config
(setq-default default-input-method 'russian-computer)
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

;;; move to the beginning of comment, indentation, line (move where I mean)
(use-package mwim :ensure t)
(keymap-global-unset "C-a")
(keymap-global-unset "C-e")
(keymap-global-set "C-a" #'mwim-beginning)
(keymap-global-set "C-e" #'mwim-end)

;;; Quickly generate linear ranges in Emacs (tiny)
(use-package tiny :ensure t :defer t)

;;; minor mode that guesses the indentation offset
(use-package dtrt-indent :ensure t :defer t)

;;; lice.el (License And Header Template)
(use-package lice :ensure t)
