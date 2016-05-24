;;----------------------------------------------------------------------------
;; BY LZ
;;----------------------------------------------------------------------------

 ;;set transparent effect
 (global-set-key [(f11)] 'loop-alpha)
 (setq alpha-list '((100 100) (65 35)))
 (defun loop-alpha ()
    (interactive)
    (let ((h (car alpha-list)))                ;; head value will set to
      ((lambda (a ab)
         (set-frame-parameter (selected-frame) 'alpha (list a ab))
         (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
        ) (car h) (car (cdr h)))
     (setq alpha-list (cdr (append alpha-list (list h))))
     )
 )
 
;; 编码设置 begin
(scroll-bar-mode nil)
(set-language-environment 'Chinese-GB)
(set-keyboard-coding-system 'euc-cn)
(set-clipboard-coding-system 'euc-cn)
(set-terminal-coding-system 'euc-cn)
(set-buffer-file-coding-system 'euc-cn)
(set-selection-coding-system 'euc-cn)
(set-default-coding-systems 'euc-cn)
(modify-coding-system-alist 'process "*" 'euc-cn)
(setq default-process-coding-system
      '(euc-cn . euc-cn))
(setq-default pathname-coding-system 'euc-cn)
(set-file-name-coding-system 'euc-cn) 

;; default-buffer-file-coding-system变量在emacs23.2之后已被废弃，使用buffer-file-coding-system代替
(set-default buffer-file-coding-system 'euc-cn)
(set-default-coding-systems 'utf-8)
(setq file-name-coding-system 'euc-cn)
(prefer-coding-system 'utf-8) 

;;插入日期乱码解决。。。
(setq locale-coding-system 'euc-cn) 

;;(ansi-color-for-comint-mode-on)
;; 编码设置 end

(setq auto-image-file-mode t) ;;让 Emacs 可以直接打开和显示图片。
(setq org-image-actual-width 10)       ; Fallback to width 300
 

  (set-fontset-font "fontset-default"
 'gb18030 '("Microsoft YaHei" . "unicode-bmp"))

;; chinese-gbk 编码的shell终端
(defun gshell()
  (interactive)
  (let ((coding-system-for-read 'chinese-gbk)
	(coding-system-for-write 'chinese-gbk))
    (call-interactively (shell))))
;; utf-8-unix 编码的 shell终端
(defun ushell()
  (interactive)
  (let ((coding-system-for-read 'utf-8-unix)
	(coding-system-for-write 'utf-8-unix))
    (call-interactively (shell))))
	

;; 代码高亮
(setq org-src-fontify-natively t)

;; org-mode自动换行
(global-set-key [f12] 'toggle-truncate-lines)
;; org-mode缩进
(setq org-startup-indented t)

;; 执行代码
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (sh . t)
   (python . t)
   (java . t)
   (R . t)
   (ruby . t)
   (ditaa . t)
   (dot . t)
   (octave . t)
   (sqlite . t)
   (perl . t)
   (C . t)
   ))
;;缩进
;;(setq c-basic-offset 4)
;;(setq tab-width 4)
;;(setq-default indent-tabs-mode t)

;;重新绑定tab键
(global-set-key [C-tab] '(lambda () (interactive) (insert-char 9 1)))

(provide 'myInit)
;;; myInit.el ends here
