;;
;;  INPUT SYSTEM
;;

.include "../man/entity_manager.h.s"
.include "../man/game.h.s"
.include "../cpct_functions.h.s"
.include "input_system.h.s"
.include "render_system.h.s"

;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################


;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    IX
sys_input_init::
  call  man_entity_get_player
  ld    (player_ptr), ix
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_input_update::  
  player_ptr = .+2
  ld    ix, #0x0000    

  ;; Reset velocities
  ld    e_vx(ix), #0
  ld    e_vy(ix), #0

  call  cpct_scanKeyboard_f_asm

  ld    hl, #Key_O
  call  cpct_isKeyPressed_asm
  jr    z, O_NotPressed
O_Pressed:
  ld    e_vx(ix), #move_left
  ret
O_NotPressed:

  ld    hl, #Key_P
  call  cpct_isKeyPressed_asm
  jr    z, P_NotPressed
P_Pressed:
  ld    e_vx(ix), #move_right
  ret
P_NotPressed:

  ld    hl, #Key_Q
  call  cpct_isKeyPressed_asm
  jr    z, Q_NotPressed
Q_Pressed:
  ld    e_vy(ix), #move_up
  ret
Q_NotPressed:

  ld    hl, #Key_A
  call  cpct_isKeyPressed_asm
  jr    z, A_NotPressed
A_Pressed:
  ld    e_vy(ix), #move_down    
  ret
A_NotPressed:   

; ;   ld    hl, #Key_Space
; ;   call  cpct_isKeyPressed_asm
; ;   jr    z, Space_NotPressed
; ; Space_Pressed:
; ;   call  man_entity_create_bomb    
; ;   ret
; ; Space_NotPressed: 

  ld    hl, #Key_Esc
  call  cpct_isKeyPressed_asm
  jr    z, Esc_NotPressed
Esc_Pressed:
  call  man_game_menu
  call  sys_render_map
  
Esc_NotPressed:
  ret


sys_input_press_start::
  ld    a, #0

  call  cpct_scanKeyboard_f_asm

  ld    hl, #Key_Space
  call  cpct_isKeyPressed_asm
  jr    z, Start_NotPressed
  ld    a, #1
Start_NotPressed:
  ret


sys_input_press_restart::
  ld    a, #0

  call  cpct_scanKeyboard_f_asm

  ld    hl, #Key_R
  call  cpct_isKeyPressed_asm
  jr    z, Restart_NotPressed
  ld    a, #1
Restart_NotPressed:
  ret