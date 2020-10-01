;;
;;  ENTITY MANAGER HEADER
;;

.globl  entityman_init
.globl  get_entity_array
.globl  entityman_set_dead
.globl  entityman_update

.macro DefineStar _type,_x,_y,_vx,_vy,_color,_last_ptr
    .db _type
    .db _x
    .db _y
    .db _vx
    .db _vy
    .db _color    
    .dw _last_ptr
.endm

e_type = 0
e_x = 1
e_y = 2
e_vx = 3
e_vy = 4
e_color = 5
e_last_ptr_1 = 6
e_last_ptr_2 = 7
sizeof_e = 8
max_entities = 10