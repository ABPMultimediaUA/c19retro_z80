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
                             47     .db invalid_type
                             48 .endm
                             49 
                             50 ;;########################################################
                             51 ;;                       CONSTANTS                       #             
                             52 ;;########################################################
                     0000    53 e_type = 0
                     0001    54 e_x = 1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                     0002    55 e_y = 2
                     0003    56 e_vx = 3
                     0004    57 e_vy = 4
                     0005    58 e_color = 5
                     0006    59 e_last_ptr_1 = 6
                     0007    60 e_last_ptr_2 = 7
                     0008    61 sizeof_e = 8
                     000A    62 max_entities = 10
                             63 
                             64 ;;########################################################
                             65 ;;                      ENTITY TYPES                     #             
                             66 ;;########################################################
                     0000    67 empty_type = 0x00
                     0001    68 alive_type = 0x01
                     00FE    69 dead_type = 0xFE
                     00FF    70 invalid_type = 0xFF
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
   4098 00                    1     _entity_num:    .db 0    
   4099 9B 40                 2     _entity_last:   .dw _entity_array
   409B                       3     _entity_array: 
                              4     .rept max_entities    
                              5         DefineStarDefault
                              6     .endm
   0003                       1         DefineStarDefault
   409B 01                    1     .db alive_type
   409C 40                    2     .db 0x40
   409D 01                    3     .db 0x01
   409E FE                    4     .db 0xFE
   409F FE                    5     .db 0xFE
   40A0 FF                    6     .db 0xFF    
   40A1 CC CC                 7     .dw 0xCCCC
   000B                       1         DefineStarDefault
   40A3 01                    1     .db alive_type
   40A4 40                    2     .db 0x40
   40A5 01                    3     .db 0x01
   40A6 FE                    4     .db 0xFE
   40A7 FE                    5     .db 0xFE
   40A8 FF                    6     .db 0xFF    
   40A9 CC CC                 7     .dw 0xCCCC
   0013                       1         DefineStarDefault
   40AB 01                    1     .db alive_type
   40AC 40                    2     .db 0x40
   40AD 01                    3     .db 0x01
   40AE FE                    4     .db 0xFE
   40AF FE                    5     .db 0xFE
   40B0 FF                    6     .db 0xFF    
   40B1 CC CC                 7     .dw 0xCCCC
   001B                       1         DefineStarDefault
   40B3 01                    1     .db alive_type
   40B4 40                    2     .db 0x40
   40B5 01                    3     .db 0x01
   40B6 FE                    4     .db 0xFE
   40B7 FE                    5     .db 0xFE
   40B8 FF                    6     .db 0xFF    
   40B9 CC CC                 7     .dw 0xCCCC
   0023                       1         DefineStarDefault
   40BB 01                    1     .db alive_type
   40BC 40                    2     .db 0x40
   40BD 01                    3     .db 0x01
   40BE FE                    4     .db 0xFE
   40BF FE                    5     .db 0xFE
   40C0 FF                    6     .db 0xFF    
   40C1 CC CC                 7     .dw 0xCCCC
   002B                       1         DefineStarDefault
   40C3 01                    1     .db alive_type
   40C4 40                    2     .db 0x40
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   40C5 01                    3     .db 0x01
   40C6 FE                    4     .db 0xFE
   40C7 FE                    5     .db 0xFE
   40C8 FF                    6     .db 0xFF    
   40C9 CC CC                 7     .dw 0xCCCC
   0033                       1         DefineStarDefault
   40CB 01                    1     .db alive_type
   40CC 40                    2     .db 0x40
   40CD 01                    3     .db 0x01
   40CE FE                    4     .db 0xFE
   40CF FE                    5     .db 0xFE
   40D0 FF                    6     .db 0xFF    
   40D1 CC CC                 7     .dw 0xCCCC
   003B                       1         DefineStarDefault
   40D3 01                    1     .db alive_type
   40D4 40                    2     .db 0x40
   40D5 01                    3     .db 0x01
   40D6 FE                    4     .db 0xFE
   40D7 FE                    5     .db 0xFE
   40D8 FF                    6     .db 0xFF    
   40D9 CC CC                 7     .dw 0xCCCC
   0043                       1         DefineStarDefault
   40DB 01                    1     .db alive_type
   40DC 40                    2     .db 0x40
   40DD 01                    3     .db 0x01
   40DE FE                    4     .db 0xFE
   40DF FE                    5     .db 0xFE
   40E0 FF                    6     .db 0xFF    
   40E1 CC CC                 7     .dw 0xCCCC
   004B                       1         DefineStarDefault
   40E3 01                    1     .db alive_type
   40E4 40                    2     .db 0x40
   40E5 01                    3     .db 0x01
   40E6 FE                    4     .db 0xFE
   40E7 FE                    5     .db 0xFE
   40E8 FF                    6     .db 0xFF    
   40E9 CC CC                 7     .dw 0xCCCC
   40EB FF                    7     .db invalid_type
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
   40EC                      24 entityman_new_entity::
   40EC 3A 98 40      [13]   25   ld    a, (_entity_num)
   40EF 3C            [ 4]   26   inc   a
   40F0 32 98 40      [13]   27   ld    (_entity_num), a
                             28 
   40F3 DD 2A 99 40   [20]   29   ld    ix, (_entity_last)    
   40F7 2A 99 40      [16]   30   ld    hl, (_entity_last)    
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   40FA 01 08 00      [10]   31   ld    bc, #sizeof_e
   40FD 09            [11]   32   add   hl, bc
   40FE 22 99 40      [16]   33   ld    (_entity_last), hl
   4101 C9            [10]   34   ret
                             35 
                             36 ;;
                             37 ;;  INPUT: 
                             38 ;;    ix with memory address of entity that must be initialized
                             39 ;;
   4102                      40 entityman_initialize_rand::  
   4102 DD 36 00 01   [19]   41   ld    e_type(ix), #alive_type    ;; set Y velocity  
                             42 
   4106 3E 00         [ 7]   43   ld    a, #0
   4108 DD 77 04      [19]   44   ld    e_vy(ix), a               ;; set Y velocity  
                             45 
   410B CD C7 41      [17]   46   call cpct_getRandom_mxor_u8_asm
   410E 7D            [ 4]   47   ld    a, l
   410F 1F            [ 4]   48   rra   
   4110 DD 77 02      [19]   49   ld    e_y(ix), a                ;; set Y coordiante
                             50 
   4113 ED 44         [ 8]   51   neg 
   4115 DD 36 03 FF   [19]   52   ld    e_vx(ix), #0xFF               ;; set X velocity  
                             53 
   4119 3E 50         [ 7]   54   ld    a, #0x50                   
   411B DD 77 01      [19]   55   ld    e_x(ix), a               ;; set X coordinate to the most right possible byte
   411E C9            [10]   56   ret
                             57 
                             58 ;;########################################################
                             59 ;;                   PUBLIC FUNCTIONS                    #             
                             60 ;;########################################################
                             61 
   411F                      62 entityman_create_one::  
   411F 3E FF         [ 7]   63   ld    a, #invalid_type
   4121 2A 99 40      [16]   64   ld    hl, (_entity_last)
   4124 BE            [ 7]   65   cp   (hl)                  ;; last entity type - invalid_type 
   4125 C8            [11]   66   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                             67 
   4126 CD EC 40      [17]   68   call  entityman_new_entity
   4129 CD 02 41      [17]   69   call  entityman_initialize_rand
   412C C9            [10]   70   ret
                             71 
                             72 
   412D                      73 entityman_init::
   412D 3E 0A         [ 7]   74   ld    a, #max_entities
   412F ED 5B 99 40   [20]   75   ld    de, (_entity_last)
   4133                      76 init_loop:
   4133 F5            [11]   77   push  af
                             78   
   4134 CD EC 40      [17]   79   call  entityman_new_entity
   4137 CD 02 41      [17]   80   call  entityman_initialize_rand
                             81   
   413A F1            [10]   82   pop   af
   413B 3D            [ 4]   83   dec   a
   413C C8            [11]   84   ret   z
   413D 18 F4         [12]   85   jr    init_loop
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                             86 
                             87 
   413F                      88 entityman_update::
   413F DD 21 9B 40   [14]   89   ld    ix, #_entity_array
   4143 3A 98 40      [13]   90   ld     a, (_entity_num)
   4146 B7            [ 4]   91   or     a
   4147 C8            [11]   92   ret    z
                             93 
   4148                      94 entityman_loop:
   4148 F5            [11]   95   push  af
                             96   
   4149 DD 7E 00      [19]   97   ld    a, e_type(ix)         ;; load type of entity
   414C E6 FE         [ 7]   98   and   #dead_type            ;; entity_type AND dead_type
                             99 
   414E 28 2F         [12]  100   jr    z, inc_index
   4150 CD 8E 40      [17]  101   call  rendersys_delete_entity
                            102 
                            103   ;; _last_element_ptr now points to the last entity in the array
                            104   ;; si A 02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   4153 3A 99 40      [13]  105   ld    a, (_entity_last)
   4156 D6 08         [ 7]  106   sub   #sizeof_e
   4158 32 99 40      [13]  107   ld    (_entity_last), a
   415B DA 61 41      [10]  108   jp    c, overflow
   415E C3 68 41      [10]  109   jp    no_overflow    
                            110   
   4161                     111 overflow:
   4161 3A 9A 40      [13]  112   ld    a, (_entity_last+1)
   4164 3D            [ 4]  113   dec   a
   4165 32 9A 40      [13]  114   ld    (_entity_last+1), a
                            115 
   4168                     116 no_overflow:
                            117   ;; move the last element to the hole left by the dead entity
   4168 DD E5         [15]  118   push  ix  
   416A E1            [10]  119   pop   hl
   416B 01 08 00      [10]  120   ld    bc, #sizeof_e       
   416E ED 5B 99 40   [20]  121   ld    de, (_entity_last)
   4172 EB            [ 4]  122   ex    de, hl
   4173 ED B0         [21]  123   ldir                        
                            124   
   4175 3A 98 40      [13]  125   ld    a, (_entity_num)
   4178 3D            [ 4]  126   dec   a
   4179 32 98 40      [13]  127   ld    (_entity_num), a  
                            128 
   417C C3 84 41      [10]  129   jp    continue_update
                            130 
   417F                     131 inc_index:
   417F 01 08 00      [10]  132   ld    bc, #sizeof_e
   4182 DD 09         [15]  133   add   ix, bc
   4184                     134 continue_update:
   4184 F1            [10]  135   pop   af
   4185 3D            [ 4]  136   dec   a
   4186 C8            [11]  137   ret   z
   4187 C3 48 41      [10]  138   jp    entityman_loop
                            139 ;
                            140 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



                            141 ;;
                            142 ;; RETURN: 
                            143 ;;  ix  begin of entity array memory address
                            144 ;;  a   number of valid and alive entities
                            145 ;;
   418A                     146 get_entity_array::
   418A DD 21 9B 40   [14]  147   ld ix, #_entity_array
   418E 3A 98 40      [13]  148   ld  a, (_entity_num)
   4191 C9            [10]  149   ret
                            150 
                            151 
                            152 ;;
                            153 ;;  INPUT: 
                            154 ;;    ix with memory address of entity that must me marked as dead
                            155 ;;
   4192                     156 entityman_set_dead::
   4192 3E FE         [ 7]  157   ld  a, #dead_type
   4194 DD 77 00      [19]  158   ld  e_type(ix), a
   4197 C9            [10]  159   ret
