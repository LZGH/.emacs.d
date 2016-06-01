(require-package 'auto-yasnippet)
(require 'yasnippet)

(yas-global-mode 1)

;; default TAB key is occupied by auto-complete
(global-set-key (kbd "M-/") 'yas/expand)
;;yas-next-field
;;(define-key global-map (kbd "C-TAB") 'yas/next-field)
;; default hotkey `C-c & C-s` is still valid
(global-set-key (kbd "C-c ; s") 'yas/insert-snippet)
;; give yas/dropdown-prompt in yas/prompt-functions a chance

;; use yas/completing-prompt when ONLY when `M-x yas/insert-snippet'
;; thanks to capitaomorte for providing the trick.
(defadvice yas/insert-snippet (around use-completing-prompt activate)
     "Use `yas/completing-prompt' for `yas/prompt-functions' but only here..."
       (let ((yas/prompt-functions '(yas/completing-prompt)))
             ad-do-it))

(provide 'init-yasnippet)
