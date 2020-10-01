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
                             13     .db _vy
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
   4084 00                   12 empty_type: .db 0x00
   4085 01                   13 alive_type: .db 0x01
   4086 FE                   14 dead_type: .db 0xFE
   4087 FF                   15 invalid_type: .db 0xFF
                             16 
   4088 0A                   17 _num_entities: .db 0x0A
   4089 8B 40                18 _last_elem_ptr: .dw _entity_array
   408B                      19 _entity_array:
                             20   ;.ds max_entities*sizeof_e
   0007                      21   DefineStar alive_type, 79, 1,  0xFE, 0x00, 0x88, 0xCCCC
   408B 85                    1     .db alive_type
   408C 4F                    2     .db 79
   408D 01                    3     .db 1
   408E FE                    4     .db 0xFE
   408F 00                    5     .db 0x00
   4090 88                    6     .db 0x88    
   4091 CC CC                 7     .dw 0xCCCC
   000F                      22   DefineStar alive_type, 79, 4,  0xFD, 0x00, 0x88, 0xCCCC
   4093 85                    1     .db alive_type
   4094 4F                    2     .db 79
   4095 04                    3     .db 4
   4096 FD                    4     .db 0xFD
   4097 00                    5     .db 0x00
   4098 88                    6     .db 0x88    
   4099 CC CC                 7     .dw 0xCCCC
   0017                      23   DefineStar alive_type, 79, 7,  0xFC, 0x00, 0x88, 0xCCCC
   409B 85                    1     .db alive_type
   409C 4F                    2     .db 79
   409D 07                    3     .db 7
   409E FC                    4     .db 0xFC
   409F 00                    5     .db 0x00
   40A0 88                    6     .db 0x88    
   40A1 CC CC                 7     .dw 0xCCCC
   001F                      24   DefineStar alive_type, 79, 10, 0xFD, 0x00, 0x88, 0xCCCC
   40A3 85                    1     .db alive_type
   40A4 4F                    2     .db 79
   40A5 0A                    3     .db 10
   40A6 FD                    4     .db 0xFD
   40A7 00                    5     .db 0x00
   40A8 88                    6     .db 0x88    
   40A9 CC CC                 7     .dw 0xCCCC
   0027                      25   DefineStar alive_type, 79, 13, 0xFC, 0x00, 0x88, 0xCCCC
   40AB 85                    1     .db alive_type
   40AC 4F                    2     .db 79
   40AD 0D                    3     .db 13
   40AE FC                    4     .db 0xFC
   40AF 00                    5     .db 0x00
   40B0 88                    6     .db 0x88    
   40B1 CC CC                 7     .dw 0xCCCC
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



   002F                      26   DefineStar alive_type, 79, 1,  0xFE, 0x00, 0x88, 0xCCCC
   40B3 85                    1     .db alive_type
   40B4 4F                    2     .db 79
   40B5 01                    3     .db 1
   40B6 FE                    4     .db 0xFE
   40B7 00                    5     .db 0x00
   40B8 88                    6     .db 0x88    
   40B9 CC CC                 7     .dw 0xCCCC
   0037                      27   DefineStar alive_type, 79, 4,  0xFA, 0x00, 0x88, 0xCCCC
   40BB 85                    1     .db alive_type
   40BC 4F                    2     .db 79
   40BD 04                    3     .db 4
   40BE FA                    4     .db 0xFA
   40BF 00                    5     .db 0x00
   40C0 88                    6     .db 0x88    
   40C1 CC CC                 7     .dw 0xCCCC
   003F                      28   DefineStar alive_type, 79, 7,  0xF9, 0x00, 0x88, 0xCCCC
   40C3 85                    1     .db alive_type
   40C4 4F                    2     .db 79
   40C5 07                    3     .db 7
   40C6 F9                    4     .db 0xF9
   40C7 00                    5     .db 0x00
   40C8 88                    6     .db 0x88    
   40C9 CC CC                 7     .dw 0xCCCC
   0047                      29   DefineStar alive_type, 79, 10, 0xFF, 0x00, 0x88, 0xCCCC
   40CB 85                    1     .db alive_type
   40CC 4F                    2     .db 79
   40CD 0A                    3     .db 10
   40CE FF                    4     .db 0xFF
   40CF 00                    5     .db 0x00
   40D0 88                    6     .db 0x88    
   40D1 CC CC                 7     .dw 0xCCCC
   004F                      30   DefineStar alive_type, 79, 13, 0xFE, 0x00, 0x88, 0xCCCC
   40D3 85                    1     .db alive_type
   40D4 4F                    2     .db 79
   40D5 0D                    3     .db 13
   40D6 FE                    4     .db 0xFE
   40D7 00                    5     .db 0x00
   40D8 88                    6     .db 0x88    
   40D9 CC CC                 7     .dw 0xCCCC
                             31 
   0057                      32 default: DefineStar alive_type, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xCCCC
   40DB 85                    1     .db alive_type
   40DC 00                    2     .db 0x00
   40DD 00                    3     .db 0x00
   40DE 00                    4     .db 0x00
   40DF 00                    5     .db 0x00
   40E0 F0                    6     .db 0xF0    
   40E1 CC CC                 7     .dw 0xCCCC
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
   40E3                      45 entityman_create::  
   40E3 01 08 00      [10]   46   ld    bc, #sizeof_e
   40E6 ED B0         [21]   47   ldir
                             48 
   40E8 3A 88 40      [13]   49   ld    a, (_num_entities)
   40EB 3C            [ 4]   50   inc   a
   40EC 32 88 40      [13]   51   ld    (_num_entities), a
                             52 
   40EF 2A 89 40      [16]   53   ld    hl, (_last_elem_ptr)    
   40F2 01 08 00      [10]   54   ld    bc, #sizeof_e
   40F5 09            [11]   55   add   hl, bc
   40F6 22 89 40      [16]   56   ld    (_last_elem_ptr), hl
                             57 
   40F9 C9            [10]   58   ret
                             59 
   40FA                      60 entityman_init::
   40FA 3E 0A         [ 7]   61   ld    a, #max_entities  
   40FC ED 5B 89 40   [20]   62   ld    de, (_last_elem_ptr)
   4100                      63 init_loop:
   4100 F5            [11]   64   push  af
                             65   
   4101 21 DB 40      [10]   66   ld    hl, #default  
   4104 CD E3 40      [17]   67   call  entityman_create
   4107 EB            [ 4]   68   ex    de, hl
                             69   
   4108 F1            [10]   70   pop   af
   4109 3D            [ 4]   71   dec   a
   410A C8            [11]   72   ret   z
   410B 18 F3         [12]   73   jr    init_loop
                             74 
                             75 
   410D                      76 entityman_update::
                             77   ;ld ix, #_entity_array
                             78   ;ld  a, (_num_entities)
                             79 ;
                             80   ;ld  c, e_type(ix)
   410D C9            [10]   81   ret
                             82 ;
                             83 
                             84 ;;
                             85 ;; RETURN: 
                             86 ;;  ix  begin of entity array memory address
                             87 ;;  a   last element pointer (free space)
                             88 ;;
   410E                      89 get_entity_array::
   410E DD 21 8B 40   [14]   90   ld ix, #_entity_array
   4112 3A 88 40      [13]   91   ld  a, (_num_entities)
   4115 C9            [10]   92   ret
