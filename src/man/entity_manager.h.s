;;
;;  ENTITY MANAGER HEADER
;;

.globl  man_entity_init

.globl  man_entity_update

.globl  man_entity_create_entity
.globl  man_entity_create_bomb

.globl  man_entity_get_player
.globl  man_entity_get_enemy_array
.globl  man_entity_get_bomb_array

.globl  man_entity_set_player_dead
.globl  man_entity_set_enemy_dead

;;########################################################
;;                        MACROS                         #              
;;########################################################

;;-----------------------  ENTITY  -----------------------
.macro DefineEntity _type,_x,_y,_w,_h,_vx,_vy,_sp_ptr
    .db _type
    .db _x, _y
    .db _w, _h      ;; both in bytes
    .db _vx, _vy    
    .dw _sp_ptr
.endm

.macro DefineEntityDefault
    .db alive_type
    .db 0xDE, 0xAD
    .db 4, 16  
    .dw 0xADDE 
    .dw 0xCCCC
.endm

.macro DefineEntityArray _Tname,_N,_DefineEntity
    _Tname'_num:    .db 0    
    _Tname'_last:   .dw _Tname'_array
    _Tname'_array: 
    .rept _N    
        _DefineEntity
    .endm
.endm

;;-----------------------  BOMBS  ------------------------
.macro DefineBombDefault    
    .db max_timer   ;; timer    
    .db 0xDE,0xAD   ;; coordinates (x, y)
    .db #4, #16     ;; width, height -> both in bytes    
    .dw 0xCCCC      ;; sprite  pointer (where it's in memory video)
.endm

.macro DefineBombArray _Tname,_N,_DefineBomb
    _Tname'_num:    .db 0    
    _Tname'_last:   .dw _Tname'_array
    _Tname'_array: 
    .rept _N    
        _DefineBomb
    .endm
.endm

;;########################################################
;;                       CONSTANTS                       #             
;;########################################################

;;-----------------------  ENTITY  -----------------------
e_type = 0
e_x = 1
e_y = 2
e_w = 3
e_h = 4
e_vx = 5
e_vy = 6
e_sp_ptr_0 = 7
e_sp_ptr_1 = 8
sizeof_e = 9
max_entities = 1

;;-----------------------  BOMBS  ------------------------
b_timer = 0
b_x = 1
b_y = 2
b_w = 3
b_h = 4
b_sp_ptr_0 = 5
b_sp_ptr_1 = 6
sizeof_b = 7
max_bombs = 1

;;########################################################
;;                      ENTITY TYPES                     #             
;;########################################################
alive_type = 0x01
dead_type = 0xFE
invalid_type = 0xFF


;;########################################################
;;                       BOMB TIMERS                     #             
;;########################################################
zero_timer = 0x00
max_timer = 0xFF