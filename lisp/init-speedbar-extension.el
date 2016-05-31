(require 'sr-speedbar)

;; Code:
(defun speedbar-forced-contract ()
  "collapses the sub list the cursor is in"
  (interactive)
  (let ((depth (save-excursion (beginning-of-line)
                               (if (looking-at "[0-9]+:")
                                   (string-to-number (match-string 0))
                                 0)))
        (lastmatch (point))
        (condition 1))
    (while (/= condition 0)
      (forward-line -1)
      (let ((subdepth (save-excursion (beginning-of-line)
                                      (if (looking-at "[0-9]+:")
                                          (string-to-number (match-string 0))
                                        0))))
        (cond ((or (< subdepth depth)
                   (progn (end-of-line) (eobp))
                   (progn (beginning-of-line) (bobp)))
               ;; We have reached the end of this block.
               (goto-char lastmatch)
               (setq condition 0))
              ((= subdepth depth)
               (setq lastmatch (point))))))
    (speedbar-position-cursor-on-line))
  (forward-line -1)
  (speedbar-contract-line))

(defun speedbar-buffers ()
  "show buffer list in the speedbar"
  (interactive)
  (speedbar-change-initial-expansion-list "quick buffers"))

(defun speedbar-files ()
  "show file list in the speedbar"
  (interactive)
  (speedbar-change-initial-expansion-list "files"))

(provide 'init-speedbar-extension)

;; init-speedbar-extension.el ends here
