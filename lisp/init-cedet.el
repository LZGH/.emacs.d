(setq cedet-root-path
    (file-name-as-directory (expand-file-name
        "lisp/cedet/")))
(add-to-list 'load-path "lisp/cedet/")
		
(setq semantic-load-turn-everything-on t)

(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)

(semantic-mode 1)
(require 'cedet)
(require 'semantic)
;;(require 'semantic/sb)
;;(require 'semantic/ctxt)
;;(require 'semantic/bovine/make)

;;(require 'semantic/bovine/c)

;; if you want to enable support for gnu global
;;(when (cedet-gnu-global-version-check t)
;;  (semanticdb-enable-gnu-global-databases 'c-mode)
;;  (semanticdb-enable-gnu-global-databases 'java-mode))

;; enable ctags for some languages:
;;  Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
;;(when (cedet-ectag-version-check t)
;;  (semantic-load-enable-primary-exuberent-ctags-support))


(global-ede-mode t)

;;(require 'semantic/db-javap)

(ede-java-root-project "TestProject"
         :file "~/work/TestProject/build.xml"
         :srcroot '("src" "test")
         :localclasspath '("/relative/path.jar")
         :classpath '("/absolute/path.jar"))

(ede-enable-generic-projects)
(global-semantic-idle-summary-mode 1)


(provide 'init-cedet)