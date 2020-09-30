ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;
                              2 ;;  ENTITY MANAGER
                              3 ;;
                              4 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              5 .include "entity_manager.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              6 
                              7 
                              8 ;;########################################################
                              9 ;;                        VARIABLES                      #             
                             10 ;;########################################################
                             11 
   409C 00                   12 empty_type: .db 0x00
   409D 01                   13 alive_type: .db 0x01
   409E FE                   14 dead_type: .db 0xFE
   409F FF                   15 invalid_type: .db 0xFF
                             16 
   40A0 0A                   17 _num_entities: .db 0x0A
   40A1 A3 40                18 _last_elem_ptr: .dw _entity_array
   40A3                      19 _entity_array:
                             20   ;.ds max_entities*sizeof_e
   0007                      21   DefineStar alive_type, 79, 1,  -1, -1, 0x88, 0xCCCC
   40A3 9D                    1     .db alive_type
   40A4 4F                    2     .db 79
   40A5 01                    3     .db 1
   40A6 FF                    4     .db -1
   40A7 FF                    5     .db -1
   40A8 88                    6     .db 0x88    
   40A9 CC CC                 7     .dw 0xCCCC
   000F                      22   DefineStar alive_type, 79, 4,  -2, -1, 0x88, 0xCCCC
   40AB 9D                    1     .db alive_type
   40AC 4F                    2     .db 79
   40AD 04                    3     .db 4
   40AE FE                    4     .db -2
   40AF FE                    5     .db -2
   40B0 88                    6     .db 0x88    
   40B1 CC CC                 7     .dw 0xCCCC
   0017                      23   DefineStar alive_type, 79, 7,  -3, -1, 0x88, 0xCCCC
   40B3 9D                    1     .db alive_type
   40B4 4F                    2     .db 79
   40B5 07                    3     .db 7
   40B6 FD                    4     .db -3
   40B7 FD                    5     .db -3
   40B8 88                    6     .db 0x88    
   40B9 CC CC                 7     .dw 0xCCCC
   001F                      24   DefineStar alive_type, 79, 10, -1, -1, 0x88, 0xCCCC
   40BB 9D                    1     .db alive_type
   40BC 4F                    2     .db 79
   40BD 0A                    3     .db 10
   40BE FF                    4     .db -1
   40BF FF                    5     .db -1
   40C0 88                    6     .db 0x88    
   40C1 CC CC                 7     .dw 0xCCCC
   0027                      25   DefineStar alive_type, 79, 13, -3, -1, 0x88, 0xCCCC
   40C3 9D                    1     .db alive_type
   40C4 4F                    2     .db 79
   40C5 0D                    3     .db 13
   40C6 FD                    4     .db -3
   40C7 FD                    5     .db -3
   40C8 88                    6     .db 0x88    
   40C9 CC CC                 7     .dw 0xCCCC
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



   002F                      26   DefineStar alive_type, 79, 1,  -1, -1, 0x88, 0xCCCC
   40CB 9D                    1     .db alive_type
   40CC 4F                    2     .db 79
   40CD 01                    3     .db 1
   40CE FF                    4     .db -1
   40CF FF                    5     .db -1
   40D0 88                    6     .db 0x88    
   40D1 CC CC                 7     .dw 0xCCCC
   0037                      27   DefineStar alive_type, 79, 4,  -2, -1, 0x88, 0xCCCC
   40D3 9D                    1     .db alive_type
   40D4 4F                    2     .db 79
   40D5 04                    3     .db 4
   40D6 FE                    4     .db -2
   40D7 FE                    5     .db -2
   40D8 88                    6     .db 0x88    
   40D9 CC CC                 7     .dw 0xCCCC
   003F                      28   DefineStar alive_type, 79, 7,  -3, -1, 0x88, 0xCCCC
   40DB 9D                    1     .db alive_type
   40DC 4F                    2     .db 79
   40DD 07                    3     .db 7
   40DE FD                    4     .db -3
   40DF FD                    5     .db -3
   40E0 88                    6     .db 0x88    
   40E1 CC CC                 7     .dw 0xCCCC
   0047                      29   DefineStar alive_type, 79, 10, -1, -1, 0x88, 0xCCCC
   40E3 9D                    1     .db alive_type
   40E4 4F                    2     .db 79
   40E5 0A                    3     .db 10
   40E6 FF                    4     .db -1
   40E7 FF                    5     .db -1
   40E8 88                    6     .db 0x88    
   40E9 CC CC                 7     .dw 0xCCCC
   004F                      30   DefineStar alive_type, 79, 13, -3, -1, 0x88, 0xCCCC
   40EB 9D                    1     .db alive_type
   40EC 4F                    2     .db 79
   40ED 0D                    3     .db 13
   40EE FD                    4     .db -3
   40EF FD                    5     .db -3
   40F0 88                    6     .db 0x88    
   40F1 CC CC                 7     .dw 0xCCCC
                             31 
   0057                      32 default: DefineStar 0xFF, 0x28, 0x28, 0xFE, 0xFE, 0xFF, 0xCCCC
   40F3 FF                    1     .db 0xFF
   40F4 28                    2     .db 0x28
   40F5 28                    3     .db 0x28
   40F6 FE                    4     .db 0xFE
   40F7 FE                    5     .db 0xFE
   40F8 FF                    6     .db 0xFF    
   40F9 CC CC                 7     .dw 0xCCCC
                             33 
                             34 ;;########################################################
                             35 ;;                   PUBLIC FUNCTIONS                    #             
                             36 ;;########################################################
                             37 
                             38 ;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                             39 ;;  INPUT: 
                             40 ;;    hl with memory address of default entity
                             41 ;;    de with memory address of free space for new entity
                             42 ;;  RETURN
                             43 ;;    hl with memory address of free space for new entity
                             44 ;;
   40FB                      45 entityman_create::  
   40FB 01 08 00      [10]   46   ld    bc, #sizeof_e
   40FE ED B0         [21]   47   ldir
                             48 
   4100 3A A0 40      [13]   49   ld    a, (_num_entities)
   4103 3C            [ 4]   50   inc   a
   4104 32 A0 40      [13]   51   ld    (_num_entities), a
                             52 
   4107 2A A1 40      [16]   53   ld    hl, (_last_elem_ptr)    
   410A 01 08 00      [10]   54   ld    bc, #sizeof_e
   410D 09            [11]   55   add   hl, bc
   410E 22 A1 40      [16]   56   ld    (_last_elem_ptr), hl
                             57 
   4111 C9            [10]   58   ret
                             59 
   4112                      60 entityman_init::
   4112 3E 0A         [ 7]   61   ld    a, #max_entities  
   4114 ED 5B A1 40   [20]   62   ld    de, (_last_elem_ptr)
   4118                      63 init_loop:
   4118 F5            [11]   64   push  af
                             65   
   4119 21 F3 40      [10]   66   ld    hl, #default  
   411C CD FB 40      [17]   67   call  entityman_create
   411F EB            [ 4]   68   ex    de, hl
                             69   
   4120 F1            [10]   70   pop   af
   4121 3D            [ 4]   71   dec   a
   4122 C8            [11]   72   ret   z
   4123 18 F3         [12]   73   jr    init_loop
                             74 
                             75 
   4125                      76 entityman_update::
                             77   ;ld ix, #_entity_array
                             78   ;ld  a, (_num_entities)
                             79 ;
                             80   ;ld  c, e_type(ix)
   4125 C9            [10]   81   ret
                             82 ;
                             83 
                             84 ;;
                             85 ;; RETURN: 
                             86 ;;  ix  begin of entity array memory address
                             87 ;;  a   last element pointer (free space)
                             88 ;;
   4126                      89 get_entity_array::
   4126 DD 21 A3 40   [14]   90   ld ix, #_entity_array
   412A 3A A0 40      [13]   91   ld  a, (_num_entities)
   412D C9            [10]   92   ret
