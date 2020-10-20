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
DefineLevel1Map _level1
DefineLevel2Map _level2
num_lvl:    .db 0x01


;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

man_map_init::
    ld  a,  #1
    ld (num_lvl),  a
    ret

man_map_update::
    ld  a, (num_lvl)
    inc a
    ld (num_lvl),  a
    ret

man_map_terminate::
    ret 

man_map_get_lvl_map::
    ld  a, (num_lvl)
    ret

; Input: a, number of level
man_map_get_map_array::
    ld  b, a
    xor #1
    jr  z,  ret_level1

    ld  a, b
    xor #2
    jr  z,  ret_level2

ret_level1:
  ld    ix, #_level1_array
  ret
ret_level2:
  ld    ix, #_level2_array
  ret