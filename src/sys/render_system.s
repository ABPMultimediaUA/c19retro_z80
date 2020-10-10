;;
;;  RENDER SYSTEM
;;

.include "../man/entity_manager.h.s"
.include "../cpct_functions.h.s"
.include "render_system.h.s"
.include "../assets/assets.h.s"


;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################
;;
;;  Render player and update its sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    DE,BC,HL,IX
sys_render_player::
  player_ptr = .+2
  ld    ix, #0x0000  

  call  sys_render_remove_entity
  
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, e_x(ix)                  ;; C = x coordinate       
  ld    b, e_y(ix)                  ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
  
  ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
  ld  e_sp_ptr_0(ix), l
  ld  e_sp_ptr_1(ix), h

  ;;  Draw sprite blended
  ex    de, hl                      ;; DE = Destination video memory pointer
  ld    hl, #_sp_player             ;; Source Sprite Pointer (array with pixel data)
  ld    c, e_w(ix)                  ;; Sprite width
  ld    b, e_h(ix)                  ;; Sprite height
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
sys_render_enemies::
  enemy_ptr = .+2
  ld    ix, #0x0000
  enemy_num = .+1
  ld     a, #0
  render_enemies_loop:
    push  af

    ;call  sys_render_remove_entity
    
    ;; Calculate a video-memory location for sprite
    ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
    ld    c, e_x(ix)                  ;; C = x coordinate       
    ld    b, e_y(ix)                  ;; B = y coordinate   
    call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
    
    ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
    ld  e_sp_ptr_0(ix), l
    ld  e_sp_ptr_1(ix), h

    ;;  Draw sprite blended
    ex    de, hl                      ;; DE = Destination video memory pointer
    ld    hl, #_sp_enemy              ;; Source Sprite Pointer (array with pixel data)
    ld    b, e_w(ix)                  ;; Sprite width
    ld    c, e_h(ix)                  ;; Sprite height
    call  cpct_drawSpriteBlended_asm    
  
    ld   bc, #sizeof_e
    add  ix, bc

    pop   af
    dec   a
    ret   z
    jr    render_enemies_loop
    ret


;;
;;  Render bombs and update their sp_ptr
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_render_bombs::
  call   man_entity_get_bomb_array
  or     a   ;; _bomb_num OR _bomb_num: if Z=1, they're equal, 0 bombs in _bomb_array
  ret    z
  render_bombs_loop:
    push af

    ;call  sys_render_remove_entity
    
    ;; Calculate a video-memory location for sprite
    ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
    ld    c, b_x(ix)                  ;; C = x coordinate       
    ld    b, b_y(ix)                  ;; B = y coordinate   
    call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
    
    ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
    ld  b_sp_ptr_0(ix), l
    ld  b_sp_ptr_1(ix), h

    ;;  Draw sprite blended
    ex    de, hl                      ;; DE = Destination video memory pointer
    ld    hl, #_sp_bomb               ;; Source Sprite Pointer (array with pixel data)    
    ld    b, b_w(ix)                  ;; Sprite width
    ld    c, b_h(ix)                  ;; Sprite height
    call  cpct_drawSpriteBlended_asm    
  
    ld   bc, #sizeof_b
    add  ix, bc

    pop   af
    dec   a
    ret   z
    jr    render_bombs_loop
    ret

;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  Set video mode and palette
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    AF,BC,DE,HL
sys_render_init::  
  ld    c, #0
  call  cpct_setVideoMode_asm    

  ld    l, #0
  ld    h, #HW_BLACK
  call  cpct_setPALColour_asm

  call  man_entity_get_player
  ld    (player_ptr), ix

  call  man_entity_get_enemy_array
  ld    (enemy_ptr), ix
  ld    (enemy_num), a    
  ret


;;
;;  Updates the sprites on screen (video-memory)
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,DE,BC,HL,IX
sys_render_update::
  call  sys_render_player
  ; call  sys_render_enemies
  ; call  sys_render_bombs
  ret  


;;
;;  Remove an entity from screen (video-memory)
;;  INPUT:
;;    ix  with memory address of entity that must be removed
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    AF,BC,DE,HL
sys_render_remove_entity::
  ld    e, e_sp_ptr_0(ix)          
  ld    d, e_sp_ptr_1(ix)           ;; Destination video memory pointer
  ld    a, #0x00  ;;0xFF rojo
  ld    c, e_w(ix)                  ;; Sprite width
  ld    b, e_h(ix)                  ;; Sprite height
  call  cpct_drawSolidBox_asm
  ret


;;
;;  Remove an entity from screen (video-memory)
;;  INPUT:
;;    ix  with memory address of entity that must be removed
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    AF,BC,DE,HL
sys_render_remove_bomb::
  ;ld    e, b_sp_ptr_0(ix)          
  ;ld    d, b_sp_ptr_1(ix)           ;; Destination video memory pointer
  ;ld    hl, #_sp_bomb               ;; Source Sprite Pointer (array with pixel data)
  ;ld    b, b_w(ix)                  ;; Sprite width
  ;ld    c, b_h(ix)                  ;; Sprite height
  ;call  cpct_drawSpriteBlended_asm
  ret


;  Render map
;;  INPUT:
;;    C = x coordinate       
;;    B = y coordinate 
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    DE,BC,HL,IX
sys_render_one_border_block::
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen 
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ;;  Draw sprite blended
  ex    de, hl                      ;; DE = Destination video memory pointer
  ld    hl, #_sp_border_block          ;; Source Sprite Pointer (array with pixel data)
  ld    c, #4                 ;; Sprite width
  ld    b, #16            ;; Sprite height
  call  cpct_drawSprite_asm 
  ret
;================================================================
sys_render_min_row_map::
  ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
  ld    b, #min_map_y_coord_valid         ;; B = y coordinate  

min_row:
  push bc
  call sys_render_one_border_block 
  pop bc
  ld  hl, #0x0004
  add hl, bc
  ld b, h
  ld c, l
  
  ld a, #max_map_x_coord_valid-4
  cp c
  jr  nc, min_row
  ret
  ;================================================================
sys_render_max_row_map::
  ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
  ld    b, #max_map_y_coord_valid-16         ;; B = y coordinate  

max_row:
  push bc
  call sys_render_one_border_block 
  pop bc
  ld  hl, #0x0004
  add hl, bc
  ld b, h
  ld c, l
  
  ld a, #max_map_x_coord_valid-4
  cp c
  jr  nc, max_row
  ret
;================================================================
sys_render_min_col_map::
  ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
  ld    b, #min_map_y_coord_valid         ;; B = y coordinate  

min_col:
  push bc
  call sys_render_one_border_block 
  pop bc
  ld  hl, #0x1000 ;+16
  add hl, bc
  ld b, h
  ld c, l
  
  ld a, #max_map_y_coord_valid-16
  cp b
  jr  nc, min_col
  ret
;================================================================
sys_render_max_col_map::
  ld    c, #max_map_x_coord_valid-4         ;; C = x coordinate       
  ld    b, #min_map_y_coord_valid         ;; B = y coordinate  

max_col:
  push bc
  call sys_render_one_border_block 
  pop bc
  ld  hl, #0x1000 ;+16
  add hl, bc
  ld b, h
  ld c, l
  
  ld a, #max_map_y_coord_valid-16
  cp b
  jr  nc, max_col
  ret


;  Render map
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    DE,BC,HL,IX
sys_render_map::
  call sys_render_min_row_map
  call sys_render_max_row_map
  call sys_render_min_col_map
  call sys_render_max_col_map
  ret
  

  

