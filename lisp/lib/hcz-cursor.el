;;; Change cursor color according to mode

(defvar hcz-set-cursor-color-color "")
(defvar hcz-set-cursor-color-buffer "")

(defun hcz-set-cursor-color-according-to-mode ()
  "change cursor color according to some minor modes."
  ;; set-cursor-color is somewhat costly, so we only call it when needed:
  (let ((color
	 (if buffer-read-only "gray"
	   (if overwrite-mode
	       "yellow"
	     "green"))))
    (unless (and
	     (string= color hcz-set-cursor-color-color)
	     (string= (buffer-name) hcz-set-cursor-color-buffer))
      (set-cursor-color (setq hcz-set-cursor-color-color color))
      (setq hcz-set-cursor-color-buffer (buffer-name)))))

(provide 'hcz-cursor)
