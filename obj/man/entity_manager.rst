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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                     0007    55 e_last_ptr_2 = 7
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
   409C DE                    2     .db 0xDE
   409D AD                    3     .db 0xAD
   409E DE                    4     .db 0xDE
   409F AD                    5     .db 0xAD
   40A0 80                    6     .db 0x80    
   40A1 CC CC                 7     .dw 0xCCCC
   000B                       1         DefineStarDefault
   40A3 01                    1     .db alive_type
   40A4 DE                    2     .db 0xDE
   40A5 AD                    3     .db 0xAD
   40A6 DE                    4     .db 0xDE
   40A7 AD                    5     .db 0xAD
   40A8 80                    6     .db 0x80    
   40A9 CC CC                 7     .dw 0xCCCC
   0013                       1         DefineStarDefault
   40AB 01                    1     .db alive_type
   40AC DE                    2     .db 0xDE
   40AD AD                    3     .db 0xAD
   40AE DE                    4     .db 0xDE
   40AF AD                    5     .db 0xAD
   40B0 80                    6     .db 0x80    
   40B1 CC CC                 7     .dw 0xCCCC
   001B                       1         DefineStarDefault
   40B3 01                    1     .db alive_type
   40B4 DE                    2     .db 0xDE
   40B5 AD                    3     .db 0xAD
   40B6 DE                    4     .db 0xDE
   40B7 AD                    5     .db 0xAD
   40B8 80                    6     .db 0x80    
   40B9 CC CC                 7     .dw 0xCCCC
   0023                       1         DefineStarDefault
   40BB 01                    1     .db alive_type
   40BC DE                    2     .db 0xDE
   40BD AD                    3     .db 0xAD
   40BE DE                    4     .db 0xDE
   40BF AD                    5     .db 0xAD
   40C0 80                    6     .db 0x80    
   40C1 CC CC                 7     .dw 0xCCCC
   002B                       1         DefineStarDefault
   40C3 01                    1     .db alive_type
   40C4 DE                    2     .db 0xDE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   40C5 AD                    3     .db 0xAD
   40C6 DE                    4     .db 0xDE
   40C7 AD                    5     .db 0xAD
   40C8 80                    6     .db 0x80    
   40C9 CC CC                 7     .dw 0xCCCC
   0033                       1         DefineStarDefault
   40CB 01                    1     .db alive_type
   40CC DE                    2     .db 0xDE
   40CD AD                    3     .db 0xAD
   40CE DE                    4     .db 0xDE
   40CF AD                    5     .db 0xAD
   40D0 80                    6     .db 0x80    
   40D1 CC CC                 7     .dw 0xCCCC
   003B                       1         DefineStarDefault
   40D3 01                    1     .db alive_type
   40D4 DE                    2     .db 0xDE
   40D5 AD                    3     .db 0xAD
   40D6 DE                    4     .db 0xDE
   40D7 AD                    5     .db 0xAD
   40D8 80                    6     .db 0x80    
   40D9 CC CC                 7     .dw 0xCCCC
   0043                       1         DefineStarDefault
   40DB 01                    1     .db alive_type
   40DC DE                    2     .db 0xDE
   40DD AD                    3     .db 0xAD
   40DE DE                    4     .db 0xDE
   40DF AD                    5     .db 0xAD
   40E0 80                    6     .db 0x80    
   40E1 CC CC                 7     .dw 0xCCCC
   004B                       1         DefineStarDefault
   40E3 01                    1     .db alive_type
   40E4 DE                    2     .db 0xDE
   40E5 AD                    3     .db 0xAD
   40E6 DE                    4     .db 0xDE
   40E7 AD                    5     .db 0xAD
   40E8 80                    6     .db 0x80    
   40E9 CC CC                 7     .dw 0xCCCC
   0053                       1         DefineStarDefault
   40EB 01                    1     .db alive_type
   40EC DE                    2     .db 0xDE
   40ED AD                    3     .db 0xAD
   40EE DE                    4     .db 0xDE
   40EF AD                    5     .db 0xAD
   40F0 80                    6     .db 0x80    
   40F1 CC CC                 7     .dw 0xCCCC
   005B                       1         DefineStarDefault
   40F3 01                    1     .db alive_type
   40F4 DE                    2     .db 0xDE
   40F5 AD                    3     .db 0xAD
   40F6 DE                    4     .db 0xDE
   40F7 AD                    5     .db 0xAD
   40F8 80                    6     .db 0x80    
   40F9 CC CC                 7     .dw 0xCCCC
   0063                       1         DefineStarDefault
   40FB 01                    1     .db alive_type
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   40FC DE                    2     .db 0xDE
   40FD AD                    3     .db 0xAD
   40FE DE                    4     .db 0xDE
   40FF AD                    5     .db 0xAD
   4100 80                    6     .db 0x80    
   4101 CC CC                 7     .dw 0xCCCC
   006B                       1         DefineStarDefault
   4103 01                    1     .db alive_type
   4104 DE                    2     .db 0xDE
   4105 AD                    3     .db 0xAD
   4106 DE                    4     .db 0xDE
   4107 AD                    5     .db 0xAD
   4108 80                    6     .db 0x80    
   4109 CC CC                 7     .dw 0xCCCC
   0073                       1         DefineStarDefault
   410B 01                    1     .db alive_type
   410C DE                    2     .db 0xDE
   410D AD                    3     .db 0xAD
   410E DE                    4     .db 0xDE
   410F AD                    5     .db 0xAD
   4110 80                    6     .db 0x80    
   4111 CC CC                 7     .dw 0xCCCC
   007B                       1         DefineStarDefault
   4113 01                    1     .db alive_type
   4114 DE                    2     .db 0xDE
   4115 AD                    3     .db 0xAD
   4116 DE                    4     .db 0xDE
   4117 AD                    5     .db 0xAD
   4118 80                    6     .db 0x80    
   4119 CC CC                 7     .dw 0xCCCC
   0083                       1         DefineStarDefault
   411B 01                    1     .db alive_type
   411C DE                    2     .db 0xDE
   411D AD                    3     .db 0xAD
   411E DE                    4     .db 0xDE
   411F AD                    5     .db 0xAD
   4120 80                    6     .db 0x80    
   4121 CC CC                 7     .dw 0xCCCC
   008B                       1         DefineStarDefault
   4123 01                    1     .db alive_type
   4124 DE                    2     .db 0xDE
   4125 AD                    3     .db 0xAD
   4126 DE                    4     .db 0xDE
   4127 AD                    5     .db 0xAD
   4128 80                    6     .db 0x80    
   4129 CC CC                 7     .dw 0xCCCC
   0093                       1         DefineStarDefault
   412B 01                    1     .db alive_type
   412C DE                    2     .db 0xDE
   412D AD                    3     .db 0xAD
   412E DE                    4     .db 0xDE
   412F AD                    5     .db 0xAD
   4130 80                    6     .db 0x80    
   4131 CC CC                 7     .dw 0xCCCC
   009B                       1         DefineStarDefault
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



   4133 01                    1     .db alive_type
   4134 DE                    2     .db 0xDE
   4135 AD                    3     .db 0xAD
   4136 DE                    4     .db 0xDE
   4137 AD                    5     .db 0xAD
   4138 80                    6     .db 0x80    
   4139 CC CC                 7     .dw 0xCCCC
   00A3                       1         DefineStarDefault
   413B 01                    1     .db alive_type
   413C DE                    2     .db 0xDE
   413D AD                    3     .db 0xAD
   413E DE                    4     .db 0xDE
   413F AD                    5     .db 0xAD
   4140 80                    6     .db 0x80    
   4141 CC CC                 7     .dw 0xCCCC
   00AB                       1         DefineStarDefault
   4143 01                    1     .db alive_type
   4144 DE                    2     .db 0xDE
   4145 AD                    3     .db 0xAD
   4146 DE                    4     .db 0xDE
   4147 AD                    5     .db 0xAD
   4148 80                    6     .db 0x80    
   4149 CC CC                 7     .dw 0xCCCC
   00B3                       1         DefineStarDefault
   414B 01                    1     .db alive_type
   414C DE                    2     .db 0xDE
   414D AD                    3     .db 0xAD
   414E DE                    4     .db 0xDE
   414F AD                    5     .db 0xAD
   4150 80                    6     .db 0x80    
   4151 CC CC                 7     .dw 0xCCCC
   00BB                       1         DefineStarDefault
   4153 01                    1     .db alive_type
   4154 DE                    2     .db 0xDE
   4155 AD                    3     .db 0xAD
   4156 DE                    4     .db 0xDE
   4157 AD                    5     .db 0xAD
   4158 80                    6     .db 0x80    
   4159 CC CC                 7     .dw 0xCCCC
   00C3                       1         DefineStarDefault
   415B 01                    1     .db alive_type
   415C DE                    2     .db 0xDE
   415D AD                    3     .db 0xAD
   415E DE                    4     .db 0xDE
   415F AD                    5     .db 0xAD
   4160 80                    6     .db 0x80    
   4161 CC CC                 7     .dw 0xCCCC
   00CB                       1         DefineStarDefault
   4163 01                    1     .db alive_type
   4164 DE                    2     .db 0xDE
   4165 AD                    3     .db 0xAD
   4166 DE                    4     .db 0xDE
   4167 AD                    5     .db 0xAD
   4168 80                    6     .db 0x80    
   4169 CC CC                 7     .dw 0xCCCC
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



   00D3                       1         DefineStarDefault
   416B 01                    1     .db alive_type
   416C DE                    2     .db 0xDE
   416D AD                    3     .db 0xAD
   416E DE                    4     .db 0xDE
   416F AD                    5     .db 0xAD
   4170 80                    6     .db 0x80    
   4171 CC CC                 7     .dw 0xCCCC
   00DB                       1         DefineStarDefault
   4173 01                    1     .db alive_type
   4174 DE                    2     .db 0xDE
   4175 AD                    3     .db 0xAD
   4176 DE                    4     .db 0xDE
   4177 AD                    5     .db 0xAD
   4178 80                    6     .db 0x80    
   4179 CC CC                 7     .dw 0xCCCC
   00E3                       1         DefineStarDefault
   417B 01                    1     .db alive_type
   417C DE                    2     .db 0xDE
   417D AD                    3     .db 0xAD
   417E DE                    4     .db 0xDE
   417F AD                    5     .db 0xAD
   4180 80                    6     .db 0x80    
   4181 CC CC                 7     .dw 0xCCCC
   00EB                       1         DefineStarDefault
   4183 01                    1     .db alive_type
   4184 DE                    2     .db 0xDE
   4185 AD                    3     .db 0xAD
   4186 DE                    4     .db 0xDE
   4187 AD                    5     .db 0xAD
   4188 80                    6     .db 0x80    
   4189 CC CC                 7     .dw 0xCCCC
   418B FF                    7     .db invalid_type
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
   418C                      24 entityman_new_entity::
   418C 3A 98 40      [13]   25   ld    a, (_entity_num)
   418F 3C            [ 4]   26   inc   a
   4190 32 98 40      [13]   27   ld    (_entity_num), a
                             28 
   4193 DD 2A 99 40   [20]   29   ld    ix, (_entity_last)    
   4197 2A 99 40      [16]   30   ld    hl, (_entity_last)    
   419A 01 08 00      [10]   31   ld    bc, #sizeof_e
   419D 09            [11]   32   add   hl, bc
   419E 22 99 40      [16]   33   ld    (_entity_last), hl
   41A1 C9            [10]   34   ret
                             35 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



                             36 ;;
                             37 ;;  INPUT: 
                             38 ;;    ix with memory address of entity that must be initialized
                             39 ;;
   41A2                      40 entityman_initialize_rand::  
   41A2 DD 36 00 01   [19]   41   ld    e_type(ix), #alive_type    ;; set Y velocity  
                             42 
   41A6 3E 00         [ 7]   43   ld    a, #0
   41A8 DD 77 04      [19]   44   ld    e_vy(ix), a               ;; set Y velocity  
                             45 
   41AB CD 66 42      [17]   46   call cpct_getRandom_mxor_u8_asm
   41AE 7D            [ 4]   47   ld    a, l
   41AF 17            [ 4]   48   rla
   41B0 17            [ 4]   49   rla  
   41B1 DD 77 02      [19]   50   ld    e_y(ix), a                ;; set Y coordiante
                             51 
   41B4 DD 36 03 FF   [19]   52   ld    e_vx(ix), #0xFF               ;; set X velocity  
                             53 
   41B8 3E 50         [ 7]   54   ld    a, #0x50                   
   41BA DD 77 01      [19]   55   ld    e_x(ix), a               ;; set X coordinate to the most right possible byte
   41BD C9            [10]   56   ret
                             57 
                             58 ;;########################################################
                             59 ;;                   PUBLIC FUNCTIONS                    #             
                             60 ;;########################################################
                             61 
   41BE                      62 entityman_create_one::  
   41BE 3E FF         [ 7]   63   ld    a, #invalid_type
   41C0 2A 99 40      [16]   64   ld    hl, (_entity_last)
   41C3 BE            [ 7]   65   cp   (hl)                  ;; last entity type - invalid_type 
   41C4 C8            [11]   66   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                             67 
   41C5 CD 8C 41      [17]   68   call  entityman_new_entity
   41C8 CD A2 41      [17]   69   call  entityman_initialize_rand
   41CB C9            [10]   70   ret
                             71 
                             72 
   41CC                      73 entityman_init::
   41CC 3E 1E         [ 7]   74   ld    a, #max_entities
   41CE ED 5B 99 40   [20]   75   ld    de, (_entity_last)
   41D2                      76 init_loop:
   41D2 F5            [11]   77   push  af
                             78   
   41D3 CD 8C 41      [17]   79   call  entityman_new_entity
   41D6 CD A2 41      [17]   80   call  entityman_initialize_rand
                             81   
   41D9 F1            [10]   82   pop   af
   41DA 3D            [ 4]   83   dec   a
   41DB C8            [11]   84   ret   z
   41DC 18 F4         [12]   85   jr    init_loop
                             86 
                             87 
   41DE                      88 entityman_update::
   41DE DD 21 9B 40   [14]   89   ld    ix, #_entity_array
   41E2 3A 98 40      [13]   90   ld     a, (_entity_num)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



   41E5 B7            [ 4]   91   or     a
   41E6 C8            [11]   92   ret    z
                             93 
   41E7                      94 entityman_loop:
   41E7 F5            [11]   95   push  af
                             96   
   41E8 DD 7E 00      [19]   97   ld    a, e_type(ix)         ;; load type of entity
   41EB E6 FE         [ 7]   98   and   #dead_type            ;; entity_type AND dead_type
                             99 
   41ED 28 2F         [12]  100   jr    z, inc_index
   41EF CD 8E 40      [17]  101   call  rendersys_delete_entity
                            102 
                            103   ;; _last_element_ptr now points to the last entity in the array
                            104   ;; si A 02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   41F2 3A 99 40      [13]  105   ld    a, (_entity_last)
   41F5 D6 08         [ 7]  106   sub   #sizeof_e
   41F7 32 99 40      [13]  107   ld    (_entity_last), a
   41FA DA 00 42      [10]  108   jp    c, overflow
   41FD C3 07 42      [10]  109   jp    no_overflow    
                            110   
   4200                     111 overflow:
   4200 3A 9A 40      [13]  112   ld    a, (_entity_last+1)
   4203 3D            [ 4]  113   dec   a
   4204 32 9A 40      [13]  114   ld    (_entity_last+1), a
                            115 
   4207                     116 no_overflow:
                            117   ;; move the last element to the hole left by the dead entity
   4207 DD E5         [15]  118   push  ix  
   4209 E1            [10]  119   pop   hl
   420A 01 08 00      [10]  120   ld    bc, #sizeof_e       
   420D ED 5B 99 40   [20]  121   ld    de, (_entity_last)
   4211 EB            [ 4]  122   ex    de, hl
   4212 ED B0         [21]  123   ldir                        
                            124   
   4214 3A 98 40      [13]  125   ld    a, (_entity_num)
   4217 3D            [ 4]  126   dec   a
   4218 32 98 40      [13]  127   ld    (_entity_num), a  
                            128 
   421B C3 23 42      [10]  129   jp    continue_update
                            130 
   421E                     131 inc_index:
   421E 01 08 00      [10]  132   ld    bc, #sizeof_e
   4221 DD 09         [15]  133   add   ix, bc
   4223                     134 continue_update:
   4223 F1            [10]  135   pop   af
   4224 3D            [ 4]  136   dec   a
   4225 C8            [11]  137   ret   z
   4226 C3 E7 41      [10]  138   jp    entityman_loop
                            139 ;
                            140 
                            141 ;;
                            142 ;; RETURN: 
                            143 ;;  ix  begin of entity array memory address
                            144 ;;  a   number of valid and alive entities
                            145 ;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 13.
Hexadecimal [16-Bits]



   4229                     146 get_entity_array::
   4229 DD 21 9B 40   [14]  147   ld ix, #_entity_array
   422D 3A 98 40      [13]  148   ld  a, (_entity_num)
   4230 C9            [10]  149   ret
                            150 
                            151 
                            152 ;;
                            153 ;;  INPUT: 
                            154 ;;    ix with memory address of entity that must me marked as dead
                            155 ;;
   4231                     156 entityman_set_dead::
   4231 3E FE         [ 7]  157   ld  a, #dead_type
   4233 DD 77 00      [19]  158   ld  e_type(ix), a
   4236 C9            [10]  159   ret
