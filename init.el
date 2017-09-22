(setq custom-file (concat user-emacs-directory "custom.el")
      custom-buffer-done-kill t)
(load custom-file t)

(require 'package)
;; the default archives list uses a non-TLS address for GNU ELPA
;; https://git.savannah.gnu.org/cgit/emacs.git/commit/?id=048133d4886d2e7fa547879478127edc9a9243f6
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(eval-when-compile (require 'use-package))

(setq auto-save-default nil
      auto-save-list-file-prefix nil
      create-lockfiles nil
      make-backup-files nil)

(setq echo-keystrokes 0.1)
(setq sentence-end-double-space nil)
(setq visual-line-fringe-indicators '(left-curly-arrow nil))
(setq menu-bar-mode nil
      tool-bar-mode nil)
(setq initial-major-mode 'org-mode
      initial-scratch-message nil)
(setq save-interprogram-paste-before-kill t)

(setq-default truncate-lines t)
(setq-default indent-tabs-mode nil)
(show-paren-mode 1)
(setq global-hl-line-sticky-flag t)
(global-hl-line-mode 1)

(use-package general
  :demand t
  :config
  (general-create-definer private/with-leader
                          :prefix "SPC"
                          :non-normal-prefix "M-SPC"
                          :states '(normal visual insert emacs))
  (general-create-definer private/with-local-leader
                          :prefix "DEL"
                          :non-normal-prefix "M-DEL"
                          :states '(normal visual insert emacs)))
(use-package hydra
  :demand t)

(use-package ws-butler
  :demand t
  :diminish 'ws-butler-mode
  :init
  (setq ws-butler-keep-whitespace-before-point nil)
  :config
  (ws-butler-global-mode 1))

(use-package evil
  :demand t
  :diminish 'undo-tree-mode
  :init
  (setq evil-want-Y-yank-to-eol t
        evil-disable-insert-state-bindings t)
  :config
  (evil-mode 1)
  :general
  (:states '(normal visual)
   ";" 'evil-ex
   "s" 'save-buffer
   "x" 'other-window
   "r" 'universal-argument)
  (:keymaps 'universal-argument-map
   "r" 'universal-argument-more)
  (private/with-leader
   "SPC" 'execute-extended-command
   ";" 'eval-expression
   "f" 'find-file
   "b" 'switch-buffer)
  (private/with-leader
   :infix "h"
   "h" 'help-for-help
   "f" 'describe-function
   "k" 'describe-key
   "v" 'describe-variable
   "m" 'describe-mode
   "w" 'where-is)
  (private/with-leader
   :infix "d"
   "h" 'split-window-vertically
   "v" 'split-window-horizontally
   "x" 'delete-window
   "k" 'kill-buffer-and-window))

(use-package ivy-hydra
  :commands (hydra-ivy/body))
(use-package wgrep
  :commands (wgrep-change-to-wgrep-mode)
  :init
  (setq wgrep-auto-save-buffer t)
  :general
  (:keymaps 'wgrep-mode-map
   [remap save-buffer] 'wgrep-finish-edit))
(use-package counsel
  :diminish 'ivy-mode
  :init
  (setq ivy-count-format "(%d/%d) ")
  :config
  (ivy-mode 1)
  :general
  ([remap execute-extended-command] 'counsel-M-x
   [remap find-file] 'counsel-find-file
   [remap switch-buffer] 'ivy-switch-buffer
   [remap describe-face] 'counsel-describe-face
   [remap describe-function] 'counsel-describe-function
   [remap describe-variable] 'counsel-describe-variable
   [remap imenu] 'counsel-imenu)
  (:keymaps 'ivy-minibuffer-map
   "<escape>" 'keyboard-escape-quit))

(use-package avy
  :init
  (setq avy-all-windows nil)
  :config
  ;; evil automatically remaps those commands to be inclusive
  ;; however, when i use these with an operator, i usually want
  ;; exclusive behavior, so i'm redefining them
  (evil-define-avy-motion avy-goto-char-2-above exclusive)
  (evil-define-avy-motion avy-goto-char-2-below exclusive)
  ;; TODO: pressing esc for avy input should just cancel out immediately
  ;;       we can do this with C-g, so maybe we should advise these functions
  ;;       to remap <escape> to C-g and unmap afterwards
  ;; TODO: should have a good way of repeating last avy search
  ;; TODO: should we have a binding for t/T?
  :general
  (:states '(motion)
   "f" 'avy-goto-char-2-below
   "F" 'avy-goto-char-2-above))

(use-package ace-window
  :init
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-scope 'frame)
  :config
  (face-spec-set 'aw-leading-char-face
    '((((class color)) (:foreground "red" :height 3.0))
      (((background dark)) (:foreground "gray100" :height 3.0))
      (((background light)) (:foreground "gray0" :height 3.0))
      (t (:foreground "gray100" :underline nil :height 3.0))))
  :general
  ([remap other-window] 'ace-window))

(use-package swiper
  :general
  (private/with-leader
   "/" 'swiper))

(use-package shackle
  :demand t
  :diminish 'shackle-mode
  :init
  (setq shackle-rules '((help-mode :select t
                                   :popup t
                                   :align 'below
                                   :size 0.5)))
  :config
  (shackle-mode 1))

(use-package hydra-ox
  :commands (hydra-ox/body))
(use-package org
  :init
  (setq org-M-RET-may-split-line nil
        org-blank-before-new-entry '((heading . nil)
                                     (plain-list-item . nil))
        org-catch-invisible-edits 'smart
        org-ctrl-k-protect-subtree t
        org-file-apps '(("pdf" . "xdg-open %s"))
        org-ellipsis "⤵"
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-window-setup 'current-window
        org-imenu-depth 20
        imenu-auto-rescan t)
  (setq-default imenu-auto-rescan-maxout 1000000000)
  (defhydra private/hydra-org-headings ()
    "navigate org headings"
    ("<tab>" org-cycle "cycle heading")
    ("u" outline-up-heading "up to higher level")
    ("j" outline-next-visible-heading "down any level")
    ("k" outline-previous-visible-heading "up any level")
    ("J" org-forward-heading-same-level "down same level")
    ("K" org-backward-heading-same-level "up same level"))
  :general
  (:states '(insert emacs)
   "RET" 'org-return-indent)
  (private/with-local-leader
   :keymaps 'org-mode-map
   "/" 'imenu
   "e" 'hydra-ox/body
   "r" 'org-reveal
   "u" 'private/hydra-org-headings/outline-up-heading
   "j" 'private/hydra-org-headings/outline-next-visible-heading
   "k" 'private/hydra-org-headings/outline-previous-visible-heading
   "J" 'private/hydra-org-headings/org-forward-heading-same-level
   "K" 'private/hydra-org-headings/org-backward-heading-same-level
   "o" '(lambda (arg)
          (interactive "P")
          (end-of-line)
          (org-insert-heading arg)
          (evil-append nil))
   "O" '(lambda (arg)
          (interactive "P")
          (beginning-of-line)
          (org-insert-heading arg)
          (evil-append nil))))
