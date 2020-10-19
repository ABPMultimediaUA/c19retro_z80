;;
;;  RENDER SYSTEM
;;

.include "../man/entity_manager.h.s"
.include "../man/game.h.s"
.include "../man/map_manager.h.s"
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

  ;;  Draw sprite
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

      ;;  Draw sprite
      ex    de, hl                      ;; DE = Destination video memory pointer
      ld    hl, #_sp_enemy              ;; Source Sprite Pointer (array with pixel data)
      ld    c, e_w(ix)                  ;; Sprite width
      ld    b, e_h(ix)                  ;; Sprite height
      call  cpct_drawSprite_asm    
  
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
  
    ret

;INPUT: BC (y, x) coordinate
sys_render_one_default_block::
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ex    de, hl                      ;; DE = Destination video memory pointer
  ;ld    hl, #_sp_floor_block          ;; Source Sprite Pointer (array with pixel data)
  ld    a, #0x33  ;green
  ld    c, #4                 ;; Sprite width
  ld    b, #16            ;; Sprite height
  call  cpct_drawSolidBox_asm 
  ret

sys_render_map::
  map_ptr = .+2
  ld    ix, #0x0000 ;map_ptr NOT USED
  ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
  ld    b, #min_map_y_coord_valid         ;; B = y coordinate  

_row:
  ld    c, #min_map_x_coord_valid         ;; C = x coordinate 
  _col:
    push bc

    ;;====================
    ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
    call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

    ex    de, hl                      ;; DE = Destination video memory pointer
    ;ld    hl, #_sp_floor_block          ;; Source Sprite Pointer (array with pixel data)
    
    ld    a, b_type(ix) ;;ld type of block
    xor   #default_btype
    jr    nz, _draw_solid_box
  
    ld    a, #0x33  ;green
    jr    _end_draw_box

    _draw_solid_box:
      ld    a, #0x02  ;
    _end_draw_box:
    
    ld    c, #4                 ;; Sprite width
    ld    b, #16            ;; Sprite height
    call  cpct_drawSolidBox_asm 
    
    ld    bc, #sizeof_block ;size of block type
    add   ix, bc
    ;;====================

    pop bc
    ld  hl, #0x0004 ;c+=4 (x+=4)
    add hl, bc
    ld b, h
    ld c, l
    
    ld a, #max_map_x_coord_valid-4
    cp c
    jr  nc, _col
  _endcol:
  
  ld  hl, #0x1000   ;b+=16 (y+=16)
  add hl, bc
  ld b, h
  ld c, l

  ld a, #max_map_y_coord_valid-16
  cp b
  jr  nc, _row
ret

;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

sys_render_menu::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #16                      ;; C = x coordinate       
  ld    b, #40                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL  

  ;;  Draw sprite
  ex    de, hl                      ;; DE = Destination video memory pointer
  ld    hl, #_sp_menu               ;; Source Sprite Pointer (array with pixel data)
  ld    c, #50                      ;; Sprite width
  ld    b, #100                     ;; Sprite height
  call  cpct_drawSprite_asm 
  ret

;;
;;  Set video mode and palette
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    AF,BC,DE,HL

sys_render_init_config::
  ld    c, #0
  call  cpct_setVideoMode_asm    

  ld    l, #0
  ld    h, #HW_BLACK
  call  cpct_setPALColour_asm
  ret


;;
;;  Render map, borders and init pointers
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    AF,BC,DE,HL
sys_render_init::      
  call  man_entity_get_player
  ld    (player_ptr), ix

  call  man_entity_get_enemy_array
  ld    (enemy_ptr), ix
  ld    (enemy_num), a    

  call  sys_render_border_map

  call  man_map_get_map_array
  ld    (map_ptr), ix
  call  sys_render_map

  ;; ========== CHAPUZA para poner el ultimo puntero del player a su posicion
  call  man_entity_get_player
    ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, e_x(ix)                  ;; C = x coordinate       
  ld    b, e_y(ix)                  ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
  
  ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
  ld  e_sp_ptr_0(ix), l
  ld  e_sp_ptr_1(ix), h
  ;;============= FIN CHAPUZA

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
  call  sys_render_enemies
  ;call  sys_render_bombs
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
  ld    a, #0x33  ;;0xFF rojo
  ;;TODO sprite del suelo (default)
  ld    c, e_w(ix)                  ;; Sprite width
  ld    b, e_h(ix)                  ;; Sprite height
  call  cpct_drawSolidBox_asm
  ret


;;
;;  Remove menu from screen (video-memory)
;;  INPUT:
;;    ix  with memory address of entity that must be removed
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    AF,BC,DE,HL
sys_render_remove_menu::
  ;; Calculate a video-memory location for sprite
  ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
  ld    c, #16                      ;; C = x coordinate       
  ld    b, #40                      ;; B = y coordinate   
  call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

  ex    de, hl
  ld    a, #0x00  ;;0xFF rojo  
  ld    c, #50                      ;; Sprite width
  ld    b, #100                     ;; Sprite height
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
  ld    c, #border_block_w                 ;; Sprite width
  ld    b, #border_block_h            ;; Sprite height
  call  cpct_drawSprite_asm 
  ret
;================================================================
sys_render_min_row_map::
  ld    c, #min_map_x_coord_valid-border_block_w         ;; C = x coordinate       
  ld    b, #min_map_y_coord_valid-border_block_h        ;; B = y coordinate  

min_row:
  push bc
  call sys_render_one_border_block 
  pop bc
  ld  hl, #0x0002
  add hl, bc
  ld b, h
  ld c, l
  
  ld a, #max_map_x_coord_valid
  cp c
  jr  nc, min_row
  ret
  ;================================================================
sys_render_max_row_map::
  ld    c, #min_map_x_coord_valid-border_block_w         ;; C = x coordinate       
  ld    b, #max_map_y_coord_valid         ;; B = y coordinate  

max_row:
  push bc
  call sys_render_one_border_block 
  pop bc
  ld  hl, #0x0002
  add hl, bc
  ld b, h
  ld c, l
  
  ld a, #max_map_x_coord_valid
  cp c
  jr  nc, max_row
  ret
;================================================================
sys_render_min_col_map::
  ld    c, #min_map_x_coord_valid-border_block_w         ;; C = x coordinate       
  ld    b, #min_map_y_coord_valid-border_block_h         ;; B = y coordinate  

min_col:
  push bc
  call sys_render_one_border_block 
  pop bc
  ld  hl, #0x0800 
  add hl, bc
  ld b, h
  ld c, l
  
  ld a, #max_map_y_coord_valid
  cp b
  jr  nc, min_col
  ret
;================================================================
sys_render_max_col_map::
  ld    c, #max_map_x_coord_valid        ;; C = x coordinate       
  ld    b, #min_map_y_coord_valid-border_block_h        ;; B = y coordinate  

max_col:
  push bc
  call sys_render_one_border_block 
  pop bc
  ld  hl, #0x0800 
  add hl, bc
  ld b, h
  ld c, l
  
  ld a, #max_map_y_coord_valid
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
sys_render_border_map::
  call sys_render_min_row_map
  call sys_render_max_row_map
  call sys_render_min_col_map
  call sys_render_max_col_map
  ret


  ;; Deprecated, it just print all map green
; ;   sys_render_map::
; ;   map_ptr = .+2
; ;   ld    ix, #0x0000 ;map_ptr NOT USED
; ;   ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
; ;   ld    b, #min_map_y_coord_valid         ;; B = y coordinate  

; ; _row:
; ;   ld    c, #min_map_x_coord_valid         ;; C = x coordinate 
; ;   _col:
; ;     push bc
; ;     call sys_render_one_default_block 
; ;     pop bc
; ;     ld  hl, #0x0004 ;c+=4 (x+=4)
; ;     add hl, bc
; ;     ld b, h
; ;     ld c, l
    
; ;     ld a, #max_map_x_coord_valid-4
; ;     cp c
; ;     jr  nc, _col
; ;   _endcol:
  
; ;   ld  hl, #0x1000   ;b+=16 (y+=16)
; ;   add hl, bc
; ;   ld b, h
; ;   ld c, l

; ;   ld a, #max_map_y_coord_valid-16
; ;   cp b
; ;   jr  nc, _row
; ; ret
  

  

