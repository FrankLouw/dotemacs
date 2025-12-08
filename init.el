;; -*- lexical-binding: t; -*-
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(global-set-key [remap dabbrev-expand] 'hippie-expand)
(global-set-key [remap list-buffers] 'ibuffer)
;;(set-frame-font "Iosevka NFM 14" nil t)

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
(setq org-default-notes-file (concat org-directory "worknotes.org"))
(setq org-agenda-files (list org-directory))
(setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
(setq org-archive-location (concat org-directory "/archive.org::"))

(setq org-todo-keywords
      '((sequence "TODO(t!)" "NEXT(n!)" "|" "DONE(d!)")
	(sequence "WAITING(w!)" "|" "DONE(d!)")
	(sequence "SOMEDAY(s!)")
	(sequence "CANCELLED(c!)")
        (sequence "DISCUSS(D!)" "|" "RESOLVED(r!)")))

(customize-set-variable 'org-log-into-drawer t)

(setq org-todo-keyword-faces
      '(
	("SOMEDAY" . "blue")
	("WAITING" . "purple")
	("TODO" . "orange")
	))

(setq org-tag-alist
      '(
	("@work" . ?w)
	("@home" . ?h)
       	("@agenda" . ?a)
            ("@errands" . ?e)
	("quick" . ?q)
	("deep" . ?d)
	("johan_d" . ?j)
	("yves_b" . ?y)
	("yarden_a" . ?Y)
	("nevin_j" . ?n)
	("wayne_c" . ?w)
	))

(setq org-capture-templates
      '(("I" "Inbox note - personal" entry (file+headline "~/gtd/personalinbox.org" "Inbox")
         "* TODO %?\n  %i\n  %a")
	("i" "Inbox note - work" entry (file+headline "~/gtd/worknotes.org" "Inbox")
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


(defun my/sync-gtd ()
  "Sync ~/gtd folder with git: add, commit, pull, and push changes."
  (interactive)
  (let ((default-directory (expand-file-name "~/gtd/")))
    (if (not (file-directory-p default-directory))
        (message "GTD directory not found: %s" default-directory)
      (message "Syncing GTD folder...")
      (org-save-all-org-buffers)
      ;; Check for any changes (staged or unstaged)
      (if (zerop (shell-command "git diff-index --quiet HEAD --"))
          ;; No local changes, just pull and push
          (progn
            (shell-command "git pull --rebase")
            (shell-command "git push -u origin HEAD")
            (message "GTD synced successfully"))
        ;; Has local changes: stage, commit, pull, push
        (shell-command "git add -A")
        (let ((timestamp (format-time-string "%Y-%m-%d %H:%M:%S")))
          (when (zerop (shell-command (format "git commit -m \"Auto-sync: %s\"" timestamp)))
            (if (zerop (shell-command "git pull --rebase"))
                (if (zerop (shell-command "git push -u origin HEAD"))
                    (message "GTD synced successfully")
                  (message "GTD: Push failed"))
              (message "GTD: Conflicts detected - resolve manually and run git rebase --continue"))))))))

(defun my/sync-emacs-config ()
  "Sync Emacs config directory with git: add, commit, pull, and push changes."
  (interactive)
  (let ((default-directory user-emacs-directory))
    (message "Syncing Emacs config...")
    ;; Check for any changes
    (if (zerop (shell-command "git diff-index --quiet HEAD --"))
        ;; No local changes
        (progn
          (shell-command "git pull --rebase")
          (shell-command "git push -u origin HEAD")
          (message "Emacs config synced successfully"))
      ;; Has local changes
      (shell-command "git add -A")
      (let ((timestamp (format-time-string "%Y-%m-%d %H:%M:%S")))
        (when (zerop (shell-command (format "git commit -m \"Auto-sync: %s\"" timestamp)))
          (if (zerop (shell-command "git pull --rebase"))
              (if (zerop (shell-command "git push -u origin HEAD"))
                  (message "Emacs config synced successfully")
                (message "Emacs config: Push failed"))
            (message "Emacs config: Conflicts detected - resolve manually and run git rebase --continue")))))))


(add-hook 'kill-emacs-hook #'my/sync-emacs-config)
(add-hook 'kill-emacs-hook #'my/sync-gtd)
