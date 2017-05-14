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

(use-package general
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
   :states '(normal insert emacs)
   "SPC" 'execute-extended-command
   "ff" 'find-file
   "fb" 'switch-buffer
   "ww" 'save-buffer))

(use-package counsel
  :diminish 'ivy-mode
  :init
  (setq ivy-count-format "(%d/%d) ")
  :config
  (ivy-mode 1)
  :general
  ([remap execute-extended-command] 'counsel-M-x
   [remap find-file] 'counsel-find-file
   [remap switch-buffer] 'ivy-switch-buffer)
  (:keymaps 'ivy-minibuffer-map
   "<escape>" 'keyboard-escape-quit))

(use-package swiper
  :general
  (:prefix "SPC"
   :non-normal-prefix "M-SPC"
   :states '(normal insert emacs)
   "/" 'swiper))
