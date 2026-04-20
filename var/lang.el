;;; lang.el --- various programming langs support -*- no-byte-compile: t; lexical-binding: t; -*-
;;; CODE:

;;; ELISP packages
;;;; Enables automatic indentation of code while typing (aggressive-indent)
(use-package aggressive-indent :ensure t
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

;;;; Highlights function and variable definitions in Emacs Lisp mode (highlight-defined)
(use-package highlight-defined :ensure t
  :commands highlight-defined-mode
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

;;;; Displays visible indicators for page breaks
(use-package page-break-lines :ensure t
  :commands (page-break-lines-mode
             global-page-break-lines-mode)
  :hook
  (emacs-lisp-mode . page-break-lines-mode))

;;;; Provides functions to find references to functions, macros, variables, special forms, and symbols in Emacs Lisp
(use-package elisp-refs :ensure t
  :commands (elisp-refs-function
             elisp-refs-macro
             elisp-refs-variable
             elisp-refs-special
             elisp-refs-symbol))


;;; Support for Dockerfile files.
;;
(use-package dockerfile-mode :ensure t
  :commands dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))
;;; Git files support (.gitconfig, .gitignore, .gitattributes...)
(use-package git-modes :ensure t
  :commands (gitattributes-mode
             gitconfig-mode
             gitignore-mode)
  :mode (("/\\.gitignore\\'"       . gitignore-mode)
         ("/info/exclude\\'"       . gitignore-mode)
         ("/git/ignore\\'"         . gitignore-mode)
         ("/.gitignore_global\\'"  . gitignore-mode)  ; jc-dotfiles

         ("/\\.gitconfig\\'"       . gitconfig-mode)
         ("/\\.git/config\\'"      . gitconfig-mode)
         ("/modules/.*/config\\'"  . gitconfig-mode)
         ("/git/config\\'"         . gitconfig-mode)
         ("/\\.gitmodules\\'"      . gitconfig-mode)
         ("/etc/gitconfig\\'"      . gitconfig-mode)

         ("/\\.gitattributes\\'"   . gitattributes-mode)
         ("/info/attributes\\'"    . gitattributes-mode)
         ("/git/attributes\\'"     . gitattributes-mode)))

;;;; Git diffs (diff-hl)
(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))

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

;;; Python
(defun my/setup-python-mode ()
  "Setup my personal setup for Python mode"
  (setq-local tab-width 4)
  (setq-local indent-tabs-mode t)     ; Use tabs, not spaces
  (setq-local fill-column 120))
(add-hook 'python-mode-hook 'my/setup-python-mode)
(add-hook 'python-ts-mode-hook 'my/setup-python-mode)

(use-package uv
  :load-path "~/.emacs.d/var/packlocal"
  :bind ("C-c u" . uv))

;;; Go
(use-package go-mode :ensure t
  :commands go-mode
  :mode ("\\.go\\'" . go-mode))

;;; Rust
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

;;; Vim configuration file support.
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

;;; YAML
(use-package yaml-mode :ensure t
  :defer t)

;;; GNU Octave
(add-to-list 'auto-mode-alist '("\\.m\\'". octave-mode))

;;; C/C++
(use-package doxymacs :ensure t)

;;; markdown-mode
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

(defconst Google-clang-format
  '((c-basic-offset . 2)
    (c-offsets-alist . ((innamespace . 0)     ;; namespace indentation: none
                        (access-label . -)    ;; public/private: one level out
                        (inclass . +)         ;; class contents indented
                        (template-args-cont . c-lineup-template-args-indented)
                        (arglist-cont-nonempty . +)))
    (fill-column . 120)                        ;; column limit for auto-fill
    (c-hanging-braces-alist . ((brace-list-open)
                               (brace-entry-open)
                               (substatement-open after)
                               (block-close . c-snug-do-close)
                               (extern-lang-open after)))
    (c-hanging-colons-alist . ((member-init-intro before)
                               (inher-intro)
                               (case-label after)
                               (label after)
                               (access-label after)))
    (c-cleanup-list . (scope-operator
                       list-close-comma
                       defun-close-semi)))
  "My custom C++ style based on Google with 120 column limit.")

;; Add the style to the list
(c-add-style "Google" Google-clang-format)

(defun my/setup-c-style ()
  "Setup my personal C/C++ style for all C-like modes."
  ;; Common settings for all C-like modes
  (setq-local tab-width 8)
  (setq-local indent-tabs-mode t)
  (setq-local fill-column 120)
  ;; (setq-local comment-column 40)      ; Align comments to column 40

  ;; Electric pair settings for Allman style braces
  (setq-local electric-pair-preserve-balance t)
  (setq-local electric-pair-open-newline-between-pairs t)

  ;; Set the style - this will apply all settings from llvm-allman-style
  (c-set-style "linux")

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
(setq-default c-default-style '((c-mode . "linux")
                                (c++-mode . "linux")
                                (java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

;; Apply to existing buffers via hooks
(add-hook 'c-mode-hook 'my/setup-c-style)
(add-hook 'c++-mode-hook 'my/setup-c-style)

;;; TSX
(use-package jtsx
  :ensure t
  :mode (("\\.jsx?\\'" . jtsx-jsx-mode))
  :commands jtsx-install-treesit-language
  :hook ((jtsx-jsx-mode . hs-minor-mode)
         (jtsx-tsx-mode . hs-minor-mode)
         (jtsx-typescript-mode . hs-minor-mode))
  :custom
  ;; Optional customizations
  (js-indent-level 4)
  (typescript-ts-mode-indent-offset 4)
  ;; (jtsx-switch-indent-offset 0)
  ;; (jtsx-indent-statement-block-regarding-standalone-parent nil)
  (jtsx-jsx-element-move-allow-step-out t)
  (jtsx-enable-jsx-electric-closing-element t)
  (jtsx-enable-electric-open-newline-between-jsx-element-tags t)
  ;; (jtsx-enable-jsx-element-tags-auto-sync nil)
  (jtsx-enable-all-syntax-highlighting-features ))

(use-package typescript-mode
  :ensure nil
  :mode (("\\.tsx\\'" . typescript-mode)
         ("\\.ts\\'" . typescript-mode)))
