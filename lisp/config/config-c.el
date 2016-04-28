;;; Configuration for C/C++

;; (require 'config-common)

(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (other . "k&r")))

(setq-default c-basic-offset 4
              tab-width 4
              indent-tabs-mode nil)

(defun config-display-gdb-buffer ()
  (interactive)
  (require 'config-gud)
  (if (fboundp 'gdb-display-gdb-buffer)
      (gdb-display-gdb-buffer)
    (config-show-no-gud)))

(defconfig configure-c
  (setq c-eldoc-includes "`pkg-config glib-2.0 gio-2.0 --cflags` `guile-config compile` -I/usr/include -I./ -I../ ")
  (load "c-eldoc")
  (c-turn-on-eldoc-mode)
  ;; (smartparens-mode)
  (bind-key "C-<f10>" 'config-display-gdb-buffer c-mode-map)
  (bind-key "C-! C-r" 'config-display-gdb-buffer c-mode-map)
  (bind-key "C-c C-z" 'config-display-gdb-buffer c-mode-map)
  (bind-key "C-<f11>" 'gdb c-mode-map)
  (bind-key "C-! C-d" 'gdb c-mode-map)
  (bind-key "C-<f5>" 'gud-run c-mode-map)
  (bind-key "C-x C-a C-a" 'gud-run c-mode-map)
  (bind-key "C-x a a" 'gud-run c-mode-map)
  (bind-key "C-<f12>" 'gdb-display-disassembly-buffer c-mode-map)
  (bind-key "C-x C-a C-q" 'gdb-display-disassembly-buffer c-mode-map)
  (bind-key "C-x a q" 'gdb-display-disassembly-buffer c-mode-map)
  )

(add-hook 'c-mode-hook 'configure-c)
(add-hook 'c++-mode-hook 'configure-c)

(provide 'config-c)
