

.include "../man/entity_manager.h.s"
.include "../man/game.h.s"
.include "../man/map_manager.h.s"

.include "../cpct_functions.h.s"



;Input: ix ghost, iy player
;Ret: a = 1 if colision
sys_colision_ghost_player::
    ret


; Input ix, iy (2 entities)
; Return a { 1 if colision, 0 if not}
sys_colision_entity_entity::
  ld  a, e_xcell(ix)
  ld  b, a
  ld  a, e_xcell(iy)

  sub b   ; a - b (x2-x1)
  jr  nz, _no_colision

  ld  a, e_ycell(ix)
  ld  b, a
  ld  a, e_ycell(iy)

  sub b   ; a - b (y2-y1)
  jr  nz, _no_colision

_colision:
  ld  a, #1
  ret
_no_colision:
  ld  a, #0
  ret