;; critic3-mode.el

(load "/var/lib/myfrdcsa/codebases/minor/critic3/frdcsa/emacs/critic-knowledge-editor.el")

(global-set-key "\C-cCrc" 'critic)
(global-set-key "\C-cCrk" 'critic-knowledge-editor)
(global-set-key "\C-cCrdak" 'critic-record-new-assertion-keybinding)
(global-set-key "\C-cCrv" 'critic-view-recent-entries)
(global-set-key "\C-cCrg" 'critic-view-recent-goals)
(global-set-key "\C-cCrq" 'critic-critique-entries)
(global-set-key "\C-cCrrd" 'critic-redefine-current-knowledge-editor-mode-map)
(global-set-key "\C-cCrKe" 'critic-ke-edit)
(global-set-key "\C-cCrKu" 'critic-ke-unassert)
(global-set-key "\C-cCrt" 'critic-classify)
(global-set-key "\C-cCrs" 'critic-split-window-into-n-columns)

(defvar critic-mode-map nil
 "Keymap for Critic mode.")

(defvar critic-default-context-root "Org::FRDCSA::CRITIC::Domain")

(defvar critic-metadata-context "Org::FRDCSA::CRITIC::Metadata")

(defvar critic-current-domain nil)

(defvar critic-current-context nil)

(defvar critic-possible-domains
 (list
  "UniLang"
  "ToDo"
  "SPSE2"
  ))

(defun critic-redefine-current-knowledge-editor-mode-map ()
 ""
 (interactive)
 (see
  (freekbs2-query
   '("hasKeybinding" critic-current-context var-keybinding var-function)
   critic-metadata-context)))

(defun critic-define-current-knowledge-editor-mode-map ()
 ""
 (interactive)
 
 (let ((map (make-keymap)))
  ;; go ahead and query the formalog to get 

  ;; which predicates are completeExtentAsserted
  (define-key map "pc" 'pse-completed)
  (define-key map "pC" 'pse-query-completed)
  (define-key map "pi" 'pse-incomplete)
  (define-key map "po" 'pse-comment)
  (define-key map "ps" 'pse-solution)
  (define-key map "pb" 'pse-belongs-to)
  (define-key map "sa" 'freekbs-assert-relation)
  (define-key map "su" 'freekbs-assert-relation)
  (define-key map "s." 'freekbs-push-entry-at-point-onto-stack)
  (define-key map "sc" 'freekbs-clear-stack)
  (define-key map "t" 'critic-classify)
  (define-key map "k" 'critic-knowledge-editor)
  (setq critic-mode-map map)))

(critic-define-current-knowledge-editor-mode-map)

(defvar critic-mode-syntax-table nil
 "Syntax table used while in text mode.")
     
(defun critic ()
 ""
 (interactive)
 (let* ((buffer (get-buffer-create (concat "*CRITIC<" critic-current-context ">*"))))
  (pop-to-buffer buffer)
  (critic-mode)
  (beginning-of-buffer)))

(defun critic-mode ()
 "Major mode for editing text intended for humans to read...
      Special commands: \\{critic-mode-map}
     Turning on critic-mode runs the hook `critic-mode-hook'."
 (interactive)
 (kill-all-local-variables)
 (use-local-map critic-mode-map)
 ;; (setq local-abbrev-table critic-mode-abbrev-table)
 ;; (set-syntax-table critic-mode-syntax-table)
 (setq mode-name "Critic")
 (setq major-mode 'critic-mode)
 (run-hooks 'critic-mode-hook)
 (if (null critic-current-context)
  (critic-choose-current-context))
 (critic-load-current-context-into-critic-buffer))

(defun critic-choose-current-context ()
 ""
 (interactive)
 (let* ((domain (completing-read "Current CRITIC Domain: " critic-possible-domains)))
  (if (non-nil domain)
   (progn
    (setq critic-current-context
     (concat critic-default-context-root "::" domain))
    (setq critic-current-domain domain))
   (error "Not set"))))

(defun critic-load-current-context-into-critic-buffer ()
 ""
 (interactive)
 (kmax-clear-buffer)
 (insert
  (shell-command-to-string
   (concat
    "/var/lib/myfrdcsa/codebases/minor/critic3/scripts/critic-load-current-context.pl -d "
    (shell-quote-argument critic-current-context))))
 (critic-hide-digests)
 (critic-hide-keys))

(defun critic-hide-digests ()
 ""
 (interactive)
 (beginning-of-buffer)
 (while (non-nil (critic-next-digest))
  (critic-hide-line)))

(defun critic-next-digest ()
 ""
 (interactive)
 (condition-case nil
  (re-search-forward "^Digest: ")
  (error nil)))
 
(defun critic-hide-line ()
 ""
 (interactive)
 (beginning-of-line)
 (set-mark (point))
 (end-of-line)
 (forward-char 1)
 (put-text-property (mark) (point) 'invisible t))

(defun critic-hide-keys ()
 ""
 (interactive)
 (beginning-of-buffer)
 (while (non-nil (critic-next-key))
  (critic-hide-key)))

(defun critic-next-key ()
 ""
 (interactive)
 (forward-char 1)
 (condition-case nil
  (re-search-forward "^\\([0-9A-Za-z]+\\): ")
  (error nil)))

(defun critic-hide-key ()
 ""
 (interactive)
 (set-mark (point))
 (beginning-of-line)
 (put-text-property (point) (mark) 'invisible t))

(defun critic-get-key-for-current-entry (key)
 ""
 (interactive)
 (re-search-backward "^Digest: ")
 (backward-char 1)
 (re-search-forward (concat "^" key ": "))
 (forward-char 1)
 (let ((hidden (critic-line-hidden-p)))
  (if hidden
   (critic-unhide-line))
  (re-search-backward (concat "^" key ": "))
  (setq critic-tmp-text (substring-no-properties (kmax-get-line)))
  (if hidden
   (critic-hide-line))
  (string-match (concat "^" key ": \\(.+\\)$") critic-tmp-text)
  (see (match-string 1 critic-tmp-text))))

(defun critic-line-hidden-p ()
 ""
 (interactive)
 (get-text-property (point) 'invisible))

(defun critic-unhide-line ()
 ""
 (interactive)
 (beginning-of-line)
 (set-mark (point))
 (end-of-line)
 (forward-char 1)
 (remove-text-properties (mark) (point) '(invisible)))

(defun critic-unhide-buffer ()
 ""
 (interactive)
 (mark-whole-buffer)
 (remove-text-properties (point) (mark) '(invisible)))

(defun critic-next-entry ()
 "Jump to next entry in list"
 (interactive)
 (next-line))

(defun critic-previous-entry ()
 "Jump to previous entry in list"
 (interactive)
 (forward-line -1))

(defun critic-search ()
 "search for matching entries")

(defun critic-rate ()
 "")

(defun critic-get-current-entry-id ()
 ""
 (interactive)
 (critic-get-key-for-current-entry "Digest"))

(defun critic-relate ()
 "")

(defun critic-compare ()
 "")

(defun critic-reload ()
 "")

(defun critic-resort ()
 "")

;; selection algebra

(defun critic-select ()
 "")

(defun critic-deselect ()
 "")

(defun critic-select-all ()
 "")

(defun critic-deselect-all ()
 "")

(defun critic-select-region ()
 "")

(defun critic-deselect-region ()
 "")

(defun critic-push-up ()
 "")

(defun critic-push-down ()
 "")

(defun critic-view ()
 "")

(defun critic-classify ()
 "")

(defun critic-record-new-assertion-keybinding ()
 ""
 (interactive)
 ;; critic-current-context
 (see (read-key-sequence "Describe key (or click or menu item): "))
 ;; (critic-reload-all-affected-critic-buffers)
 )

(defun critic-reload-all-affected-critic-buffers ()
 ""
 (interactive))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (defun critic-view-recent-entries (&optional depth search)
;;  ""
;;  (interactive "p")
;;  (if (= depth 1)
;;   (setq depth 100))
;;  (pop-to-buffer (get-buffer-create "Critic"))
;;  (erase-buffer)
;;  (insert
;;   ;; (shell-command-to-string 
;;    (concat 
;;     "corpus -s "
;;     (if (non-nil search)
;;      (shell-quote-argument search)
;;      ".")
;;     " -d " 
;;     (number-to-string depth)
;;     " --k2 "
;;     freekbs2-context
;;     ))
;;  (critic-mode))

;; (defun critic-view-recent-goals ()
;;  ""
;;  (interactive)
;;  (pop-to-buffer (get-buffer-create (concat "Critic-Goals " freekbs-context)))
;;  (erase-buffer)
;;  (insert
;;   (shell-command-to-string 
;;    (concat 
;;     "corpus -s "
;;     "."
;;     " -k "
;;     freekbs-context
;;     " -g "
;;     )))
;;  (critic-mode))


;; (defun critic-critique-entries ()
;;  ""
;;  (interactive)
;;  ;; what this is going to do is to allow the user to search some
;;  ;; existing set of entries.  first, depending on how you ask it, it
;;  ;; removes the entries that you've already seen (or it just displays
;;  ;; them under a "seen" heading or with some markup that they have
;;  ;; been seen.
;;  ;; 
;;  ;; Then it allows you to make assertions, and reload if you wish the
;;  ;; contents, finally you can mark which sections you have reviewed.
;;  ;; note that you can mark it as reviewed wrt a specific purpose.

;;  ;; this same review system should actually apply to knowledge as well
;;  (if (= depth 1)
;;   (setq depth 100))
;;  (pop-to-buffer (get-buffer-create "Critic"))
;;  (erase-buffer)
;;  (insert
;;   (shell-command-to-string 
;;    (concat 
;;     "corpus -s "
;;     (if (non-nil search)
;;      (shell-quote-argument search)
;;      ".")
;;     " -d " 
;;     (number-to-string depth)
;;     " -k"
;;     )))
;;  (critic-mode))



;; n-ary functions

(defun critic-split-window-into-n-columns (arg)
 ""
 (interactive "P")
 (delete-other-windows)
 (dotimes (i (- arg 1))
  (split-window-horizontally))
 (balance-windows)) 

;; (critic-split-window-into-n-columns 5)
