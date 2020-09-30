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
   4050                      23 rendersys_init::  
                             24   ;;ld    hl, #pallete
                             25   ;;call  cpct_setPalette_asm
                             26 
   4050 CD 26 41      [17]   27   call get_entity_array
   4053                      28 rendersys_init_loop:  
   4053 F5            [11]   29   push af
                             30   ;; Calculate a video-memory location for printing a string
   4054 11 00 C0      [10]   31   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   4057 DD 4E 01      [19]   32   ld    c, e_x(ix)                  ;; C = x coordinate       
   405A DD 46 02      [19]   33   ld    b, e_y(ix)                  ;; B = y coordinate   
   405D CD 71 41      [17]   34   call  cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
                             35 
   4060 DD 4E 05      [19]   36   ld    c, e_color(ix)
   4063 71            [ 7]   37   ld   (hl), c
   4064 01 08 00      [10]   38   ld   bc, #sizeof_e
   4067 DD 09         [15]   39   add  ix, bc
                             40   
   4069 F1            [10]   41   pop   af
   406A 3D            [ 4]   42   dec   a
   406B C8            [11]   43   ret   z
   406C 18 E5         [12]   44   jr rendersys_init_loop
   406E C9            [10]   45   ret
                             46 
   406F                      47 rendersys_update::
   406F CD 26 41      [17]   48   call get_entity_array
                             49 
   4072                      50 rendersys_loop:
   4072 F5            [11]   51   push af
                             52 
                             53   ;; Calculate a video-memory location for printing a string  
   4073 DD 6E 06      [19]   54   ld    l, e_last_ptr_1(ix)          
   4076 DD 66 07      [19]   55   ld    h, e_last_ptr_2(ix)          
   4079 0E 00         [ 7]   56   ld    c, #00
   407B 71            [ 7]   57   ld   (hl), c
                             58 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                             59   ;; Calculate a video-memory location for printing a string
   407C 11 00 C0      [10]   60   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   407F DD 4E 01      [19]   61   ld    c, e_x(ix)                  ;; C = x coordinate       
   4082 DD 46 02      [19]   62   ld    b, e_y(ix)                  ;; B = y coordinate   
   4085 CD 71 41      [17]   63   call  cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
                             64 
   4088 DD 75 06      [19]   65   ld  e_last_ptr_1(ix), l
   408B DD 74 07      [19]   66   ld  e_last_ptr_2(ix), h
   408E DD 4E 05      [19]   67   ld    c, e_color(ix)
   4091 71            [ 7]   68   ld   (hl), c
   4092 01 08 00      [10]   69   ld   bc, #sizeof_e
   4095 DD 09         [15]   70   add  ix, bc
                             71 
   4097 F1            [10]   72   pop   af
   4098 3D            [ 4]   73   dec   a
   4099 C8            [11]   74   ret   z
   409A 18 D6         [12]   75   jr rendersys_loop
