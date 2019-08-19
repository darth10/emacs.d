;;; mod-lang-elisp.el --- Configuration for Emacs Lisp  -*- lexical-binding: t; -*-

(use-package lisp-mode
  :lang (:map emacs-lisp-mode-map
         (:repl-start . core/find-or-run-eshell)
         (:eval-buffer . eval-buffer)
         (:load-file . load-file)
         (:compile-file . +elisp/compile-file)
         :map lisp-interaction-mode-map
         (:eval-buffer . eval-print-last-sexp))
  :config
  (defun +elisp/compile-file ()
	(interactive)
	(core:compile-file buffer-file-name)))

(use-package eldoc
  :config
  ;; disable eldoc for eval-expression
  (defun +elisp--turn-off-eldoc ()
    (eldoc-mode -1))
  (add-hook 'eval-expression-minibuffer-setup-hook #'+elisp--turn-off-eldoc)

  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
  (add-hook 'ielm-mode-hook 'eldoc-mode)
  (add-hook 'eshell-mode-hook 'eldoc-mode))

(use-package eshell
  :commands (+elisp/load-bash-aliases-in-eshell)
  :init
  (add-hook 'eshell-mode-hook #'+elisp/load-bash-aliases-in-eshell)
  :config
  (setq eshell-directory-name (concat core-var-cache-dir-full-path "eshell/"))
  (defun +elisp/load-bash-aliases-in-eshell ()
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
      (if (get-buffer "bash-aliases") (kill-buffer "bash-aliases"))
      (if (get-buffer "bash-errors") (kill-buffer "bash-errors"))
      (message "Loaded aliases.")
      (delete-other-windows))))

(use-package eval-sexp-fu
  :ensure t
  :hook ((lisp-mode emacs-lisp-mode eshell-mode) . +eval-sexp-fu--init)
  :custom-face
  (eval-sexp-fu-flash ((t (:background "green" :foreground "black"))))
  :config
  (defun +eval-sexp-fu--init ()
    (require 'eval-sexp-fu)))

(use-package esup
  :ensure t
  :commands (esup))

(use-package try
  :ensure t
  :commands (try))

(provide 'mod-lang-elisp)
