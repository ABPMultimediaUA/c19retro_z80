ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;
                              2 ;;  ENTITY MANAGER HEADER
                              3 ;;
                              4 
                              5 .globl  entityman_init
                              6 .globl  get_entity_array
                              7 
                              8 .macro DefineStar _type,_x,_y,_vx,_vy,_color,_last_ptr
                              9     .db _type
                             10     .db _x
                             11     .db _y
                             12     .db _vx
                             13     .db _vx
                             14     .db _color    
                             15     .dw _last_ptr
                             16 .endm
                             17 
                     0000    18 e_type = 0
                     0001    19 e_x = 1
                     0002    20 e_y = 2
                     0003    21 e_vx = 3
                     0004    22 e_vy = 4
                     0005    23 e_color = 5
                     0006    24 e_last_ptr_1 = 6
                     0007    25 e_last_ptr_2 = 7
                     0008    26 sizeof_e = 8
                     000A    27 max_entities = 10
