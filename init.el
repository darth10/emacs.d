;;; init.el -*- lexical-binding: t; no-byte-compile: t; -*-

(require 'core (concat user-emacs-directory "lib/core/core"))

;;; Set proxy server if required.
;;; (setq url-proxy-services '(("http" . "host:port")))
(core:defsource '("org-elpa"  . "https://orgmode.org/elpa/"))
(core:defsource '("melpa"     . "https://melpa.org/packages/"))
(core:initialize-packages-and-modules)

;;; Load before language modules.
(require 'mod-company)
(require 'mod-compile)
(require 'mod-editor)
(require 'mod-files)
(require 'mod-helm)
(require 'mod-search)
(require 'mod-vc)

;;; Load language modules.
(require 'mod-lang-c)
(require 'mod-lang-clojure)
(require 'mod-lang-csharp)
(require 'mod-lang-elisp)
(require 'mod-lang-gnuplot)
(require 'mod-lang-go)
(require 'mod-lang-haskell)
(require 'mod-lang-js)
(require 'mod-lang-php)
(require 'mod-lang-powershell)
(require 'mod-lang-python)
(require 'mod-lang-ruby)
(require 'mod-lang-scala)
(require 'mod-lang-scheme)
(require 'mod-lang-sql)

;;; Load after language modules.
(require 'mod-docker)
(require 'mod-games)
(require 'mod-github)
(require 'mod-org)
(require 'mod-projectile)
(require 'mod-servers)
(require 'mod-web)
