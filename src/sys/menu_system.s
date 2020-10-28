;;
;;  MENU SYSTEM
;;

.include "../cpct_functions.h.s"
.include "render_system.h.s"
.include "../assets/assets.h.s"
.include "menu_system.h.s"

; _str_game_name:
;   .db 0
_str_game_name:  
  .ascii "Cell Block"
  .db 0

_str_move_up:
  .ascii "Q up"
  .db 0

_str_move_down:
  .ascii "A down"
  .db 0

_str_move_left: 
  .ascii "O left"
  .db 0

_str_move_right:
  .ascii "P right"
  .db 0

_str_pause:
  .ascii "Esc pause"
  .db 0

_str_restart: 
  .ascii "R restart"
  .db 0

_str_play_game:
  .ascii "Space to play"
  .db 0

;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

;;
;;  Render enemies and update their sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_menu_restart_key::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                  ;; C = x coordinate       
  ld    b, #117                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_restart
  call  cpct_drawStringM0_asm
  ret


;;
;;  Render enemies and update their sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_menu_play_key::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #14                       ;; C = x coordinate       
  ld    b, #157                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #02
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_play_game
  call  cpct_drawStringM0_asm
  ret


;;
;;  Render enemies and update their sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_menu_pause_key::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                  ;; C = x coordinate       
  ld    b, #133                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_pause
  call  cpct_drawStringM0_asm
  ret


;;
;;  Render enemies and update their sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_menu_move_keys::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                      ;; C = x coordinate       
  ld    b, #58                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_move_left
  call  cpct_drawStringM0_asm

  ;;#################################################################

  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                  ;; C = x coordinate       
  ld    b, #72                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_move_right
  call  cpct_drawStringM0_asm

  ;;#################################################################

  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                  ;; C = x coordinate       
  ld    b, #87                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_move_up
  call  cpct_drawStringM0_asm

  ;;#################################################################

  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                  ;; C = x coordinate       
  ld    b, #102                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_move_down
  call  cpct_drawStringM0_asm 
  ret

;;
;;  Render enemies and update their sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_menu_game_name::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #20                 ;; C = x coordinate       
  ld    b, #32                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #07
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_game_name
  call  cpct_drawStringM0_asm
  ret

sys_menu_num_lifes::

  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #30                  ;; C = x coordinate       
  ld    b, #58                  ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ;;  Draw sprite
  ex    de, hl                      ;; DE = Destination video memory pointer
  ld    hl, #_sp_life            ;; Source Sprite Pointer (array with pixel data)
  ld    c, #4                  ;; Sprite width
  ld    b, #16                  ;; Sprite height
  call  cpct_drawSprite_asm 
  ret

;;
;;  Render enemies and update their sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_menu_background::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #10                      ;; C = x coordinate       
  ld    b, #14                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ex    de, hl
  ld    a, #0x00  
  ld    c, #60                      ;; Sprite width
  ld    b, #172                     ;; Sprite height
  call  cpct_drawSolidBox_asm
  ret


;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

sys_menu_init_and_pause::
  call  sys_menu_background
  call  sys_menu_game_name
  call  sys_menu_move_keys
  call  sys_menu_pause_key
  call  sys_menu_play_key
  call  sys_menu_restart_key
  ret 

sys_menu_game_end::
  call  sys_menu_background
  call  sys_menu_game_name
  call  sys_menu_restart_key
  ret 

sys_menu_lifes::
  call  sys_menu_background
  call  sys_menu_game_name
  call  sys_menu_num_lifes
  call  sys_menu_restart_key
  ret  