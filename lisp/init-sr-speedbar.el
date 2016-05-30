(require-package 'sr-speedbar)

(require 'sr-speedbar)

;;sr-speedbar-right-side 把speedbar放在左侧位置
;;sr-speedbar-skip-other-window-p 多窗口切换时跳过speedbar窗口
;;sr-speedbar-max-width与sr-speedbar-width-x 设置宽度
(custom-set-variables 
	'(sr-speedbar-right-side nil)
	'(sr-speedbar-skip-other-window-p t) 
	'(sr-speedbar-max-width 20) 
	'(sr-speedbar-width-x 8))

;; Start Sr-Speedbar in buffer mode by default
(add-hook 'speedbar-mode-hook
          (lambda ()
            (speedbar-change-initial-expansion-list "quick buffers")))
			
(global-set-key (kbd "<f5>") (lambda()
          (interactive)
          (sr-speedbar-toggle)))
		  
(provide 'init-sr-speedbar)