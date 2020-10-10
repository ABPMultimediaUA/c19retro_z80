;;
;;  PHYSICS SYSTEM
;;

.include "../man/entity_manager.h.s"
.include "physics_system.h.s"
.include "render_system.h.s"
.include "../cpct_functions.h.s"

;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

;;
;;  INPUT:
;;    ix  address memory where entity starts
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_physics_update_entity::
  ;; Calculate the X coordinate where the entity should be positioned and stores result in B
  ld    a, e_x(ix)
  add   e_vx(ix)
  ;add   #2
  ld    b, a

  ;; Check is new X coordinate is greater than min allowed
  ;; IF new(A)<min(B) THEN C-flag=1, new position is invalid, position is not updated
  cp    #min_map_x_coord_valid
  jr    c, check_y

  ;; Calculate max X coordinate where an entity could be
  ld    a, #max_map_x_coord_valid
  sub   e_w(ix)  

  ;; Check is new X coordinate is smaller than max allowed
  ;; IF new(B)>max(A) THEN C-flag=1, new position is invalid, position is not updated
  cp    b
  jr    c, check_y

  ld    e_x(ix), b    ;; Update X coordinate

check_y:
  ;; Calculate the Y coordinate where the entity should be positioned and stores result in B
  ld    a, e_y(ix)
  add   e_vy(ix)
  ld    b, a

  ;; Check is new Y coordinate is greater than min allowed
  ;; IF new(A)<min(B) THEN C-flag=1, new position is invalid, position is not updated
  cp    #min_map_y_coord_valid
  ret   c

  ;; Calculate max X coordinate where an entity could be
  ld    a, #max_map_y_coord_valid
  sub   e_h(ix)  

  ;; Check is new Y coordinate is smaller than max allowed
  ;; IF new(B)>max(A) THEN C-flag=1, new position is invalid, position is not updated
  cp    b
  ret   c
  
  ld    e_y(ix), b    ;; Update X coordinate
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,BC,IX
sys_physics_player_update::
  player_ptr = .+2
  ld    ix, #0x0000  
  call  sys_physics_update_entity
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A,BC,IX
sys_physics_enemies_update::
  enemy_ptr = .+2
  ld    ix, #0x0000
  enemy_num = .+1
  ld     a, #0

physics_enemies_loop:
  push  af
  
  call  sys_physics_update_entity

  ld    bc, #sizeof_e
  add   ix, bc

  pop   af
  dec   a
  ret   z
  jr    physics_enemies_loop
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_physics_bomb_update::
  ret



;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  none
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_physics_init::
  call  man_entity_get_player
  ld    (player_ptr), ix

  call  man_entity_get_enemy_array
  ld    (enemy_ptr), ix
  ld    (enemy_num), a
  ret


sys_physics_update::
  call  sys_physics_player_update
  call  sys_physics_enemies_update
  call  sys_physics_bomb_update
  ret
  
