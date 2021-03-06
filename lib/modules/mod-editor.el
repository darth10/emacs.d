;;; mod-editor.el --- Primary editor configuration   -*- lexical-binding: t; -*-

(custom-set-variables   ;; Set color theme
 `(custom-enabled-themes (quote ,holy-emacs-enabled-custom-themes)))

(use-package core-editor
  :straight nil
  :load-path core-lib-path
  :commands (core:kill-line-utils-init)
  :bind (("C-' n" . core/display-line-numbers)
         ("C-' C-n" . core/display-line-numbers)
         ("C-<f6>" . core/display-line-numbers)
         ("C-! p" . core/list-processes-and-switch)
         ("C-! C-p" . core/list-processes-and-switch)
         ("C-! s" . core/find-or-run-shell)
         ("C-! C-s" . core/find-or-run-shell)
         ("C-%" . core/match-paren)
         ("C-+" . core/resize-window)
         ("C-s" . save-buffer)
         ("C-x <C-M-return>" . core/find-user-init-file)
         ("C-x <f3>" . core/list-processes-and-switch)
         ("C-x C-0" . delete-window)
         ("C-x C-1" . delete-other-windows)
         ("C-x C-2" . split-window-below)
         ("C-x C-3" . split-window-right)
         ("C-x C-5 C-0" . delete-frame)
         ("C-x C-5 C-1" . delete-other-frames)
         ("C-x C-5 C-2" . make-frame-command)
         ("C-x 9" . core/delete-single-window)
         ("C-x C-9" . core/delete-single-window)
         ("C-x '" . core/switch-to-scratch-other-window)
         ("C-x C-'" . core/switch-to-scratch-other-window)
         ("C-x \"" . core/switch-to-scratch)
         ("C-x C-\"" . core/switch-to-scratch)
         ("C-x 5 '" . core/switch-to-scratch-other-frame)
         ("C-x C-5 C-'" . core/switch-to-scratch-other-frame)
         ("C-x C-c" . core/confirm-and-kill-terminal)
         ("C-x M-[" . previous-buffer)
         ("C-x M-]" . next-buffer)
         ("M-[" . tab-to-tab-stop)
         ("C-x |" . core/find-user-init-file)
         ("C-|" . core/switch-to-window)
         ("<f6>" . core/match-paren)
         ("M-<down>" . core/move-line-region-down)
         ("M-<up>" . core/move-line-region-up)
         ("M-n" . core/move-line-region-down)
         ("M-p" . core/move-line-region-up)
         ("C-' w" . toggle-truncate-lines)
         ("C-' C-w" . toggle-truncate-lines)
         ("C-<f9>" . toggle-truncate-lines)
         ("C-' q" . auto-fill-mode)
         ("C-' C-q" . auto-fill-mode)
         ("C-c \\" . just-one-space)
         ("C-h C-l" . describe-personal-keybindings))
  :init
  (global-unset-key (kbd "<f10>"))
  (global-unset-key (kbd "C-z"))

  ;; enable disabled commands
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)

  (core:kill-line-utils-init)

  (when (core:is-windows-p)     ;; Windows-only config
    (setq w32-get-true-file-attributes nil)
    (w32-send-sys-command 61488))

  (unless (core:is-windows-p)   ;; Linux-only config
    (setq shell-command-switch "-ic")))

(use-package whitespace
  :bind (("C-' ." . whitespace-mode)
         ("C-' C-." . whitespace-mode)))

(use-package simple
  :straight nil
  :config
  (defconst +simple-backup-dir
    (concat user-emacs-directory (concat core-var-cache-dir-path "backups/")))
  (setq auto-save-file-name-transforms `((".*" ,+simple-backup-dir t))
        auto-save-list-file-prefix +simple-backup-dir
        backup-directory-alist `((".*" . ,+simple-backup-dir))
        create-lockfiles nil))

(use-package tramp
  :defer 2
  :config
  ;; File paths like `/sshx:user@remotehost|sudo:remotehost:/etc/dhcpd.conf`
  ;; will open remote files over multiple hops.
  (setq
   ;; tramp-debug-buffer t
   ;; tramp-verbose 9
   tramp-default-method "scpx"
   tramp-persistency-file-name (concat core-var-cache-dir-full-path "tramp")
   tramp-auto-save-directory (concat core-var-cache-dir-full-path "tramp-auto-save/")))

(use-package gud
  :defer t
  :lang (:map gud-minor-mode-map
         (:debug-set-break . gud-break)
         (:debug-remove-break . gud-remove)
         (:debug-step-over . gud-next)
         (:debug-step-into . gud-step)
         (:debug-step-out . gud-finish)
         (:debug-continue . gud-cont)
         (:debug-run . gud-run))
  :config
  (setq gdb-many-windows t))

(use-package desktop
  :init
  (setq desktop-path (list core-var-cache-dir-full-path)
        desktop-base-file-name "desktop"
        desktop-base-lock-name "desktop.lock")
  :config
  (desktop-save-mode t))

(use-package god-mode
  :if holy-emacs-enable-god-mode
  :hook ((after-init . god-mode-all)
         (overwrite-mode . +god--toggle-on-overwrite))
  :bind (("<escape>" . god-local-mode)
         ("S-<escape>" . god-mode-all)
         ("M-i" . god-local-mode)
         :map god-local-mode-map
         ("." . repeat)
         ("z" . repeat)
         ("i" . god-local-mode))
  :config
  (defun +god--toggle-on-overwrite ()
    (if (bound-and-true-p overwrite-mode)
        (god-local-mode-pause)
      (god-local-mode-resume)))

  (let ((exempt-modes (list
                       'Custom-mode
                       'Info-mode
                       'ag-mode
                       'calendar-mode
                       'calculator-mode
                       'cider-test-report-mode
                       'compilation-mode
                       'debugger-mode
                       'dired-mode
                       'edebug-mode
                       'ediff-mode
                       'eww-mode
                       'geben-breakpoint-list-mode
                       'ibuffer-mode
                       'org-agenda-mode
                       'recentf-dialog-mode
                       'sldb-mode
                       'wdired-mode
                       )))
    (cl-loop for mode in exempt-modes
             do (add-to-list 'god-exempt-major-modes mode))))

(use-package transient
  :defer 2
  :init
  (let ((transient-dir-path (concat core-var-cache-dir-full-path "transient/")))
    (setq transient-levels-file (concat transient-dir-path "levels.el")
          transient-values-file (concat transient-dir-path "values.el")
          transient-history-file (concat transient-dir-path "history.el"))))

(use-package exec-path-from-shell
  :unless (core:is-windows-p)
  :defer 2
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package projectile
  :defer 2
  :bind (:map projectile-mode-map
         ("C-c p" . projectile-command-map))
  :init
  (setq projectile-cache-file (concat core-var-cache-dir-full-path "projectile/cache")
        projectile-known-projects-file (concat core-var-cache-dir-full-path "projectile/bookmarks.eld"))
  :config
  (projectile-mode t))

(use-package server
  :defer 2
  :config
  (setq server-auth-dir (concat core-var-cache-dir-full-path "server/"))
  (server-start))

(use-package edit-server
  :if window-system
  :defer 2
  :config
  (edit-server-start))

(use-package clipmon
  :defer 2
  :config
  (clipmon-mode-start))

(use-package iedit
  :bind ("C-;" . iedit-mode))

(use-package multiple-cursors
  :bind (("C-<" . mc/mark-previous-like-this)
         ("C->" . mc/mark-next-like-this)
         ("C-c <f3>" . mc/mark-all-like-this)
         ("C-c >" . mc/mark-all-like-this)
         ("C-x <C-return>" . mc/edit-lines)
         ("C-x RET RET" . set-rectangular-region-anchor))
  :init
  (setq mc/list-file (concat core-var-cache-dir-full-path "mc-lists.el"))
  :custom-face
  (mc/cursor-bar-face ((t (:height 1 :background "green")))))

(use-package mod-editor-compile    :straight nil :load-path core-modules-lib-path)
(use-package mod-editor-completion :straight nil :load-path core-modules-lib-path)
(use-package mod-editor-format     :straight nil :load-path core-modules-lib-path)
(use-package mod-editor-help       :straight nil :load-path core-modules-lib-path)
(use-package mod-editor-highlight  :straight nil :load-path core-modules-lib-path)
(use-package mod-editor-navigation :straight nil :load-path core-modules-lib-path)
(use-package mod-editor-parens     :straight nil :load-path core-modules-lib-path)
(use-package mod-editor-search     :straight nil :load-path core-modules-lib-path)

(provide 'mod-editor)
