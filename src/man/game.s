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
  call  sys_input_press_start   ;; Returns in register A if start was pressed

  or    a                       ;; If A=00 THEN do not start (loop) ELSE start game (ret)
  jr    z, man_game_not_start
  jr    man_game_menu_remove
man_game_not_start:

  call  sys_input_press_restart   ;; Returns in register A if start was pressed

  or    a                       ;; If A=00 THEN do not start (loop) ELSE start game (ret)
  jr    z, man_game_not_restart
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
  call  man_entity_init     
  call  sys_input_init
  ;call  sys_ai_init
  call  sys_physics_init
  call  sys_render_init   

  ret

man_game_init_next_lvl::
  call  man_entity_terminate

  call  man_map_update  
  
  call  man_entity_init      
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
  ;call  sys_ai_update
  call  sys_physics_update
  call  man_entity_update
  ret

;;
;;  Increases counter of entities and pointer to the last element.
;;  When user need to reset the game for any reason. Restart the game from ZERO.
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
man_game_terminate::    
  call  man_entity_terminate  
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

  call  man_map_init
  call  sys_render_remove_end_menu
  ret

