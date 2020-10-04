;;
;;  ENTITY MANAGER
;;

.include "entity_manager.h.s"
.include "../sys/render_system.h.s"
.include "../cpct_functions.h.s"


;;########################################################
;;                        VARIABLES                      #             
;;########################################################

_player:  DefineEntity alive_type, 0, 0, 4, 16, 0, 0, 0xCCCC
DefineEntityArray _enemy, max_entities, DefineEntityDefault

DefineBombArray _bomb, max_bombs, DefineBombDefault

;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

;;
;;  Increases counter of entities and pointer to the last element.
;;  INPUT:
;;    none
;;  RETURN: 
;;    hl with memory address of free space for new entity
;;    ix with memory address of last created entity
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
;;    ix with memory address of entity that must be initialized
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A
man_entity_initialize_entity::  
  ld    e_type(ix), #alive_type  
  
  ld    e_x(ix), #40          ;; set X coordiante
  ld    e_y(ix), #12           ;; set Y coordiante

  ld    e_vx(ix), #0         ;; set X velocity  
  ld    e_vy(ix), #0          ;; set Y velocity    
  
  ld    e_w(ix), #4           ;; set sprite width
  ld    e_h(ix), #16          ;; set sprite height

  ret


;;
;;  Increases counter of bombs and pointer to the last element.
;;  INPUT:
;;    none
;;  RETURN: 
;;    hl with memory address of free space for new bomb
;;    ix with memory address of last created bomb
;;  DESTROYED:
;;    A,BC
man_entity_new_bomb::
  ld    a, (_bomb_num)
  inc   a
  ld    (_bomb_num), a

  ld    ix, (_bomb_last)    
  ld    hl, (_bomb_last)    
  ld    bc, #sizeof_b
  add   hl, bc
  ld    (_bomb_last), hl
  ret

;;
;;  Initialize data for all bombs.
;;  INPUT:
;;    ix  with memory address of entity that must be initialized
;;    l   X coordinate where bomb must be positioned
;;    h   Y coordinate where bomb must positioned
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A
man_entity_initialize_bomb::    
  ld    b_x(ix), l                  ;; set X velocity  
  ld    b_y(ix), h                  ;; set Y velocity    
  
  ld    b_w(ix), #4                 ;; set sprite width
  ld    b_h(ix), #16                ;; set sprite height
      
  ld    b_timer(ix), #max_timer     ;; set timer
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
  ld    a, #max_entities
  ld    de, (_enemy_last)
init_loop:
  push  af
  
  call  man_entity_new_entity
  call  man_entity_initialize_entity
  
  pop   af
  dec   a
  ret   z
  jr    init_loop

;;
;;  Reset bombs data
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,HL
man_entity_init_bombs::
  ld    a, #0
  ld    (_bomb_num), a

  ld    hl, #_bomb_array
  ld    (_bomb_last), hl
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

man_entity_bombs_update::
  ld    ix, #_enemy_array
  ld     a, (_enemy_num)
  or     a
  ret    z

  bombs_update_loop:
    push  af
    
    ld    a, b_timer(ix)         ;; load timer of bomb
    and   #zero_timer            ;; _bomb_timer AND zero_timer

    jr    z, bombs_increase_index
    call  sys_render_remove_bomb

    ;; _last_element_ptr now points to the last entity in the array
    ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
    ld    a, (_enemy_last)
    sub   #sizeof_e
    ld    (_enemy_last), a
    jp    c, bombs_overflow_update
    jp    bombs_no_overflow_update    
    
  bombs_overflow_update:
    ld    a, (_bomb_last+1)
    dec   a
    ld    (_bomb_last+1), a

  bombs_no_overflow_update:
    ;; move the last element to the hole left by the dead entity
    push  ix  
    pop   hl
    ld    bc, #sizeof_b       
    ld    de, (_bomb_last)
    ex    de, hl
    ldir                        
    
    ld    a, (_bomb_num)
    dec   a
    ld    (_bomb_num), a  

    jp    bombs_continue_update

  bombs_increase_index:
    ld    bc, #sizeof_b
    add   ix, bc
  bombs_continue_update:
    pop   af
    dec   a
    ret   z
    jp    bombs_update_loop  
  ret

;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  Initialize data for all enemies, player and reset bombs data.
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    AF,DE,IX,HL,BC
man_entity_init::
  call  man_entity_init_entities
  call  man_entity_init_bombs
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    AF,DE,IX,HL,BC
man_entity_update::
  call  man_entity_player_update
  call  man_entity_enemies_update
  call  man_entity_bombs_update
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    hl with memory address of free space for new entity
;;    ix with memory address of last created entity
;;  DESTROYED:
;;    A,HL,BC
man_entity_create_entity::  
  ld    a, #max_entities
  ld    hl, #_enemy_num
  cp   (hl)                  ;; max_entities - _enemy_num
  ret   z                    ;; IF Z=1 THEN array is full ELSE create more

  call  man_entity_new_entity
  call  man_entity_initialize_entity
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    hl with memory address of free space for new bomb
;;    ix with memory address of last created bomb
;;  DESTROYED:
;;    A,HL,BC
man_entity_create_bomb::  
  ld    a, #max_bombs
  ld    hl, #_bomb_num
  cp   (hl)                  ;; max_bombs - _bomb_num
  ret   z                    ;; IF Z=1 THEN array is full ELSE create more

  call  man_entity_create_bomb
  call  man_entity_initialize_bomb
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    ix with memory address of player
;;  DESTROYED:
;;    none
man_entity_get_player::
  ld    ix, #_player
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    ix  begin of enemy array memory address
;;    a   number of enemies in the array
;;  DESTROYED:
;;    none
man_entity_get_enemy_array::
  ld    ix, #_enemy_array
  ld     a, (_enemy_num)
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    ix  begin of bomb array memory address
;;    a   number of bombs in the array
;;  DESTROYED:
;;    none
man_entity_get_bomb_array::
  ld    ix, #_bomb_array
  ld     a, (_bomb_num)
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    ix  begin of player memory address
;;  DESTROYED:
;;    A
man_entity_set_player_dead::
  ld    ix, #_player
  ld     a, #dead_type
  ld    e_type(ix), a
  ret


;;
;;  INPUT:
;;    ix with memory address of entity that must me marked as dead
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A
man_entity_set_enemy_dead::
  ld    a, #dead_type
  ld    e_type(ix), a
  ret
