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
   40AF 0A                   18 _num_entities: .db 0x0A
   40B0 02 41                19 _last_elem_ptr: .dw max_entities*sizeof_e+_entity_array
   40B2                      20 _entity_array:
                             21   ;.ds max_entities*sizeof_e
   0003                      22   DefineStar alive_type, 79, 1,  0xFE, 0x00, 0x80, 0xCCCC
   40B2 01                    1     .db alive_type
   40B3 4F                    2     .db 79
   40B4 01                    3     .db 1
   40B5 FE                    4     .db 0xFE
   40B6 00                    5     .db 0x00
   40B7 80                    6     .db 0x80    
   40B8 CC CC                 7     .dw 0xCCCC
   000B                      23   DefineStar alive_type, 79, 3,  0xFD, 0x00, 0x08, 0xCCCC
   40BA 01                    1     .db alive_type
   40BB 4F                    2     .db 79
   40BC 03                    3     .db 3
   40BD FD                    4     .db 0xFD
   40BE 00                    5     .db 0x00
   40BF 08                    6     .db 0x08    
   40C0 CC CC                 7     .dw 0xCCCC
   0013                      24   DefineStar alive_type, 79, 5,  0xFC, 0x00, 0x88, 0xCCCC
   40C2 01                    1     .db alive_type
   40C3 4F                    2     .db 79
   40C4 05                    3     .db 5
   40C5 FC                    4     .db 0xFC
   40C6 00                    5     .db 0x00
   40C7 88                    6     .db 0x88    
   40C8 CC CC                 7     .dw 0xCCCC
   001B                      25   DefineStar alive_type, 79, 7, 0xFD, 0x00, 0x30, 0xCCCC
   40CA 01                    1     .db alive_type
   40CB 4F                    2     .db 79
   40CC 07                    3     .db 7
   40CD FD                    4     .db 0xFD
   40CE 00                    5     .db 0x00
   40CF 30                    6     .db 0x30    
   40D0 CC CC                 7     .dw 0xCCCC
   0023                      26   DefineStar alive_type, 79, 9, 0xFC, 0x00, 0x03, 0xCCCC
   40D2 01                    1     .db alive_type
   40D3 4F                    2     .db 79
   40D4 09                    3     .db 9
   40D5 FC                    4     .db 0xFC
   40D6 00                    5     .db 0x00
   40D7 03                    6     .db 0x03    
   40D8 CC CC                 7     .dw 0xCCCC
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   002B                      27   DefineStar alive_type, 79, 11,  0xFE, 0x00, 0x33, 0xCCCC
   40DA 01                    1     .db alive_type
   40DB 4F                    2     .db 79
   40DC 0B                    3     .db 11
   40DD FE                    4     .db 0xFE
   40DE 00                    5     .db 0x00
   40DF 33                    6     .db 0x33    
   40E0 CC CC                 7     .dw 0xCCCC
   0033                      28   DefineStar alive_type, 79, 13,  0xFA, 0x00, 0x70, 0xCCCC
   40E2 01                    1     .db alive_type
   40E3 4F                    2     .db 79
   40E4 0D                    3     .db 13
   40E5 FA                    4     .db 0xFA
   40E6 00                    5     .db 0x00
   40E7 70                    6     .db 0x70    
   40E8 CC CC                 7     .dw 0xCCCC
   003B                      29   DefineStar alive_type, 79, 15,  0xF9, 0x00, 0x07, 0xCCCC
   40EA 01                    1     .db alive_type
   40EB 4F                    2     .db 79
   40EC 0F                    3     .db 15
   40ED F9                    4     .db 0xF9
   40EE 00                    5     .db 0x00
   40EF 07                    6     .db 0x07    
   40F0 CC CC                 7     .dw 0xCCCC
   0043                      30   DefineStar alive_type, 79, 17, 0xFF, 0x00, 0x77, 0xCCCC
   40F2 01                    1     .db alive_type
   40F3 4F                    2     .db 79
   40F4 11                    3     .db 17
   40F5 FF                    4     .db 0xFF
   40F6 00                    5     .db 0x00
   40F7 77                    6     .db 0x77    
   40F8 CC CC                 7     .dw 0xCCCC
   004B                      31   DefineStar alive_type, 79, 19, 0xFE, 0x00, 0xF0, 0xCCCC
   40FA 01                    1     .db alive_type
   40FB 4F                    2     .db 79
   40FC 13                    3     .db 19
   40FD FE                    4     .db 0xFE
   40FE 00                    5     .db 0x00
   40FF F0                    6     .db 0xF0    
   4100 CC CC                 7     .dw 0xCCCC
   4102 00                   32   .db empty_type
                             33 
   0054                      34 default: DefineStar alive_type, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xCCCC
   4103 01                    1     .db alive_type
   4104 00                    2     .db 0x00
   4105 00                    3     .db 0x00
   4106 00                    4     .db 0x00
   4107 00                    5     .db 0x00
   4108 F0                    6     .db 0xF0    
   4109 CC CC                 7     .dw 0xCCCC
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
   410B                      47 entityman_create::  
   410B 01 08 00      [10]   48   ld    bc, #sizeof_e
   410E ED B0         [21]   49   ldir
                             50 
   4110 3A AF 40      [13]   51   ld    a, (_num_entities)
   4113 3C            [ 4]   52   inc   a
   4114 32 AF 40      [13]   53   ld    (_num_entities), a
                             54 
   4117 2A B0 40      [16]   55   ld    hl, (_last_elem_ptr)    
   411A 01 08 00      [10]   56   ld    bc, #sizeof_e
   411D 09            [11]   57   add   hl, bc
   411E 22 B0 40      [16]   58   ld    (_last_elem_ptr), hl
                             59 
   4121 C9            [10]   60   ret
                             61 
   4122                      62 entityman_init::
   4122 3E 0A         [ 7]   63   ld    a, #max_entities  
   4124 ED 5B B0 40   [20]   64   ld    de, (_last_elem_ptr)
   4128                      65 init_loop:
   4128 F5            [11]   66   push  af
                             67   
   4129 21 03 41      [10]   68   ld    hl, #default  
   412C CD 0B 41      [17]   69   call  entityman_create
   412F EB            [ 4]   70   ex    de, hl
                             71   
   4130 F1            [10]   72   pop   af
   4131 3D            [ 4]   73   dec   a
   4132 C8            [11]   74   ret   z
   4133 18 F3         [12]   75   jr    init_loop
                             76 
                             77 
   4135                      78 entityman_update::
   4135 DD 21 B2 40   [14]   79   ld    ix, #_entity_array
   4139 3A AF 40      [13]   80   ld     a, (_num_entities)
   413C B7            [ 4]   81   or     a
   413D C8            [11]   82   ret    z
                             83 
   413E                      84 entityman_loop:
   413E F5            [11]   85   push  af
                             86   
   413F DD 7E 00      [19]   87   ld    a, e_type(ix)         ;; load type of entity
   4142 E6 FE         [ 7]   88   and   #dead_type            ;; entity_type AND dead_type
                             89 
   4144 28 2F         [12]   90   jr    z, inc_index
   4146 CD A5 40      [17]   91   call  rendersys_delete_entity
                             92 
                             93   ;; _last_element_ptr now points to the last entity in the array
                             94   ;; si A 02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   4149 3A B0 40      [13]   95   ld    a, (_last_elem_ptr)
   414C D6 08         [ 7]   96   sub   #sizeof_e
   414E 32 B0 40      [13]   97   ld    (_last_elem_ptr), a
   4151 DA 57 41      [10]   98   jp    c, overflow
   4154 C3 5E 41      [10]   99   jp    no_overflow    
                            100   
   4157                     101 overflow:
   4157 3A B1 40      [13]  102   ld    a, (_last_elem_ptr+1)
   415A 3D            [ 4]  103   dec   a
   415B 32 B1 40      [13]  104   ld    (_last_elem_ptr+1), a
                            105 
   415E                     106 no_overflow:
                            107   ;; move the last element to the hole left by the dead entity
   415E DD E5         [15]  108   push  ix  
   4160 E1            [10]  109   pop   hl
   4161 01 08 00      [10]  110   ld    bc, #sizeof_e       
   4164 ED 5B B0 40   [20]  111   ld    de, (_last_elem_ptr)
   4168 EB            [ 4]  112   ex    de, hl
   4169 ED B0         [21]  113   ldir                        
                            114   
   416B 3A AF 40      [13]  115   ld    a, (_num_entities)
   416E 3D            [ 4]  116   dec   a
   416F 32 AF 40      [13]  117   ld    (_num_entities), a  
                            118 
   4172 C3 7A 41      [10]  119   jp    continue_update
                            120 
   4175                     121 inc_index:
   4175 01 08 00      [10]  122   ld    bc, #sizeof_e
   4178 DD 09         [15]  123   add   ix, bc
   417A                     124 continue_update:
   417A F1            [10]  125   pop   af
   417B 3D            [ 4]  126   dec   a
   417C C8            [11]  127   ret   z
   417D C3 3E 41      [10]  128   jp    entityman_loop
                            129 ;
                            130 
                            131 ;;
                            132 ;; RETURN: 
                            133 ;;  ix  begin of entity array memory address
                            134 ;;  a   number of valid and alive entities
                            135 ;;
   4180                     136 get_entity_array::
   4180 DD 21 B2 40   [14]  137   ld ix, #_entity_array
   4184 3A AF 40      [13]  138   ld  a, (_num_entities)
   4187 C9            [10]  139   ret
                            140 
                            141 
                            142 ;;
                            143 ;;  INPUT: 
                            144 ;;    ix with memory address of entity that must me marked as dead
                            145 ;;
   4188                     146 entityman_set_dead::
   4188 3E FE         [ 7]  147   ld  a, #dead_type
   418A DD 77 00      [19]  148   ld  e_type(ix), a
   418D C9            [10]  149   ret
