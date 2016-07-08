;;
;; init-find-file-in-project.el --- Find files in a project quickly, on any OS
;; 

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(require 'find-file-in-project)

(autoload 'find-file-in-project "find-file-in-project" nil t)
(autoload 'find-file-in-project "find-file-in-project-by-selected" nil t)
(autoload 'find-file-in-project "find-directory-in-project-by-selected" nil t)

(setq ffip-project-root "/")
;; well, I'm not interested in concatenated BIG js file or file in dist/
(setq ffip-find-options "-not -size +64k -not -iwholename '*/dist/*'")
;; for this project, I'm only interested certain types of files
;;(setq ffip-patterns '("*.html" "*.js" "*.css" "*.java" "*.xml" "*.el"))
;; exclude below directories and files
(setq ffip-prune-patterns '("*/.metadata/*" "*/classes/*"))

(if (eq system-type 'windows-nt)
    ;; Native Windows
    (setq ffip-project-root "D:/eclipse_workspace")
  )

(global-set-key (kbd "C-x f") 'find-file-in-project)
(global-set-key (kbd "C-c f") 'find-file-in-project-by-selected)

(provide 'init-find-file-in-project)

;;; init-find-file-in-project.el ends here
