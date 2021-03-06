;;; mod-helm.el --- Configuration for helm           -*- lexical-binding: t; -*-

(use-package helm
  :bind (("C-c ;" . helm-imenu)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini)
         ("C-~" . helm-mark-ring)
         ("M-x" . helm-M-x)
         ("<apps>" . helm-M-x)
         ("<menu>" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-<f2>" . helm-imenu)
         ("M-s i" . helm-occur)
         :map helm-map
         ("<tab>" . helm-execute-persistent-action)
         ("C-i" . helm-execute-persistent-action)
         ("C-z" . helm-select-action))
  :config
  (helm-mode t))

(use-package helm-swoop
  :bind (("M-]" . helm-swoop)
		 ("M-s ]" . helm-swoop)))

(use-package helm-ls-git
  :bind ("C-: C-f" . helm-ls-git-ls))

(use-package helm-bm
  :after bm
  :bind (("C-c : :" . helm-bm)
         ("C-c : C-:" . helm-bm)))

(use-package helm-projectile
  :after projectile
  :config
  (setq projectile-completion-system 'helm))

(provide 'mod-helm)
