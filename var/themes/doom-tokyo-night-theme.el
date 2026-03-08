;;; doom-tokyo-night-theme.el --- inspired by VSCode's Tokyo Night theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Added: December 15, 2021 (#650)
;; Author: FosterHangdaan <https://github.com/FosterHangdaan>
;; Maintainer:
;; Source: https://github.com/enkia/tokyo-night-vscode-theme
;;
;;; Commentary:
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-tokyo-night-theme nil
  "Options for doom-themes"
  :group 'doom-themes)

(defcustom doom-tokyo-night-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-tokyo-night-theme
  :type 'boolean)

(defcustom doom-tokyo-night-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-tokyo-night-theme
  :type 'boolean)

(defcustom doom-tokyo-night-comment-bg doom-tokyo-night-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their legibility."
  :group 'doom-tokyo-night-theme
  :type 'boolean)

(defcustom doom-tokyo-night-padded-modeline nil
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to determine the exact padding."
  :group 'doom-tokyo-night-theme
  :type '(or integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-tokyo-night
    "A clean, dark theme that celebrates the lights of downtown Tokyo at night."

                                        ; Color Scheme
                                        ; gui       256
                                        ; "#f7768e" "#f7768e" => This keyword, HTML elements, Regex group symbol, CSS units, Terminal Red
                                        ; "#ff9e64" "#ff9e64" => Number and Boolean constants, Language support constants
                                        ; "#e0af68" "#e0af68" => Function parameters, Regex character sets, Terminal Yellow
                                        ; "#9ece6a" "#9ece6a" => Strings, CSS class names
                                        ; "#73daca" "#73daca" => Object literal keys, Markdown links, Terminal Green
                                        ; "#b4f9f8" "#b4f9f8" => Regex literal strings
                                        ; "#2ac3de" "#2ac3de" => Language support functions, CSS HTML elements
                                        ; "#7dcfff" "#7dcfff" => Object properties, Regex quantifiers and flags, Markdown headings, Terminal Cyan, Markdown code, Import/export keywords
                                        ; "#7aa2f7" "#7aa2f7" => Function names, CSS property names, Terminal Blue
                                        ; "#bb9af7" "#bb9af7" => Control Keywords, Storage Types, Regex symbols and operators, HTML Attributes, Terminal Magenta
                                        ; "#c0caf5" "#c0caf5" => Variables, Class names, Terminal White
                                        ; "#a9b1d6" "#a9b1d6" => Editor foreground
                                        ; "#9aa5ce" "#9aa5ce" => Markdown Text, HTML Text
                                        ; "#cfc9c2" "#cfc9c2" => Parameters inside functions (semantic highlighting only)
                                        ; "#565f89" "#565f89" => Comments
                                        ; "#414868" "#414868" => Terminal black
                                        ; "#24283b" "#24283b" => Editor background (Storm)
                                        ; "#1a1b26" "#1a1b26" => Editor background (Night)

  ;; name        default   256       16
  ((bg         '("#1a1b26" nil       nil            ))
   (bg-alt     '("#13141c" nil       nil            ))
   (base0      '("#414868" "#414868" "black"        ))
   (base1      '("#51587a" "#51587a" "brightblack"  ))
   (base2      '("#61698b" "#61698b" "brightblack"  ))
   (base3      '("#71799d" "#71799d" "brightblack"  ))
   (base4      '("#8189af" "#8189af" "brightblack"  ))
   (base5      '("#9099c0" "#9099c0" "brightblack"  ))
   (base6      '("#a0aad2" "#a0aad2" "brightblack"  ))
   (base7      '("#b0bae3" "#b0bae3" "brightblack"  ))
   (base8      '("#c0caf5" "#c0caf5" "white"        ))
   (fg-alt     '("#c0caf5" "#c0caf5" "brightwhite"  ))
   (fg         '("#a9b1d6" "#a9b1d6" "white"        ))

   (grey       base4)
   (red        '("#f7768e" "#f7768e" "red"          ))
   (orange     '("#ff9e64" "#ff9e64" "brightred"    ))
   (green      '("#73daca" "#73daca" "green"        ))
   (teal       '("#2ac3de" "#2ac3de" "brightgreen"  ))
   (yellow     '("#e0af68" "#e0af68" "yellow"       ))
   (blue       '("#7aa2f7" "#7aa2f7" "brightblue"   ))
   (dark-blue  '("#565f89" "#565f89" "blue"         ))
   (magenta    '("#bb9af7" "#bb9af7" "magenta"      ))
   (violet     '("#9aa5ce" "#9aa5ce" "brightmagenta"))
   (cyan       '("#b4f9f8" "#b4f9f8" "brightcyan"   ))
   (dark-cyan  '("#7dcfff" "#7dcfff" "cyan"         ))
                                        ; Additional custom colors
   (dark-green '("#9ece6a" "#9ece6a" "green"        ))
   (brown      '("#cfc9c2" "#cfc9c2" "yellow"       ))

   ;; face categories -- required for all themes
   (highlight      cyan)
   (vertical-bar   (doom-lighten bg 0.05))
   (selection      base0)
   (builtin        red)
   (comments       (if doom-tokyo-night-brighter-comments base5 base1))
   (doc-comments   (doom-lighten (if doom-tokyo-night-brighter-comments base5 base1) 0.25))
   (constants      orange)
   (functions      blue)
   (keywords       magenta)
   (methods        blue)
   (operators      dark-cyan)
   (type           base8)
   (strings        dark-green)
   (variables      base8)
   (numbers        orange)
   (region         base0)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   (level-1 "#CADAFF")
   (level-2 "#81ADFF")
   (level-3 "#FFC9DB")
   (level-4 "#FF79BA")
   (level-5 "#FFD474")
   (level-6 "#E0A200")
   (level-7 "#15FDD6")
   (level-8 "#00CBA2")

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (-modeline-bright doom-tokyo-night-brighter-modeline)
   (-modeline-pad
    (when doom-tokyo-night-padded-modeline
      (if (integerp doom-tokyo-night-padded-modeline) doom-tokyo-night-padded-modeline 4)))

   (modeline-fg     'unspecified)
   (modeline-fg-alt base5)

   (modeline-bg
    (if -modeline-bright
	    base3
	  `(,(doom-darken (car bg) 0.15) ,@(cdr base0))))
   (modeline-bg-l
    (if -modeline-bright
	    base3
	  `(,(doom-darken (car bg) 0.1) ,@(cdr base0))))
   (modeline-bg-inactive   (doom-darken bg 0.1))
   (modeline-bg-inactive-l `(,(car bg) ,@(cdr base1))))


  ;; --- Extra Faces ------------------------
  (
   ((line-number-current-line &override) :foreground base8)
   ((line-number &override) :foreground comments :background (doom-darken bg 0.025))

   (font-lock-comment-face
    :foreground comments
    :background (if doom-tokyo-night-comment-bg (doom-lighten bg 0.05) 'unspecified))
   (font-lock-doc-face
    :inherit 'font-lock-comment-face
    :foreground doc-comments)

   ;;; Doom Modeline
   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))
   (doom-modeline-buffer-path :foreground base8 :weight 'normal)
   (doom-modeline-buffer-file :foreground brown :weight 'normal)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if -modeline-bright base8 highlight))
   (mode-line-buffer-id
    :foreground highlight)

   ;;; Indentation
   (whitespace-indentation :background bg)
   (whitespace-tab :background bg)

   ;;; Ivy
   (ivy-subdir :foreground blue)
   (ivy-minibuffer-match-face-1 :foreground green :background bg-alt)
   (ivy-minibuffer-match-face-2 :foreground orange :background bg-alt)
   (ivy-minibuffer-match-face-3 :foreground red :background bg-alt)
   (ivy-minibuffer-match-face-4 :foreground yellow :background bg-alt)

   ;;; Elscreen
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")

   ;;; Solaire
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))

   ;;; Telephone
   (telephone-line-accent-active
    :inherit 'mode-line
    :background (doom-lighten bg 0.2))
   (telephone-line-accent-inactive
    :inherit 'mode-line
    :background (doom-lighten bg 0.05))
   (telephone-line-evil-emacs
    :inherit 'mode-line
    :background dark-blue)

   ;;; Outline:
   (outline-1 :foreground level-1 :height 1.1 :weight 'bold)
   (outline-2 :foreground level-2 :height 1.0 :weight 'bold)
   (outline-3 :foreground level-3 :height 1.0 :weight 'bold)
   (outline-4 :foreground level-4 :height 1.0 :weight 'bold)
   (outline-5 :foreground level-5 :height 1.0 :weight 'bold)
   (outline-6 :foreground level-6 :height 1.0 :weight 'bold)
   (outline-7 :foreground level-7 :height 1.0 :weight 'bold)
   (outline-8 :foreground level-8 :height 1.0 :weight 'bold)

   ;; LaTeX
   (font-latex-sectioning-0-face :inherit 'outline-8)
   (font-latex-sectioning-1-face :inherit 'outline-1)
   (font-latex-sectioning-2-face :inherit 'outline-2)
   (font-latex-sectioning-3-face :inherit 'outline-3)
   (font-latex-sectioning-4-face :inherit 'outline-4)
   (font-latex-sectioning-5-face :inherit 'outline-5)
   (font-latex-sectioning-6-face :inherit 'outline-6)
   (font-latex-sectioning-7-face :inherit 'outline-7)
   (font-latex-sectioning-8-face :inherit 'outline-8)

   (org-level-1 :inherit 'outline-1)
   (org-level-2 :inherit 'outline-2)
   (org-level-3 :inherit 'outline-3)
   (org-level-4 :inherit 'outline-4)
   (org-level-5 :inherit 'outline-5)
   (org-level-6 :inherit 'outline-6)
   (org-level-7 :inherit 'outline-7)
   (org-level-8 :inherit 'outline-8)

   ;; Markdown
   (markdown-header-face-1 :inherit 'outline-1)
   (markdown-header-face-2 :inherit 'outline-2)
   (markdown-header-face-3 :inherit 'outline-3)
   (markdown-header-face-4 :inherit 'outline-4)
   (markdown-header-face-5 :inherit 'outline-5)
   (markdown-header-face-6 :inherit 'outline-6)

   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground fg)
   (rainbow-delimiters-depth-2-face :foreground blue)
   (rainbow-delimiters-depth-3-face :foreground orange)
   (rainbow-delimiters-depth-4-face :foreground green)
   (rainbow-delimiters-depth-5-face :foreground cyan)
   (rainbow-delimiters-depth-6-face :foreground yellow)
   (rainbow-delimiters-depth-7-face :foreground teal)

   ;;; Treemacs
   (treemacs-root-face :foreground magenta :weight 'bold :height 1.2)
   (doom-themes-treemacs-root-face :foreground magenta :weight 'ultra-bold :height 1.2)
   (doom-themes-treemacs-file-face :foreground fg-alt)
   (treemacs-directory-face :foreground base8)
   (treemacs-file-face :foreground fg)
   (treemacs-git-modified-face :foreground green)
   (treemacs-git-renamed-face :foreground yellow)

   ;;; Magit
   (magit-section-heading :foreground blue)
   (magit-branch-remote   :foreground orange)
   (magit-diff-our :foreground (doom-darken red 0.2) :background (doom-darken red 0.7))
   (magit-diff-our-highlight :foreground red :background (doom-darken red 0.5) :weight 'bold)
   (magit-diff-removed :foreground (doom-darken red 0.2) :background (doom-darken red 0.7))
   (magit-diff-removed-highlight :foreground red :background (doom-darken red 0.5) :weight 'bold)

   ;; --- Major-Mode Faces -------------------
   ;;; elisp
   (highlight-quoted-symbol :foreground yellow)

   ;;; js2-mode
   (js2-function-param :foreground yellow)
   (js2-object-property :foreground green)

   ;;; typescript-mode
   (typescript-this-face :foreground red)
   (typescript-access-modifier-face :foreground brown)

   ;;; rjsx-mode
   (rjsx-tag :foreground red)
   (rjsx-text :foreground violet)
   (rjsx-attr :foreground magenta :slant 'italic :weight 'medium)
   (rjsx-tag-bracket-face :foreground (doom-darken red 0.3))

   ;;; css-mode / scss-mode
   (css-property             :foreground blue)
   (css-selector             :foreground teal)
   (css-pseudo-class         :foreground orange)

   ;;; markdown-mode
   (markdown-markup-face :foreground violet)
   (markdown-header-face :inherit 'bold :foreground dark-cyan)
   (markdown-blockquote-face :foreground violet :background (doom-lighten bg 0.04))
   (markdown-table-face :foreground violet :background (doom-lighten bg 0.04))
   ((markdown-code-face &override) :foreground dark-cyan :background (doom-lighten bg 0.04))

   ;;; org-mode
   (org-hide :foreground hidden)
   (org-block :background (doom-darken base2 0.65))
   (org-block-begin-line :background (doom-darken base2 0.65) :foreground comments :extend t)
   (solaire-org-hide-face :foreground hidden)

   ;;; web-mode
   (web-mode-json-context-face :foreground brown)
   (web-mode-json-key-face :foreground teal)
   ;;;; Block
   (web-mode-block-delimiter-face :foreground yellow)
   ;;;; Code
   (web-mode-constant-face :foreground constants)
   (web-mode-variable-name-face :foreground variables)
   ;;;; CSS
   (web-mode-css-pseudo-class-face :foreground orange)
   (web-mode-css-property-name-face :foreground blue)
   (web-mode-css-selector-face :foreground teal)
   (web-mode-css-function-face :foreground yellow)
   ;;;; HTML
   (web-mode-html-attr-engine-face :foreground yellow)
   (web-mode-html-attr-equal-face :foreground operators)
   (web-mode-html-attr-name-face :foreground magenta)
   (web-mode-html-tag-bracket-face :foreground (doom-darken red 0.3))
   (web-mode-html-tag-face :foreground red)

   ;; ;;;; tab-line/tab-bar (Emacs 27+)
   ;; ((tab-line &override) :background (doom-darken bg 0.8) :foreground base4)
   ;; (tab-line-tab :i:background base4 :foreground fg)
   ;; ;; (tab-line-tab-inactive :background bg-alt :foreground fg-alt)
   ;; (tab-line-tab-incative :background (doom-darken bg 0.5) :foreground base4)
   ;; (tab-line-tab-inactive-alternate :inherit 'tab-line-tab-inactive)
   ;; (tab-line-tab-current :background bg :foreground fg)
   ;; ;; (tab-line-special )
   ;; (tab-line-highlight :inherit 'tab-line-tab)
   ;; (tab-line-close-highlight :foreground highlight)
   ;; ((tab-bar &override) :inherit 'tab-line)
   ;; ((tab-bar-tab &override) :inherit 'tab-line-tab)
   ;; ((tab-bar-tab-inactive &override) :inherit 'tab-line-tab-inactive)
   ;;
   ;; ;;;; centaur-tabs
   ;; (centaur-tabs-default :inherit 'tab-bar :box nil)
   ;; ((centaur-tabs-selected &override) :inherit 'tab-line-tab :box nil)
   ;; (centaur-tabs-unselected :inherit 'tab-bar-tab-inactive :box nil)
   ;; (centaur-tabs-selected-modified   :background bg :foreground teal)
   ;; (centaur-tabs-unselected-modified :background bg-alt :foreground teal)
   ;; (centaur-tabs-active-bar-face :background (if (bound-and-true-p -modeline-bright) modeline-bg highlight))
   ;; (centaur-tabs-modified-marker-selected
   ;;  :foreground (if (bound-and-true-p -modeline-bright) modeline-bg highlight)
   ;;  :inherit 'centaur-tabs-selected)
   ;; (centaur-tabs-modified-marker-unselected
   ;;  :foreground (if (bound-and-true-p -modeline-bright) modeline-bg highlight)
   ;;  :inherit 'centaur-tabs-unselected)

   (paren-face-match    :foreground bg  :background magenta :weight 'ultra-bold)
   (paren-face-mismatch :foreground bg  :background red   :weight 'ultra-bold)
   (paren-face-no-match :inherit 'paren-face-mismatch :weight 'ultra-bold)

   )

  ;; --- extra variables ---------------------
  ;; ()
  )

;;; doom-tokyo-night-theme.el ends here
