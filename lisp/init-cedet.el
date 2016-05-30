(require 'cedet)

(require 'semantic)
(require 'semantic/sb)
(require 'semantic/ia)
(require 'semantic/ctxt)
(require 'semantic/bovine/make)
(require 'semantic/bovine/gcc)
(require 'semantic/bovine/c)
(setq semantic-load-turn-everything-on t)
(semantic-mode 1)

(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)


(global-ede-mode t)
(ede-enable-generic-projects)
(global-semantic-idle-summary-mode 1)


(provide 'init-cedet)