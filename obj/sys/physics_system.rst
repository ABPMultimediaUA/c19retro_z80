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



                              7 .include "physics_system.h.s"
                              1 ;;
                              2 ;;  PHYSICS SYSTEM HEADER
                              3 ;;
                              4 
                              5 .globl  sys_physics_init
                              6 .globl  sys_physics_update
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 .include "render_system.h.s"
                              1 ;;
                              2 ;;  RENDER SYSTEM HEADER
                              3 ;;
                              4 
                              5 .globl  sys_render_init
                              6 .globl  sys_render_update
                              7 .globl  sys_render_remove_entity
                              8 .globl  sys_render_remove_bomb
                              9 .globl  sys_render_map
                             10 
                             11 
                             12 ;;########################################################
                             13 ;;                       CONSTANTS                       #             
                             14 ;;########################################################
                     0000    15 video_mode = 0
                             16 
                             17 ;;  In pixels
                     00A0    18 screen_width = 160
                     00C8    19 screen_height = 200
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                              9 .include "../cpct_functions.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                             10 
                             11 ;;########################################################
                             12 ;;                   PRIVATE FUNCTIONS                   #             
                             13 ;;########################################################
                             14 
                             15 ;;
                             16 ;;  INPUT:
                             17 ;;    ix  address memory where entity starts
                             18 ;;  RETURN: 
                             19 ;;    none
                             20 ;;  DESTROYED:
                             21 ;;    none
   411A                      22 sys_physics_update_entity::
                             23   ;; Calculate the X coordinate where the entity should be positioned and stores result in B
   411A DD 7E 01      [19]   24   ld    a, e_x(ix)
   411D DD 86 05      [19]   25   add   e_vx(ix)
                             26   ;add   #2
   4120 47            [ 4]   27   ld    b, a
                             28 
                             29   ;; Check is new X coordinate is greater than min allowed
                             30   ;; IF new(A)<min(B) THEN C-flag=1, new position is invalid, position is not updated
   4121 FE 1E         [ 7]   31   cp    #min_map_x_coord_valid
   4123 38 0B         [12]   32   jr    c, check_y
                             33 
                             34   ;; Calculate max X coordinate where an entity could be
   4125 3E 4E         [ 7]   35   ld    a, #max_map_x_coord_valid
   4127 DD 96 03      [19]   36   sub   e_w(ix)  
                             37 
                             38   ;; Check is new X coordinate is smaller than max allowed
                             39   ;; IF new(B)>max(A) THEN C-flag=1, new position is invalid, position is not updated
   412A B8            [ 4]   40   cp    b
   412B 38 03         [12]   41   jr    c, check_y
                             42 
   412D DD 70 01      [19]   43   ld    e_x(ix), b    ;; Update X coordinate
                             44 
   4130                      45 check_y:
                             46   ;; Calculate the Y coordinate where the entity should be positioned and stores result in B
   4130 DD 7E 02      [19]   47   ld    a, e_y(ix)
   4133 DD 86 06      [19]   48   add   e_vy(ix)
   4136 47            [ 4]   49   ld    b, a
                             50 
                             51   ;; Check is new Y coordinate is greater than min allowed
                             52   ;; IF new(A)<min(B) THEN C-flag=1, new position is invalid, position is not updated
   4137 FE 04         [ 7]   53   cp    #min_map_y_coord_valid
   4139 D8            [11]   54   ret   c
                             55 
                             56   ;; Calculate max X coordinate where an entity could be
   413A 3E C4         [ 7]   57   ld    a, #max_map_y_coord_valid
   413C DD 96 04      [19]   58   sub   e_h(ix)  
                             59 
                             60   ;; Check is new Y coordinate is smaller than max allowed
                             61   ;; IF new(B)>max(A) THEN C-flag=1, new position is invalid, position is not updated
   413F B8            [ 4]   62   cp    b
   4140 D8            [11]   63   ret   c
                             64   
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



   4141 DD 70 02      [19]   65   ld    e_y(ix), b    ;; Update X coordinate
   4144 C9            [10]   66   ret
                             67 
                             68 
                             69 ;;
                             70 ;;  INPUT:
                             71 ;;    none
                             72 ;;  RETURN: 
                             73 ;;    none
                             74 ;;  DESTROYED:
                             75 ;;    A,BC,IX
   4145                      76 sys_physics_player_update::
                     002D    77   player_ptr = .+2
   4145 DD 21 00 00   [14]   78   ld    ix, #0x0000  
   4149 CD 1A 41      [17]   79   call  sys_physics_update_entity
   414C C9            [10]   80   ret
                             81 
                             82 
                             83 ;;
                             84 ;;  INPUT:
                             85 ;;    none
                             86 ;;  RETURN: 
                             87 ;;    none
                             88 ;;  DESTROYED:
                             89 ;;    A,BC,IX
   414D                      90 sys_physics_enemies_update::
                     0035    91   enemy_ptr = .+2
   414D DD 21 00 00   [14]   92   ld    ix, #0x0000
                     0038    93   enemy_num = .+1
   4151 3E 00         [ 7]   94   ld     a, #0
                             95 
   4153                      96 physics_enemies_loop:
   4153 F5            [11]   97   push  af
                             98   
   4154 CD 1A 41      [17]   99   call  sys_physics_update_entity
                            100 
   4157 01 09 00      [10]  101   ld    bc, #sizeof_e
   415A DD 09         [15]  102   add   ix, bc
                            103 
   415C F1            [10]  104   pop   af
   415D 3D            [ 4]  105   dec   a
   415E C8            [11]  106   ret   z
   415F 18 F2         [12]  107   jr    physics_enemies_loop
   4161 C9            [10]  108   ret
                            109 
                            110 
                            111 ;;
                            112 ;;  INPUT:
                            113 ;;    none
                            114 ;;  RETURN: 
                            115 ;;    none
                            116 ;;  DESTROYED:
                            117 ;;    none
   4162                     118 sys_physics_bomb_update::
   4162 C9            [10]  119   ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



                            120 
                            121 
                            122 
                            123 ;;########################################################
                            124 ;;                   PUBLIC FUNCTIONS                    #             
                            125 ;;########################################################
                            126 
                            127 ;;
                            128 ;;  none
                            129 ;;  INPUT:
                            130 ;;    none
                            131 ;;  RETURN: 
                            132 ;;    none
                            133 ;;  DESTROYED:
                            134 ;;    none
   4163                     135 sys_physics_init::
   4163 CD 9A 44      [17]  136   call  man_entity_get_player
   4166 DD 22 47 41   [20]  137   ld    (player_ptr), ix
                            138 
   416A CD 9F 44      [17]  139   call  man_entity_get_enemy_array
   416D DD 22 4F 41   [20]  140   ld    (enemy_ptr), ix
   4171 32 52 41      [13]  141   ld    (enemy_num), a
   4174 C9            [10]  142   ret
                            143 
                            144 
   4175                     145 sys_physics_update::
   4175 CD 45 41      [17]  146   call  sys_physics_player_update
   4178 CD 4D 41      [17]  147   call  sys_physics_enemies_update
   417B CD 62 41      [17]  148   call  sys_physics_bomb_update
   417E C9            [10]  149   ret
                            150   
