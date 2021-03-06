;;; mod-lang-js.el --- Configuration for JavaScript  -*- lexical-binding: t; -*-

(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx\\'" . js2-jsx-mode))
  :hook (js2-mode . flycheck-mode)
  :config
  (setq js2-basic-offset 2))

(use-package js2-refactor
  :after js2-mode
  :hook (js2-mode . js2-refactor-mode)
  :config
  (cl-loop for key in holy-emacs-lang-apply-refactor-keys
           do (js2r-add-keybindings-with-prefix key)))

(use-package tern
  :after js2-mode
  :hook (js2-mode . tern-mode)
  :lang (:map js2-mode-map
         (:find-definition . tern-find-definition)))

(use-package company-tern
  :after tern
  :lang (:comp (js2-mode . company-tern)))

(provide 'mod-lang-js)
