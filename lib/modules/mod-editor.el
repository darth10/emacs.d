;;; config-editor.el -*- lexical-binding: t; -*-

(custom-set-variables   ;; Set color theme
 `(custom-enabled-themes (quote ,core-enabled-custom-themes)))

(use-package core-editor
  :load-path core-lib-path
  :bind (("C-' n" . core/display-line-numbers)
         ("C-' C-n" . core/display-line-numbers)
         ("C-<f6>" . core/display-line-numbers)
         ("C-! e" . core/find-or-run-eshell)
         ("C-! C-e" . core/find-or-run-eshell)
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
         ("C-c C-\\" . just-one-space)
         ("C-c \\" . just-one-space)
         ("C-h C-l" . describe-personal-keybindings))
  :commands (core/kill-line-utils-init)
  :init
  (global-unset-key (kbd "<f10>"))
  (global-unset-key (kbd "C-z"))
  (setq shell-command-switch "-ic"
        eshell-directory-name (concat core-var-cache-dir-full-path "eshell/"))

  ;; enable disabled commands
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)

  (core/kill-line-utils-init)

  (when (core:is-windows-p)     ;; Windows-only config
    (setq w32-get-true-file-attributes nil)
    (w32-send-sys-command 61488))

  (defun +eshell-load-bash-aliases ()
    "Reads bash aliases from Bash and inserts
    them into the list of eshell aliases."
    (interactive)
    (progn
      (shell-command "alias" "bash-aliases" "bash-errors")
      (switch-to-buffer "bash-aliases")
      (replace-string "alias " "")
      (goto-char 1)
      (replace-string "='" " ")
      (goto-char 1)
      (replace-string "'\n" "\n")
      (goto-char 1)
      (let ((alias-name) (command-string) (alias-list))
        (while (not (eobp))
          (while (not (char-equal (char-after) 32))
            (forward-char 1))
          (setq alias-name
                (buffer-substring-no-properties (line-beginning-position) (point)))
          (forward-char 1)
          (setq command-string
                (buffer-substring-no-properties (point) (line-end-position)))
          (setq alias-list (cons (list alias-name command-string) alias-list))
          (forward-line 1))
        (setq eshell-command-aliases-list alias-list))
      (if (get-buffer "bash-aliases")(kill-buffer "bash-aliases"))
      (if (get-buffer "bash-errors")(kill-buffer "bash-errors"))
      (message "Loaded aliases.")))

  (add-hook 'eshell-mode-hook '+eshell-load-bash-aliases))

(use-package god-mode
  :ensure t
  :if core-enable-god-mode
  :bind (("<escape>" . god-local-mode)
         ("S-<escape>" . god-mode-all)
         ("M-i" . god-local-mode)
         :map god-local-mode-map
         ("." . repeat)
         ("z" . repeat)
         ("i" . god-local-mode))
  :hook (after-init . god-mode-all)
  :config
  (defun god-toggle-on-overwrite ()
    (if (bound-and-true-p overwrite-mode)
        (god-local-mode-pause)
      (god-local-mode-resume)))

  (let* ((exempt-modes (list
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
                        'wdired-mode
                        )))
    (dolist (i exempt-modes)
      (add-to-list 'god-exempt-major-modes i)))

  (add-hook 'overwrite-mode-hook #'god-toggle-on-overwrite))

(use-package which-key
  :ensure t
  :bind (("C-' k" . which-key-mode)
         ("C-' C-k" . which-key-mode))
  :init
  (which-key-setup-side-window-bottom)
  (which-key-enable-god-mode-support)
  (setq which-key-max-description-length 24
        which-key-max-display-columns 4
        which-key-separator " : ")
  (unbind-key "C-h C-h")
  (which-key-mode t))

(use-package hl-line
  :bind (("C-' l" . hl-line-mode)
         ("C-' C-l" . hl-line-mode)
         ("C-<f4>" . hl-line-mode))
  :init
  (add-hook 'prog-mode-hook #'hl-line-mode)
  (add-hook 'org-mode-hook #'hl-line-mode)
  (add-hook 'dired-mode-hook #'hl-line-mode))

(use-package iedit
  :ensure t
  :bind ("C-;" . iedit-mode))

(use-package highlight-sexp
  :quelpa (highlight-sexp :fetcher github :repo "daimrod/highlight-sexp")
  :defer 2
  :config
  (defun +highlight-sexp-set-hl-line ()
    (interactive)
    (hl-line-mode (if highlight-sexp-mode -1 t)))
  (add-hook 'highlight-sexp-mode-hook #'+highlight-sexp-set-hl-line)

  (defconst +highlight-sexp-keys
    '("C-<f12>"
      "C-' C-s"
      "C-' s"))

  (defun +highlight-sexp-bind-keys (mode-map)
    (core-bind-keys +highlight-sexp-keys #'highlight-sexp-mode mode-map))

  (use-package lisp-mode
    :config
    (+highlight-sexp-bind-keys 'lisp-mode-map)
    (+highlight-sexp-bind-keys 'emacs-lisp-mode-map))
  (use-package clojure-mode :config (+highlight-sexp-bind-keys 'clojure-mode-map))
  (use-package scheme :config (+highlight-sexp-bind-keys 'scheme-mode-map)))

(use-package multiple-cursors
  :ensure t
  :bind (("C-<" . mc/mark-previous-like-this)
         ("C->" . mc/mark-next-like-this)
         ("C-c C-<f3>" . mc/mark-all-like-this)
         ("C-c C->" . mc/mark-all-like-this)
         ("C-x <C-return>" . mc/edit-lines)
         ("C-x RET RET" . set-rectangular-region-anchor))
  :init
  (setq mc/list-file (concat core-var-cache-dir-full-path "mc-lists.el"))
  (face-spec-set 'mc/cursor-bar-face '((t (:height 1 :background "green")))))

(use-package paredit
  :ensure t
  :defer 2
  :bind (("C-' (" . paredit-mode)
         ("C-' C-(" . paredit-mode))
  :config
  (defun +paredit-bind-key (key function)
    (bind-key key function paredit-mode-map))
  (defun +paredit-unbind-key (key)
    (unbind-key key paredit-mode-map))

  (+paredit-unbind-key "M-s")
  (+paredit-unbind-key "ESC <up>")
  (+paredit-unbind-key "M-<up>")
  (+paredit-bind-key "ESC M-<up>" 'paredit-splice-sexp-killing-backward)
  (+paredit-bind-key "ESC ESC <up>" 'paredit-splice-sexp-killing-backward)
  (+paredit-bind-key "C-, C-, C-k" 'paredit-splice-sexp-killing-backward)
  (+paredit-bind-key "C-, , k" 'paredit-splice-sexp-killing-backward)
  (+paredit-unbind-key "ESC <down>")
  (+paredit-unbind-key "M-<down>")
  (+paredit-bind-key "ESC M-<down>" 'paredit-splice-sexp-killing-forward)
  (+paredit-bind-key "ESC ESC <down>" 'paredit-splice-sexp-killing-forward)
  (+paredit-bind-key "C-, C-k" 'paredit-splice-sexp-killing-forward)
  (+paredit-bind-key "C-, k" 'paredit-splice-sexp-killing-forward)
  (+paredit-unbind-key "C-<right>")
  (+paredit-bind-key "M-<right>" 'paredit-forward-slurp-sexp)
  (+paredit-bind-key "ESC <right>" 'paredit-forward-slurp-sexp)
  (+paredit-bind-key "C-, C-f" 'paredit-forward-slurp-sexp)
  (+paredit-bind-key "C-, f" 'paredit-forward-slurp-sexp)
  (+paredit-unbind-key "C-<left>")
  (+paredit-bind-key "M-<left>" 'paredit-forward-barf-sexp)
  (+paredit-bind-key "ESC <left>" 'paredit-forward-barf-sexp)
  (+paredit-bind-key "C-, C-b" 'paredit-forward-barf-sexp)
  (+paredit-bind-key "C-, b" 'paredit-forward-barf-sexp)
  (+paredit-unbind-key "ESC C-<right>")
  (+paredit-bind-key "ESC M-<right>" 'paredit-backward-barf-sexp)
  (+paredit-bind-key "ESC ESC <right>" 'paredit-backward-barf-sexp)
  (+paredit-bind-key "C-, C-, C-f" 'paredit-backward-barf-sexp)
  (+paredit-bind-key "C-, , f" 'paredit-backward-barf-sexp)
  (+paredit-unbind-key "ESC C-<left>")
  (+paredit-bind-key "ESC M-<left>" 'paredit-backward-slurp-sexp)
  (+paredit-bind-key "ESC ESC <left>" 'paredit-backward-slurp-sexp)
  (+paredit-bind-key "C-, C-, C-b" 'paredit-backward-slurp-sexp)
  (+paredit-bind-key "C-, , b" 'paredit-backward-slurp-sexp)

  (add-hook 'eshell-mode-hook #'paredit-mode)

  (use-package smartparens
    :config
    (defun disable-smartparens-mode ()
      (interactive)
      (smartparens-mode (if paredit-mode -1 t)))
    (add-hook 'paredit-mode-hook #'disable-smartparens-mode))
  (use-package lisp-mode
    :config
    (add-hook 'lisp-mode-hook #'paredit-mode)
    (add-hook 'emacs-lisp-mode-hook #'paredit-mode))
  (use-package ielm :config (add-hook 'ielm-mode-hook #'paredit-mode))
  (use-package clojure-mode :config (add-hook 'clojure-mode-hook #'paredit-mode))
  (use-package cider :config (add-hook 'cider-repl-mode-hook #'paredit-mode))
  (use-package scheme :config (add-hook 'scheme-mode-hook #'paredit-mode))
  (use-package geiser :config (add-hook 'geiser-repl-mode-hook #'paredit-mode)))

(use-package eval-sexp-fu
  :ensure t
  :defer 2
  :config
  (face-spec-set 'eval-sexp-fu-flash '((t (:background "green" :foreground "black"))))

  (defun +eval-sexp-fu-init ()
    (require 'eval-sexp-fu))

  (add-hook 'lisp-mode-hook #'+eval-sexp-fu-init)
  (add-hook 'emacs-lisp-mode-hook #'+eval-sexp-fu-init)
  (add-hook 'eshell-mode-hook #'+eval-sexp-fu-init))

(use-package transient
  :ensure t
  :defer 2
  :init
  (let ((transient-dir-path (concat core-var-cache-dir-full-path "transient/")))
    (setq transient-levels-file (concat transient-dir-path "levels.el")
          transient-values-file (concat transient-dir-path "values.el")
          transient-history-file (concat transient-dir-path "history.el"))))

(use-package simple
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

(use-package ws-butler
  :ensure t
  :bind (("C-' d" . ws-butler-mode)
         ("C-' C-d" . ws-butler-mode))
  :commands (ws-butler-mode)
  :init
  (add-hook 'prog-mode-hook #'ws-butler-mode)
  (add-hook 'conf-mode-hook #'ws-butler-mode))

(use-package helpful
  :ensure t
  :bind (("C-h f" . helpful-function)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)))

(use-package fic-mode
  :ensure t
  :config
  (setq fic-highlighted-words '("FIXME" "TODO" "BUG" "HACK"))
  (add-hook 'prog-mode-hook #'fic-mode)
  (add-hook 'conf-mode-hook #'fic-mode))

(use-package abbrev
  :defer 2)

(use-package anzu
  :ensure t
  :defer t
  :hook (after-init . global-anzu-mode))

(use-package smartparens
  :ensure t
  :defer 2
  :config
  (add-hook 'prog-mode-hook 'smartparens-mode))

(use-package hideshow
  :bind (:map hs-minor-mode-map
              ("C-c d" . hs-hide-block)
              ("C-c v d" . hs-hide-all)
              ("C-c s" . hs-show-block)
              ("C-c v s" . hs-show-all))
  :config
  (add-hook 'clojure-mode-hook 'hs-minor-mode)
  (add-hook 'c-mode-common-hook 'hs-minor-mode)
  (add-hook 'csharp-mode-hook 'hs-minor-mode)
  (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
  (add-hook 'java-mode-hook 'hs-minor-mode)
  (add-hook 'lisp-mode-hook 'hs-minor-mode)
  (add-hook 'sh-mode-hook 'hs-minor-mode))

(use-package yasnippet
  :ensure t
  :defer 2
  :bind (("C-' C-y" . yas-global-mode)
         ("C-' y" . yas-global-mode))
  :config
  (custom-set-faces
   '(yas-field-highlight-face ((t (:inherit 'region)))))

  (let* ((temp-yas-snippet-dirs
          (append yas-snippet-dirs
                  (list (expand-file-name (concat core-var-dir-path "snippets")
                                          user-emacs-directory))))
         (temp-yas-snippet-dirs
          (delete yas--default-user-snippets-dir temp-yas-snippet-dirs)))
    (setq yas-snippet-dirs temp-yas-snippet-dirs))

  (use-package yasnippet-snippets
    :ensure t)

  (yas-global-mode t))

(use-package exec-path-from-shell
  :ensure t
  :unless (core:is-windows-p)
  :defer 2
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package editorconfig
  :ensure t
  :defer 2
  :config
  (editorconfig-mode 1))

(use-package desktop
  :init
  (setq desktop-path (list core-var-cache-dir-full-path)
        desktop-base-file-name "desktop"
        desktop-base-lock-name "desktop.lock")
  :config
  (desktop-save-mode t))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package subword
  :bind (("C-' c" . subword-mode)
         ("C-' C-c" . subword-mode)))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer))

(use-package woman
  :unless (core:is-windows-p)
  :bind ("C-x ?" . woman))

(use-package clipmon
  :ensure t
  :defer 2
  :config
  (clipmon-mode-start))

(use-package yaml-mode
  :ensure t)

(use-package markdown-mode
  :ensure t
  :defer 5)

(use-package inflections
  :ensure t)

(use-package wide-column
  :ensure t)

(use-package smex
  :ensure t
  :defer 2)

(provide 'mod-editor)