ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .include "../man/entity_manager.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              2 .include "physics_system.h.s"
                              1 .globl  physicssys_init
                              2 .globl  physicssys_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              3 .include "../cpct_functions.h.s"
                              1 
                              2 .globl  cpct_disableFirmware_asm
                              3 .globl  cpct_setVideoMode_asm
                              4 .globl  cpct_setPalette_asm
                              5 .globl  cpct_getScreenPtr_asm
                              6 .globl  cpct_waitVSYNC_asm
                              7 
                     C000     8 CPCT_VMEM_START_ASM = 0xC000
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              4 
   401E                       5 physicssys_init::
   401E C9            [10]    6   ret
                              7 
   401F                       8 physicssys_update::
   401F CD 26 41      [17]    9   call  get_entity_array
                             10 
   4022                      11 physicssys_loop:    
   4022 DD 4E 01      [19]   12   ld    c, e_x(ix)                  ;; C = x coordinate       
   4025 DD 46 02      [19]   13   ld    b, e_y(ix)                  ;; B = y coordinate  
   4028 DD 6E 03      [19]   14   ld    l, e_vx(ix)                 ;; L = x velocity       
   402B DD 66 04      [19]   15   ld    h, e_vy(ix)                 ;; H = y velocity  
                             16 
   402E 09            [11]   17   add   hl, bc
                             18 
   402F 38 11         [12]   19   jr    c, invalid_position;
                             20 
   4031 4D            [ 4]   21   ld    c, l
   4032 44            [ 4]   22   ld    b, h
                             23   
   4033 DD 71 01      [19]   24   ld    e_x(ix), c                  ;; C = x coordinate       
   4036 DD 70 02      [19]   25   ld    e_y(ix), b                  ;; B = y coordinate  
                             26 
   4039 01 08 00      [10]   27   ld    bc, #sizeof_e
   403C DD 09         [15]   28   add   ix, bc
                             29 
   403E 3D            [ 4]   30   dec   a  
   403F C8            [11]   31   ret   z
   4040 18 E0         [12]   32   jr    physicssys_loop
                             33 
   4042                      34 invalid_position:
   4042 F5            [11]   35   push  af
   4043 3E FF         [ 7]   36   ld    a, #0xFF
   4045 DD 77 00      [19]   37   ld    e_type(ix), a
   4048 F1            [10]   38   pop   af
   4049 01 08 00      [10]   39   ld    bc, #sizeof_e
   404C DD 09         [15]   40   add   ix, bc
   404E 18 D2         [12]   41   jr    physicssys_loop
