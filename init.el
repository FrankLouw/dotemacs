;; -*- lexical-binding: t; -*-
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(global-set-key [remap dabbrev-expand] 'hippie-expand)
(global-set-key [remap list-buffers] 'ibuffer)


(tool-bar-mode 0)
(scroll-bar-mode 0)
(fido-vertical-mode t)
(which-key-mode t)
(setq visible-bell t)
(line-number-mode t)
(global-hl-line-mode t)
(blink-cursor-mode -1)
(setq line-spacing 3)
;; Keymaps
(keymap-global-set "M-o" 'other-window)

(keymap-global-set "C-c c" 'org-capture)
(keymap-global-set "C-c a" 'org-agenda)
(keymap-global-set "C-c l" 'org-store-link)
;; Org-mode
(setq org-directory "~/gtd")
(setq org-default-notes-file (concat org-directory "inbox.org"))
(setq org-agenda-files (list org-directory))
(setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
(setq org-archive-location (concat org-directory "/archive.org::"))

(setq org-todo-keywords
           '((sequence "TODO(t)" "WATING(w)" "FOLLOW_UP(f)" "|" "DONE(d)")
             (sequence "DISCUSS(D)" "|" "RESOLVED(r)")))

(setq org-tag-alist '(("@work" . ?w) ("@home" . ?h) ("johan_d" . ?j) ("yves_b" . ?y)))

(setq org-capture-templates
      '(("I" "Inbox note - personal" entry (file+headline "~/gtd/personalinbox.org" "Inbox")
              "* TODO %?\n  %i\n  %a")
	("i" "Inbox note - work" entry (file+headline "~/gtd/workinbox.org" "Inbox")
              "* TODO %?\n  %i\n  %a")
	("T" "Todo - personal" entry (file+headline "~/gtd/personalnotes.org" "Tasks")
              "* TODO %?\n  %i\n  %a")
	("t" "Todo - work" entry (file+headline "~/gtd/worknotes.org" "Tasks")
              "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/gtd/journal.org")
              "* %?\nEntered on %U\n  %i\n  %a")))

(add-hook 'org-mode-hook (lambda ()
			   (org-indent-mode)
			   (visual-line-mode)))

(set-face-attribute 'default nil :height 130)
