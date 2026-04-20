;;; ui.el --- ui config -*- no-byte-compile: t; lexical-binding: t; -*-
;;; CODE:

(setq custom-safe-themes t) ; treat all custom themes as safe

;;; Themes
(use-package doom-modeline :ensure t
  :config (doom-modeline-mode t))

(use-package leuven-theme :ensure t
  :defer t)

(use-package modus-themes :ensure t
  :defer t)

(use-package standard-themes :ensure t
  :defer t)

(use-package solarized-theme :ensure t
  :defer t)

(use-package doom-themes :ensure t
  :defer t)

(use-package aircon-theme :ensure t
  :defer t)

(setq modus-themes-italic-constructs nil
      modus-themes-bold-constructs nil
      modus-themes-disable-other-themes t)

(setq modus-operandi-palette-overrides
      '((bg-prose-block-contents bg-diff-context)
        (bg-prose-block-delimiter bg-tab-bar)
        (fg-prose-block-delimiter "gray22")
        (comment red)))

;; Fix org block extend
;; (defun my/fix-org-block-extend (&rest _args)
;;   (dolist (face '(org-block-begin-line org-block-end-line))
;;     (when (facep face)
;;       (set-face-attribute face nil :extend nil))))

;; (defun my/set-theme-by-time ()
;;   "Load a light theme between 6:00 and 18:00, and a dark theme otherwise."
;;   (interactive)
;;   (let* ((hour (string-to-number (format-time-string "%H")))
;;          (light-theme 'doom-tomorrow-day)
;;          (dark-theme  'doom-material-dark)
;;          (now-light?  (and (>= hour 6) (< hour 18)))
;;          (target-theme (if now-light? light-theme dark-theme)))
;;
;;     ;; Only reload if the target theme isn't already the top active one
;;     (unless (eq (car custom-enabled-themes) target-theme)
;;       ;; Disable all currently active themes to ensure a clean switch
;;       (mapc #'disable-theme custom-enabled-themes)
;;       (if (eq dark-theme target-theme)
;;           (progn
;;             (load-theme target-theme t)
;;             ;; (my/fix-org-block-extend)
;;             )
;;         (load-theme target-theme t))
;;       (message "Switched to %s theme" target-theme))))
;; ;; Run the check every N seconds
;; (run-at-time nil 300 #'my/set-theme-by-time)

;; (custom-theme-set-faces 'aircon-theme
;;                         '(font-lock-comment-face ((t (:foreground "#3D9A8C" :inherit italic)))))

(use-package auto-dark
  :ensure t
  :demand t
  :custom
  (auto-dark-themes '((doom-solarized-dark) ; dark
                      (doom-solarized-light) ; light
                      ))
  (auto-dark-polling-interval-seconds 5)
  (auto-dark-allow-powershell nil)
  ;; (auto-dark-detection-method nil) ; dangerous to be set manually
  :hook
  (auto-dark-dark-mode
   . (lambda ()
       ;; something to execute when dark mode is detected
       ))
  (auto-dark-light-mode
   . (lambda () )))

(unless (eq window-system 'mac)
  (setq-default auto-dark-allow-osascript t))

(add-hook 'on-init-ui-hook #'auto-dark-mode)

(use-package solaire-mode :ensure t
  :defer t)

(add-hook 'on-init-ui-hook #'solaire-global-mode)

(use-package pos-tip :ensure t)
(setq pos-tip-internal-border-width 6
      pos-tip-border-width 1)
