ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;
                              2 ;;  ENTITY MANAGER
                              3 ;;
                              4 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              5 .include "entity_manager.h.s"
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



                              6 .include "game.h.s"
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



                              7 .include "../sys/render_system.h.s"
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
                             24 .globl  Key_R
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                              9 
                             10 
                             11 ;;########################################################
                             12 ;;                        VARIABLES                      #             
                             13 ;;########################################################
                             14 
   0000                      15 _player:  DefineEntity alive_type, 0, 0, 4, 16, 0, 0, 0xCCCC
   432A 01                    1     .db alive_type
   432B 00 00                 2     .db 0, 0
   432D 04 10                 3     .db 4, 16      ;; both in bytes
   432F 00 00                 4     .db 0, 0    
   4331 CC CC                 5     .dw 0xCCCC
   0009                      16 DefineEntityArray _enemy, max_entities, DefineEntityDefault
   4333 00                    1     _enemy_num:    .db 0    
   4334 36 43                 2     _enemy_last:   .dw _enemy_array
   4336                       3     _enemy_array: 
                              4     .rept max_entities    
                              5         DefineEntityDefault
                              6     .endm
   000C                       1         DefineEntityDefault
   4336 01                    1     .db alive_type
   4337 DE AD                 2     .db 0xDE, 0xAD
   4339 04 10                 3     .db 4, 16  
   433B DE AD                 4     .dw 0xADDE 
   433D CC CC                 5     .dw 0xCCCC
                             17 
   0015                      18 DefineBombArray _bomb, max_bombs, DefineBombDefault
   433F 00                    1     _bomb_num:    .db 0    
   4340 42 43                 2     _bomb_last:   .dw _bomb_array
   4342                       3     _bomb_array: 
                              4     .rept max_bombs    
                              5         DefineBombDefault
                              6     .endm
   0018                       1         DefineBombDefault
   4342 FF                    1     .db max_timer   ;; timer    
   4343 DE AD                 2     .db 0xDE,0xAD   ;; coordinates (x, y)
   4345 04 10                 3     .db #4, #16     ;; width, height -> both in bytes    
   4347 CC CC                 4     .dw 0xCCCC      ;; sprite  pointer (where it's in memory video)
                             19 
                             20 ;;########################################################
                             21 ;;                   PRIVATE FUNCTIONS                   #             
                             22 ;;########################################################
                             23 
                             24 ;;
                             25 ;;  Increases counter of entities and pointer to the last element.
                             26 ;;  INPUT:
                             27 ;;    none
                             28 ;;  RETURN: 
                             29 ;;    hl with memory address of free space for new entity
                             30 ;;    ix with memory address of last created entity
                             31 ;;  DESTROYED:
                             32 ;;    AF,DE,BC
   4349                      33 man_entity_new_entity::
   4349 3A 33 43      [13]   34   ld    a, (_enemy_num)
   434C 3C            [ 4]   35   inc   a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   434D 32 33 43      [13]   36   ld    (_enemy_num), a
                             37 
   4350 DD 2A 34 43   [20]   38   ld    ix, (_enemy_last)    
   4354 2A 34 43      [16]   39   ld    hl, (_enemy_last)    
   4357 01 09 00      [10]   40   ld    bc, #sizeof_e
   435A 09            [11]   41   add   hl, bc
   435B 22 34 43      [16]   42   ld    (_enemy_last), hl
   435E C9            [10]   43   ret
                             44 
                             45 ;;
                             46 ;;  Initialize data for all enemies and player.
                             47 ;;  INPUT:
                             48 ;;    ix  with memory address of entity that must be initialized
                             49 ;;    b   X coordinate
                             50 ;;    c   Y coordinate
                             51 ;;  RETURN: 
                             52 ;;    none
                             53 ;;  DESTROYED:
                             54 ;;    A
   435F                      55 man_entity_initialize_entity::  
   435F DD 36 00 01   [19]   56   ld    e_type(ix), #alive_type  
                             57   
   4363 DD 70 01      [19]   58   ld    e_x(ix), b        ;; set X coordiante
   4366 DD 71 02      [19]   59   ld    e_y(ix), c        ;; set Y coordiante
                             60 
   4369 DD 36 05 00   [19]   61   ld    e_vx(ix), #0      ;; set X velocity  
   436D DD 36 06 00   [19]   62   ld    e_vy(ix), #0      ;; set Y velocity    
                             63   
   4371 DD 36 03 04   [19]   64   ld    e_w(ix), #4       ;; set sprite width
   4375 DD 36 04 10   [19]   65   ld    e_h(ix), #16      ;; set sprite height
                             66 
   4379 C9            [10]   67   ret
                             68 
                             69 
                             70 ;;
                             71 ;;  Increases counter of bombs and pointer to the last element.
                             72 ;;  INPUT:
                             73 ;;    none
                             74 ;;  RETURN: 
                             75 ;;    hl with memory address of free space for new bomb
                             76 ;;    ix with memory address of last created bomb
                             77 ;;  DESTROYED:
                             78 ;;    A,BC
   437A                      79 man_entity_new_bomb::
   437A 3A 3F 43      [13]   80   ld    a, (_bomb_num)
   437D 3C            [ 4]   81   inc   a
   437E 32 3F 43      [13]   82   ld    (_bomb_num), a
                             83 
   4381 DD 2A 40 43   [20]   84   ld    ix, (_bomb_last)    
   4385 2A 40 43      [16]   85   ld    hl, (_bomb_last)    
   4388 01 07 00      [10]   86   ld    bc, #sizeof_b
   438B 09            [11]   87   add   hl, bc
   438C 22 40 43      [16]   88   ld    (_bomb_last), hl
   438F C9            [10]   89   ret
                             90 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                             91 ;;
                             92 ;;  Initialize data for all bombs.
                             93 ;;  INPUT:
                             94 ;;    ix  with memory address of entity that must be initialized
                             95 ;;    l   X coordinate where bomb must be positioned
                             96 ;;    h   Y coordinate where bomb must positioned
                             97 ;;  RETURN: 
                             98 ;;    none
                             99 ;;  DESTROYED:
                            100 ;;    A
   4390                     101 man_entity_initialize_bomb::    
   4390 DD 75 01      [19]  102   ld    b_x(ix), l                  ;; set X velocity  
   4393 DD 74 02      [19]  103   ld    b_y(ix), h                  ;; set Y velocity    
                            104   
   4396 DD 36 03 04   [19]  105   ld    b_w(ix), #4                 ;; set sprite width
   439A DD 36 04 10   [19]  106   ld    b_h(ix), #16                ;; set sprite height
                            107       
   439E DD 36 00 FF   [19]  108   ld    b_timer(ix), #max_timer     ;; set timer
   43A2 C9            [10]  109   ret
                            110 
                            111 
   43A3                     112 man_entity_init_player::
   43A3 DD 21 2A 43   [14]  113   ld    ix, #_player
   43A7 06 1E         [ 7]  114   ld    b, #min_map_x_coord_valid
   43A9 0E 04         [ 7]  115   ld    c, #min_map_y_coord_valid
   43AB CD 5F 43      [17]  116   call  man_entity_initialize_entity
   43AE C9            [10]  117   ret
                            118 
                            119 ;;
                            120 ;;  Initialize data for all enemies and player.
                            121 ;;  INPUT:
                            122 ;;    none
                            123 ;;  RETURN: 
                            124 ;;    hl with memory address of free space for new entity
                            125 ;;    ix with memory address of last created entity
                            126 ;;  DESTROYED:
                            127 ;;    AF,DE,IX,HL,BC
   43AF                     128 man_entity_init_entities::
   43AF 3E 01         [ 7]  129   ld    a, #max_entities
   43B1 ED 5B 34 43   [20]  130   ld    de, (_enemy_last)
   43B5                     131 init_loop:
   43B5 F5            [11]  132   push  af
                            133   
   43B6 CD 49 43      [17]  134   call  man_entity_new_entity
                            135 
   43B9 06 1E         [ 7]  136   ld    b, #min_map_x_coord_valid
   43BB 0E D4         [ 7]  137   ld    c, #max_map_y_coord_valid-move_up
   43BD CD 5F 43      [17]  138   call  man_entity_initialize_entity
                            139   
   43C0 F1            [10]  140   pop   af
   43C1 3D            [ 4]  141   dec   a
   43C2 C8            [11]  142   ret   z
   43C3 18 F0         [12]  143   jr    init_loop
                            144 
                            145 ;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



                            146 ;;  Reset bombs data
                            147 ;;  INPUT:
                            148 ;;    none
                            149 ;;  RETURN: 
                            150 ;;    none
                            151 ;;  DESTROYED:
                            152 ;;    A,HL
   43C5                     153 man_entity_init_bombs::
   43C5 3E 00         [ 7]  154   ld    a, #0
   43C7 32 3F 43      [13]  155   ld    (_bomb_num), a
                            156 
   43CA 21 42 43      [10]  157   ld    hl, #_bomb_array
   43CD 22 40 43      [16]  158   ld    (_bomb_last), hl
   43D0 C9            [10]  159   ret
                            160 
                            161 
   43D1                     162 man_entity_player_update::
   43D1 C9            [10]  163   ret
                            164 
                            165 
   43D2                     166 man_entity_enemies_update::
   43D2 DD 21 36 43   [14]  167   ld    ix, #_enemy_array
   43D6 3A 33 43      [13]  168   ld     a, (_enemy_num)
   43D9 B7            [ 4]  169   or     a
   43DA C8            [11]  170   ret    z
                            171 
   43DB                     172   enemies_update_loop:
   43DB F5            [11]  173     push  af
                            174     
   43DC DD 7E 00      [19]  175     ld    a, e_type(ix)         ;; load type of entity
   43DF E6 FE         [ 7]  176     and    #dead_type            ;; entity_type AND dead_type
                            177 
   43E1 28 2F         [12]  178     jr    z, enemies_increase_index
   43E3 CD 83 42      [17]  179     call  sys_render_remove_entity
                            180 
                            181     ;; _last_element_ptr now points to the last entity in the array
                            182     ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   43E6 3A 34 43      [13]  183     ld    a, (_enemy_last)
   43E9 D6 09         [ 7]  184     sub   #sizeof_e
   43EB 32 34 43      [13]  185     ld    (_enemy_last), a
   43EE DA F4 43      [10]  186     jp    c, enemies_overflow_update
   43F1 C3 FB 43      [10]  187     jp    enemies_no_overflow_update    
                            188     
   43F4                     189   enemies_overflow_update:
   43F4 3A 35 43      [13]  190     ld    a, (_enemy_last+1)
   43F7 3D            [ 4]  191     dec   a
   43F8 32 35 43      [13]  192     ld    (_enemy_last+1), a
                            193 
   43FB                     194   enemies_no_overflow_update:
                            195     ;; move the last element to the hole left by the dead entity
   43FB DD E5         [15]  196     push  ix  
   43FD E1            [10]  197     pop   hl
   43FE 01 09 00      [10]  198     ld    bc, #sizeof_e       
   4401 ED 5B 34 43   [20]  199     ld    de, (_enemy_last)
   4405 EB            [ 4]  200     ex    de, hl
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



   4406 ED B0         [21]  201     ldir                        
                            202     
   4408 3A 33 43      [13]  203     ld    a, (_enemy_num)
   440B 3D            [ 4]  204     dec   a
   440C 32 33 43      [13]  205     ld    (_enemy_num), a  
                            206 
   440F C3 17 44      [10]  207     jp    enemies_continue_update
                            208 
   4412                     209   enemies_increase_index:
   4412 01 09 00      [10]  210     ld    bc, #sizeof_e
   4415 DD 09         [15]  211     add   ix, bc
   4417                     212   enemies_continue_update:
   4417 F1            [10]  213     pop   af
   4418 3D            [ 4]  214     dec   a
   4419 C8            [11]  215     ret   z
   441A C3 DB 43      [10]  216     jp    enemies_update_loop
   441D C9            [10]  217   ret
                            218 
                            219 
   441E                     220 man_entity_bombs_update::
   441E DD 21 42 43   [14]  221   ld    ix, #_bomb_array
   4422 3A 3F 43      [13]  222   ld     a, (_bomb_num)
   4425 B7            [ 4]  223   or     a
   4426 C8            [11]  224   ret    z
                            225 
   4427                     226   bombs_update_loop:
   4427 F5            [11]  227     push  af
                            228     
   4428 DD 7E 00      [19]  229     ld    a, b_timer(ix)         ;; load timer of bomb
   442B E6 00         [ 7]  230     and   #zero_timer            ;; _bomb_timer AND zero_timer
                            231 
   442D 28 2F         [12]  232     jr    z, bombs_increase_index
   442F CD 95 42      [17]  233     call  sys_render_remove_bomb
                            234 
                            235     ;; _last_element_ptr now points to the last entity in the array
                            236     ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   4432 3A 40 43      [13]  237     ld    a, (_bomb_last)
   4435 D6 07         [ 7]  238     sub   #sizeof_b
   4437 32 40 43      [13]  239     ld    (_bomb_last), a
   443A DA 40 44      [10]  240     jp    c, bombs_overflow_update
   443D C3 47 44      [10]  241     jp    bombs_no_overflow_update    
                            242     
   4440                     243   bombs_overflow_update:
   4440 3A 41 43      [13]  244     ld    a, (_bomb_last+1)
   4443 3D            [ 4]  245     dec   a
   4444 32 41 43      [13]  246     ld    (_bomb_last+1), a
                            247 
   4447                     248   bombs_no_overflow_update:
                            249     ;; move the last element to the hole left by the dead entity
   4447 DD E5         [15]  250     push  ix  
   4449 E1            [10]  251     pop   hl
   444A 01 07 00      [10]  252     ld    bc, #sizeof_b       
   444D ED 5B 40 43   [20]  253     ld    de, (_bomb_last)
   4451 EB            [ 4]  254     ex    de, hl
   4452 ED B0         [21]  255     ldir                        
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



                            256     
   4454 3A 3F 43      [13]  257     ld    a, (_bomb_num)
   4457 3D            [ 4]  258     dec   a
   4458 32 3F 43      [13]  259     ld    (_bomb_num), a  
                            260 
   445B C3 63 44      [10]  261     jp    bombs_continue_update
                            262 
   445E                     263   bombs_increase_index:
   445E 01 07 00      [10]  264     ld    bc, #sizeof_b
   4461 DD 09         [15]  265     add   ix, bc
   4463                     266   bombs_continue_update:
   4463 F1            [10]  267     pop   af
   4464 3D            [ 4]  268     dec   a
   4465 C8            [11]  269     ret   z
   4466 C3 27 44      [10]  270     jp    bombs_update_loop  
   4469 C9            [10]  271   ret
                            272 
                            273 ;;########################################################
                            274 ;;                   PUBLIC FUNCTIONS                    #             
                            275 ;;########################################################
                            276 
                            277 ;;
                            278 ;;  Initialize data for all enemies, player and reset bombs data.
                            279 ;;  INPUT:
                            280 ;;    none
                            281 ;;  RETURN: 
                            282 ;;    none
                            283 ;;  DESTROYED:
                            284 ;;    AF,DE,IX,HL,BC
   446A                     285 man_entity_init::
   446A CD A3 43      [17]  286   call  man_entity_init_player
   446D CD AF 43      [17]  287   call  man_entity_init_entities
   4470 CD C5 43      [17]  288   call  man_entity_init_bombs
   4473 C9            [10]  289   ret
                            290 
                            291 
                            292 ;;
                            293 ;;  INPUT:
                            294 ;;    none
                            295 ;;  RETURN: 
                            296 ;;    none
                            297 ;;  DESTROYED:
                            298 ;;    AF,DE,IX,HL,BC
   4474                     299 man_entity_update::
   4474 CD D1 43      [17]  300   call  man_entity_player_update
   4477 CD D2 43      [17]  301   call  man_entity_enemies_update
   447A CD 1E 44      [17]  302   call  man_entity_bombs_update
   447D C9            [10]  303   ret
                            304 
                            305 
                            306 ;;
                            307 ;;  INPUT:
                            308 ;;    none
                            309 ;;  RETURN: 
                            310 ;;    hl with memory address of free space for new entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 13.
Hexadecimal [16-Bits]



                            311 ;;    ix with memory address of last created entity
                            312 ;;  DESTROYED:
                            313 ;;    A,HL,BC
   447E                     314 man_entity_create_entity::  
   447E 3E 01         [ 7]  315   ld    a, #max_entities
   4480 21 33 43      [10]  316   ld    hl, #_enemy_num
   4483 BE            [ 7]  317   cp   (hl)                  ;; max_entities - _enemy_num
   4484 C8            [11]  318   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                            319 
   4485 CD 49 43      [17]  320   call  man_entity_new_entity
   4488 CD 5F 43      [17]  321   call  man_entity_initialize_entity
   448B C9            [10]  322   ret
                            323 
                            324 
                            325 ;;
                            326 ;;  INPUT:
                            327 ;;    none
                            328 ;;  RETURN: 
                            329 ;;    hl with memory address of free space for new bomb
                            330 ;;    ix with memory address of last created bomb
                            331 ;;  DESTROYED:
                            332 ;;    A,HL,BC
   448C                     333 man_entity_create_bomb::  
   448C 3E 01         [ 7]  334   ld    a, #max_bombs
   448E 21 3F 43      [10]  335   ld    hl, #_bomb_num
   4491 BE            [ 7]  336   cp   (hl)                  ;; max_bombs - _bomb_num
   4492 C8            [11]  337   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                            338 
   4493 CD 8C 44      [17]  339   call  man_entity_create_bomb
   4496 CD 90 43      [17]  340   call  man_entity_initialize_bomb
   4499 C9            [10]  341   ret
                            342 
                            343 
                            344 ;;
                            345 ;;  INPUT:
                            346 ;;    none
                            347 ;;  RETURN: 
                            348 ;;    ix with memory address of player
                            349 ;;  DESTROYED:
                            350 ;;    none
   449A                     351 man_entity_get_player::
   449A DD 21 2A 43   [14]  352   ld    ix, #_player
   449E C9            [10]  353   ret
                            354 
                            355 
                            356 ;;
                            357 ;;  INPUT:
                            358 ;;    none
                            359 ;;  RETURN: 
                            360 ;;    ix  begin of enemy array memory address
                            361 ;;    a   number of enemies in the array
                            362 ;;  DESTROYED:
                            363 ;;    none
   449F                     364 man_entity_get_enemy_array::
   449F DD 21 36 43   [14]  365   ld    ix, #_enemy_array
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 14.
Hexadecimal [16-Bits]



   44A3 3A 33 43      [13]  366   ld     a, (_enemy_num)
   44A6 C9            [10]  367   ret
                            368 
                            369 
                            370 ;;
                            371 ;;  INPUT:
                            372 ;;    none
                            373 ;;  RETURN: 
                            374 ;;    ix  begin of bomb array memory address
                            375 ;;    a   number of bombs in the array
                            376 ;;  DESTROYED:
                            377 ;;    none
   44A7                     378 man_entity_get_bomb_array::
   44A7 DD 21 42 43   [14]  379   ld    ix, #_bomb_array
   44AB 3A 3F 43      [13]  380   ld     a, (_bomb_num)
   44AE C9            [10]  381   ret
                            382 
                            383 
                            384 ;;
                            385 ;;  INPUT:
                            386 ;;    none
                            387 ;;  RETURN: 
                            388 ;;    ix  begin of player memory address
                            389 ;;  DESTROYED:
                            390 ;;    A
   44AF                     391 man_entity_set_player_dead::
   44AF DD 21 2A 43   [14]  392   ld    ix, #_player
   44B3 3E FE         [ 7]  393   ld     a, #dead_type
   44B5 DD 77 00      [19]  394   ld    e_type(ix), a
   44B8 C9            [10]  395   ret
                            396 
                            397 
                            398 ;;
                            399 ;;  INPUT:
                            400 ;;    ix with memory address of entity that must me marked as dead
                            401 ;;  RETURN: 
                            402 ;;    none
                            403 ;;  DESTROYED:
                            404 ;;    A
   44B9                     405 man_entity_set_enemy_dead::
   44B9 3E FE         [ 7]  406   ld    a, #dead_type
   44BB DD 77 00      [19]  407   ld    e_type(ix), a
   44BE C9            [10]  408   ret
                            409 
                            410 
   44BF                     411 man_entity_terminate::
   44BF 3E 36         [ 7]  412   ld  a, #_enemy_array
   44C1 32 34 43      [13]  413   ld  (_enemy_last), a
                            414 
   44C4 3E 00         [ 7]  415   ld  a, #0
   44C6 32 33 43      [13]  416   ld  (_enemy_num), a
                            417 
   44C9 3E 42         [ 7]  418   ld  a, #_bomb_array
   44CB 32 40 43      [13]  419   ld  (_bomb_last), a
                            420 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 15.
Hexadecimal [16-Bits]



   44CE 3E 00         [ 7]  421   ld  a, #0
   44D0 32 3F 43      [13]  422   ld  (_bomb_num), a
   44D3 C9            [10]  423   ret
