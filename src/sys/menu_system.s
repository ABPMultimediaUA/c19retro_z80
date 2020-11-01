;;
;;  MENU SYSTEM
;;

.include "../cpct_functions.h.s"
.include "render_system.h.s"
.include "../assets/assets.h.s"
.include "menu_system.h.s"

;;########################################################
;;                        STRINGS                        #             
;;########################################################
_str_game_name:  
  .asciz "Cell Block"

;;-----------------------  MOVE  -------------------------
_str_move_up:
  .asciz "Q up"

_str_move_down:
  .asciz "A down"

_str_move_left: 
  .asciz "O left"

_str_move_right:
  .asciz "P right"

;;----------------------  OTHER  -------------------------
_str_pause:
  .asciz "Esc pause"

_str_restart: 
  .asciz "R restart"

_str_play_again: 
  .asciz "R play again"

_str_play_game:
  .asciz "Space to play"

;;---------------------  AUTHORS  -------------------------
_str_authors:
  .asciz "Created by"

_str_author_anton:
  .asciz "Anton C."

_str_author_sergio:
  .asciz "Sergio C."

_str_author_carlos:
  .asciz "Carlos A."

_str_thanks:
  .asciz "Thanks for"          

_str_playing:
  .asciz "playing!"          

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
sys_menu_game_name::
  ;; BORDER BACKGROUND
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #10                      ;; C = x coordinate       
  ld    b, #14                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ex    de, hl
  ld    a, #0xCC 
  ld    c, #60                      ;; Sprite width
  ld    b, #44                      ;; Sprite height
  call  cpct_drawSolidBox_asm

  ;; COLOUR BACKGROUND
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #10                      ;; C = x coordinate       
  ld    b, #18                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ex    de, hl
  ld    a, #0x3C
  ld    c, #60                      ;; Sprite width
  ld    b, #36                      ;; Sprite height
  call  cpct_drawSolidBox_asm

  ;; TEXT
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #20                      ;; C = x coordinate       
  ld    b, #32                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #06           
  ld    l, #01
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_game_name
  call  cpct_drawStringM0_asm
  ret


;;-----------------------  MOVE  -------------------------
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
  ld    b, #68                      ;; B = y coordinate   
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
  ld    b, #82                      ;; B = y coordinate   
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
  ld    b, #97                      ;; B = y coordinate   
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
  ld    b, #112                      ;; B = y coordinate   
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



;;----------------------  OTHER  -------------------------
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
  ld    b, #127                      ;; B = y coordinate   
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
sys_menu_play_again_key::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #17                  ;; C = x coordinate       
  ld    b, #168                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #02
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_play_again
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
  ld    b, #167                      ;; B = y coordinate   
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
  ld    b, #143                      ;; B = y coordinate   
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

;;---------------------  AUTHORS  -------------------------
;;
;;  Render enemies and update their sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_menu_authors::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #20                      ;; C = x coordinate       
  ld    b, #62                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #10
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_authors
  call  cpct_drawStringM0_asm

  ;;#################################################################

  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                  ;; C = x coordinate       
  ld    b, #78                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00          
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_author_anton
  call  cpct_drawStringM0_asm

  ;;#################################################################

  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                  ;; C = x coordinate       
  ld    b, #94                     ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_author_carlos
  call  cpct_drawStringM0_asm  

  ;;#################################################################

  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #22                  ;; C = x coordinate       
  ld    b, #110                     ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #04
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_author_sergio
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
sys_menu_thanks::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #20                      ;; C = x coordinate       
  ld    b, #130                     ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #01
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_thanks
  call  cpct_drawStringM0_asm  
  
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #24                      ;; C = x coordinate       
  ld    b, #145                     ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  
  
  ;;  Draw sprite
  push  hl                      ;; DE = Destination video memory pointer
  ld    h, #00           
  ld    l, #01
  call  cpct_setDrawCharM0_asm  
  pop   hl

  ld    iy, #_str_playing
  call  cpct_drawStringM0_asm 

  ret

;Input: A lifes
sys_menu_num_lifes::
  push  af
  ld    c, #30  ; x coordinate
  ld    b, #70  ; y coordinate

_alive_hearts_loop:
  or    a 
  jr    z, _dead_hearts_start   
  dec   a
  push  af
  
  push  bc
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ; future c(x) += a
  pop   bc
  ld    a, #7
  add   c 
  ld    c, a
  push  bc
  ;;  Draw sprite
  ex    de, hl                      ;; DE = Destination video memory pointer
  ld    hl, #_sp_life           ;; Source Sprite Pointer (array with pixel data)
  ld    c, #4                  ;; Sprite width
  ld    b, #16                  ;; Sprite height
  call  cpct_drawSprite_asm 

  pop   bc
  pop   af
  jr    _alive_hearts_loop

_dead_hearts_start:
  pop   af
  ld    l, a 
  ld    a, #3
  sub   l   ; a = 3 - alive hearts = dead hearts

_dead_hearts:
  or    a 
  ret   z   ; jr if a == 0
  dec   a
  push  af
  
  push  bc
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ; future c(x) += a
  pop   bc
  ld    a, #7
  add   c 
  ld    c, a
  push  bc
  ;;  Draw sprite
  ex    de, hl                      ;; DE = Destination video memory pointer
  ld    hl, #_sp_life_dead            ;; Source Sprite Pointer (array with pixel data)
  ld    c, #4                  ;; Sprite width
  ld    b, #16                  ;; Sprite height
  call  cpct_drawSprite_asm 

  pop   bc
  pop   af
  jr    _dead_hearts

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
  ;; BORDER
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #09                      ;; C = x coordinate       
  ld    b, #12                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ex    de, hl
  ld    a, #0xCC
  ld    c, #62                      ;; Sprite width
  ld    b, #176                     ;; Sprite height
  call  cpct_drawSolidBox_asm

  ;; SOLID
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #10                      ;; C = x coordinate       
  ld    b, #14                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ex    de, hl
  ld    a, #0x00  
  ld    c, #60                      ;; Sprite width
  ld    b, #171                     ;; Sprite height
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
  call  sys_menu_authors
  call  sys_menu_thanks
  call  sys_menu_play_again_key
  ret 

;Input; A num lifes
sys_menu_lifes::
  push  af
  call  sys_menu_background
  call  sys_menu_game_name
  pop   af
  push  af
  call  sys_menu_num_lifes
  pop   af

  or    a
  jr    z, _game_over
  call  sys_menu_play_key
  ret

_game_over:
  call  sys_menu_play_again_key     
  ret  