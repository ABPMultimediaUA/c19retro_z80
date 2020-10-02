ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .include "../man/entity_manager.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              2 .include "physics_system.h.s"
                              1 .globl  physicssys_init
                              2 .globl  physicssys_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              3 .include "../cpct_functions.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                              4 
   401D                       5 physicssys_init::
   401D C9            [10]    6   ret
                              7 
   401E                       8 physicssys_update::
   401E CD 29 42      [17]    9   call  get_entity_array
   4021 B7            [ 4]   10   or     a
   4022 C8            [11]   11   ret    z
                             12 
   4023                      13 physicssys_loop:    
   4023 F5            [11]   14   push  af
                             15 
   4024 DD 4E 01      [19]   16   ld    c, e_x(ix)                  ;; C = x coordinate       
   4027 DD 7E 03      [19]   17   ld    a, e_vx(ix)                 ;; L = x velocity       
   402A 81            [ 4]   18   add   a, c
   402B FA 48 40      [10]   19   jp    m, invalid_x
                             20 
   402E                      21 continue_x:
   402E DD 77 01      [19]   22   ld    e_x(ix), a  
                             23 
   4031 DD 46 02      [19]   24   ld    b, e_y(ix)                  ;; B = y coordinate  
   4034 DD 7E 04      [19]   25   ld    a, e_vy(ix)                 ;; H = y velocity  
   4037 80            [ 4]   26   add   a, b
   4038 FA 4D 40      [10]   27   jp    m, invalid_y
   403B                      28 continue_y:
   403B DD 77 02      [19]   29   ld    e_y(ix), a
                             30 
   403E 01 08 00      [10]   31   ld    bc, #sizeof_e
   4041 DD 09         [15]   32   add   ix, bc
                             33 
   4043 F1            [10]   34   pop   af
   4044 3D            [ 4]   35   dec   a  
   4045 C8            [11]   36   ret   z
   4046 18 DB         [12]   37   jr    physicssys_loop
                             38 
   4048                      39 invalid_x:
   4048 CD 31 42      [17]   40   call  entityman_set_dead
   404B 18 E1         [12]   41   jr    continue_x
                             42 
   404D                      43 invalid_y:
   404D CD 31 42      [17]   44   call  entityman_set_dead
   4050 18 E9         [12]   45   jr    continue_y
