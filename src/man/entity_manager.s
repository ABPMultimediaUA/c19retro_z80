;;
;;  ENTITY MANAGER
;;

.include "entity_manager.h.s"
.include "game.h.s"
.include "../sys/render_system.h.s"
.include "../cpct_functions.h.s"


;;########################################################
;;                        VARIABLES                      #             
;;########################################################

_player:    
  DefineEntity alive_type, 0,  0,   0,  0,   0,  0,   no_ghost

_enemy_num:
  .db 1

_enemy_last:
  .dw _enemy_array

_enemy_array:
  .dw enemies_map1


enemies_map1::
  .db 2
  DefineEntity alive_type, 16,  1,   0,  0,   0,  0,   no_ghost
  DefineEntity alive_type, 16,  4,   4,  0,   2,  0,   no_ghost

enemies_map2::
  .db 4
  DefineEntity alive_type,  8,  1,   0, 16,   0,  2,   no_ghost
  DefineEntity alive_type, 13,  4,   4,  0,   4,  0,   no_ghost
  DefineEntity alive_type,  7,  9,   0, 16,   0,  3,   no_ghost
  DefineEntity alive_type, 10,  9,   0, 16,   0,  3,   no_ghost

enemies_map3::
  .db 5
  DefineEntity alive_type,  2,  8,   0, 16,   0,  7,   no_ghost
  DefineEntity alive_type,  9,  2,   0, 16,   0,  7,   no_ghost
  DefineEntity alive_type, 12,  2,   0, 16,   0,  8,   no_ghost
  DefineEntity alive_type, 16,  8,   4,  0,   7,  0,   no_ghost
  DefineEntity alive_type, 16, 10,   4,  0,   9,  0,   no_ghost  

enemies_map4::
  .db 3
  DefineEntity alive_type,  6,  1,   0,  0,   3,  3,   ghost
  DefineEntity alive_type,  8,  7,   4,  0,   5,  0,   no_ghost
  DefineEntity alive_type,  9,  9,   4,  0,   9,  0,   no_ghost  

enemies_map5::
  .db 9
  DefineEntity alive_type,  5,  0,   0,  0,   3,  3,   ghost
  DefineEntity alive_type, 13,  0,   0, 16,   0,  7,   no_ghost
  DefineEntity alive_type, 12,  1,   0, 16,   0, 10,   no_ghost  

  DefineEntity alive_type,  0,  2,   4,  0,  10,  0,   no_ghost
  DefineEntity alive_type, 16,  2,   0, 16,   0, 10,   no_ghost
  DefineEntity alive_type,  1,  5,   4,  0,   9,  0,   no_ghost

  DefineEntity alive_type,  9,  6,   0, 16,   0,  6,   no_ghost  
  DefineEntity alive_type, 12,  7,   0, 16,   0,  9,   no_ghost
  DefineEntity alive_type,  2,  8,   4,  0,   8,  0,   no_ghost

  DefineEntity alive_type, 15,  8,   0, 16,   0,  8,   no_ghost  


enemies_map6::
  .db 6
  DefineEntity alive_type,  3,  1,   0,  0,   2,  2,   ghost
  DefineEntity alive_type,  5,  1,   0, 16,   0,  8,   no_ghost
  DefineEntity alive_type, 14,  4,   4,  0,   7,  0,   no_ghost
  DefineEntity alive_type, 14,  6,   4,  0,   8,  0,   no_ghost
  DefineEntity alive_type, 18,  6,   4,  0,   6,  0,   no_ghost
  DefineEntity alive_type, 14,  8,   4,  0,  10,  0,   no_ghost  


enemies_map7::
  .db 11
  DefineEntity alive_type,  3,  1,   0,  0,   2,  2,   ghost
  DefineEntity alive_type,  5,  1,   0, 16,   0,  8,   no_ghost
  DefineEntity alive_type, 14,  4,   4,  0,   7,  0,   no_ghost

  DefineEntity alive_type, 14,  6,   4,  0,   8,  0,   no_ghost
  DefineEntity alive_type, 18,  6,   4,  0,   6,  0,   no_ghost
  DefineEntity alive_type, 14,  8,   4,  0,  10,  0,   no_ghost
  
  DefineEntity alive_type,  3,  1,   0,  0,   2,  2,   ghost
  DefineEntity alive_type,  5,  1,   0, 16,   0,  8,   no_ghost
  DefineEntity alive_type, 14,  4,   4,  0,   7,  0,   no_ghost

  DefineEntity alive_type, 14,  6,   4,  0,   8,  0,   no_ghost
  DefineEntity alive_type, 18,  6,   4,  0,   6,  0,   no_ghost  


;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

;;
;;  Increases counter of entities and pointer to the last element.
;;  INPUT:
;;    none
;;  RETURN: 
;;    hl with memory address of free space for new entity
;;    ix with memory address of last entity
;;  DESTROYED:
;;    AF,DE,BC
man_entity_new_entity::
  ld    a, (_enemy_num)
  inc   a
  ld    (_enemy_num), a
  
  ld    ix, (_enemy_last)
  ld    hl, (_enemy_last)      
  ld    bc, #sizeof_e
  add   hl, bc
  ld    (_enemy_last), hl
  ret

;;
;;  Initialize data for all enemies and player.
;;  INPUT:
;;    ix  with memory address of entity that must be initialized
;;    b   X coordinate
;;    c   Y coordinate
;;    h   X cell
;;    l   Y cell
;;    d   X velocity
;;    e   Y velocity
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A
man_entity_initialize_entity::  
  ld    e_type(ix), #alive_type  
  
  ld    e_x(ix), b        ;; set X coordiante
  ld    e_y(ix), c        ;; set Y coordiante

  ld    e_xcell(ix), h      ;; set X coordiante cell  
  ld    e_ycell(ix), l      ;; set Y coordiante cell 

  ld    e_vx(ix), d      ;; set X velocity  
  ld    e_vy(ix), e      ;; set Y velocity    
  
  ld    e_w(ix), #4       ;; set sprite width
  ld    e_h(ix), #16      ;; set sprite height

  ld    hl, #CPCT_VMEM_START_ASM+402
  ld    e_sp_ptr_0(ix), h
  ld    e_sp_ptr_1(ix), l

  ld    e_l(ix),  #max_lifes

  ld    bomb_type+sizeof_e_solo(ix), #invalid_type
  ld    bomb_w+sizeof_e_solo(ix), #4
  ld    bomb_h+sizeof_e_solo(ix), #16   

  ret


man_entity_init_player::
  ld    ix, #_player
  ld    b, #min_map_x_coord_valid
  ld    c, #min_map_y_coord_valid
  ld    h, #0     ;; set X coordiante cell  
  ld    l, #0     ;; set Y coordiante cell        
  ld    d, #0     ;; set X velocity
  ld    e, #0     ;; set Y velocity
  call  man_entity_initialize_entity
  ret

;;
;;  Initialize data for all enemies and player.
;;  INPUT:
;;    none
;;  RETURN: 
;;    hl with memory address of free space for new entity
;;    ix with memory address of last created entity
;;  DESTROYED:
;;    AF,DE,IX,HL,BC
man_entity_init_entities::    

  ;; enemy 1 -> Abajo a la izda
  call  man_entity_new_entity

  ld    ix, #_enemy_array
  ld    b, #min_map_x_coord_valid
  ld    c, #max_map_y_coord_valid+move_up
  ld    h, #0     ;; set X coordiante cell  
  ld    l, #10    ;; set Y coordiante cell 
  call  man_entity_initialize_entity
  ld    e_vx(ix), #4      ;; set X velocity  
  ld    e_vy(ix), #0      ;; set Y velocity

  ;; enemy 2 -> Arriba a la derecha
  call  man_entity_new_entity

  ld   bc, #sizeof_e
  add  ix, bc
  ld    b, #max_map_x_coord_valid+move_left   
  ld    c, #min_map_y_coord_valid 
  ld    h, #11     ;; set X coordiante cell  
  ld    l, #0      ;; set Y coordiante cell 
  call  man_entity_initialize_entity

  ;; enemy 3 -> Abajo a la derecha
  call  man_entity_new_entity

  ld   bc, #sizeof_e
  add  ix, bc
  ld    b, #max_map_x_coord_valid+move_left
  ld    c, #max_map_y_coord_valid+move_up
  ld    h, #11    ;; set X coordiante cell  
  ld    l, #10    ;; set Y coordiante cell 
  call  man_entity_initialize_entity

  ret   


man_entity_player_update::
  ret


man_entity_enemies_update::  
  ld    ix, #_enemy_array
  ld     a, (_enemy_num)
  or     a
  ret    z

  enemies_update_loop:
    push  af
    
    ld    a, e_type(ix)         ;; load type of entity
    and    #dead_type            ;; entity_type AND dead_type

    jr    z, enemies_increase_index
    call  sys_render_remove_entity

    ;; _last_element_ptr now points to the last entity in the array
    ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
    ld    a, (_enemy_last)
    sub   #sizeof_e
    ld    (_enemy_last), a
    jp    c, enemies_overflow_update
    jp    enemies_no_overflow_update    
    
  enemies_overflow_update:
    ld    a, (_enemy_last+1)
    dec   a
    ld    (_enemy_last+1), a

  enemies_no_overflow_update:
    ;; move the last element to the hole left by the dead entity
    push  ix  
    pop   hl
    ld    bc, #sizeof_e       
    ld    de, (_enemy_last)
    ex    de, hl
    ldir                        
    
    ld    a, (_enemy_num)
    dec   a
    ld    (_enemy_num), a  

    jp    enemies_continue_update

  enemies_increase_index:
    ld    bc, #sizeof_e
    add   ix, bc
  enemies_continue_update:
    pop   af
    dec   a
    ret   z
    jp    enemies_update_loop
  ret


;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  Initialize data for all enemies, player and reset bombs data.
;;  INPUT:  
;;    A with level map number
;;  DESTROYED:
;;    AF,DE,IX,HL,BC
man_entity_init::
  call  man_entity_init_enemies
  call  man_entity_init_player  
  ;call  man_entity_init_entities
  ret


;;  DESTROYED:
;;    AF,DE,IX,HL,BC
man_entity_update::
  call  man_entity_player_update
  ;call  man_entity_enemies_update
  ;call  man_entity_bombs_update
  ret


;;  INPUT:
;;    ix  with memory address of entity that must be initialized
;;    b   X coordinate
;;    c   Y coordinate
;;    h   X cell
;;    l   Y cell
;;    d   X velocity
;;    e   Y velocity
;;  RETURN: 
;;    hl with memory address of free space for new entity
;;    ix with memory address of last created entity
;;  DESTROYED:
;;    A,HL,BC
man_entity_create_entity::  
  push  hl
  push  bc

  ld    a, #max_entities
  ld    hl, #_enemy_num
  cp   (hl)                  ;; max_entities - _enemy_num
  ret   z                    ;; IF Z=1 THEN array is full ELSE create more

  call  man_entity_new_entity

  pop   bc
  pop   hl
  call  man_entity_initialize_entity
  ret


;;  RETURN: 
;;    ix with memory address of player
man_entity_get_player::
  ld    ix, #_player
  ret


;;  RETURN: 
;;    ix  begin of enemy array memory address
;;    a   number of enemies in the array
man_entity_get_enemy_array::
  ld    ix, (_enemy_array)
  ld    a, 0(ix)
  inc   ix
  ret


;;  RETURN: 
;;    ix  begin of player memory address
man_entity_set_player_dead::
  ld    ix, #_player
  ld     a, #dead_type
  ld    e_type(ix), a
  ret

;;
;;  INPUT:
;;    ix with memory address of entity that must me marked as dead
man_entity_set_enemy_dead::
  ld    a, #dead_type
  ld    e_type(ix), a
  ret


man_entity_terminate::
  ; ld  a, #_enemy_array
  ; ld  (_enemy_last), a

  ; ld  a, #0
  ; ld  (_enemy_num), a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  BOMB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Input: ix pointer to entity
;only 1 bomb now
man_entity_create_bomb::  
  ld    a,  bomb_type+sizeof_e_solo(ix)
  xor   #invalid_type
  ret   nz   ;ret if we have alive bomb

  ld    bomb_type+sizeof_e_solo(ix), #alive_type
  ld    bomb_timer+sizeof_e_solo(ix), #max_timer

  ld    b,    e_x(ix)
  ld    bomb_x+sizeof_e_solo(ix), b

  ld    b,    e_y(ix)
  ld    bomb_y+sizeof_e_solo(ix), b

  ld    b,    e_xcell(ix)
  ld    bomb_xcell+sizeof_e_solo(ix), b

  ld    b,    e_ycell(ix)
  ld    bomb_ycell+sizeof_e_solo(ix), b

  ld    bomb_w+sizeof_e_solo(ix), #4
  ld    bomb_h+sizeof_e_solo(ix), #16              
          
  ret


;Input: ix pointer to entity
man_entity_bombs_update::
  ld    a,  bomb_type+sizeof_e_solo(ix)
  xor   #invalid_type
  ret   z   ;ret if invalid, nothing to update

  ld    a,  bomb_type+sizeof_e_solo(ix)
  xor   #dead_type
  ret   nz     ;ret if is not dead

  ld    bomb_type+sizeof_e_solo(ix), #invalid_type
  ret

;Input: ix pointer to entity
; man_entity_bombs_terminate::
;   ld    bomb_type+sizeof_e(ix), #invalid_type
;   ret


;input A with level number
man_entity_init_enemies::
  ld    b, a
  xor    #1
  jr    z, lvl_1

  ld    a, b
  xor    #2
  jr    z, lvl_2

  ld    a, b
  xor    #3
  jr    z, lvl_3
  
  ld    a, b
  xor    #4
  jr    z, lvl_4

  ld    a, b
  xor    #5
  jr    z, lvl_5

  ld    a, b
  xor    #6
  jr    z, lvl_6

  ld    a, b
  xor    #7
  jr    z, lvl_7

  ret
lvl_1:
  ld    hl, #enemies_map1
  ld    (_enemy_array), hl
  ret
lvl_2:
  ld    hl, #enemies_map2
  ld    (_enemy_array), hl
  ret

lvl_3:
  ld    hl, #enemies_map3
  ld    (_enemy_array), hl  
  ret

lvl_4:
  ld    hl, #enemies_map4
  ld    (_enemy_array), hl 
  ret
lvl_5:
  ld    hl, #enemies_map5
  ld    (_enemy_array), hl 
  ret
lvl_6:
  ld    hl, #enemies_map6
  ld    (_enemy_array), hl 
  ret
  
lvl_7:
  ld    hl, #enemies_map7
  ld    (_enemy_array), hl 
  ret
