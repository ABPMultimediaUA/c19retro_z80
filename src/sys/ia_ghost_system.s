.include "../man/entity_manager.h.s"
.include "../man/game.h.s"
.include "../man/map_manager.h.s"

.include "../cpct_functions.h.s"

; Input: ix ghost, iy player
sys_ia_ghost::
    ld  a, e_x(iy)
    ld  b, e_x(ix)

    ; if a < b: C-flag = 1
    cp  b
    jr  c, _move_ghost_left

_move_ghost_right:
    ld  a, e_x(ix)
    ld  b, #1
    add b 
    ld  e_x(ix), a
    ret

_move_ghost_left:
    ld  a, e_x(ix)
    ld  b, #-1
    add b 
    ld  e_x(ix), a
    ret