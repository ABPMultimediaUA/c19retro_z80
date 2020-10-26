;;
;;  MAP MANAGER
;;

.include "map_manager.h.s"
.include "entity_manager.h.s"
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
    call  man_map_enemies_init
    ret

man_map_enemies_init::
    ld      ix, (_maps_last)
    ld      a, (ix)    
    inc     ix
    or      a
    ret     z    

man_map_enemies_init_loop:
    push    af    
    push    ix
    ld      b, enemy_x(ix)
    ld      c, enemy_y(ix)    
    ld      h, enemy_cx(ix)
    ld      l, enemy_cy(ix)
    ld      d, enemy_vx(ix)
    ld      e, enemy_vy(ix)    
    call    man_entity_create_entity
    
    ld      bc, #sizeof_enemy
    pop     ix
    add     ix, bc
    pop     af
    dec     a
    ret     z
    jr      man_map_enemies_init_loop

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
    ret
game_no_end:
    call  man_map_enemies_init
    ret

man_map_terminate::
    ret 

man_map_get_lvl_map::
    ld  a, (_maps_num)    
    ret

; Input: a, number of level
man_map_get_map_array::
    ld    ix, (_maps_last)
    ld    bc, #sizeof_enemy_array
    add   ix, bc
    ret
