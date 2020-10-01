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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                     0003    55 e_vx = 3
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              6 .include "../sys/render_system.h.s"
                              1 .globl  rendersys_init
                              2 .globl  rendersys_update
                              3 .globl  rendersys_delete_entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                              7 .include "../cpct_functions.h.s"
                              1 
                              2 .globl  cpct_disableFirmware_asm
                              3 .globl  cpct_setVideoMode_asm
                              4 .globl  cpct_getScreenPtr_asm
                              5 .globl  cpct_waitVSYNC_asm
                              6 .globl  cpct_setPALColour_asm
                              7 .globl  cpct_getRandom_mxor_u8_asm
                              8 
                              9 .globl  HW_BLACK
                             10 .globl  HW_WHITE
                             11 
                             12 .globl  CPCT_VMEM_START_ASM
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 
                              9 
                             10 ;;########################################################
                             11 ;;                        VARIABLES                      #             
                             12 ;;########################################################
   0000                      13 DefineStarArray _entity, max_entities, DefineStarDefault
   40A4 00                    1     _entity_num:    .db 0    
   40A5 A7 40                 2     _entity_last:   .dw _entity_array
   40A7                       3     _entity_array: 
                              4     .rept max_entities    
                              5         DefineStarDefault
                              6     .endm
   0003                       1         DefineStarDefault
   40A7 01                    1     .db alive_type
   40A8 40                    2     .db 0x40
   40A9 01                    3     .db 0x01
   40AA FE                    4     .db 0xFE
   40AB FE                    5     .db 0xFE
   40AC FF                    6     .db 0xFF    
   40AD CC CC                 7     .dw 0xCCCC
   000B                       1         DefineStarDefault
   40AF 01                    1     .db alive_type
   40B0 40                    2     .db 0x40
   40B1 01                    3     .db 0x01
   40B2 FE                    4     .db 0xFE
   40B3 FE                    5     .db 0xFE
   40B4 FF                    6     .db 0xFF    
   40B5 CC CC                 7     .dw 0xCCCC
   0013                       1         DefineStarDefault
   40B7 01                    1     .db alive_type
   40B8 40                    2     .db 0x40
   40B9 01                    3     .db 0x01
   40BA FE                    4     .db 0xFE
   40BB FE                    5     .db 0xFE
   40BC FF                    6     .db 0xFF    
   40BD CC CC                 7     .dw 0xCCCC
   001B                       1         DefineStarDefault
   40BF 01                    1     .db alive_type
   40C0 40                    2     .db 0x40
   40C1 01                    3     .db 0x01
   40C2 FE                    4     .db 0xFE
   40C3 FE                    5     .db 0xFE
   40C4 FF                    6     .db 0xFF    
   40C5 CC CC                 7     .dw 0xCCCC
   0023                       1         DefineStarDefault
   40C7 01                    1     .db alive_type
   40C8 40                    2     .db 0x40
   40C9 01                    3     .db 0x01
   40CA FE                    4     .db 0xFE
   40CB FE                    5     .db 0xFE
   40CC FF                    6     .db 0xFF    
   40CD CC CC                 7     .dw 0xCCCC
   002B                       1         DefineStarDefault
   40CF 01                    1     .db alive_type
   40D0 40                    2     .db 0x40
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   40D1 01                    3     .db 0x01
   40D2 FE                    4     .db 0xFE
   40D3 FE                    5     .db 0xFE
   40D4 FF                    6     .db 0xFF    
   40D5 CC CC                 7     .dw 0xCCCC
   0033                       1         DefineStarDefault
   40D7 01                    1     .db alive_type
   40D8 40                    2     .db 0x40
   40D9 01                    3     .db 0x01
   40DA FE                    4     .db 0xFE
   40DB FE                    5     .db 0xFE
   40DC FF                    6     .db 0xFF    
   40DD CC CC                 7     .dw 0xCCCC
   003B                       1         DefineStarDefault
   40DF 01                    1     .db alive_type
   40E0 40                    2     .db 0x40
   40E1 01                    3     .db 0x01
   40E2 FE                    4     .db 0xFE
   40E3 FE                    5     .db 0xFE
   40E4 FF                    6     .db 0xFF    
   40E5 CC CC                 7     .dw 0xCCCC
   0043                       1         DefineStarDefault
   40E7 01                    1     .db alive_type
   40E8 40                    2     .db 0x40
   40E9 01                    3     .db 0x01
   40EA FE                    4     .db 0xFE
   40EB FE                    5     .db 0xFE
   40EC FF                    6     .db 0xFF    
   40ED CC CC                 7     .dw 0xCCCC
   004B                       1         DefineStarDefault
   40EF 01                    1     .db alive_type
   40F0 40                    2     .db 0x40
   40F1 01                    3     .db 0x01
   40F2 FE                    4     .db 0xFE
   40F3 FE                    5     .db 0xFE
   40F4 FF                    6     .db 0xFF    
   40F5 CC CC                 7     .dw 0xCCCC
                             14 
                             15 ;;########################################################
                             16 ;;                   PRIVATE FUNCTIONS                   #             
                             17 ;;########################################################
                             18 
                             19 ;;
                             20 ;;  RETURN
                             21 ;;    hl with memory address of free space for new entity
                             22 ;;    ix with memory address of last created entity
                             23 ;;
   40F7                      24 entityman_new_entity::
   40F7 3A A4 40      [13]   25   ld    a, (_entity_num)
   40FA 3C            [ 4]   26   inc   a
   40FB 32 A4 40      [13]   27   ld    (_entity_num), a
                             28 
   40FE DD 2A A5 40   [20]   29   ld    ix, (_entity_last)    
   4102 2A A5 40      [16]   30   ld    hl, (_entity_last)    
   4105 01 08 00      [10]   31   ld    bc, #sizeof_e
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   4108 09            [11]   32   add   hl, bc
   4109 22 A5 40      [16]   33   ld    (_entity_last), hl
   410C C9            [10]   34   ret
                             35 
                             36 ;;
                             37 ;;  INPUT: 
                             38 ;;    ix with memory address of entity that must be initialized
                             39 ;;
   410D                      40 entityman_initialize_rand::  
   410D 3E 00         [ 7]   41   ld    a, #0
   410F DD 77 04      [19]   42   ld    e_vy(ix), a               ;; set Y velocity  
                             43 
   4112 CD C7 41      [17]   44   call cpct_getRandom_mxor_u8_asm
   4115 7D            [ 4]   45   ld    a, l
   4116 1F            [ 4]   46   rra   
   4117 DD 77 02      [19]   47   ld    e_y(ix), a                ;; set Y coordiante
                             48 
   411A ED 44         [ 8]   49   neg 
   411C DD 36 03 FF   [19]   50   ld    e_vx(ix), #0xFF               ;; set X velocity  
                             51 
   4120 3E 50         [ 7]   52   ld    a, #80                    
   4122 DD 77 01      [19]   53   ld    e_x(ix), a               ;; set X coordinate to the most right possible byte
   4125 C9            [10]   54   ret
                             55 
                             56 ;;########################################################
                             57 ;;                   PUBLIC FUNCTIONS                    #             
                             58 ;;########################################################
                             59 
   4126                      60 entityman_create_one::
   4126 CD F7 40      [17]   61   call  entityman_new_entity
   4129 CD 0D 41      [17]   62   call  entityman_initialize_rand
   412C C9            [10]   63   ret
                             64 
                             65 
   412D                      66 entityman_init::
   412D 3E 0A         [ 7]   67   ld    a, #max_entities
   412F ED 5B A5 40   [20]   68   ld    de, (_entity_last)
   4133                      69 init_loop:
   4133 F5            [11]   70   push  af
                             71   
   4134 CD F7 40      [17]   72   call  entityman_new_entity
   4137 CD 0D 41      [17]   73   call  entityman_initialize_rand
                             74   
   413A F1            [10]   75   pop   af
   413B 3D            [ 4]   76   dec   a
   413C C8            [11]   77   ret   z
   413D 18 F4         [12]   78   jr    init_loop
                             79 
                             80 
   413F                      81 entityman_update::
   413F DD 21 A7 40   [14]   82   ld    ix, #_entity_array
   4143 3A A4 40      [13]   83   ld     a, (_entity_num)
   4146 B7            [ 4]   84   or     a
   4147 C8            [11]   85   ret    z
                             86 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



   4148                      87 entityman_loop:
   4148 F5            [11]   88   push  af
                             89   
   4149 DD 7E 00      [19]   90   ld    a, e_type(ix)         ;; load type of entity
   414C E6 FE         [ 7]   91   and   #dead_type            ;; entity_type AND dead_type
                             92 
   414E 28 2F         [12]   93   jr    z, inc_index
   4150 CD 9A 40      [17]   94   call  rendersys_delete_entity
                             95 
                             96   ;; _last_element_ptr now points to the last entity in the array
                             97   ;; si A 02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   4153 3A A5 40      [13]   98   ld    a, (_entity_last)
   4156 D6 08         [ 7]   99   sub   #sizeof_e
   4158 32 A5 40      [13]  100   ld    (_entity_last), a
   415B DA 61 41      [10]  101   jp    c, overflow
   415E C3 68 41      [10]  102   jp    no_overflow    
                            103   
   4161                     104 overflow:
   4161 3A A6 40      [13]  105   ld    a, (_entity_last+1)
   4164 3D            [ 4]  106   dec   a
   4165 32 A6 40      [13]  107   ld    (_entity_last+1), a
                            108 
   4168                     109 no_overflow:
                            110   ;; move the last element to the hole left by the dead entity
   4168 DD E5         [15]  111   push  ix  
   416A E1            [10]  112   pop   hl
   416B 01 08 00      [10]  113   ld    bc, #sizeof_e       
   416E ED 5B A5 40   [20]  114   ld    de, (_entity_last)
   4172 EB            [ 4]  115   ex    de, hl
   4173 ED B0         [21]  116   ldir                        
                            117   
   4175 3A A4 40      [13]  118   ld    a, (_entity_num)
   4178 3D            [ 4]  119   dec   a
   4179 32 A4 40      [13]  120   ld    (_entity_num), a  
                            121 
   417C C3 84 41      [10]  122   jp    continue_update
                            123 
   417F                     124 inc_index:
   417F 01 08 00      [10]  125   ld    bc, #sizeof_e
   4182 DD 09         [15]  126   add   ix, bc
   4184                     127 continue_update:
   4184 F1            [10]  128   pop   af
   4185 3D            [ 4]  129   dec   a
   4186 C8            [11]  130   ret   z
   4187 C3 48 41      [10]  131   jp    entityman_loop
                            132 ;
                            133 
                            134 ;;
                            135 ;; RETURN: 
                            136 ;;  ix  begin of entity array memory address
                            137 ;;  a   number of valid and alive entities
                            138 ;;
   418A                     139 get_entity_array::
   418A DD 21 A7 40   [14]  140   ld ix, #_entity_array
   418E 3A A4 40      [13]  141   ld  a, (_entity_num)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



   4191 C9            [10]  142   ret
                            143 
                            144 
                            145 ;;
                            146 ;;  INPUT: 
                            147 ;;    ix with memory address of entity that must me marked as dead
                            148 ;;
   4192                     149 entityman_set_dead::
   4192 3E FE         [ 7]  150   ld  a, #dead_type
   4194 DD 77 00      [19]  151   ld  e_type(ix), a
   4197 C9            [10]  152   ret
