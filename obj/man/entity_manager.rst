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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              6 .include "../sys/render_system.h.s"
                              1 .globl  rendersys_init
                              2 .globl  rendersys_update
                              3 .globl  rendersys_delete_entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              7 
                              8 
                              9 ;;########################################################
                             10 ;;                        VARIABLES                      #             
                             11 ;;########################################################
                             12 
                     0000    13 empty_type = 0x00
                     0001    14 alive_type = 0x01
                     00FE    15 dead_type = 0xFE
                     00FF    16 invalid_type = 0xFF
                             17 
   40A5 0A                   18 _num_entities: .db 0x0A
   40A6 F8 40                19 _last_elem_ptr: .dw max_entities*sizeof_e+_entity_array
   40A8                      20 _entity_array:
                             21   ;.ds max_entities*sizeof_e
   0003                      22   DefineStar alive_type, 79, 1,  0xFF, 0x00, 0x80, 0xCCCC
   40A8 01                    1     .db alive_type
   40A9 4F                    2     .db 79
   40AA 01                    3     .db 1
   40AB FF                    4     .db 0xFF
   40AC 00                    5     .db 0x00
   40AD 80                    6     .db 0x80    
   40AE CC CC                 7     .dw 0xCCCC
   000B                      23   DefineStar alive_type, 79, 3,  0xFE, 0x00, 0x08, 0xCCCC
   40B0 01                    1     .db alive_type
   40B1 4F                    2     .db 79
   40B2 03                    3     .db 3
   40B3 FE                    4     .db 0xFE
   40B4 00                    5     .db 0x00
   40B5 08                    6     .db 0x08    
   40B6 CC CC                 7     .dw 0xCCCC
   0013                      24   DefineStar alive_type, 79, 5,  0xFD, 0x00, 0x88, 0xCCCC
   40B8 01                    1     .db alive_type
   40B9 4F                    2     .db 79
   40BA 05                    3     .db 5
   40BB FD                    4     .db 0xFD
   40BC 00                    5     .db 0x00
   40BD 88                    6     .db 0x88    
   40BE CC CC                 7     .dw 0xCCCC
   001B                      25   DefineStar alive_type, 79, 7, 0xFE, 0x00, 0x30, 0xCCCC
   40C0 01                    1     .db alive_type
   40C1 4F                    2     .db 79
   40C2 07                    3     .db 7
   40C3 FE                    4     .db 0xFE
   40C4 00                    5     .db 0x00
   40C5 30                    6     .db 0x30    
   40C6 CC CC                 7     .dw 0xCCCC
   0023                      26   DefineStar alive_type, 79, 9, 0xFD, 0x00, 0x03, 0xCCCC
   40C8 01                    1     .db alive_type
   40C9 4F                    2     .db 79
   40CA 09                    3     .db 9
   40CB FD                    4     .db 0xFD
   40CC 00                    5     .db 0x00
   40CD 03                    6     .db 0x03    
   40CE CC CC                 7     .dw 0xCCCC
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   002B                      27   DefineStar alive_type, 79, 11,  0xFF, 0x00, 0x33, 0xCCCC
   40D0 01                    1     .db alive_type
   40D1 4F                    2     .db 79
   40D2 0B                    3     .db 11
   40D3 FF                    4     .db 0xFF
   40D4 00                    5     .db 0x00
   40D5 33                    6     .db 0x33    
   40D6 CC CC                 7     .dw 0xCCCC
   0033                      28   DefineStar alive_type, 79, 13,  0xFB, 0x00, 0x70, 0xCCCC
   40D8 01                    1     .db alive_type
   40D9 4F                    2     .db 79
   40DA 0D                    3     .db 13
   40DB FB                    4     .db 0xFB
   40DC 00                    5     .db 0x00
   40DD 70                    6     .db 0x70    
   40DE CC CC                 7     .dw 0xCCCC
   003B                      29   DefineStar alive_type, 79, 15,  0xFA, 0x00, 0x07, 0xCCCC
   40E0 01                    1     .db alive_type
   40E1 4F                    2     .db 79
   40E2 0F                    3     .db 15
   40E3 FA                    4     .db 0xFA
   40E4 00                    5     .db 0x00
   40E5 07                    6     .db 0x07    
   40E6 CC CC                 7     .dw 0xCCCC
   0043                      30   DefineStar alive_type, 79, 17, 0xFF, 0x00, 0x77, 0xCCCC
   40E8 01                    1     .db alive_type
   40E9 4F                    2     .db 79
   40EA 11                    3     .db 17
   40EB FF                    4     .db 0xFF
   40EC 00                    5     .db 0x00
   40ED 77                    6     .db 0x77    
   40EE CC CC                 7     .dw 0xCCCC
   004B                      31   DefineStar alive_type, 79, 19, 0xFF, 0x00, 0xF0, 0xCCCC
   40F0 01                    1     .db alive_type
   40F1 4F                    2     .db 79
   40F2 13                    3     .db 19
   40F3 FF                    4     .db 0xFF
   40F4 00                    5     .db 0x00
   40F5 F0                    6     .db 0xF0    
   40F6 CC CC                 7     .dw 0xCCCC
   40F8 00                   32   .db empty_type
                             33 
   0054                      34 default: DefineStar alive_type, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xCCCC
   40F9 01                    1     .db alive_type
   40FA 00                    2     .db 0x00
   40FB 00                    3     .db 0x00
   40FC 00                    4     .db 0x00
   40FD 00                    5     .db 0x00
   40FE F0                    6     .db 0xF0    
   40FF CC CC                 7     .dw 0xCCCC
                             35 
                             36 ;;########################################################
                             37 ;;                   PUBLIC FUNCTIONS                    #             
                             38 ;;########################################################
                             39 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                             40 ;;
                             41 ;;  INPUT: 
                             42 ;;    hl with memory address of default entity
                             43 ;;    de with memory address of free space for new entity
                             44 ;;  RETURN
                             45 ;;    hl with memory address of free space for new entity
                             46 ;;
   4101                      47 entityman_create::  
   4101 01 08 00      [10]   48   ld    bc, #sizeof_e
   4104 ED B0         [21]   49   ldir
                             50 
   4106 3A A5 40      [13]   51   ld    a, (_num_entities)
   4109 3C            [ 4]   52   inc   a
   410A 32 A5 40      [13]   53   ld    (_num_entities), a
                             54 
   410D 2A A6 40      [16]   55   ld    hl, (_last_elem_ptr)    
   4110 01 08 00      [10]   56   ld    bc, #sizeof_e
   4113 09            [11]   57   add   hl, bc
   4114 22 A6 40      [16]   58   ld    (_last_elem_ptr), hl
                             59 
   4117 C9            [10]   60   ret
                             61 
   4118                      62 entityman_init::
   4118 3E 0A         [ 7]   63   ld    a, #max_entities  
   411A ED 5B A6 40   [20]   64   ld    de, (_last_elem_ptr)
   411E                      65 init_loop:
   411E F5            [11]   66   push  af
                             67   
   411F 21 F9 40      [10]   68   ld    hl, #default  
   4122 CD 01 41      [17]   69   call  entityman_create
   4125 EB            [ 4]   70   ex    de, hl
                             71   
   4126 F1            [10]   72   pop   af
   4127 3D            [ 4]   73   dec   a
   4128 C8            [11]   74   ret   z
   4129 18 F3         [12]   75   jr    init_loop
                             76 
                             77 
   412B                      78 entityman_update::
   412B DD 21 A8 40   [14]   79   ld    ix, #_entity_array
   412F 3A A5 40      [13]   80   ld     a, (_num_entities)
   4132 B7            [ 4]   81   or     a
   4133 C8            [11]   82   ret    z
                             83 
   4134                      84 entityman_loop:
   4134 F5            [11]   85   push  af
                             86   
   4135 DD 7E 00      [19]   87   ld    a, e_type(ix)         ;; load type of entity
   4138 E6 FE         [ 7]   88   and   #dead_type            ;; entity_type AND dead_type
                             89 
   413A 28 2F         [12]   90   jr    z, inc_index
   413C CD 9B 40      [17]   91   call  rendersys_delete_entity
                             92 
                             93   ;; _last_element_ptr now points to the last entity in the array
                             94   ;; si A 02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   413F 3A A6 40      [13]   95   ld    a, (_last_elem_ptr)
   4142 D6 08         [ 7]   96   sub   #sizeof_e
   4144 32 A6 40      [13]   97   ld    (_last_elem_ptr), a
   4147 DA 4D 41      [10]   98   jp    c, overflow
   414A C3 54 41      [10]   99   jp    no_overflow    
                            100   
   414D                     101 overflow:
   414D 3A A7 40      [13]  102   ld    a, (_last_elem_ptr+1)
   4150 3D            [ 4]  103   dec   a
   4151 32 A7 40      [13]  104   ld    (_last_elem_ptr+1), a
                            105 
   4154                     106 no_overflow:
                            107   ;; move the last element to the hole left by the dead entity
   4154 DD E5         [15]  108   push  ix  
   4156 E1            [10]  109   pop   hl
   4157 01 08 00      [10]  110   ld    bc, #sizeof_e       
   415A ED 5B A6 40   [20]  111   ld    de, (_last_elem_ptr)
   415E EB            [ 4]  112   ex    de, hl
   415F ED B0         [21]  113   ldir                        
                            114   
   4161 3A A5 40      [13]  115   ld    a, (_num_entities)
   4164 3D            [ 4]  116   dec   a
   4165 32 A5 40      [13]  117   ld    (_num_entities), a  
                            118 
   4168 C3 70 41      [10]  119   jp    continue_update
                            120 
   416B                     121 inc_index:
   416B 01 08 00      [10]  122   ld    bc, #sizeof_e
   416E DD 09         [15]  123   add   ix, bc
   4170                     124 continue_update:
   4170 F1            [10]  125   pop   af
   4171 3D            [ 4]  126   dec   a
   4172 C8            [11]  127   ret   z
   4173 C3 34 41      [10]  128   jp    entityman_loop
                            129 ;
                            130 
                            131 ;;
                            132 ;; RETURN: 
                            133 ;;  ix  begin of entity array memory address
                            134 ;;  a   number of valid and alive entities
                            135 ;;
   4176                     136 get_entity_array::
   4176 DD 21 A8 40   [14]  137   ld ix, #_entity_array
   417A 3A A5 40      [13]  138   ld  a, (_num_entities)
   417D C9            [10]  139   ret
                            140 
                            141 
                            142 ;;
                            143 ;;  INPUT: 
                            144 ;;    ix with memory address of entity that must me marked as dead
                            145 ;;
   417E                     146 entityman_set_dead::
   417E 3E FE         [ 7]  147   ld  a, #dead_type
   4180 DD 77 00      [19]  148   ld  e_type(ix), a
   4183 C9            [10]  149   ret
