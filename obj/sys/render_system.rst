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



                              2 .include "../cpct_functions.h.s"
                              1 
                              2 .globl  cpct_disableFirmware_asm
                              3 .globl  cpct_setVideoMode_asm
                              4 .globl  cpct_setPalette_asm
                              5 .globl  cpct_getScreenPtr_asm
                              6 .globl  cpct_waitVSYNC_asm
                              7 
                     C000     8 CPCT_VMEM_START_ASM = 0xC000
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              3 .include "render_system.h.s"
                              1 .globl  rendersys_init
                              2 .globl  rendersys_update
                              3 .globl  rendersys_delete_entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              4 
                              5 ;pallete: 
                              6 ;  .db   HW_BLACK
                              7 ;  .db   HW_BLACK
                              8 ;  .db   HW_BLACK
                              9 ;  .db   HW_BLACK
                             10 ;  .db   HW_WHITE
                             11 ;  .db   HW_WHITE
                             12 ;  .db   HW_WHITE
                             13 ;  .db   HW_WHITE
                             14 ;  .db   HW_BLUE
                             15 ;  .db   HW_BLUE
                             16 ;  .db   HW_BLUE
                             17 ;  .db   HW_BLUE
                             18 ;  .db   HW_RED
                             19 ;  .db   HW_RED
                             20 ;  .db   HW_RED
                             21 ;  .db   HW_RED
                             22 
   4051                      23 rendersys_init::  
                             24   ;;ld    hl, #pallete
                             25   ;;call  cpct_setPalette_asm
                             26 
   4051 CD 80 41      [17]   27   call get_entity_array
   4054                      28 rendersys_init_loop:  
   4054 F5            [11]   29   push af
                             30   ;; Calculate a video-memory location for printing a string
   4055 11 00 C0      [10]   31   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   4058 DD 4E 01      [19]   32   ld    c, e_x(ix)                  ;; C = x coordinate       
   405B DD 46 02      [19]   33   ld    b, e_y(ix)                  ;; B = y coordinate   
   405E CD D1 41      [17]   34   call  cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
                             35 
   4061 DD 75 06      [19]   36   ld  e_last_ptr_1(ix), l
   4064 DD 74 07      [19]   37   ld  e_last_ptr_2(ix), h
   4067 DD 4E 05      [19]   38   ld    c, e_color(ix)
   406A 71            [ 7]   39   ld   (hl), c
   406B 01 08 00      [10]   40   ld   bc, #sizeof_e
   406E DD 09         [15]   41   add  ix, bc
                             42   
   4070 F1            [10]   43   pop   af
   4071 3D            [ 4]   44   dec   a
   4072 C8            [11]   45   ret   z
   4073 18 DF         [12]   46   jr rendersys_init_loop
   4075 C9            [10]   47   ret
                             48 
   4076                      49 rendersys_update::
   4076 CD 80 41      [17]   50   call get_entity_array
   4079 B7            [ 4]   51   or     a
   407A C8            [11]   52   ret    z
   407B                      53 rendersys_loop:
   407B F5            [11]   54   push af
                             55 
   407C DD 6E 06      [19]   56   ld    l, e_last_ptr_1(ix)          
   407F DD 66 07      [19]   57   ld    h, e_last_ptr_2(ix)          
   4082 0E 00         [ 7]   58   ld    c, #00
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   4084 71            [ 7]   59   ld   (hl), c
                             60 
                             61   ;; Calculate a video-memory location for printing a string
   4085 11 00 C0      [10]   62   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   4088 DD 4E 01      [19]   63   ld    c, e_x(ix)                  ;; C = x coordinate       
   408B DD 46 02      [19]   64   ld    b, e_y(ix)                  ;; B = y coordinate   
   408E CD D1 41      [17]   65   call  cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
                             66 
   4091 DD 75 06      [19]   67   ld  e_last_ptr_1(ix), l
   4094 DD 74 07      [19]   68   ld  e_last_ptr_2(ix), h
   4097 DD 4E 05      [19]   69   ld    c, e_color(ix)
   409A 71            [ 7]   70   ld   (hl), c
   409B 01 08 00      [10]   71   ld   bc, #sizeof_e
   409E DD 09         [15]   72   add  ix, bc
                             73 
   40A0 F1            [10]   74   pop   af
   40A1 3D            [ 4]   75   dec   a
   40A2 C8            [11]   76   ret   z
   40A3 18 D6         [12]   77   jr rendersys_loop
                             78 
                             79 
                             80 ;;
                             81 ;;  INPUT: 
                             82 ;;    ix with memory address of entity that must be deleted
                             83 ;;  DESTROY
                             84 ;;    hl, c
                             85 ;;
   40A5                      86 rendersys_delete_entity::
                             87   ;; Calculate a video-memory location for printing a string  
   40A5 DD 6E 06      [19]   88   ld    l, e_last_ptr_1(ix)          
   40A8 DD 66 07      [19]   89   ld    h, e_last_ptr_2(ix)          
   40AB 0E 00         [ 7]   90   ld    c, #00
   40AD 71            [ 7]   91   ld   (hl), c
   40AE C9            [10]   92   ret
