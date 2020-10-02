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
                             27     .db 0xDE
                             28     .db 0xAD
                             29     .db 0xDE
                             30     .db 0xAD
                             31     .db 0x80    
                             32     .dw 0xCCCC
                             33 .endm
                             34 
                             35 .macro DefineStarArray _Tname,_N,_DefineStar
                             36     _Tname'_num:    .db 0    
                             37     _Tname'_last:   .dw _Tname'_array
                             38     _Tname'_array: 
                             39     .rept _N    
                             40         _DefineStar
                             41     .endm
                             42     .db invalid_type
                             43 .endm
                             44 
                             45 ;;########################################################
                             46 ;;                       CONSTANTS                       #             
                             47 ;;########################################################
                     0000    48 e_type = 0
                     0001    49 e_x = 1
                     0002    50 e_y = 2
                     0003    51 e_vx = 3
                     0004    52 e_vy = 4
                     0005    53 e_color = 5
                     0006    54 e_last_ptr_1 = 6
                     0007    55 e_last_ptr_2 = 7
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                     0008    56 sizeof_e = 8
                     001E    57 max_entities = 30
                             58 
                             59 ;;########################################################
                             60 ;;                      ENTITY TYPES                     #             
                             61 ;;########################################################
                     0000    62 empty_type = 0x00
                     0001    63 alive_type = 0x01
                     00FE    64 dead_type = 0xFE
                     00FF    65 invalid_type = 0xFF
