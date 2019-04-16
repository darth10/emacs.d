;;; Comfiguration for company

(use-package company
  :ensure t
  :defer 2
  :bind (("C-' a" . global-company-mode)
         ("C-' C-a" . global-company-mode)
         ("M-SPC" . company-manual-begin))
  :config
  (global-company-mode t))

(provide 'config-company)