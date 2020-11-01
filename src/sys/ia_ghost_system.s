; ; ; ; MIT License

; ; ; ; Copyright (c) 2020 Carlos Eduardo Arismendi Sánchez / Antón Chernysh / Sergio Cortés Espinosa

; ; ; ; Permission is hereby granted, free of charge, to any person obtaining a copy
; ; ; ; of this software and associated documentation files (the "Software"), to deal
; ; ; ; in the Software without restriction, including without limitation the rights
; ; ; ; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; ; ; ; copies of the Software, and to permit persons to whom the Software is
; ; ; ; furnished to do so, subject to the following conditions:

; ; ; ; The above copyright notice and this permission notice shall be included in all
; ; ; ; copies or substantial portions of the Software.

; ; ; ; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; ; ; ; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; ; ; ; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; ; ; ; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; ; ; ; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; ; ; ; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; ; ; ; SOFTWARE.

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