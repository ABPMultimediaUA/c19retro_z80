.include "../man/entity_manager.h.s"
.include "physics_system.h.s"
.include "../cpct_functions.h.s"

physicssys_init::
  ret

physicssys_update::
  call  get_entity_array

physicssys_loop:    
  ld    c, e_x(ix)                  ;; C = x coordinate       
  ld    b, e_y(ix)                  ;; B = y coordinate  
  ld    l, e_vx(ix)                 ;; L = x velocity       
  ld    h, e_vy(ix)                 ;; H = y velocity  

  add   hl, bc

  jr    c, invalid_position;

  ld    c, l
  ld    b, h
  
  ld    e_x(ix), c                  ;; C = x coordinate       
  ld    e_y(ix), b                  ;; B = y coordinate  

  ld    bc, #sizeof_e
  add   ix, bc

  dec   a  
  ret   z
  jr    physicssys_loop

invalid_position:
  push  af
  ld    a, #0xFF
  ld    e_type(ix), a
  pop   af
  ld    bc, #sizeof_e
  add   ix, bc
  jr    physicssys_loop
