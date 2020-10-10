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
   4253 01                    1     .db alive_type
   4254 00 00                 2     .db 0, 0
   4256 04 10                 3     .db 4, 16      ;; both in bytes
   4258 00 00                 4     .db 0, 0    
   425A CC CC                 5     .dw 0xCCCC
   0009                      16 DefineEntityArray _enemy, max_entities, DefineEntityDefault
   425C 00                    1     _enemy_num:    .db 0    
   425D 5F 42                 2     _enemy_last:   .dw _enemy_array
   425F                       3     _enemy_array: 
                              4     .rept max_entities    
                              5         DefineEntityDefault
                              6     .endm
   000C                       1         DefineEntityDefault
   425F 01                    1     .db alive_type
   4260 DE AD                 2     .db 0xDE, 0xAD
   4262 04 10                 3     .db 4, 16  
   4264 DE AD                 4     .dw 0xADDE 
   4266 CC CC                 5     .dw 0xCCCC
                             17 
   0015                      18 DefineBombArray _bomb, max_bombs, DefineBombDefault
   4268 00                    1     _bomb_num:    .db 0    
   4269 6B 42                 2     _bomb_last:   .dw _bomb_array
   426B                       3     _bomb_array: 
                              4     .rept max_bombs    
                              5         DefineBombDefault
                              6     .endm
   0018                       1         DefineBombDefault
   426B FF                    1     .db max_timer   ;; timer    
   426C DE AD                 2     .db 0xDE,0xAD   ;; coordinates (x, y)
   426E 04 10                 3     .db #4, #16     ;; width, height -> both in bytes    
   4270 CC CC                 4     .dw 0xCCCC      ;; sprite  pointer (where it's in memory video)
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
   4272                      33 man_entity_new_entity::
   4272 3A 5C 42      [13]   34   ld    a, (_enemy_num)
   4275 3C            [ 4]   35   inc   a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



   4276 32 5C 42      [13]   36   ld    (_enemy_num), a
                             37 
   4279 DD 2A 5D 42   [20]   38   ld    ix, (_enemy_last)    
   427D 2A 5D 42      [16]   39   ld    hl, (_enemy_last)    
   4280 01 09 00      [10]   40   ld    bc, #sizeof_e
   4283 09            [11]   41   add   hl, bc
   4284 22 5D 42      [16]   42   ld    (_enemy_last), hl
   4287 C9            [10]   43   ret
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
   4288                      55 man_entity_initialize_entity::  
   4288 DD 36 00 01   [19]   56   ld    e_type(ix), #alive_type  
                             57   
   428C DD 70 01      [19]   58   ld    e_x(ix), b        ;; set X coordiante
   428F DD 71 02      [19]   59   ld    e_y(ix), c        ;; set Y coordiante
                             60 
   4292 DD 36 05 00   [19]   61   ld    e_vx(ix), #0      ;; set X velocity  
   4296 DD 36 06 00   [19]   62   ld    e_vy(ix), #0      ;; set Y velocity    
                             63   
   429A DD 36 03 04   [19]   64   ld    e_w(ix), #4       ;; set sprite width
   429E DD 36 04 10   [19]   65   ld    e_h(ix), #16      ;; set sprite height
                             66 
   42A2 C9            [10]   67   ret
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
   42A3                      79 man_entity_new_bomb::
   42A3 3A 68 42      [13]   80   ld    a, (_bomb_num)
   42A6 3C            [ 4]   81   inc   a
   42A7 32 68 42      [13]   82   ld    (_bomb_num), a
                             83 
   42AA DD 2A 69 42   [20]   84   ld    ix, (_bomb_last)    
   42AE 2A 69 42      [16]   85   ld    hl, (_bomb_last)    
   42B1 01 07 00      [10]   86   ld    bc, #sizeof_b
   42B4 09            [11]   87   add   hl, bc
   42B5 22 69 42      [16]   88   ld    (_bomb_last), hl
   42B8 C9            [10]   89   ret
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
   42B9                     101 man_entity_initialize_bomb::    
   42B9 DD 75 01      [19]  102   ld    b_x(ix), l                  ;; set X velocity  
   42BC DD 74 02      [19]  103   ld    b_y(ix), h                  ;; set Y velocity    
                            104   
   42BF DD 36 03 04   [19]  105   ld    b_w(ix), #4                 ;; set sprite width
   42C3 DD 36 04 10   [19]  106   ld    b_h(ix), #16                ;; set sprite height
                            107       
   42C7 DD 36 00 FF   [19]  108   ld    b_timer(ix), #max_timer     ;; set timer
   42CB C9            [10]  109   ret
                            110 
                            111 
   42CC                     112 man_entity_init_player::
   42CC DD 21 53 42   [14]  113   ld    ix, #_player
   42D0 06 1E         [ 7]  114   ld    b, #min_map_x_coord_valid
   42D2 0E 04         [ 7]  115   ld    c, #min_map_y_coord_valid
   42D4 CD 88 42      [17]  116   call  man_entity_initialize_entity
   42D7 C9            [10]  117   ret
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
   42D8                     128 man_entity_init_entities::
   42D8 3E 01         [ 7]  129   ld    a, #max_entities
   42DA ED 5B 5D 42   [20]  130   ld    de, (_enemy_last)
   42DE                     131 init_loop:
   42DE F5            [11]  132   push  af
                            133   
   42DF CD 72 42      [17]  134   call  man_entity_new_entity
                            135 
   42E2 06 1E         [ 7]  136   ld    b, #min_map_x_coord_valid
   42E4 0E D4         [ 7]  137   ld    c, #max_map_y_coord_valid-move_up
   42E6 CD 88 42      [17]  138   call  man_entity_initialize_entity
                            139   
   42E9 F1            [10]  140   pop   af
   42EA 3D            [ 4]  141   dec   a
   42EB C8            [11]  142   ret   z
   42EC 18 F0         [12]  143   jr    init_loop
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
   42EE                     153 man_entity_init_bombs::
   42EE 3E 00         [ 7]  154   ld    a, #0
   42F0 32 68 42      [13]  155   ld    (_bomb_num), a
                            156 
   42F3 21 6B 42      [10]  157   ld    hl, #_bomb_array
   42F6 22 69 42      [16]  158   ld    (_bomb_last), hl
   42F9 C9            [10]  159   ret
                            160 
                            161 
   42FA                     162 man_entity_player_update::
   42FA C9            [10]  163   ret
                            164 
                            165 
   42FB                     166 man_entity_enemies_update::
   42FB DD 21 5F 42   [14]  167   ld    ix, #_enemy_array
   42FF 3A 5C 42      [13]  168   ld     a, (_enemy_num)
   4302 B7            [ 4]  169   or     a
   4303 C8            [11]  170   ret    z
                            171 
   4304                     172   enemies_update_loop:
   4304 F5            [11]  173     push  af
                            174     
   4305 DD 7E 00      [19]  175     ld    a, e_type(ix)         ;; load type of entity
   4308 E6 FE         [ 7]  176     and    #dead_type            ;; entity_type AND dead_type
                            177 
   430A 28 2F         [12]  178     jr    z, enemies_increase_index
   430C CD 40 42      [17]  179     call  sys_render_remove_entity
                            180 
                            181     ;; _last_element_ptr now points to the last entity in the array
                            182     ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   430F 3A 5D 42      [13]  183     ld    a, (_enemy_last)
   4312 D6 09         [ 7]  184     sub   #sizeof_e
   4314 32 5D 42      [13]  185     ld    (_enemy_last), a
   4317 DA 1D 43      [10]  186     jp    c, enemies_overflow_update
   431A C3 24 43      [10]  187     jp    enemies_no_overflow_update    
                            188     
   431D                     189   enemies_overflow_update:
   431D 3A 5E 42      [13]  190     ld    a, (_enemy_last+1)
   4320 3D            [ 4]  191     dec   a
   4321 32 5E 42      [13]  192     ld    (_enemy_last+1), a
                            193 
   4324                     194   enemies_no_overflow_update:
                            195     ;; move the last element to the hole left by the dead entity
   4324 DD E5         [15]  196     push  ix  
   4326 E1            [10]  197     pop   hl
   4327 01 09 00      [10]  198     ld    bc, #sizeof_e       
   432A ED 5B 5D 42   [20]  199     ld    de, (_enemy_last)
   432E EB            [ 4]  200     ex    de, hl
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



   432F ED B0         [21]  201     ldir                        
                            202     
   4331 3A 5C 42      [13]  203     ld    a, (_enemy_num)
   4334 3D            [ 4]  204     dec   a
   4335 32 5C 42      [13]  205     ld    (_enemy_num), a  
                            206 
   4338 C3 40 43      [10]  207     jp    enemies_continue_update
                            208 
   433B                     209   enemies_increase_index:
   433B 01 09 00      [10]  210     ld    bc, #sizeof_e
   433E DD 09         [15]  211     add   ix, bc
   4340                     212   enemies_continue_update:
   4340 F1            [10]  213     pop   af
   4341 3D            [ 4]  214     dec   a
   4342 C8            [11]  215     ret   z
   4343 C3 04 43      [10]  216     jp    enemies_update_loop
   4346 C9            [10]  217   ret
                            218 
                            219 
   4347                     220 man_entity_bombs_update::
   4347 DD 21 6B 42   [14]  221   ld    ix, #_bomb_array
   434B 3A 68 42      [13]  222   ld     a, (_bomb_num)
   434E B7            [ 4]  223   or     a
   434F C8            [11]  224   ret    z
                            225 
   4350                     226   bombs_update_loop:
   4350 F5            [11]  227     push  af
                            228     
   4351 DD 7E 00      [19]  229     ld    a, b_timer(ix)         ;; load timer of bomb
   4354 E6 00         [ 7]  230     and   #zero_timer            ;; _bomb_timer AND zero_timer
                            231 
   4356 28 2F         [12]  232     jr    z, bombs_increase_index
   4358 CD 52 42      [17]  233     call  sys_render_remove_bomb
                            234 
                            235     ;; _last_element_ptr now points to the last entity in the array
                            236     ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   435B 3A 69 42      [13]  237     ld    a, (_bomb_last)
   435E D6 07         [ 7]  238     sub   #sizeof_b
   4360 32 69 42      [13]  239     ld    (_bomb_last), a
   4363 DA 69 43      [10]  240     jp    c, bombs_overflow_update
   4366 C3 70 43      [10]  241     jp    bombs_no_overflow_update    
                            242     
   4369                     243   bombs_overflow_update:
   4369 3A 6A 42      [13]  244     ld    a, (_bomb_last+1)
   436C 3D            [ 4]  245     dec   a
   436D 32 6A 42      [13]  246     ld    (_bomb_last+1), a
                            247 
   4370                     248   bombs_no_overflow_update:
                            249     ;; move the last element to the hole left by the dead entity
   4370 DD E5         [15]  250     push  ix  
   4372 E1            [10]  251     pop   hl
   4373 01 07 00      [10]  252     ld    bc, #sizeof_b       
   4376 ED 5B 69 42   [20]  253     ld    de, (_bomb_last)
   437A EB            [ 4]  254     ex    de, hl
   437B ED B0         [21]  255     ldir                        
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



                            256     
   437D 3A 68 42      [13]  257     ld    a, (_bomb_num)
   4380 3D            [ 4]  258     dec   a
   4381 32 68 42      [13]  259     ld    (_bomb_num), a  
                            260 
   4384 C3 8C 43      [10]  261     jp    bombs_continue_update
                            262 
   4387                     263   bombs_increase_index:
   4387 01 07 00      [10]  264     ld    bc, #sizeof_b
   438A DD 09         [15]  265     add   ix, bc
   438C                     266   bombs_continue_update:
   438C F1            [10]  267     pop   af
   438D 3D            [ 4]  268     dec   a
   438E C8            [11]  269     ret   z
   438F C3 50 43      [10]  270     jp    bombs_update_loop  
   4392 C9            [10]  271   ret
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
   4393                     285 man_entity_init::
   4393 CD CC 42      [17]  286   call  man_entity_init_player
   4396 CD D8 42      [17]  287   call  man_entity_init_entities
   4399 CD EE 42      [17]  288   call  man_entity_init_bombs
   439C C9            [10]  289   ret
                            290 
                            291 
                            292 ;;
                            293 ;;  INPUT:
                            294 ;;    none
                            295 ;;  RETURN: 
                            296 ;;    none
                            297 ;;  DESTROYED:
                            298 ;;    AF,DE,IX,HL,BC
   439D                     299 man_entity_update::
   439D CD FA 42      [17]  300   call  man_entity_player_update
   43A0 CD FB 42      [17]  301   call  man_entity_enemies_update
   43A3 CD 47 43      [17]  302   call  man_entity_bombs_update
   43A6 C9            [10]  303   ret
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
   43A7                     314 man_entity_create_entity::  
   43A7 3E 01         [ 7]  315   ld    a, #max_entities
   43A9 21 5C 42      [10]  316   ld    hl, #_enemy_num
   43AC BE            [ 7]  317   cp   (hl)                  ;; max_entities - _enemy_num
   43AD C8            [11]  318   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                            319 
   43AE CD 72 42      [17]  320   call  man_entity_new_entity
   43B1 CD 88 42      [17]  321   call  man_entity_initialize_entity
   43B4 C9            [10]  322   ret
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
   43B5                     333 man_entity_create_bomb::  
   43B5 3E 01         [ 7]  334   ld    a, #max_bombs
   43B7 21 68 42      [10]  335   ld    hl, #_bomb_num
   43BA BE            [ 7]  336   cp   (hl)                  ;; max_bombs - _bomb_num
   43BB C8            [11]  337   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                            338 
   43BC CD B5 43      [17]  339   call  man_entity_create_bomb
   43BF CD B9 42      [17]  340   call  man_entity_initialize_bomb
   43C2 C9            [10]  341   ret
                            342 
                            343 
                            344 ;;
                            345 ;;  INPUT:
                            346 ;;    none
                            347 ;;  RETURN: 
                            348 ;;    ix with memory address of player
                            349 ;;  DESTROYED:
                            350 ;;    none
   43C3                     351 man_entity_get_player::
   43C3 DD 21 53 42   [14]  352   ld    ix, #_player
   43C7 C9            [10]  353   ret
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
   43C8                     364 man_entity_get_enemy_array::
   43C8 DD 21 5F 42   [14]  365   ld    ix, #_enemy_array
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 14.
Hexadecimal [16-Bits]



   43CC 3A 5C 42      [13]  366   ld     a, (_enemy_num)
   43CF C9            [10]  367   ret
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
   43D0                     378 man_entity_get_bomb_array::
   43D0 DD 21 6B 42   [14]  379   ld    ix, #_bomb_array
   43D4 3A 68 42      [13]  380   ld     a, (_bomb_num)
   43D7 C9            [10]  381   ret
                            382 
                            383 
                            384 ;;
                            385 ;;  INPUT:
                            386 ;;    none
                            387 ;;  RETURN: 
                            388 ;;    ix  begin of player memory address
                            389 ;;  DESTROYED:
                            390 ;;    A
   43D8                     391 man_entity_set_player_dead::
   43D8 DD 21 53 42   [14]  392   ld    ix, #_player
   43DC 3E FE         [ 7]  393   ld     a, #dead_type
   43DE DD 77 00      [19]  394   ld    e_type(ix), a
   43E1 C9            [10]  395   ret
                            396 
                            397 
                            398 ;;
                            399 ;;  INPUT:
                            400 ;;    ix with memory address of entity that must me marked as dead
                            401 ;;  RETURN: 
                            402 ;;    none
                            403 ;;  DESTROYED:
                            404 ;;    A
   43E2                     405 man_entity_set_enemy_dead::
   43E2 3E FE         [ 7]  406   ld    a, #dead_type
   43E4 DD 77 00      [19]  407   ld    e_type(ix), a
   43E7 C9            [10]  408   ret
                            409 
                            410 
   43E8                     411 man_entity_terminate::
   43E8 3E 5F         [ 7]  412   ld  a, #_enemy_array
   43EA 32 5D 42      [13]  413   ld  (_enemy_last), a
                            414 
   43ED 3E 00         [ 7]  415   ld  a, #0
   43EF 32 5C 42      [13]  416   ld  (_enemy_num), a
                            417 
   43F2 3E 6B         [ 7]  418   ld  a, #_bomb_array
   43F4 32 69 42      [13]  419   ld  (_bomb_last), a
                            420 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 15.
Hexadecimal [16-Bits]



   43F7 3E 00         [ 7]  421   ld  a, #0
   43F9 32 68 42      [13]  422   ld  (_bomb_num), a
   43FC C9            [10]  423   ret
