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



                              2 .include "../cpct_functions.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              3 .include "render_system.h.s"
                              1 .globl  rendersys_init
                              2 .globl  rendersys_update
                              3 .globl  rendersys_delete_entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                              4 
   4052                       5 rendersys_init::  
   4052 0E 00         [ 7]    6   ld    c, #0
   4054 CD 41 42      [17]    7   call  cpct_setVideoMode_asm    
                              8 
   4057 2E 00         [ 7]    9   ld    l, #0
   4059 26 14         [ 7]   10   ld    h, #HW_BLACK
   405B CD 37 42      [17]   11   call  cpct_setPALColour_asm
   405E C9            [10]   12   ret
                             13 
   405F                      14 rendersys_update::
   405F CD 29 42      [17]   15   call get_entity_array
   4062 B7            [ 4]   16   or     a
   4063 C8            [11]   17   ret    z
   4064                      18 rendersys_loop:
   4064 F5            [11]   19   push af
                             20 
   4065 DD 6E 06      [19]   21   ld    l, e_last_ptr_1(ix)          
   4068 DD 66 07      [19]   22   ld    h, e_last_ptr_2(ix)          
   406B 0E 00         [ 7]   23   ld    c, #00
   406D 71            [ 7]   24   ld   (hl), c
                             25 
                             26   ;; Calculate a video-memory location for printing a string
   406E 11 00 C0      [10]   27   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   4071 DD 4E 01      [19]   28   ld    c, e_x(ix)                  ;; C = x coordinate       
   4074 DD 46 02      [19]   29   ld    b, e_y(ix)                  ;; B = y coordinate   
   4077 CD 8C 42      [17]   30   call  cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
                             31 
   407A DD 75 06      [19]   32   ld  e_last_ptr_1(ix), l
   407D DD 74 07      [19]   33   ld  e_last_ptr_2(ix), h
   4080 DD 4E 05      [19]   34   ld    c, e_color(ix)
   4083 71            [ 7]   35   ld   (hl), c
   4084 01 08 00      [10]   36   ld   bc, #sizeof_e
   4087 DD 09         [15]   37   add  ix, bc
                             38 
   4089 F1            [10]   39   pop   af
   408A 3D            [ 4]   40   dec   a
   408B C8            [11]   41   ret   z
   408C 18 D6         [12]   42   jr rendersys_loop
                             43 
                             44 
                             45 ;;
                             46 ;;  INPUT: 
                             47 ;;    ix with memory address of entity that must be deleted
                             48 ;;  DESTROY
                             49 ;;    hl, c
                             50 ;;
   408E                      51 rendersys_delete_entity::
                             52   ;; Calculate a video-memory location for printing a string  
   408E DD 6E 06      [19]   53   ld    l, e_last_ptr_1(ix)          
   4091 DD 66 07      [19]   54   ld    h, e_last_ptr_2(ix)          
   4094 0E 00         [ 7]   55   ld    c, #00
   4096 71            [ 7]   56   ld   (hl), c
   4097 C9            [10]   57   ret
