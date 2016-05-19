;;; package helm
(require-package 'helm)
(require 'helm-config)
(require 'helm)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-m") 'helm-M-x)
(global-set-key (kbd "C-h f") 'helm-apropos)
(global-set-key (kbd "C-h r") 'helm-info-emacs)
(global-set-key (kbd "C-h C-l") 'helm-locate-library)
(global-set-key (kbd "C-h i") 'helm-info-at-point)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action

(setq helm-semantic-fuzzy-match t
	  helm-M-x-fuzzy-match t
	  helm-buffers-fuzzy-matching t
	  helm-locate-fuzzy-match t
	  helm-recentf-fuzzy-match	t
      helm-imenu-fuzzy-match    t)
	  
;;invoke helm-ff-run-grep with C-s to search a file/directory on highlighted entry in the Helm buffer.
(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

;;quickly jump to any man entry using Helm interface
(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(helm-mode 1)
(helm-autoresize-mode t)
(provide 'init-helm)
;;; init-helm.el ends here
