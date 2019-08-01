(defun critic-completing-read-cyc-constant-by-type (type mt)
 ""
 (substring-no-properties
  (read-from-minibuffer (concat "Cyc Constant of Type: <" type ">: "))))

;; cmh-constant-complete
;; (defun critic-completing-read-cyc-constant-by-type (type mt)
;;  ""
;;  (completing-read (concat "Cyc Constant of Type: <" type ">: "
;; 		   ())))

(defun critic-choose-predicate ()
 ""
 (interactive)
 (let* ((cyc-constant (thing-at-point 'cyc-constant))
	(cyc-constant-no-properties
	 (if cyc-constant
	  (substring-no-properties cyc-constant)
	  (critic-completing-read-cyc-constant-by-type "#$Predicate" "#$EverythingPSC"))))
 (see (cmh-cyc-query (list "#$argIsa" cyc-constant-no-properties 'var-X 'var-COL) "#$EverythingPSC"))))

;; (see (cmh-send-subl-command "(all-instances #$Predicate #$EverythingPSC)"))


;; #$consumedObject

;; ((((var-X "." "1") (var-COL "." "#$DestructionEvent")) ((var-X "." "1") (var-COL "." "#$Ingesting")) ((var-X "." "2") (var-COL "." "#$PartiallyTangible"))))


(defun critic-extract-arg-types-from-results (result)
 ""
 (dolist (item (first result))
  (see (string-to-number (first (last (alist-get 'var-X item)))))
  (see (first (last (alist-get 'var-COL item))))))

;; (critic-extract-arg-types-from-results '((((var-X "." "1") (var-COL "." "#$DestructionEvent")) ((var-X "." "1") (var-COL "." "#$Ingesting")) ((var-X "." "2") (var-COL "." "#$PartiallyTangible")))))
