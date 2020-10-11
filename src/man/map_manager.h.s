;;
;;  MAP MANAGER HEADER
;;

.globl  man_map_init
.globl  man_map_update
.globl  man_map_terminate

;.globl  man_map_create_map

.globl  man_map_get_map_array

;.globl  man_map_set_block_type

;;########################################################
;;                        MACROS                         #              
;;########################################################

;;-----------------------  BLOCK  ------------------------
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

;;########################################################
;;                       CONSTANTS                       #             
;;########################################################

;;---------------------  BLOCK ENTITY  -------------------
b_type = 0
sizeof_b = 1

;;########################################################
;;                      BLOCK TYPES                     #             
;;########################################################
default_btype = 0xFF ;floor
solid_btype = 0xDD   ;solid block, immutable
box_btype = 0xBB     ;box block, mutable