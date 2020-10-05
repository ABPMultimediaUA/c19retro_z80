;;
;;  INPUT SYSTEM
;;

.include "../man/entity_manager.h.s"
.include "../cpct_functions.h.s"
.include "input_system.h.s"

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
;;    none
sys_input_init::
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_input_update::
  call  man_entity_get_player

  ;; Reset velocities
  ld    e_vx(ix), #0
  ld    e_vy(ix), #0

  call  cpct_scanKeyboard_f_asm

  ld    hl, #Key_A;O
  call  cpct_isKeyPressed_asm
  jr    z, O_NotPressed
O_Pressed:
    ld    e_vx(ix), #move_left
    ret
O_NotPressed:

    ld    hl, #Key_D;P
    call  cpct_isKeyPressed_asm
    jr    z, P_NotPressed

P_Pressed:
    ld    e_vx(ix), #move_right
    ret
P_NotPressed:

    ld    hl, #Key_W;Q
    call  cpct_isKeyPressed_asm
    jr    z, Q_NotPressed
Q_Pressed:
    ld    e_vy(ix), #move_up
    ret
Q_NotPressed:

    ld    hl, #Key_S;A
    call  cpct_isKeyPressed_asm
    jr    z, A_NotPressed
A_Pressed:
    ld    e_vy(ix), #move_down    
A_NotPressed:    
    ret