;;; mod-editor-parens.el --- Editor packages for parentheses  -*- lexical-binding: t; -*-

(use-package smartparens
  :commands (smartparens-mode)
  :hook (prog-mode . smartparens-mode))

(use-package paredit
  :commands (paredit-mode)
  :hook (paredit-mode . +paredit--disable-smartparens-mode)
  :bind (("C-' (" . paredit-mode)
         ("C-' C-(" . paredit-mode))
  :config
  (defun +paredit--disable-smartparens-mode ()
    (smartparens-mode (if paredit-mode -1 t)))

  (defun +paredit--bind-key (key function)
    (bind-key key function paredit-mode-map))

  (defun +paredit--unbind-key (key)
    (unbind-key key paredit-mode-map))

  (+paredit--unbind-key "M-s")
  (+paredit--unbind-key "ESC <up>")
  (+paredit--unbind-key "M-<up>")
  (+paredit--bind-key "M-S-<up>" #'paredit-splice-sexp-killing-backward)
  (+paredit--bind-key "ESC ESC <up>" #'paredit-splice-sexp-killing-backward)
  (+paredit--bind-key "C-, C-, C-k" #'paredit-splice-sexp-killing-backward)
  (+paredit--bind-key "C-, , k" #'paredit-splice-sexp-killing-backward)
  (+paredit--unbind-key "ESC <down>")
  (+paredit--unbind-key "M-<down>")
  (+paredit--bind-key "M-S-<down>" #'paredit-splice-sexp-killing-forward)
  (+paredit--bind-key "ESC ESC <down>" #'paredit-splice-sexp-killing-forward)
  (+paredit--bind-key "C-, C-k" #'paredit-splice-sexp-killing-forward)
  (+paredit--bind-key "C-, k" #'paredit-splice-sexp-killing-forward)
  (+paredit--unbind-key "C-<right>")
  (+paredit--bind-key "M-<right>" #'paredit-forward-slurp-sexp)
  (+paredit--bind-key "ESC <right>" #'paredit-forward-slurp-sexp)
  (+paredit--bind-key "C-, C-f" #'paredit-forward-slurp-sexp)
  (+paredit--bind-key "C-, f" #'paredit-forward-slurp-sexp)
  (+paredit--unbind-key "C-<left>")
  (+paredit--bind-key "M-<left>" #'paredit-forward-barf-sexp)
  (+paredit--bind-key "ESC <left>" #'paredit-forward-barf-sexp)
  (+paredit--bind-key "C-, C-b" #'paredit-forward-barf-sexp)
  (+paredit--bind-key "C-, b" #'paredit-forward-barf-sexp)
  (+paredit--unbind-key "ESC C-<right>")
  (+paredit--bind-key "M-S-<right>" #'paredit-backward-barf-sexp)
  (+paredit--bind-key "ESC ESC <right>" #'paredit-backward-barf-sexp)
  (+paredit--bind-key "C-, C-, C-f" #'paredit-backward-barf-sexp)
  (+paredit--bind-key "C-, , f" #'paredit-backward-barf-sexp)
  (+paredit--unbind-key "ESC C-<left>")
  (+paredit--bind-key "M-S-<left>" #'paredit-backward-slurp-sexp)
  (+paredit--bind-key "ESC ESC <left>" #'paredit-backward-slurp-sexp)
  (+paredit--bind-key "C-, C-, C-b" #'paredit-backward-slurp-sexp)
  (+paredit--bind-key "C-, , b" #'paredit-backward-slurp-sexp))

(provide 'mod-editor-parens)
