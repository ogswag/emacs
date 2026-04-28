;;; input.el --- input config -*- no-byte-compile: t; lexical-binding: t; -*-

;;; CODE:

;;; PLATFORM DETECTION
(defconst my/is-mac (eq system-type 'darwin))
(defconst my/is-linux (eq system-type 'gnu/linux))
(defconst my/is-windows (eq system-type 'windows-nt))

(require 'viper-cmd)

;;; MEOW mode

(use-package meow :ensure t :demand t)

;;;; MEOW setup

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . undo-fu-only-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(require 'meow)
(meow-setup)
(meow-global-mode 1)

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
(keymap-global-unset "S-<down-mouse-1>")
;; (keymap-global-unset "M-c")  ; capitalize-word

;;;; Disable secondary selection mouse bindings

(keymap-global-unset "<mouse-2>")   ; middle mouse button secondary yank
(keymap-global-unset "M-<mouse-1>") ; set secondary selection start
(keymap-global-unset "M-<mouse-3>") ; set secondary selection end

(keymap-global-unset "C-M-<down-mouse-1>")
(keymap-global-unset "C-s")

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


;;;; GENERAL

(keymap-global-set "M-8" #'toggle-frame-fullscreen)
(keymap-global-set "M-0" #'iconify-frame)

(keymap-global-unset "C-z" t)
(keymap-global-unset "C-Z" t)
(keymap-global-unset "C-z" t)
(keymap-global-unset "C-S-z" t)
(keymap-global-set "C-z" #'undo-fu-only-undo)
(keymap-global-set "C-S-z" #'undo-fu-only-redo)

(keymap-global-set "C-=" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)
(keymap-global-set "C-0" #'text-scale-adjust)

(keymap-global-unset "C-r" t)
(keymap-global-set "C-r" #'recentf)

(keymap-global-set "M-[" #'backward-paragraph)
(keymap-global-set "M-]" #'forward-paragraph)

(keymap-global-unset "C-<left>")
(keymap-global-unset "C-<right>")
(keymap-global-unset "C-M-/" t)

(keymap-global-set "C-<left>" #'viper-backward-word)
(keymap-global-set "C-<right>" #'viper-forward-word)

(keymap-global-set "M-S-<down-mouse-1>" #'mouse-drag-region-rectangle)

(keymap-global-set "M-j" #'join-line)

(keymap-global-unset "C-/")
(keymap-global-set "C-/" #'comment-line)

(keymap-global-set "C-s" #'set-mark-command)

;; (keymap-global-unset "M-<up>" t)
;; (keymap-global-unset "M-<down>" t)
;;
;; (keymap-global-set "M-<up>" #'move-dup-move-lines-up)
;; (keymap-global-set "M-<down>" #'move-dup-move-line)
;;
;; (keymap-global-set "C-M-S-v" #'move-dup-duplicate-up)
;; (keymap-global-set "C-M-v" #'move-dup-duplicate-down)

(keymap-global-set "C-c c" #'compile)
(keymap-global-set "C-c r" #'recompile)

(keymap-global-set "C-c e b" #'eval-buffer)
(keymap-global-set "C-c e r" #'eval-region)

(keymap-global-set "M-1" #'shell-command)
(keymap-global-set "M-2" #'async-shell-command)
(keymap-global-set "M-3" #'my/open-curdir)
(keymap-global-set "C-," #'goto-last-change)
(keymap-global-set "C-<" #'goto-last-change-reverse)
(keymap-global-set "C-'" #'goto-last-point)


;;; keyboard.el ends here
