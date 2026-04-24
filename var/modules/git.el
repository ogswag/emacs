;; -*- lexical-binding: t; -*-

;;; Magit
(use-package magit :ensure t :defer t)

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

;;; Git diffs (diff-hl)
(use-package diff-hl :ensure t
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))
