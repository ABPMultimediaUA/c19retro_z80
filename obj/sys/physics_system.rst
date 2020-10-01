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
                              4 .globl  cpct_getScreenPtr_asm
                              5 .globl  cpct_waitVSYNC_asm
                              6 .globl  cpct_setPALColour_asm
                              7 .globl  HW_BLACK
                              8 .globl  HW_WHITE
                     C000     9 CPCT_VMEM_START_ASM = 0xC000
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              4 
   402A                       5 physicssys_init::
   402A C9            [10]    6   ret
                              7 
   402B                       8 physicssys_update::
   402B CD 76 41      [17]    9   call  get_entity_array
   402E B7            [ 4]   10   or     a
   402F C8            [11]   11   ret    z
                             12 
   4030                      13 physicssys_loop:    
   4030 F5            [11]   14   push  af
                             15 
   4031 DD 4E 01      [19]   16   ld    c, e_x(ix)                  ;; C = x coordinate       
   4034 DD 7E 03      [19]   17   ld    a, e_vx(ix)                 ;; L = x velocity       
   4037 81            [ 4]   18   add   a, c
   4038 FA 55 40      [10]   19   jp    m, invalid_x
                             20 
   403B                      21 continue_x:
   403B DD 77 01      [19]   22   ld    e_x(ix), a  
                             23 
   403E DD 46 02      [19]   24   ld    b, e_y(ix)                  ;; B = y coordinate  
   4041 DD 7E 04      [19]   25   ld    a, e_vy(ix)                 ;; H = y velocity  
   4044 80            [ 4]   26   add   a, b
   4045 FA 5A 40      [10]   27   jp    m, invalid_y
   4048                      28 continue_y:
   4048 DD 77 02      [19]   29   ld    e_y(ix), a
                             30 
   404B 01 08 00      [10]   31   ld    bc, #sizeof_e
   404E DD 09         [15]   32   add   ix, bc
                             33 
   4050 F1            [10]   34   pop   af
   4051 3D            [ 4]   35   dec   a  
   4052 C8            [11]   36   ret   z
   4053 18 DB         [12]   37   jr    physicssys_loop
                             38 
   4055                      39 invalid_x:
   4055 CD 7E 41      [17]   40   call  entityman_set_dead
   4058 18 E1         [12]   41   jr    continue_x
                             42 
   405A                      43 invalid_y:
   405A CD 7E 41      [17]   44   call  entityman_set_dead
   405D 18 E9         [12]   45   jr    continue_y
