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

(provide 'init-sr-speedbar)