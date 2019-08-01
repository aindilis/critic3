(defun make-tabulated-headers (column-names rows)
   "column width are calculated by picking the max width of every cell under that
column + the column name"
 (let ((widths
	(-reduce-from
	 (lambda (acc x)
	  (-zip-with (lambda (l r) (max l (length r))) acc (append x '())))
	 (-map #'length columns-names)
	 rows)))
  (cl-map
   #'vector #'identity
   (-zip-with
    (lambda (col size) (list col size nil))
    columns-names widths))))

(defun display-table-in-buffer (columns-names rows)
 (let ((headers (make-tabulated-headers columns-names rows))
       (bname "*display table*"))
  (with-current-buffer (get-buffer-create bname)
   (tabulated-list-mode)
   (setq tabulated-list-format headers)
   (setq tabulated-list-padding 2)
   (tabulated-list-init-header)
   (setq tabulated-list-entries
    (-zip-with
     (lambda (i x) (list i x))
     (-iterate '1+ 0 (length rows))
     rows))
   (tabulated-list-print t)
   (popwin:popup-buffer bname))))

;; (display-table-in-buffer
;;  '("Header 1" "Header 2" "Header 3" "#")
;;  '(["" "foo" "bar" "123"]
;;    ["abc" "def" "hij" "900"]))
