;;
;;  MAP MANAGER
;;

.include "map_manager.h.s"
.include "game.h.s"
.include "../sys/render_system.h.s"
.include "../cpct_functions.h.s"

.globl  man_map_init
.globl  man_map_update
.globl  man_map_terminate
.globl  man_map_get_map_array

;;########################################################
;;                        VARIABLES                      #             
;;########################################################

;DefineBlockArray _map, map_resolution_cell, DefineBlockDefault
;DefineLevel1Map _level1
;DefineLevel2Map _level2
;_maps_num:    .db 0x01


DefineMapsArray _maps

;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

man_map_init::
    ld  a,  #1
    ld (_maps_num),  a

    ld    hl, #_maps_array          
    ld    (_maps_last), hl
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
    ret   nc                    ;; IF Z=1 THEN array is full

    call  man_map_init

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
