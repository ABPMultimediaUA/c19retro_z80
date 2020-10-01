.include "../man/entity_manager.h.s"
.include "../cpct_functions.h.s"
.include "render_system.h.s"

;pallete: 
;  .db   HW_BLACK
;  .db   HW_BLACK
;  .db   HW_BLACK
;  .db   HW_BLACK
;  .db   HW_WHITE
;  .db   HW_WHITE
;  .db   HW_WHITE
;  .db   HW_WHITE
;  .db   HW_BLUE
;  .db   HW_BLUE
;  .db   HW_BLUE
;  .db   HW_BLUE
;  .db   HW_RED
;  .db   HW_RED
;  .db   HW_RED
;  .db   HW_RED

rendersys_init::  
  ld    c, #0
  call  cpct_setVideoMode_asm    

  ld    l, #0
  ld    h, #HW_BLACK
  call  cpct_setPALColour_asm
  ret

rendersys_update::
  call get_entity_array
  or     a
  ret    z
rendersys_loop:
  push af

  ld    l, e_last_ptr_1(ix)          
  ld    h, e_last_ptr_2(ix)          
  ld    c, #00
  ld   (hl), c

  ;; Calculate a video-memory location for printing a string
  ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
  ld    c, e_x(ix)                  ;; C = x coordinate       
  ld    b, e_y(ix)                  ;; B = y coordinate   
  call  cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

  ld  e_last_ptr_1(ix), l
  ld  e_last_ptr_2(ix), h
  ld    c, e_color(ix)
  ld   (hl), c
  ld   bc, #sizeof_e
  add  ix, bc

  pop   af
  dec   a
  ret   z
  jr rendersys_loop


;;
;;  INPUT: 
;;    ix with memory address of entity that must be deleted
;;  DESTROY
;;    hl, c
;;
rendersys_delete_entity::
  ;; Calculate a video-memory location for printing a string  
  ld    l, e_last_ptr_1(ix)          
  ld    h, e_last_ptr_2(ix)          
  ld    c, #00
  ld   (hl), c
  ret