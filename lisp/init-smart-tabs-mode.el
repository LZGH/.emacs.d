(require-package 'smart-tabs-mode)
(require 'smart-tabs-mode)

(autoload 'smart-tabs-mode "smart-tabs-mode"
	"Intelligently indent with tabs, align with spaces!")
(autoload 'smart-tabs-mode-enable "smart-tabs-mode")
(autoload 'smart-tabs-advice "smart-tabs-mode")
(autoload 'smart-tabs-insinuate "smart-tabs-mode")

(smart-tabs-insinuate 'c 'c++ 'java 'javascript 'cperl 'python 'ruby 'nxml)
		   
(setq-default tab-width 4) ; or any other preferred value
(setq-default indent-tabs-mode t)
(setq cua-auto-tabify-rectangles nil)

(add-hook 'js2-mode-hook 'smart-tabs-mode-enable)
(smart-tabs-advice js2-indent-line js2-basic-offset)
(add-hook 'js2-mode-hook (lambda () (indent-tabs-mode t)))

;; Perl (cperl-mode)
(add-hook 'cperl-mode-hook 'smart-tabs-mode-enable)
(smart-tabs-advice cperl-indent-line cperl-indent-level)

;; Python
(add-hook 'python-mode-hook 'smart-tabs-mode-enable)
(smart-tabs-advice python-indent-line-1 python-indent)

(defadvice align (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice align-regexp (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice indent-relative (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice indent-according-to-mode (around smart-tabs activate)
  (let ((indent-tabs-mode indent-tabs-mode))
	(if (memq indent-line-function
			  '(indent-relative
				indent-relative-maybe))
		(setq indent-tabs-mode nil))
	ad-do-it))
(defmacro smart-tabs-advice (function offset)
  `(progn
	 (defvaralias ',offset 'tab-width)
	 (defadvice ,function (around smart-tabs activate)
	   (cond
		(indent-tabs-mode
		 (save-excursion
		   (beginning-of-line)
		   (while (looking-at "\t*\\( +\\)\t+")
			 (replace-match "" nil nil nil 1)))
		 (setq tab-width tab-width)
		 (let ((tab-width fill-column)
			   (,offset fill-column)
			   (wstart (window-start)))
		   (unwind-protect
			   (progn ad-do-it)
			 (set-window-start (selected-window) wstart))))
		(t
		 ad-do-it)))))
(smart-tabs-advice c-indent-line c-basic-offset)
(smart-tabs-advice c-indent-region c-basic-offset)

(provide 'init-smart-tabs-mode)
