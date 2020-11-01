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

;;
;;  MAP MANAGER
;;

.include "map_manager.h.s"
.include "entity_manager.h.s"
.include "game.h.s"
.include "../sys/render_system.h.s"
.include "../cpct_functions.h.s"

;;########################################################
;;                        VARIABLES                      #             
;;########################################################

;DefineBlockArray _map, map_resolution_cell, DefineBlockDefault
;DefineLevel1Map _level1
;DefineLevel2Map _level2
;_maps_num:    .db 0x01


DefineMapsArray _maps
; _maps_num:    .db 1    
; _maps_last:   .dw _maps_array
; _maps_array: .db 0


;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

man_map_init::
    ld   a,  #1
    ld   (_maps_num),  a

    ld   hl, #_maps_array        
    ld   (_maps_last), hl    
    ret

man_map_update::
    ld  a, (_maps_num)
    inc a
    ld (_maps_num),  a

    ld    hl, (_maps_last)      
    ld    bc, #sizeof_map
    add   hl, bc
    ld    (_maps_last), hl

    ld     a,  #max_maps 
    ld    hl, #_maps_num
    cp   (hl)                  ;; max_entities - _enemy_num    
    jr   nc, #game_no_end                    ;; IF Z=1 THEN array is full

game_end:
    call  man_game_end    
game_no_end:    
    ret

man_map_terminate::
    ret 

man_map_get_lvl_map::
    ld  a, (_maps_num)    
    ret

; Input: a, number of level
man_map_get_map_array::
    ld    ix, (_maps_last)    
    ret
