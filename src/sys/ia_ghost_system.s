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
    jr  z, _check_y
    jr  c, _move_ghost_left

_move_ghost_right:
    ld  a, e_x(ix)
    ld  b, #1
    add b 
    ld  e_x(ix), a
    jr  _check_y

_move_ghost_left:
    ld  a, e_x(ix)
    ld  b, #-1
    add b 
    ld  e_x(ix), a
    jr  _check_y

_check_y:
    ld  a, e_y(iy)
    ld  b, e_y(ix)

    ; if a < b: C-flag = 1
    cp  b
    ret z
    jr  c, _move_ghost_up
_move_ghost_down:
    ld  a, e_y(ix)
    ld  b, #2
    add b 
    ld  e_y(ix), a
    ret

_move_ghost_up:
    ld  a, e_y(ix)
    ld  b, #-2
    add b 
    ld  e_y(ix), a
    ret