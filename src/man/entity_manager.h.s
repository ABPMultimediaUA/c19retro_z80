;;
;;  ENTITY MANAGER HEADER
;;

.globl  entityman_init
.globl  get_entity_array
.globl  entityman_set_dead
.globl  entityman_update
.globl  entityman_create_one

;;########################################################
;;                        MACROS                         #              
;;########################################################

.macro DefineStar _type,_x,_y,_vx,_vy,_color,_last_ptr
    .db _type
    .db _x
    .db _y
    .db _vx
    .db _vy
    .db _color    
    .dw _last_ptr
.endm

.macro DefineStarDefault
    .db alive_type
    .db 0xDE
    .db 0xAD
    .db 0xDE
    .db 0xAD
    .db 0x80    
    .dw 0xCCCC
.endm

.macro DefineStarArray _Tname,_N,_DefineStar
    _Tname'_num:    .db 0    
    _Tname'_last:   .dw _Tname'_array
    _Tname'_array: 
    .rept _N    
        _DefineStar
    .endm
    .db invalid_type
.endm

;;########################################################
;;                       CONSTANTS                       #             
;;########################################################
e_type = 0
e_x = 1
e_y = 2
e_vx = 3
e_vy = 4
e_color = 5
e_last_ptr_1 = 6
e_last_ptr_2 = 7
sizeof_e = 8
max_entities = 30

;;########################################################
;;                      ENTITY TYPES                     #             
;;########################################################
empty_type = 0x00
alive_type = 0x01
dead_type = 0xFE
invalid_type = 0xFF