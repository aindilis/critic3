(setq critic-knowledge-editor-mode-map nil)

(defvar critic-knowledge-editor-mode-map nil
 "Keymap for Critic mode.")

(let ((map (make-keymap)))
 (define-key map "q" 'critic-knowledge-editor-quit)
 (setq critic-knowledge-editor-mode-map map))

(defun critic-knowledge-editor-quit ()
 ""
 (interactive))

(defun critic-knowledge-editor-mode (item)
 ""
 (interactive)
 (let ((buffer (get-buffer-create (concat "all-asserted: " item))))
  (set-buffer buffer)
  (insert (shell-command-to-string
	   (concat 
	    "/var/lib/myfrdcsa/codebases/releases/freekbs-0.2/freekbs-0.2/scripts/all-asserted-knowledge-2.pl "
	    item)))
  (beginning-of-buffer)
  (switch-to-buffer buffer)
  )
 )

(defun critic-knowledge-editor ()
 ""
 (interactive)
 ;; open up a new window which shows the classifications
 (let* ((entry-id (critic-get-current-entry-id))
	(buffer-name (concat "*CRITIC KE: " entry-id "*"))
	(buffer (get-buffer-create buffer-name)))
  (pop-to-buffer buffer)
  (erase-buffer)
  (insert (concat buffer-name "\n\n"))
  (insert
   (shell-command-to-string
    (concat 
     "scripts/generate-page-for.pl --id "
     entry-id)))
  (beginning-of-buffer)
  )
 )

(defun critic-ke-assert ()
 ""
 (interactive)
 )

(defun critic-ke-edit ()
 ""
 (interactive)
 ;; first get the entry ID, then bring it up, then edit it
 (let ((id (freekbs-get-id-of-assertion-at-point)))
  (if (numberp (read id))
   ()
   )
  )
 )

(defun critic-ke-unassert ()
 ""
 (interactive)
 ;; first get the entry ID, then bring it up, then edit it
 (let ((id (freekbs-get-id-of-assertion-at-point)))
  (if (numberp (read id))
   (if (y-or-n-p (concat "Unassert assertion id: " id " "))
    (freekbs-send (concat "unassert-by-id " id))
    )
   )
  )
 )
