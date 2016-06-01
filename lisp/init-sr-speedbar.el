(require-package 'sr-speedbar)

(require 'sr-speedbar)

;;sr-speedbar-skip-other-window-p 多窗口切换时跳过speedbar窗口
(custom-set-variables 
	'(sr-speedbar-skip-other-window-p t) 
	'(sr-speedbar-right-side nil)
	'(sr-speedbar-auto-refresh nil)
	'(speedbar-use-images nil)
	'(speedbar-show-unknown-files t)
	'(speedbar-hide-button-brackets-flag t)
	'(speedbar-smart-directory-expand-flag t)
	'(sr-speedbar-max-width 50)
	'(sr-speedbar-width 40))
	
(global-set-key (kbd "C-x t") 'sr-speedbar-toggle)
(global-set-key (kbd "C-c t") 'sr-speedbar-refresh-toggle)	  

(when window-system
  (defadvice sr-speedbar-open (after sr-speedbar-open-resize-frame activate)
    (set-frame-width (selected-frame)
                     (+ (frame-width) sr-speedbar-width)))
  (ad-enable-advice 'sr-speedbar-open 'after 'sr-speedbar-open-resize-frame)

  (defadvice sr-speedbar-close (after sr-speedbar-close-resize-frame activate)
    (sr-speedbar-recalculate-width)
    (set-frame-width (selected-frame)
                     (- (frame-width) sr-speedbar-width)))
  (ad-enable-advice 'sr-speedbar-close 'after 'sr-speedbar-close-resize-frame))

(provide 'init-sr-speedbar)