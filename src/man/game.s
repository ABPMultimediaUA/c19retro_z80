;;
;;  GAME MANAGER
;;

.include "entity_manager.h.s"
.include "game.h.s"
.include "map_manager.h.s"


.include "../sys/render_system.h.s"
.include "../sys/physics_system.h.s"
.include "../sys/input_system.h.s"

.include "../assets/assets.h.s"

.include "../cpct_functions.h.s"


;;########################################################
;;                        VARIABLES                      #             
;;########################################################




;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################




;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  Increases counter of entities and pointer to the last element.
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
man_game_menu::
  call  sys_render_menu

man_game_menu_loop:
  call  cpct_waitVSYNC_asm
  call  cpct_akp_musicPlay_asm
  call  sys_input_press_play   ;; Returns in register A if start was pressed

  or    a                       ;; If A=00 THEN do not start (loop) ELSE start game (ret)
  jr    z, man_game_not_play
  jr    man_game_menu_remove
man_game_not_play:

  call  sys_input_press_restart   ;; Returns in register A if start was pressed (R)

  or    a                       ;; If A=00 THEN do not start (loop) ELSE start game (ret)
  jr    z, man_game_not_restart
  ;call  sys_render_remove_ghosts
  call  man_game_terminate
  call  man_game_init
  jr    man_game_menu_remove
man_game_not_restart:
  jr    z, man_game_menu_loop

man_game_menu_remove:
  call  sys_render_remove_menu
  ret

;;
;;  Increases counter of entities and pointer to the last element.
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
man_game_init::  
  call  man_map_init
  call  man_map_get_lvl_map
  call  man_entity_init     
  call  sys_input_init
  ;call  sys_ai_init
  call  sys_physics_init
  call  sys_render_init   

  ret

man_game_init_next_lvl::
  call  man_entity_terminate  

  call  man_map_update  
  call  man_map_get_lvl_map
  call  man_entity_next_lvl      
  call  sys_input_init
  ;call  sys_ai_init
  call  sys_physics_init
  call  sys_render_init

  ret


;;
;;  Increases counter of entities and pointer to the last element.
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
man_game_update::
  call  sys_input_update  
  
  ld  a,  #4
  loop_velocity:
    push af
    
    ;call  sys_ai_update  
    call  sys_physics_update
    ;call  man_entity_update

    call  cpct_waitVSYNC_asm   
    call  sys_render_update   
    
    pop af
    dec a
    jr nz, loop_velocity
  ret

;;
;;  Increases counter of entities and pointer to the last element.
;;  When user need to reset the game for any reason. Restart the game from ZERO.
man_game_terminate::
  call  man_entity_terminate  
  ret


;; Called when player lose 1 life
;; Input: A number of lifes
man_game_terminate_dead::
  call  man_entity_get_player
  ld    a,  e_l(ix)
  dec     a
  ld    e_l(ix),  a
  
  call  sys_render_menu_lifes
  call  man_entity_get_player
  

  ld    a,  e_l(ix)
  or    a
  jr    z, _dead_man_game_wait_restart
  ;ld    e_l(ix), #3

_dead_man_game_wait_continue:
  call  cpct_waitVSYNC_asm
  call  cpct_akp_musicPlay_asm
  call  sys_input_press_play   ;; Returns in register A if start was pressed (Space)

  or    a                       
  jr    z, _dead_man_game_wait_continue  ;; Loop while a=0 not pressed (Space)
  call  man_entity_get_player
  ld    e_x(ix),  #min_map_x_coord_valid
  ld    e_y(ix),  #min_map_y_coord_valid
  ld    e_xcell(ix), #0
  ld    e_ycell(ix), #0

  ld    hl, #CPCT_VMEM_START_ASM+402
  ld    e_sp_ptr_0(ix), h
  ld    e_sp_ptr_1(ix), l
  

  call  sys_render_remove_ghosts
  call  sys_physics_init_ghosts
  call  sys_render_init_ghosts
  jr    _dead_man_game_menu_remove
  ret


_dead_man_game_wait_restart:
  call  sys_input_press_restart   ;; Returns in register A if start was pressed (R)

  or    a                       ;; If A=00 THEN do not start (loop) ELSE start game (ret)
  jr    z, _dead_man_game_wait_restart
  call  man_game_terminate
  call  man_game_init
  jr    _dead_man_game_menu_remove

_dead_man_game_menu_remove:  
  call  sys_render_init
  ret


;;
;;  When the user finishes the game
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
man_game_end::
  call  sys_render_end_menu
man_game_end_menu_loop:
  call  sys_input_press_restart   ;; Returns in register A if start was pressed

  or    a                       ;; If A=00 THEN do not start (loop) ELSE start game (ret)
  jr    z, man_game_end_menu_loop

  call  man_game_terminate
  call  man_game_init
  ;call  sys_render_remove_end_menu
  ret

