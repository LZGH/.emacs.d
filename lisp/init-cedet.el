(require 'cedet)

(setq semantic-load-turn-everything-on t)
(semantic-mode 1)

(global-ede-mode t)
(ede-enable-generic-projects)
(global-semantic-idle-summary-mode 1)


(provide 'init-cedet)