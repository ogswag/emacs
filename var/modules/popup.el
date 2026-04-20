;;; popup.el --- Popup buffers like Doom's :ui popup for Emacs 29 -*- lexical-binding: t; no-byte-compile: t; -*-

;; ;; 1. Install and enable shackle
;; (use-package shackle
;;   :ensure t
;;   :config
;;   (shackle-mode 1)
;;
;;   ;; 2. Define popup rules for common buffers
;;   (setq shackle-rules
;;         '(("*compilation*"                :regexp t :align below :size 0.3 :select t)
;;           ("*Help*"                       :regexp t :align right :size 0.4 :select t)
;;           ("*Warnings*"                   :regexp t :align below :size 0.25 :select t)
;;           ("\\*Shell Command Output\\*"   :regexp t :align below :size 0.25 :select t)
;;           ("\\*Backtrace\\*"              :regexp t :align below :size 0.35 :select t)
;;           ("\\*Compile-Log\\*"            :regexp t :align below :size 0.3 :select t)
;;           ("\\*Messages\\*"               :regexp t :align below :size 0.3 :select t)
;;           ("^\\*.*\\*$"                   :regexp t :align below :size 0.3 :select t)  ; Fallback
;;           ("^ .*"                         :regexp t :align below :size 0.3 :select t))) ; Hidden buffers
;;
;;   ;; 3. Set a default rule
;;   (setq shackle-default-rule '(:select t :align right :size 0.3))
;;
;;   ;; 4. Optional: Distinguish popups with a distinct background
;;   (defun my-popup-set-background ()
;;     "Set a distinct background color for the current buffer."
;;     (face-remap-add-relative 'default '(:background "#1e1e2e")))
;;
;;   ;; Modify a specific rule to use the custom background
;;   (setq shackle-rules
;;         (append shackle-rules
;;                 '(( "*compilation*" :regexp t :align below :size 0.3 :select t
;;                     :custom (lambda (buffer alist plist)
;;                               (with-current-buffer buffer
;;                                 (my-popup-set-background))
;;                               (shackle--default-display-buffer buffer alist plist)))))))

;; 5. Optionally, hide popups from the buffer list using ibuffer
(use-package ibuffer
  :config
  (setq ibuffer-saved-filter-groups
        '(("default"
           ("Popups" (or (name . "^*Help*")
                         (name . "^*compilation*")
                         (name . "^*Warnings*")
                         (name . "^*Shell Command Output*")
                         (name . "^*Backtrace*")
                         (name . "^*Compile-Log*")
                         (name . "^*Messages*")))
           ("All other buffers" (not (or (name . "^*Help*")
                                         (name . "^*compilation*")
                                         (name . "^*Warnings*")
                                         (name . "^*Shell Command Output*")
                                         (name . "^*Backtrace*")
                                         (name . "^*Compile-Log*")
                                         (name . "^*Messages*")))))))
  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default"))))

;;; popup.el ends here
