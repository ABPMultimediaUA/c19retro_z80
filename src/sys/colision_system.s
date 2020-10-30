

.include "../man/entity_manager.h.s"
.include "../man/game.h.s"
.include "../man/map_manager.h.s"

.include "../cpct_functions.h.s"



;Input: ix ghost, iy player
;Ret: a = 1 if colision
sys_colision_ghost_player::  
  
check_colision_x:
  ld  a, e_x(iy)    ;; x2
  ld  b, a  
  ld  a, e_x(ix)    ;; x1  
  add #e_size_w
  cp  b             ;; IF (x1+w) < x2 THEN c=1 ELSE IF (x1+w)=x2 THEN z=1
  jr  c, _no_colision_ghost_player
  jr  z, _no_colision_ghost_player

  ld  a, e_x(ix)    ;; x1
  ld  b, a  
  ld  a, e_x(iy)    ;; x2
  add #e_size_w
  cp  b             ;; IF (x2+w) < x1 THEN c=1 ELSE IF (x2+w)=x1 THEN z=1
  jr  c, _no_colision_ghost_player
  jr  z, _no_colision_ghost_player

check_colision_y:
  ld  a, e_y(iy)    ;; y2
  ld  b, a  
  ld  a, e_y(ix)    ;; y1  
  add #e_size_h
  cp  b             ;; IF (y1+h) < y2 THEN c=1 ELSE IF (y1+h)=y2 THEN z=1
  jr  c, _no_colision_ghost_player
  jr  z, _no_colision_ghost_player

  ld  a, e_y(ix)    ;; y1
  ld  b, a  
  ld  a, e_y(iy)    ;; y2
  add #e_size_h
  cp  b             ;; IF (y2+h) < y1 THEN c=1 ELSE IF (y2+h)=y1 THEN z=1
  jr  c, _no_colision_ghost_player
  jr  z, _no_colision_ghost_player
_colision_ghost_player:
  ld  a, #1
  ret
_no_colision_ghost_player:
  ld  a, #0
  ret


; Input ix, iy (2 entities)
; Return a { 1 if colision, 0 if not}
sys_colision_entity_entity::
  ld  a, e_xcell(ix)
  ld  b, a
  ld  a, e_xcell(iy)

  cp  b   ; a - b (x2-x1)
  jr  nz, _no_colision

  ld  a, e_ycell(ix)
  ld  b, a
  ld  a, e_ycell(iy)

  cp  b   ; a - b (y2-y1)
  jr  nz, _no_colision

_colision:
  ld  a, #1
  ret
_no_colision:
  ld  a, #0
  ret