;;; orgmode.el --- My org-mode config -*- no-byte-compile: t; lexical-binding: t; -*-
;;; CODE:

(use-package org
  :ensure t
  :defer t
  :commands (org-mode org-version)
  :mode ("\\.org\\'" . org-mode)
  :init
  ;; Optional: load exporters eagerly so first export is not slow
  (with-eval-after-load 'org
    (require 'ox-latex)
    (require 'ox-md)
    (require 'ox-beamer))
  :custom
  (org-export-backends '(ascii html icalendar latex beamer odt md))
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  (org-descriptive-links nil)
  (org-fontify-done-headline t)
  (org-fontify-todo-headline t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  (org-startup-truncated t)
  ;; LaTeX: use modern class and engine
  (org-latex-compiler "lualatex")
  (org-latex-listings 'minted)
  (org-latex-packages-alist '(("" "minted"))))

(use-package org-appear
  :commands org-appear-mode
  :defer t
  :hook (org-mode . org-appear-mode))

(use-package org-table-sticky-header
  :ensure t
  :defer t
  :commands org-table-sticky-header-mode)
