;;
;;  ENTITY MANAGER HEADER
;;

.globl  man_entity_init
.globl  man_entity_update
.globl  man_entity_terminate

.globl  man_entity_create_entity
.globl  man_entity_create_bomb

.globl  man_entity_get_player
.globl  man_entity_get_enemy_array

.globl  man_entity_set_player_dead
.globl  man_entity_set_enemy_dead

;;########################################################
;;                        MACROS                         #              
;;########################################################

;;-----------------------  ENTITY  -----------------------
.macro DefineEntity _type, _x, _y, _xcell, _ycell, _w, _h, _vx, _vy, _counter_vx, _counter_vy, _increment_vx, _increment_vy, _sp_ptr, _ghost
    .db _type
    .db _x, _y
    .db _xcell, _ycell
    .db _w, _h      ;; both in bytes
    .db _vx, _vy    
    .db _counter_vx, _counter_vy 
    .db _increment_vx, _increment_vy 
    .dw _sp_ptr
    .db max_lifes
    .db _ghost
    .rept max_bombs 
        DefineBombDefault
    .endm
.endm

.macro DefineEntityDefault
    .db alive_type
    .db 0xDE, 0xAD
    .db 0xDE, 0xAD
    .db 4, 16  
    .dw 0xADDE 
    .dw 0xADDE 
    .dw #CPCT_VMEM_START_ASM+402
    .db max_lifes
    .db 0x00        ;ghost
    .rept max_bombs 
        DefineBombDefault
    .endm
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
    .db invalid_type
    .db max_timer   ;; timer    
    .db 0xDE,0xAD   ;; coordinates (x, y)
    .db 0xDE,0xAD   ;; coordinates in cells (x, y)
    .db 4,16   ;;   
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
e_xcell = 3
e_ycell = 4
e_w = 5
e_h = 6
e_vx = 7
e_vy = 8
e_counter_vx = 9
e_counter_vy = 10
e_increment_vx = 11
e_increment_vy = 12
e_sp_ptr_0 = 13
e_sp_ptr_1 = 14
e_l = 15
e_ghost = 16
sizeof_e_solo = 17
sizeof_e = sizeof_e_solo + (sizeof_b * max_bombs)
max_entities = 6

;;-----------------------  BOMBS  ------------------------
bomb_type = 0
bomb_timer = 1
bomb_x = 2
bomb_y = 3
bomb_xcell = 4
bomb_ycell = 5
bomb_w = 6
bomb_h = 7

sizeof_b = 8
max_bombs = 1

;;########################################################
;;                      ENTITY TYPES                     #             
;;########################################################
alive_type = 0x01
dead_type = 0xFE
invalid_type = 0xFF
no_ghost = 0x00
ghost = 0xAA


move_type = 0xDD
max_lifes = 3


;;########################################################
;;                       BOMB TIMERS                     #             
;;########################################################
;zero_timer = 0x00
max_timer = 0xFF