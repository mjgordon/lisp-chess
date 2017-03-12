(defclass chess-gui ()
  ((image-library :accessor image-library)
   (gui-canvas :accessor gui-canvas)
   (grid-size :accessor grid-size
	      :initform 64)))

(defmethod chess-gui-init ((object chess-gui))

  (with-ltk()
    (let* ((board (make-instance 'frame
				 :master nil))
	   (sidebar (make-instance 'frame
				   :master nil))
	   (move-list (make-instance 'text
				     :master sidebar))
	   
	   ;;(sc (make-instance 'scrolled-canvas))
	   ;;(c (canvas sc))
	   (c (make-canvas board
			   :width 512
			   :height 512
			   :xscroll 512
			   :yscroll 512))
	   (img-library (make-hash-table))
	   (image-names '("board"
			  "wk" "wq" "wb" "wn" "wr" "wp"
			  "bk" "bq" "bb" "bn" "br" "bp"))
	   (starting-position '("br" "bn" "bb" "bq" "bk" "bb" "bn" "br"
				"bp" "bp" "bp" "bp" "bp" "bp" "bp" "bp"
				nil nil nil nil nil nil nil nil
				nil nil nil nil nil nil nil nil
				nil nil nil nil nil nil nil nil
				nil nil nil nil nil nil nil nil
				"wp" "wp" "wp" "wp" "wp" "wp" "wp" "wp"
				"wr" "wn" "wb" "wq" "wk" "wb" "wn" "wr")))



      

      (mapcar (lambda (name)
		(load-graphic img-library name))
	      image-names)
      

      (setf (gui-canvas object) c)
      (setf (image-library object) img-library)


      (pack board :side :left)
      (pack sidebar :side :right)
      ;;(pack sc :expand 0 :fill :both)
      (pack c)
      (pack move-list)
      (scrollregion c 0 0 800 800)

      (draw-board object starting-position))))

(defun load-graphic (hash-table-name graphic-name)
  (let ((img (make-image)))
    (image-load img (format nil "data/~a.png" graphic-name))
    (setf (gethash graphic-name hash-table-name) img)))

(defmethod draw-board ((object chess-gui) state)
  (let ((gui-canvas (gui-canvas object))
	(image-library (image-library object))
	(grid-size (grid-size object)))
    
    
    (ltk:clear gui-canvas)
    (create-image gui-canvas  0 0 :image (gethash "board" image-library))
    (let ((x 0)
	  (y 0))
      (mapcar (lambda (name)
		(create-image gui-canvas x y :image (gethash name image-library))
		(setf x (+ x grid-size))
		(if (= x (* grid-size 8))
		    (progn (setf x 0)
			   (setf y (+ y grid-size)))))
	      state))))
