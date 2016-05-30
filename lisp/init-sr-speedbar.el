(require-package 'sr-speedbar)

(require 'sr-speedbar)

;;sr-speedbar-skip-other-window-p 多窗口切换时跳过speedbar窗口
(custom-set-variables 
	'(sr-speedbar-skip-other-window-p t) 
	'(sr-speedbar-right-side nil)
	'(sr-speedbar-auto-refresh t)
	'(speedbar-use-images nil)
	'(speedbar-show-unknown-files t)
	'(speedbar-hide-button-brackets-flag t)
	'(speedbar-smart-directory-expand-flag t)
	'(sr-speedbar-max-width 40)
	'(sr-speedbar-width 30))
	
(global-set-key (kbd "C-x t") 'sr-speedbar-toggle)
		  
(provide 'init-sr-speedbar)