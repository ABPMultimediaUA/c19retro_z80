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


;;  INPUT:  ix  address memory where entity starts
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

  ld    a, b_type(iy) ;;ld type of block
  xor   #exit_btype
  jr   z, _go_next_lvl ;


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
_go_next_lvl:
  call man_game_init_next_lvl
  ret

sys_physics_update_enemy::
  ld    a, e_x(ix)
  add   e_vx(ix)
  ld    b, a

  ;; Check is new X coordinate is greater than min allowed
  ;; IF new(A)<min(B) THEN C-flag=1, new position is invalid, position is not updated
  cp    #min_map_x_coord_valid
  jr    c, _colision_x_enemy

  ;; Calculate max X coordinate where an entity could be
  ld    a, #max_map_x_coord_valid
  sub   e_w(ix)  

  ;; Check is new X coordinate is smaller than max allowed
  ;; IF new(B)>max(A) THEN C-flag=1, new position is invalid, position is not updated
  cp    b
  jr    c, _colision_x_enemy

  ld    a, e_vx(ix)
  and   a 
  jr    z, _enemy_check_y ; vx = 0
  sub   #4
  jr    z, inc_x_enemy ;if a != 4 (moved left)

  dec   e_xcell(ix)
  jr    update_x_enemy

inc_x_enemy:
  inc   e_xcell(ix)

update_x_enemy:
  ld    e_x(ix), b    ;; Update X coordinate
  jp    end_update_y_enemy

_colision_x_enemy:
  ld    a, e_vx(ix)
  neg 
  ld    e_vx(ix), a
  ret

_enemy_check_y:
  ;; Calculate the Y coordinate where the entity should be positioned and stores result in B
  ld    a, e_y(ix)
  add   e_vy(ix)
  ld    b, a

  ;; Check is new Y coordinate is greater than min allowed
  ;; IF new(A)<min(B) THEN C-flag=1, new position is invalid, position is not updated
  cp    #min_map_y_coord_valid
  jr    c,  _colision_y_enemy

  ;; Calculate max X coordinate where an entity could be
  ld    a, #max_map_y_coord_valid
  sub   e_h(ix)  

  ;; Check is new Y coordinate is smaller than max allowed
  ;; IF new(B)>max(A) THEN C-flag=1, new position is invalid, position is not updated
  cp    b
  jr    c,  _colision_y_enemy

  ld    a, e_vy(ix)
  and   a 
  jr    z, end_update_y_enemy ; vy = 0
  ;cp    #0
  sub   #16
  jr    z, inc_y_enemy ;;if a != 16 (moved up)

  dec   e_ycell(ix)
  jr    update_y_enemy

inc_y_enemy:
  inc   e_ycell(ix)

update_y_enemy:
  ld    e_y(ix), b    ;; Update Y coordinate
  jp    end_update_y_enemy

_colision_y_enemy:
  ld    a, e_vy(ix)
  neg 
  ld    e_vy(ix), a
  ret

end_update_y_enemy:
  
  player_ptr_colision = .+2
  ld  iy, #0x0000
  call sys_physics_check_colision_entity_entity ; a=1 if colision
  and a 
  jr  z, _enemy_check_colision_map

  ; enemy collided player
  call  man_game_terminate
  call  man_game_init
  ret

_enemy_check_colision_map:
  map_ptr_colision = .+2
  ld  iy, #0x0000
  ld  c,  e_ycell(ix) ;future row cell 
  ;ld  b,  e_xcell(ix) ;future col cell
  ld  b,  #map_width_cell ;cells in a row
  

; ; loop for iy += y*map_width_cell
; ;----------------------
ld  a,  c
_enemy_loop_row:

  and  a
  jr  z, _enemy_endloop_row ;if row == 0
  ld  d, a
  
  _enemy_start_loop_col:
  ld  a, b 
  _enemy_loop_col:
    or  a
    jr  z, _enemy_endloop_col ; if col == 0
    dec a
        
    inc   iy  ;,sp

    jr  _enemy_loop_col 
  _enemy_endloop_col:

  ld  a, d
  dec a     ; row --
  jr  _enemy_loop_row
_enemy_endloop_row:

; iy += xcell
_enemy_for_init_sum_iy_xcell:
  ld  a, e_xcell(ix) 
_enemy_for_sum_iy_xcell:
  or  a
  jr  z, _enemy_endfor_sum_iy_xcell ; if a == 0
  dec a
      
  inc   iy

  jr  _enemy_for_sum_iy_xcell 
_enemy_endfor_sum_iy_xcell:

  ;now iy is pointer to future cell
  ld    a, b_type(iy) ;;ld type of block
  xor   #default_btype
  jr   z, _enemy_end_update ; the cell is equal to default z = 0 (xor -> 1 if different)

;; Rehacer el cambio de posicion x y xcell
  ld    a, e_vx(ix)
  and   a 
  jr    z, _enemy_update_ycell ; vx = 0
  sub   #4
  jr    z, _enemy_dec_xcell ;if a != 4 (moved left)

  inc   e_xcell(ix)
  jr    _enemy_reupdate_x

_enemy_dec_xcell:
  dec   e_xcell(ix)
_enemy_reupdate_x:
  ld    a, e_x(ix)
  sub   e_vx(ix)
  ld    b, a
  ld    e_x(ix), b 

  ; invert velocity
  ld    a, e_vx(ix)
  neg
  ld    e_vx(ix), a
;--------------------------------
_enemy_update_ycell:

  ld    a, e_vy(ix)
  and   a 
  jr    z, _enemy_end_update ; vy = 0
  sub   #16
  jr    z, _enemy_dec_ycell ;;if a != 16 (moved up)

  inc   e_ycell(ix)
  jr    _enemy_reupdate_y

_enemy_dec_ycell:
  dec   e_ycell(ix)

_enemy_reupdate_y:
  ld    a, e_y(ix)
  sub   e_vy(ix)
  ld    b, a
  ld    e_y(ix), b 

  ; invert velocity
  ld    a, e_vy(ix)
  neg
  ld    e_vy(ix), a
 
_enemy_end_update:
  ret

; Input: ix pointer to entity
sys_physics_update_entity_bombs::
  ld    a,  bomb_type+sizeof_e_solo(ix)
  xor   #invalid_type
  ret   z   ;ret if invalid, nothing to update

  ld    a,  bomb_timer+sizeof_e_solo(ix)
  and   a
  jr    nz, dec_timer ; if a != 0 : timer--
  
  ld    bomb_type+sizeof_e_solo(ix), #dead_type
  ret

dec_timer:
  dec   bomb_timer+sizeof_e_solo(ix)
  ret

; Input ix, iy (2 entities)
; Return a { 1 if colision, 0 if not}
sys_physics_check_colision_entity_entity::
  ld  a, e_xcell(ix)
  ld  b, a
  ld  a, e_xcell(iy)

  sub b   ; a - b (x2-x1)
  jr  nz, _no_colision

  ld  a, e_ycell(ix)
  ld  b, a
  ld  a, e_ycell(iy)

  sub b   ; a - b (y2-y1)
  jr  nz, _no_colision

_colision:
  ld  a, #1
  ret
_no_colision:
  ld  a, #0
  ret


;;  DESTROYED:
;;    A,BC,IX
sys_physics_player_update::
  player_ptr = .+2
  ld    ix, #0x0000  
  call  sys_physics_update_entity
  ;call  sys_physics_update_entity_bombs 
  ret


;;  DESTROYED:
;;    A,BC,IX
sys_physics_enemies_update::
  enemy_ptr = .+2
  ld    ix, #0x0000
  enemy_num = .+1
  ld     a, #0

physics_enemies_loop:
  push  af
  
  call  sys_physics_update_enemy
  ;call  sys_physics_update_entity_bombs

  ld    bc, #sizeof_e
  add   ix, bc

  pop   af
  dec   a
  ret   z
  jr    physics_enemies_loop
  ret



;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

sys_physics_init::
  call  man_entity_get_player
  ld    (player_ptr), ix
  ld    (player_ptr_colision), ix

  call  man_entity_get_enemy_array
  ld    (enemy_ptr), ix
  ld    (enemy_num), a

  call  man_map_get_lvl_map
  call  man_map_get_map_array
  ld    (map_ptr),  ix
  ld    (map_ptr_colision),  ix
  ret


sys_physics_update::
  call  sys_physics_player_update
  call  sys_physics_enemies_update
  ret
  
