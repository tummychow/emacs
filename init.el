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

(setq-default indent-tabs-mode nil)

(use-package general
  :demand t)
(use-package hydra
  :demand t)

(use-package evil
  :demand t
  :diminish 'undo-tree-mode
  :init
  (setq evil-want-Y-yank-to-eol t)
  :config
  (evil-mode 1)
  :general
  (:prefix "SPC"
   :non-normal-prefix "M-SPC"
   :states '(normal visual insert emacs)
   "SPC" 'execute-extended-command
   "hh" 'help-for-help
   "hf" 'describe-function
   "hk" 'describe-key
   "hv" 'describe-variable
   "ff" 'find-file
   "fb" 'switch-buffer
   "fw" 'other-window
   "w" 'save-buffer))

(use-package ivy-hydra)
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

(use-package ace-window
  :init
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-scope 'frame)
  :general
  ([remap other-window] 'ace-window))

(use-package swiper
  :general
  (:prefix "SPC"
   :non-normal-prefix "M-SPC"
   :states '(normal visual insert emacs)
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

(use-package org
  :init
  (setq org-M-RET-may-split-line nil
        org-blank-before-new-entry '((heading . nil)
                                     (plain-list-item . nil))
        org-catch-invisible-edits 'smart
        org-ctrl-k-protect-subtree t
        org-file-apps '(("pdf" . "xdg-open %s"))
        org-imenu-depth 20
        imenu-auto-rescan t)
  (setq-default imenu-auto-rescan-maxout 1000000000)
  (defhydra hydra-org-headings ()
    "navigate org headings"
    ("u" outline-up-heading "up to higher level")
    ("j" outline-next-visible-heading "down any level")
    ("k" outline-previous-visible-heading "up any level")
    ("J" org-forward-heading-same-level "down same level")
    ("K" org-backward-heading-same-level "up same level"))
  :general
  (:states '(insert emacs)
   "RET" 'org-return-indent)
  (:prefix "DEL"
   :non-normal-prefix "M-DEL"
   :states '(normal insert emacs)
   "/" 'imenu
   "e" 'org-export-dispatch
   "u" 'hydra-org-headings/outline-up-heading
   "j" 'hydra-org-headings/outline-next-visible-heading
   "k" 'hydra-org-headings/outline-previous-visible-heading
   "J" 'hydra-org-headings/org-forward-heading-same-level
   "K" 'hydra-org-headings/org-backward-heading-same-level
   "o" '(lambda ()
          (interactive)
          (end-of-line)
          (org-insert-heading)
          (evil-append nil))
   "O" '(lambda ()
          (interactive)
          (beginning-of-line)
          (org-insert-heading)
          (evil-append nil))
   "DEL o" '(lambda ()
              (interactive)
              (end-of-line)
              (org-insert-heading-respect-content)
              (evil-append nil))
   "DEL O" '(lambda ()
              (interactive)
              (beginning-of-line)
              (org-insert-heading-respect-content)
              (evil-append nil))))
