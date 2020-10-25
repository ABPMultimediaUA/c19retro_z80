;;
;;  MAP MANAGER HEADER
;;

.globl  man_map_init
.globl  man_map_update
.globl  man_map_terminate

;.globl  man_map_create_map

.globl  man_map_get_lvl_map
.globl  man_map_get_map_array

;.globl  man_map_set_block_type

;;########################################################
;;                        MACROS                         #              
;;########################################################

;;-----------------------  BLOCK  ------------------------
.macro DefineEnemy _cx, _cy, _vx, _vy
    .db _cx*4,     _cy*16       ;; screen coordinates
    .db _cx,    _cy             ;; map coordinates
    .db _vx,    _vy             ;; velocity
.endm


.macro DefineBlock _type
    .db _type
.endm

.macro DefineBlockDefault    
    .db default_btype        
.endm

.macro DefineBlockArray _Tname,_N,_DefineBlock
    _Tname'_array: 
    .rept _N    
        _DefineBlock
    .endm
.endm

.macro DefineLevel1Map    
    enemies1:
        .db 0 ;; amount of enemies in the map 
        DefineEnemy 0, 0, 0, 0
        DefineEnemy 0, 0, 0, 0
        DefineEnemy 0, 0, 0, 0
        DefineEnemy 0, 0, 0, 0
        DefineEnemy 0, 0, 0, 0       

    .db 0xFF,   0xFF,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xDD,   0xFF,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xEE
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
.endm

.macro DefineLevel2Map    
    enemies2:
        .db 2 ;; amount of enemies in the map
        DefineEnemy 0, 10, 1, 1
        DefineEnemy 17, 0, 0, 1
        DefineEnemy 0, 0, 0, 0
        DefineEnemy 0, 0, 0, 0
        DefineEnemy 0, 0, 0, 0

    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xEE,   0xDD      
    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD   
    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD   
    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD   
    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD   
    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD   
    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD   
    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD   
    .db 0xFF,   0xDD,   0xFF,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD   
    .db 0xFF,   0xDD,   0xFF,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD   
    .db 0xFF,   0xFF,   0xFF,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD   
.endm


.macro DefineLevel3Map    
    enemies3:
        .db 3 ;; amount of enemies in the map
        DefineEnemy 0, 10, 1, 1
        DefineEnemy 16, 0, 0, -1
        DefineEnemy 8, 0, -1, 1
        DefineEnemy 0, 0, 0, 0
        DefineEnemy 0, 0, 0, 0

    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xEE
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF
.endm

.macro DefineLevel4Map    
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xEE
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF
    .db 0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xFF,   0xDD,   0xDD,   0xDD,   0xFF,   0xDD,   0xFF
    .db 0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xFF,   0xDD,   0xDD,   0xFF,   0xFF,   0xFF
.endm



.macro DefineMapsArray _Tname    
    _Tname'_num:    .db 1    
    _Tname'_last:   .dw _Tname'_array
    _Tname'_array: 
        DefineLevel1Map
        DefineLevel2Map
        DefineLevel3Map
        DefineLevel4Map
.endm
;;########################################################
;;                       CONSTANTS                       #             
;;########################################################

;;---------------------  ENEMY ENTITY  -------------------
enemy_x = 0
enemy_y = 1
enemy_cx = 2
enemy_cy = 3
enemy_vx = 4
enemy_vy = 5

sizeof_enemy = 6

sizeof_enemy_array = sizeof_enemy*5
;;---------------------  BLOCK ENTITY  -------------------

b_type = 0
sizeof_block  = 1
sizeof_map    = 19*11 + sizeof_enemy_array
max_maps = 4

;;########################################################
;;                      BLOCK TYPES                     #             
;;########################################################
default_btype = 0xFF ;floor
solid_btype = 0xDD   ;solid block, immutable
box_btype = 0xBB     ;box block, mutable
exit_btype = 0xEE     ;box block, mutable

map_array_end = 0x00