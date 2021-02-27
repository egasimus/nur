; this demo shows how to use the mouse events.
(defn redraw 
  (e) 
  (
    (clear) 
    ; vertical line 
    (stroke (line e:x 0 e:x e:y) "#ff0000") 
    ; horizontal line 
    (stroke 
      (line 0 e:y e:x e:y) "#72dec2") 
    ; circle 
    (stroke 
      (circle 
        e:x 
        e:y 30) "#ffffff")))
;
(on "mouse-down" redraw)
(on "mouse-up" redraw)
(on "mouse-move" redraw)