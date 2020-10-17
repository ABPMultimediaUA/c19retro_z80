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
DefineDefaultMap _map

;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

man_map_init::
    ret
man_map_update::
    ret
man_map_terminate::
    ret 
man_map_get_map_array::
  ld    ix, #_map_array
  ret