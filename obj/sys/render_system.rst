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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
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
   4052                      23 rendersys_init::  
   4052 0E 00         [ 7]   24   ld    c, #0
   4054 CD A2 41      [17]   25   call  cpct_setVideoMode_asm    
                             26 
   4057 2E 00         [ 7]   27   ld    l, #0
   4059 26 14         [ 7]   28   ld    h, #HW_BLACK
   405B CD 98 41      [17]   29   call  cpct_setPALColour_asm
   405E C9            [10]   30   ret
                             31 
   405F                      32 rendersys_update::
   405F CD 8A 41      [17]   33   call get_entity_array
   4062 B7            [ 4]   34   or     a
   4063 C8            [11]   35   ret    z
   4064                      36 rendersys_loop:
   4064 F5            [11]   37   push af
                             38 
   4065 DD 6E 06      [19]   39   ld    l, e_last_ptr_1(ix)          
   4068 DD 66 07      [19]   40   ld    h, e_last_ptr_2(ix)          
   406B 0E 00         [ 7]   41   ld    c, #00
   406D 71            [ 7]   42   ld   (hl), c
                             43 
                             44   ;; Calculate a video-memory location for printing a string
   406E 11 00 C0      [10]   45   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   4071 DD 4E 01      [19]   46   ld    c, e_x(ix)                  ;; C = x coordinate       
   4074 DD 46 02      [19]   47   ld    b, e_y(ix)                  ;; B = y coordinate   
   4077 CD ED 41      [17]   48   call  cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
                             49 
   407A DD 75 06      [19]   50   ld  e_last_ptr_1(ix), l
   407D DD 74 07      [19]   51   ld  e_last_ptr_2(ix), h
   4080 DD 4E 05      [19]   52   ld    c, e_color(ix)
   4083 71            [ 7]   53   ld   (hl), c
   4084 01 08 00      [10]   54   ld   bc, #sizeof_e
   4087 DD 09         [15]   55   add  ix, bc
                             56 
   4089 F1            [10]   57   pop   af
   408A 3D            [ 4]   58   dec   a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



   408B C8            [11]   59   ret   z
   408C 18 D6         [12]   60   jr rendersys_loop
                             61 
                             62 
                             63 ;;
                             64 ;;  INPUT: 
                             65 ;;    ix with memory address of entity that must be deleted
                             66 ;;  DESTROY
                             67 ;;    hl, c
                             68 ;;
   408E                      69 rendersys_delete_entity::
                             70   ;; Calculate a video-memory location for printing a string  
   408E DD 6E 06      [19]   71   ld    l, e_last_ptr_1(ix)          
   4091 DD 66 07      [19]   72   ld    h, e_last_ptr_2(ix)          
   4094 0E 00         [ 7]   73   ld    c, #00
   4096 71            [ 7]   74   ld   (hl), c
   4097 C9            [10]   75   ret
