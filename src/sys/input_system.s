; ; ; ; MIT License
; ; ; ; 
; ; ; ; Copyright (c) 2020 Carlos Eduardo Arismendi Sánchez / Antón Chernysh / Sergio Cortés Espinosa
; ; ; ; 
; ; ; ; Permission is hereby granted, free of charge, to any person obtaining a copy
; ; ; ; of this software and associated documentation files (the "Software"), to deal
; ; ; ; in the Software without restriction, including without limitation the rights
; ; ; ; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; ; ; ; copies of the Software, and to permit persons to whom the Software is
; ; ; ; furnished to do so, subject to the following conditions:
; ; ; ; 
; ; ; ; The above copyright notice and this permission notice shall be included in all
; ; ; ; copies or substantial portions of the Software.
; ; ; ;
; ; ; ; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; ; ; ; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; ; ; ; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; ; ; ; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; ; ; ; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; ; ; ; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; ; ; ; SOFTWARE.

; ; ; ; ----------------- AUTHORS ------------------
; ; ; ; Code & Graphics: 
; ; ; ;     Anton Chernysh: anton_chernysh@outlook.es 
; ; ; ;     Carlos Eduardo Arismendi Sánchez: carlos.arismendisanchez@gmail.com
; ; ; ; Loading screen & Music: 
; ; ; ;     Sergio Cortes Espinosa: sercotes93@gmail.com
; ; ; ; ---------------------------------------------

; ; ; ; Third Party source code used
; ; ; ; ----------------------------
; ; ; ; CPCtelera - owned by ronaldo / (Cheesetea, Fremos, ByteRealms) - GNU Lesser General Public License.

;;
;;  INPUT SYSTEM
;;

.include "../man/entity_manager.h.s"
.include "../man/game.h.s"
.include "../cpct_functions.h.s"
.include "input_system.h.s"
.include "render_system.h.s"
.include "physics_system.h.s"

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
  jr    P_NotPressed
O_NotPressed:

  ld    hl, #Key_P
  call  cpct_isKeyPressed_asm
  jr    z, P_NotPressed
P_Pressed:
  ld    e_vx(ix), #move_right
    
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
  call  sys_render_remove_ghosts
  call  man_game_menu  
  ;call  man_entity_init
  ; call  sys_render_init
  call  sys_render_map  
  call  sys_render_remove_ghosts
  ; call  sys_physics_init
  
Esc_NotPressed:
  ret


sys_input_press_play::
  ld    a, #0

  call  cpct_scanKeyboard_f_asm

  ld    hl, #Key_Space
  call  cpct_isKeyPressed_asm
  jr    z, Start_NotPressed
  ld    a, #1
  ret
Start_NotPressed:  
  ld    a, #0
  ret


sys_input_press_restart::
  ld    a, #0

  call  cpct_scanKeyboard_f_asm

  ld    hl, #Key_R
  call  cpct_isKeyPressed_asm
  jr    z, Restart_NotPressed
  ld    a, #1
  ret
Restart_NotPressed:
  ld    a, #0
  ret