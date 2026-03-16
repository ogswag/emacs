;;; complete.el --- completion in Emacs -*- no-byte-compile: t; lexical-binding: t; -*-
;;; CODE:


;;; Corfu -- completion popups

(use-package corfu
  :ensure t
  :commands (corfu-mode global-corfu-mode)

  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode)
		 (LaTeX-mode . corfu-mode))

  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-cycle t)
  ;; Enable Corfu
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode))


;;; Cape = Completion At Point Extensions

(use-package cape :ensure t
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
										; (add-hook 'completion-at-point-functions #'cape-dabbrev)
										; (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))


;;; Mason - installs supplemetary packages for formatting, LSP, typechecking, etc.

(use-package mason :ensure t
  :config
  (mason-setup))

(mason-setup
  (dolist (pkg '("basedpyright" "ruff" "clangd" "tex-fmt"))
    (unless (mason-installed-p pkg)
      (ignore-errors (mason-install pkg)))))
