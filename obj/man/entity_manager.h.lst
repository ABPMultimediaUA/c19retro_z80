ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;
                              2 ;;  ENTITY MANAGER HEADER
                              3 ;;
                              4 
                              5 .globl  entityman_init
                              6 .globl  get_entity_array
                              7 .globl  entityman_set_dead
                              8 .globl  entityman_update
                              9 .globl  entityman_create_one
                             10 
                             11 ;;########################################################
                             12 ;;                        MACROS                         #              
                             13 ;;########################################################
                             14 
                             15 .macro DefineStar _type,_x,_y,_vx,_vy,_color,_last_ptr
                             16     .db _type
                             17     .db _x
                             18     .db _y
                             19     .db _vx
                             20     .db _vy
                             21     .db _color    
                             22     .dw _last_ptr
                             23 .endm
                             24 
                             25 .macro DefineStarDefault
                             26     .db alive_type
                             27     .db 0x40
                             28     .db 0x01
                             29     .db 0xFE
                             30     .db 0xFE
                             31     .db 0xFF    
                             32     .dw 0xCCCC
                             33 .endm
                             34 
                             35 .macro DefineStarEmpty    
                             36     .db empty_type
                             37     .ds sizeof_e-1
                             38 .endm
                             39 
                             40 .macro DefineStarArray _Tname,_N,_DefineStar
                             41     _Tname'_num:    .db 0    
                             42     _Tname'_last:   .dw _Tname'_array
                             43     _Tname'_array: 
                             44     .rept _N    
                             45         _DefineStar
                             46     .endm
                             47 .endm
                             48 
                             49 ;;########################################################
                             50 ;;                       CONSTANTS                       #             
                             51 ;;########################################################
                     0000    52 e_type = 0
                     0001    53 e_x = 1
                     0002    54 e_y = 2
                     0003    55 e_vx = 3
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                     0004    56 e_vy = 4
                     0005    57 e_color = 5
                     0006    58 e_last_ptr_1 = 6
                     0007    59 e_last_ptr_2 = 7
                     0008    60 sizeof_e = 8
                     000A    61 max_entities = 10
                             62 
                             63 ;;########################################################
                             64 ;;                      ENTITY TYPES                     #             
                             65 ;;########################################################
                     0000    66 empty_type = 0x00
                     0001    67 alive_type = 0x01
                     00FE    68 dead_type = 0xFE
                     00FF    69 invalid_type = 0xFF
