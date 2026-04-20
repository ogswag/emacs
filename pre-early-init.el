;;; pre-early-init.el --- pre early init -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Reducing clutter in ~/.emacs.d by redirecting files to ~/.emacs.d/var/
(setq user-emacs-directory (expand-file-name "var/" minimal-emacs-user-directory))
(setq module-directory (expand-file-name "var/modules/" minimal-emacs-user-directory))
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "themes" user-emacs-directory))

(setq minimal-emacs-ui-features '(tool-bar context-menu menu-bar dialogs tooltips))
