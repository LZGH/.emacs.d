;;
;; init-find-file-in-project.el --- Find files in a project quickly, on any OS
;; 

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(require 'find-file-in-project)

(if (eq system-type 'windows-nt)
    ;; Native Windows
    (setq ffip-project-root "F:/emacs")
)

;; if the full path of current file is under SUBPROJECT1 or SUBPROJECT2
;; OR if I'm reading my personal issue track document,
(defun my-setup-develop-environment ()
  (interactive)
  (when (ffip-current-full-filename-match-pattern-p "\\(/|/PROJECT_DIR\\|issue-track.org\\)")
    ;; Though PROJECT_DIR is team's project, I care only its sub-directory "subproj1""
    ;;(setq-local ffip-project-root "~/projs/PROJECT_DIR/subproj1")
    ;; well, I'm not interested in concatenated BIG js file or file in dist/
    (setq-local ffip-find-options "-not -size +64k -not -iwholename '*/dist/*'")
    ;; for this project, I'm only interested certain types of files
    (setq-local ffip-patterns '("*.html" "*.js" "*.css" "*.xml"))
    ;; exclude below directories and files
    (setq-local ffip-prune-patterns '("*/.git/*" "*/node_modules/*" "*/index.js")))
  ;; insert more WHEN statements below this line for other projects
  )
;; most major modes inherit from prog-mode, so below line is enough
(add-hook 'helm-mode 'my-setup-develop-environment)

(autoload 'find-file-in-project "find-file-in-project" nil t)
(autoload 'find-file-in-project "find-file-in-project-by-selected" nil t)
(autoload 'find-file-in-project "find-directory-in-project-by-selected" nil t)

(provide 'init-find-file-in-project)

;;; init-find-file-in-project.el ends here