ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;
                              2 ;;  PHYSICS SYSTEM
                              3 ;;
                              4 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              5 .include "../man/entity_manager.h.s"
                              1 ;;
                              2 ;;  ENTITY MANAGER HEADER
                              3 ;;
                              4 
                              5 .globl  man_entity_init
                              6 
                              7 .globl  man_entity_update
                              8 
                              9 .globl  man_entity_create_entity
                             10 .globl  man_entity_create_bomb
                             11 
                             12 .globl  man_entity_get_player
                             13 .globl  man_entity_get_enemy_array
                             14 .globl  man_entity_get_bomb_array
                             15 
                             16 .globl  man_entity_set_player_dead
                             17 .globl  man_entity_set_enemy_dead
                             18 
                             19 ;;########################################################
                             20 ;;                        MACROS                         #              
                             21 ;;########################################################
                             22 
                             23 ;;-----------------------  ENTITY  -----------------------
                             24 .macro DefineEntity _type,_x,_y,_w,_h,_vx,_vy,_sp_ptr
                             25     .db _type
                             26     .db _x, _y
                             27     .db _w, _h      ;; both in bytes
                             28     .db _vx, _vy    
                             29     .dw _sp_ptr
                             30 .endm
                             31 
                             32 .macro DefineEntityDefault
                             33     .db alive_type
                             34     .db 0xDE, 0xAD
                             35     .db 4, 16  
                             36     .dw 0xADDE 
                             37     .dw 0xCCCC
                             38 .endm
                             39 
                             40 .macro DefineEntityArray _Tname,_N,_DefineEntity
                             41     _Tname'_num:    .db 0    
                             42     _Tname'_last:   .dw _Tname'_array
                             43     _Tname'_array: 
                             44     .rept _N    
                             45         _DefineEntity
                             46     .endm
                             47 .endm
                             48 
                             49 ;;-----------------------  BOMBS  ------------------------
                             50 .macro DefineBombDefault    
                             51     .db max_timer   ;; timer    
                             52     .db 0xDE,0xAD   ;; coordinates (x, y)
                             53     .db #4, #16     ;; width, height -> both in bytes    
                             54     .dw 0xCCCC      ;; sprite  pointer (where it's in memory video)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                             55 .endm
                             56 
                             57 .macro DefineBombArray _Tname,_N,_DefineBomb
                             58     _Tname'_num:    .db 0    
                             59     _Tname'_last:   .dw _Tname'_array
                             60     _Tname'_array: 
                             61     .rept _N    
                             62         _DefineBomb
                             63     .endm
                             64 .endm
                             65 
                             66 ;;########################################################
                             67 ;;                       CONSTANTS                       #             
                             68 ;;########################################################
                             69 
                             70 ;;-----------------------  ENTITY  -----------------------
                     0000    71 e_type = 0
                     0001    72 e_x = 1
                     0002    73 e_y = 2
                     0003    74 e_w = 3
                     0004    75 e_h = 4
                     0005    76 e_vx = 5
                     0006    77 e_vy = 6
                     0007    78 e_sp_ptr_0 = 7
                     0008    79 e_sp_ptr_1 = 8
                     0009    80 sizeof_e = 9
                     0001    81 max_entities = 1
                             82 
                             83 ;;-----------------------  BOMBS  ------------------------
                     0000    84 b_timer = 0
                     0001    85 b_x = 1
                     0002    86 b_y = 2
                     0003    87 b_w = 3
                     0004    88 b_h = 4
                     0005    89 b_sp_ptr_0 = 5
                     0006    90 b_sp_ptr_1 = 6
                     0007    91 sizeof_b = 7
                     0001    92 max_bombs = 1
                             93 
                             94 ;;########################################################
                             95 ;;                      ENTITY TYPES                     #             
                             96 ;;########################################################
                     0001    97 alive_type = 0x01
                     00FE    98 dead_type = 0xFE
                     00FF    99 invalid_type = 0xFF
                            100 
                            101 
                            102 ;;########################################################
                            103 ;;                       BOMB TIMERS                     #             
                            104 ;;########################################################
                     0000   105 zero_timer = 0x00
                     00FF   106 max_timer = 0xFF
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              6 .include "physics_system.h.s"
                              1 ;;
                              2 ;;  PHYSICS SYSTEM HEADER
                              3 ;;
                              4 
                              5 .globl  sys_physics_init
                              6 .globl  sys_physics_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                              7 .include "render_system.h.s"
                              1 ;;
                              2 ;;  RENDER SYSTEM HEADER
                              3 ;;
                              4 
                              5 .globl  sys_render_init
                              6 .globl  sys_render_update
                              7 .globl  sys_render_remove_entity
                              8 .globl  sys_render_remove_bomb
                              9 
                             10 
                             11 ;;########################################################
                             12 ;;                       CONSTANTS                       #             
                             13 ;;########################################################
                     0000    14 video_mode = 0
                             15 
                             16 ;;  In pixels
                     00A0    17 screen_width = 160
                     00C8    18 screen_height = 200
                             19 
                             20 ;;  In bytes
                             21 ;;  The max constants are max+1 because this way they represent the first pixel where border begins.
                             22 ;;  This way, when calculating the last allowed position where an entity may be positioned, it is easier and cleaner.
                     0004    23 min_map_y_coord_valid = 4     ;;  [0-3] border, >=4 map
                     00C4    24 max_map_y_coord_valid = 196    ;;  [196-199] border, <=195 map
                             25 
                             26 ;;  Screen width is 160px, each char is 8px, so there are 20 chars. Each bomberman cell is 2width*2height chars, so
                             27 ;;  20 width chars == 10 bomberman cells. 0.75 cell as left border + 3 cells as left extra info + 6 cells map + 0.25 cell as right border = 10 cells
                             28 ;;  1 cell = 2w char = 16px --> 3.75 cells on the left of the map = 3.75*16=60px. 
                             29 ;;  2px = 1 byte  --> 60px*1byte/2px=30bytes on the left of the map
                             30 ;;  Same reasoning for right border: 0.25cell=1char=4px=2byte of right border
                     001E    31 min_map_x_coord_valid = 30      ;;  [0-29] border, >=30 map
                     004E    32 max_map_x_coord_valid = 78    ;;  [78-79] border, <=77 map
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 .include "../cpct_functions.h.s"
                              1 
                              2 .globl  cpct_disableFirmware_asm
                              3 .globl  cpct_setVideoMode_asm
                              4 .globl  cpct_getScreenPtr_asm
                              5 .globl  cpct_waitVSYNC_asm
                              6 .globl  cpct_setPALColour_asm
                              7 .globl  cpct_getRandom_mxor_u8_asm
                              8 
                              9 .globl  cpct_drawSpriteBlended_asm
                             10 .globl  cpct_drawSolidBox_asm
                             11 .globl  cpct_drawSprite_asm
                             12 
                             13 .globl  cpct_scanKeyboard_f_asm
                             14 .globl  cpct_isKeyPressed_asm
                             15 
                             16 .globl  HW_BLACK
                             17 .globl  HW_WHITE
                             18 
                             19 .globl  CPCT_VMEM_START_ASM
                             20 .globl  Key_O
                             21 .globl  Key_P
                             22 .globl  Key_Q
                             23 .globl  Key_A
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                              9 
                             10 ;;########################################################
                             11 ;;                   PRIVATE FUNCTIONS                   #             
                             12 ;;########################################################
                             13 
                             14 ;;
                             15 ;;  INPUT:
                             16 ;;    ix  address memory where entity starts
                             17 ;;  RETURN: 
                             18 ;;    none
                             19 ;;  DESTROYED:
                             20 ;;    none
   40F6                      21 sys_physics_update_entity::
                             22   ;; Calculate the X coordinate where the entity should be positioned and stores result in B
   40F6 DD 7E 01      [19]   23   ld    a, e_x(ix)
   40F9 DD 86 05      [19]   24   add   e_vx(ix)
                             25   ;add   #2
   40FC 47            [ 4]   26   ld    b, a
                             27 
                             28   ;; Check is new X coordinate is greater than min allowed
                             29   ;; IF new(A)<min(B) THEN C-flag=1, new position is invalid, position is not updated
   40FD FE 1E         [ 7]   30   cp    #min_map_x_coord_valid
   40FF 38 0B         [12]   31   jr    c, check_y
                             32 
                             33   ;; Calculate max X coordinate where an entity could be
   4101 3E 4E         [ 7]   34   ld    a, #max_map_x_coord_valid
   4103 DD 96 03      [19]   35   sub   e_w(ix)  
                             36 
                             37   ;; Check is new X coordinate is smaller than max allowed
                             38   ;; IF new(B)>max(A) THEN C-flag=1, new position is invalid, position is not updated
   4106 B8            [ 4]   39   cp    b
   4107 38 03         [12]   40   jr    c, check_y
                             41 
   4109 DD 70 01      [19]   42   ld    e_x(ix), b    ;; Update X coordinate
                             43 
   410C                      44 check_y:
                             45   ;; Calculate the Y coordinate where the entity should be positioned and stores result in B
   410C DD 7E 02      [19]   46   ld    a, e_y(ix)
   410F DD 86 06      [19]   47   add   e_vy(ix)
   4112 47            [ 4]   48   ld    b, a
                             49 
                             50   ;; Check is new Y coordinate is greater than min allowed
                             51   ;; IF new(A)<min(B) THEN C-flag=1, new position is invalid, position is not updated
   4113 FE 04         [ 7]   52   cp    #min_map_y_coord_valid
   4115 D8            [11]   53   ret   c
                             54 
                             55   ;; Calculate max X coordinate where an entity could be
   4116 3E C4         [ 7]   56   ld    a, #max_map_y_coord_valid
   4118 DD 96 04      [19]   57   sub   e_h(ix)  
                             58 
                             59   ;; Check is new Y coordinate is smaller than max allowed
                             60   ;; IF new(B)>max(A) THEN C-flag=1, new position is invalid, position is not updated
   411B B8            [ 4]   61   cp    b
   411C D8            [11]   62   ret   c
                             63   
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   411D DD 70 02      [19]   64   ld    e_y(ix), b    ;; Update X coordinate
   4120 C9            [10]   65   ret
                             66 
                             67 
                             68 ;;
                             69 ;;  INPUT:
                             70 ;;    none
                             71 ;;  RETURN: 
                             72 ;;    none
                             73 ;;  DESTROYED:
                             74 ;;    A,BC,IX
   4121                      75 sys_physics_player_update::
   4121 CD 94 43      [17]   76   call  man_entity_get_player
   4124 CD F6 40      [17]   77   call  sys_physics_update_entity
   4127 C9            [10]   78   ret
                             79 
                             80 
                             81 ;;
                             82 ;;  INPUT:
                             83 ;;    none
                             84 ;;  RETURN: 
                             85 ;;    none
                             86 ;;  DESTROYED:
                             87 ;;    A,BC,IX
   4128                      88 sys_physics_enemies_update::
   4128 CD 99 43      [17]   89   call  man_entity_get_enemy_array
                             90 
   412B                      91 physics_enemies_loop:
   412B F5            [11]   92   push  af
                             93   
   412C CD F6 40      [17]   94   call  sys_physics_update_entity
                             95 
   412F 01 09 00      [10]   96   ld    bc, #sizeof_e
   4132 DD 09         [15]   97   add   ix, bc
                             98 
   4134 F1            [10]   99   pop   af
   4135 3D            [ 4]  100   dec   a
   4136 C8            [11]  101   ret   z
   4137 18 F2         [12]  102   jr    physics_enemies_loop
   4139 C9            [10]  103   ret
                            104 
                            105 
                            106 ;;
                            107 ;;  INPUT:
                            108 ;;    none
                            109 ;;  RETURN: 
                            110 ;;    none
                            111 ;;  DESTROYED:
                            112 ;;    none
   413A                     113 sys_physics_bomb_update::
   413A C9            [10]  114   ret
                            115 
                            116 
                            117 
                            118 ;;########################################################
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                            119 ;;                   PUBLIC FUNCTIONS                    #             
                            120 ;;########################################################
                            121 
                            122 ;;
                            123 ;;  none
                            124 ;;  INPUT:
                            125 ;;    none
                            126 ;;  RETURN: 
                            127 ;;    none
                            128 ;;  DESTROYED:
                            129 ;;    none
   413B                     130 sys_physics_init::
   413B C9            [10]  131   ret
                            132 
                            133 
   413C                     134 sys_physics_update::
   413C CD 21 41      [17]  135   call  sys_physics_player_update
   413F CD 28 41      [17]  136   call  sys_physics_enemies_update
   4142 CD 3A 41      [17]  137   call  sys_physics_bomb_update
   4145 C9            [10]  138   ret
                            139   
