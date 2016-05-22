;;; init-w3m.el --- interface for w3m on emacs
(require-package 'w3m)
(require 'w3m)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;; 设置 w3m 主页
(setq w3m-home-page "http://www.baidu.com")

;; 默认显示图片
(setq w3m-default-display-inline-images t)
(setq w3m-default-toggle-inline-images t)

;; 使用 cookies
(setq w3m-use-cookies t)

;; 设定 w3m 运行的参数，分别为使用 cookie 和使用框架  
(setq w3m-command-arguments '("-cookie" "-F"))

;; 使用 w3m 作为默认浏览器
(setq browse-url-browser-function 'w3m-browse-url)
(setq w3m-view-this-url-new-session-in-background t)

;; 显示图标                                                      
(setq w3m-show-graphic-icons-in-header-line t)
(setq w3m-show-graphic-icons-in-mode-line t)

(add-hook 'w3m-fontify-after-hook 'remove-w3m-output-garbages)
(defun remove-w3m-output-garbages ()
  " 去掉 w3m 输出的垃圾."
  (interactive)
  (let ((buffer-read-only))
        (setf (point) (point-min))
        (while (re-search-forward "[\200-\240]" nil t)
          (replace-match " "))
        (set-buffer-multibyte t))
  (set-buffer-modified-p nil))

(provide 'init-w3m)

;;; init-w3m.el ends here