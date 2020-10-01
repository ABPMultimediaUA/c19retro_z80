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
                              9 
                             10 .macro DefineStar _type,_x,_y,_vx,_vy,_color,_last_ptr
                             11     .db _type
                             12     .db _x
                             13     .db _y
                             14     .db _vx
                             15     .db _vy
                             16     .db _color    
                             17     .dw _last_ptr
                             18 .endm
                             19 
                     0000    20 e_type = 0
                     0001    21 e_x = 1
                     0002    22 e_y = 2
                     0003    23 e_vx = 3
                     0004    24 e_vy = 4
                     0005    25 e_color = 5
                     0006    26 e_last_ptr_1 = 6
                     0007    27 e_last_ptr_2 = 7
                     0008    28 sizeof_e = 8
                     000A    29 max_entities = 10
