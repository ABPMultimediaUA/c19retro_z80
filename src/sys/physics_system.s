;;
;;  PHYSICS SYSTEM
;;

.include "../man/entity_manager.h.s"
.include "../man/game.h.s"
.include "../man/map_manager.h.s"
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


  ld    a, e_vx(ix)
  and   a 
  jr    z, check_y ; vx = 0
  sub   #4
  jr    z, inc_x ;if a != 4 (moved left)

  dec   e_xcell(ix)
  jr    update_x

inc_x:
  inc   e_xcell(ix)

update_x:
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

  ld    a, e_vy(ix)
  and   a 
  jr    z, end_update_y ; vy = 0
  ;cp    #0
  sub   #16
  jr    z, inc_y ;;if a != 16 (moved up)

  dec   e_ycell(ix)
  jr    update_y

inc_y:
  inc   e_ycell(ix)

update_y:
  ld    e_y(ix), b    ;; Update Y coordinate
end_update_y:
  
; _check_colision:
; ;---------------------- X ---------------------
;   ld    a, e_x(ix)
;   add   e_vx(ix)  ;a = new x
;   sub   #min_map_x_coord_valid
;   ld    b, a  ; b = new x inside map

;   ; get b / 4
;   ld    a, #0
;   _loop_x:
;     jr  z,  _endloop_x
;     push  af

;     ld  a,  b
;     sub #4
;     ld  b,  a

;     pop   af
;     inc a
;     jr  _loop_x
;   _endloop_x:
;   ld  b,  a
;   ; b = b / 4
; ;---------------------- Y ---------------------
;   ld    a, e_y(ix)
;   add   e_vy(ix)  ;;a = new x
;   sub   #min_map_y_coord_valid
;   ld    c, a  ; c = new y inside map

;   ; get c / 16
;   ld    a, #0
;   _loop_y:
;     jr  z,  _endloop_y
;     push  af

;     ld  a,  c
;     sub #16
;     ld  c,  a

;     pop   af
;     inc a
;     jr  _loop_y
;   _endloop_y:
;   ld  c,  a
  ; c = c / 16
  ;-------------------------------------------
  ; Now BC represent the cell of map and we can search the correspond tile

  map_ptr = .+2
  ld  iy, #0x0000
  ld  c,  e_ycell(ix) ;future row cell 
  ;ld  b,  e_xcell(ix) ;future col cell
  ld  b,  #map_width_cell ;cells in a row
  

; ; loop for iy += y*map_width_cell
; ;----------------------
ld  a,  c
_loop_row:

  and  a
  jr  z, _endloop_row ;if row == 0
  ld  d, a
  
  _start_loop_col:
  ld  a, b 
  _loop_col:
    or  a
    jr  z, _endloop_col ; if col == 0
    dec a
        
    inc   iy  ;,sp

    jr  _loop_col 
  _endloop_col:

  ld  a, d
  dec a     ; row --
  jr  _loop_row
_endloop_row:

; iy += xcell
_for_init_sum_iy_xcell:
  ld  a, e_xcell(ix) 
_for_sum_iy_xcell:
  or  a
  jr  z, _endfor_sum_iy_xcell ; if a == 0
  dec a
      
  inc   iy

  jr  _for_sum_iy_xcell 
_endfor_sum_iy_xcell:

  ;now iy is pointer to future cell
  ld    a, b_type(iy) ;;ld type of block
  xor   #default_btype
  jr   z, _end_update ; the cell is equal to default z = 0 (xor -> 1 if different)


;; Rehacer el cambio de posicion x y xcell
  ld    a, e_vx(ix)
  and   a 
  jr    z, update_ycell ; vx = 0
  sub   #4
  jr    z, dec_xcell ;if a != 4 (moved left)

  inc   e_xcell(ix)
  jr    reupdate_x

dec_xcell:
  dec   e_xcell(ix)
reupdate_x:
  ld    a, e_x(ix)
  sub   e_vx(ix)
  ld    b, a
  ld    e_x(ix), b 
;--------------------------------
update_ycell:

  ld    a, e_vy(ix)
  and   a 
  jr    z, _end_update ; vy = 0
  sub   #16
  jr    z, dec_ycell ;;if a != 16 (moved up)

  inc   e_ycell(ix)
  jr    reupdate_y

dec_ycell:
  dec   e_ycell(ix)

reupdate_y:
  ld    a, e_y(ix)
  sub   e_vy(ix)
  ld    b, a
  ld    e_y(ix), b 
 
_end_update:
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

  call  man_map_get_map_array
  ld    (map_ptr),  ix
  ret


sys_physics_update::
  call  sys_physics_player_update
  call  sys_physics_enemies_update
  call  sys_physics_bomb_update
  ret
  
