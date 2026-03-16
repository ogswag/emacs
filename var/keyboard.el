;;; keyboard.el --- keybindings -*- no-byte-compile: t; lexical-binding: t; -*-

;;; CODE:

;;; PLATFORM DETECTION
(defconst my/is-mac (eq system-type 'darwin))
(defconst my/is-linux (eq system-type 'gnu/linux))
(defconst my/is-windows (eq system-type 'windows-nt))

(require 'viper-cmd)

;;; UNBINDS

(keymap-global-unset "C-M-<wheel-down>") ; mouse-wheel-global-text-scale
(keymap-global-unset "C-M-<wheel-up>")   ; mouse-wheel-global-text-scale
(keymap-global-unset "C-<wheel-down>")   ; mouse-wheel-text-scale
(keymap-global-unset "C-<wheel-up>")     ; mouse-wheel-text-scale
(keymap-global-unset "C-<mouse-5>")      ; mouse-wheel-text-scale down
(keymap-global-unset "C-<mouse-4>")      ; mouse-wheel-text-scale up
(keymap-global-unset "C-M-<mouse-5>")    ; mouse-wheel-global-text-scale down
(keymap-global-unset "C-M-<mouse-4>")    ; mouse-wheel-global-text-scale up

(keymap-global-unset "M-l")  ; downcase-word
(keymap-global-unset "M-u")  ; upcase-word
;; (keymap-global-unset "M-c")  ; capitalize-word


;;;; Disable secondary selection mouse bindings

(keymap-global-unset "<mouse-2>")   ; middle mouse button secondary yank
(keymap-global-unset "M-<mouse-1>") ; set secondary selection start
(keymap-global-unset "M-<mouse-3>") ; set secondary selection end

(keymap-global-unset "C-M-<down-mouse-1>")
(keymap-global-unset "C-s")
(keymap-global-unset "C-x b")
(keymap-global-unset "C-z")
(keymap-global-unset "M-<drag-mouse-1>")
(keymap-global-unset "M-<mouse-1>")
(keymap-global-unset "M-i")
(keymap-global-unset "M-j")
(keymap-global-unset "M-m")
(keymap-global-unset "M-o")
(keymap-global-unset "M-{") ; backward-paragraph
(keymap-global-unset "M-}") ; forward-paragraph
(keymap-global-unset "s--")
(keymap-global-unset "s-0")
(keymap-global-unset "s-<left>")
(keymap-global-unset "s-<right>")
(keymap-global-unset "s-=")
(keymap-global-unset "s-Z")
(keymap-global-unset "s-l")
(keymap-global-unset "s-q")
(keymap-global-unset "s-z")
(keymap-global-unset  "s-j")
(keymap-global-unset "s-k")


;;; GENERAL

(keymap-global-set "M-8" #'toggle-frame-fullscreen)

(when my/is-mac
  (keymap-global-set "s-z" #'undo-fu-only-undo)
  (keymap-global-set "s-Z" #'undo-fu-only-redo)
  (keymap-global-set "s-q" #'ns-do-hide-emacs))

(when my/is-linux
  (keymap-global-unset "C-z" t)
  (keymap-global-unset "C-Z" t)
  (keymap-global-unset "C-z" t)
  (keymap-global-unset "C-S-z" t)
  (keymap-global-set "C-z" #'undo-fu-only-undo)
  (keymap-global-set "C-S-z" #'undo-fu-only-redo))   ; Ctrl+Shift+Z

(keymap-global-set "C-=" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)
(keymap-global-set "C-0" #'text-scale-adjust)

(keymap-global-set "M-c r" #'recentf)

(keymap-global-set "M-[" #'backward-paragraph)
(keymap-global-set "M-]" #'forward-paragraph)
(keymap-global-unset "M-f")
(keymap-global-unset "M-b")
(keymap-global-unset "C-<left>")
(keymap-global-unset "C-<right>")
;; (keymap-global-unset "C-M-/")

(keymap-global-set "C-<left>" #'viper-backward-word)
(keymap-global-set "C-<right>" #'viper-forward-word)

(keymap-global-set "C-s-W" #'kill-buffer-and-window)
(keymap-global-set "C-s-k" #'kill-current-buffer)
(keymap-global-set "C-s-w" #'delete-window)

(keymap-global-set "C-s-," #'previous-buffer)
(keymap-global-set "C-s-." #'next-buffer)

;;; EDITING

(keymap-global-set "M-s-<down-mouse-1>" #'mouse-drag-region-rectangle)

(keymap-global-set "M-j" #'join-line)

(keymap-global-unset "C-/")
(keymap-global-set "C-/" #'comment-line)

(keymap-global-set "C-s" #'set-mark-command)

(keymap-global-unset "M-<up>" t)
;; (keymap-global-unset "M-<left>" t)
;; (keymap-global-unset "M-<right>" t)
(keymap-global-unset "M-<down>" t)

(keymap-global-set "M-<up>" #'move-dup-move-lines-up)
(keymap-global-set "M-<down>" #'move-dup-move-line)

(keymap-global-set "C-M-<up>" #'move-dup-duplicate-up)
(keymap-global-set "C-M-<down>" #'move-dup-duplicate-down)

(keymap-global-set "C-c c" #'compile)
(keymap-global-set "C-c r" #'recompile)
(keymap-global-set "C-c i" #'my/run-python-new-frame)

(keymap-global-set "C-c e b" #'eval-buffer)
(keymap-global-set "C-c e r" #'eval-region)

(keymap-global-set "M-1" #'shell-command)
(keymap-global-set "M-2" #'async-shell-command)
(keymap-global-set "M-3" #'my/open-curdir)

(keymap-global-set "C-," #'goto-last-change)
(keymap-global-set "C-<" #'goto-last-change-reverse)
(keymap-global-set "C-'" #'goto-last-point)

;;; keyboard.el ends here
