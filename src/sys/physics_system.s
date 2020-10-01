.include "../man/entity_manager.h.s"
.include "physics_system.h.s"
.include "../cpct_functions.h.s"

physicssys_init::
  ret

physicssys_update::
  call  get_entity_array
  or     a
  ret    z

physicssys_loop:    
  push  af

  ld    c, e_x(ix)                  ;; C = x coordinate       
  ld    a, e_vx(ix)                 ;; L = x velocity       
  add   a, c
  jp    m, invalid_x

continue_x:
  ld    e_x(ix), a  

  ld    b, e_y(ix)                  ;; B = y coordinate  
  ld    a, e_vy(ix)                 ;; H = y velocity  
  add   a, b
  jp    m, invalid_y
continue_y:
  ld    e_y(ix), a

  ld    bc, #sizeof_e
  add   ix, bc

  pop   af
  dec   a  
  ret   z
  jr    physicssys_loop

invalid_x:
  call  entityman_set_dead
  jr    continue_x

invalid_y:
  call  entityman_set_dead
  jr    continue_y
