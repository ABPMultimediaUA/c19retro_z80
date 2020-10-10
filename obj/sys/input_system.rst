ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;
                              2 ;;  INPUT SYSTEM
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
                              6 .globl  man_entity_update
                              7 .globl  man_entity_terminate
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



                              6 .include "../man/game.h.s"
                              1 ;;
                              2 ;;  GAME MANAGER HEADER
                              3 ;;
                              4 
                              5 .globl  man_game_init
                              6 .globl  man_game_update
                              7 .globl  man_game_terminate
                              8 
                              9 
                             10 ;;########################################################
                             11 ;;                       CONSTANTS                       #             
                             12 ;;########################################################
                             13 
                             14 ;; in bytes
                     0004    15 move_right = 4
                     FFFFFFFC    16 move_left = -move_right
                     0010    17 move_down = 16
                     FFFFFFF0    18 move_up = -move_down
                             19 
                             20 
                             21 
                             22 ;;  In bytes
                             23 ;;  The max constants are max+1 because this way they represent the first pixel where border begins.
                             24 ;;  This way, when calculating the last allowed position where an entity may be positioned, it is easier and cleaner.
                     0004    25 min_map_y_coord_valid = 4     ;;  [0-3] border, >=4 map
                     00C4    26 max_map_y_coord_valid = 196    ;;  [196-199] border, <=195 map
                             27 
                             28 ;;  Screen width is 160px, each char is 8px, so there are 20 chars. Each bomberman cell is 2width*2height chars, so
                             29 ;;  20 width chars == 10 bomberman cells. 0.75 cell as left border + 3 cells as left extra info + 6 cells map + 0.25 cell as right border = 10 cells
                             30 ;;  1 cell = 2w char = 16px --> 3.75 cells on the left of the map = 3.75*16=60px. 
                             31 ;;  2px = 1 byte  --> 60px*1byte/2px=30bytes on the left of the map
                             32 ;;  Same reasoning for right border: 0.25cell=1char=4px=2byte of right border
                     001E    33 min_map_x_coord_valid = 30      ;;  [0-29] border, >=30 map
                     004E    34 max_map_x_coord_valid = 78    ;;  [78-79] border, <=77 map
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
                             24 .globl  Key_R
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 .include "input_system.h.s"
                              1 ;;
                              2 ;;  INPUT SYSTEM HEADER
                              3 ;;
                              4 
                              5 .globl  sys_input_init
                              6 .globl  sys_input_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                              9 
                             10 ;;########################################################
                             11 ;;                   PRIVATE FUNCTIONS                   #             
                             12 ;;########################################################
                             13 
                             14 
                             15 ;;########################################################
                             16 ;;                   PUBLIC FUNCTIONS                    #             
                             17 ;;########################################################
                             18 
                             19 ;;
                             20 ;;  INPUT:
                             21 ;;    none
                             22 ;;  RETURN: 
                             23 ;;    none
                             24 ;;  DESTROYED:
                             25 ;;    IX
   413F                      26 sys_input_init::
   413F CD C3 43      [17]   27   call  man_entity_get_player
   4142 DD 22 49 41   [20]   28   ld    (player_ptr), ix
   4146 C9            [10]   29   ret
                             30 
                             31 
                             32 ;;
                             33 ;;  INPUT:
                             34 ;;    none
                             35 ;;  RETURN: 
                             36 ;;    none
                             37 ;;  DESTROYED:
                             38 ;;    none
   4147                      39 sys_input_update::  
                     000A    40   player_ptr = .+2
   4147 DD 21 00 00   [14]   41   ld    ix, #0x0000    
                             42 
                             43   ;; Reset velocities
   414B DD 36 05 00   [19]   44   ld    e_vx(ix), #0
   414F DD 36 06 00   [19]   45   ld    e_vy(ix), #0
                             46 
   4153 CD 2D 44      [17]   47   call  cpct_scanKeyboard_f_asm
                             48 
   4156 21 04 04      [10]   49   ld    hl, #Key_O
   4159 CD 97 44      [17]   50   call  cpct_isKeyPressed_asm
   415C 28 05         [12]   51   jr    z, O_NotPressed
   415E                      52 O_Pressed:
   415E DD 36 05 FC   [19]   53   ld    e_vx(ix), #move_left
   4162 C9            [10]   54   ret
   4163                      55 O_NotPressed:
                             56 
   4163 21 03 08      [10]   57   ld    hl, #Key_P
   4166 CD 97 44      [17]   58   call  cpct_isKeyPressed_asm
   4169 28 05         [12]   59   jr    z, P_NotPressed
   416B                      60 P_Pressed:
   416B DD 36 05 04   [19]   61   ld    e_vx(ix), #move_right
   416F C9            [10]   62   ret
   4170                      63 P_NotPressed:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                             64 
   4170 21 08 08      [10]   65   ld    hl, #Key_Q
   4173 CD 97 44      [17]   66   call  cpct_isKeyPressed_asm
   4176 28 05         [12]   67   jr    z, Q_NotPressed
   4178                      68 Q_Pressed:
   4178 DD 36 06 F0   [19]   69   ld    e_vy(ix), #move_up
   417C C9            [10]   70   ret
   417D                      71 Q_NotPressed:
                             72 
   417D 21 08 20      [10]   73   ld    hl, #Key_A
   4180 CD 97 44      [17]   74   call  cpct_isKeyPressed_asm
   4183 28 05         [12]   75   jr    z, A_NotPressed
   4185                      76 A_Pressed:
   4185 DD 36 06 10   [19]   77   ld    e_vy(ix), #move_down    
   4189 C9            [10]   78   ret
   418A                      79 A_NotPressed:    
   418A 21 06 04      [10]   80   ld    hl, #Key_R
   418D CD 97 44      [17]   81   call  cpct_isKeyPressed_asm
   4190 28 03         [12]   82   jr    z, R_NotPressed
   4192                      83 R_Pressed:
   4192 CD 26 44      [17]   84   call  man_game_terminate
   4195                      85 R_NotPressed:
   4195 C9            [10]   86   ret
