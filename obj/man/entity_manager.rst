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



                              6 .include "../sys/render_system.h.s"
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
                             20 
                             21 ;;  In bytes
                             22 ;;  The max constants are max+1 because this way they represent the first pixel where border begins.
                             23 ;;  This way, when calculating the last allowed position where an entity may be positioned, it is easier and cleaner.
                     0004    24 min_map_y_coord_valid = 4     ;;  [0-3] border, >=4 map
                     00C4    25 max_map_y_coord_valid = 196    ;;  [196-199] border, <=195 map
                             26 
                             27 ;;  Screen width is 160px, each char is 8px, so there are 20 chars. Each bomberman cell is 2width*2height chars, so
                             28 ;;  20 width chars == 10 bomberman cells. 0.75 cell as left border + 3 cells as left extra info + 6 cells map + 0.25 cell as right border = 10 cells
                             29 ;;  1 cell = 2w char = 16px --> 3.75 cells on the left of the map = 3.75*16=60px. 
                             30 ;;  2px = 1 byte  --> 60px*1byte/2px=30bytes on the left of the map
                             31 ;;  Same reasoning for right border: 0.25cell=1char=4px=2byte of right border
                     001E    32 min_map_x_coord_valid = 30      ;;  [0-29] border, >=30 map
                     004E    33 max_map_x_coord_valid = 78    ;;  [78-79] border, <=77 map
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
                             24 
                             25 ;;for normal people
                             26 .globl  Key_W
                             27 .globl  Key_S
                             28 .globl  Key_D
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 
                              9 
                             10 ;;########################################################
                             11 ;;                        VARIABLES                      #             
                             12 ;;########################################################
                             13 
   0000                      14 _player:  DefineEntity alive_type, min_map_x_coord_valid, min_map_y_coord_valid, 4, 16, 0, 0, 0xCCCC
   4323 01                    1     .db alive_type
   4324 1E 04                 2     .db min_map_x_coord_valid, min_map_y_coord_valid
   4326 04 10                 3     .db 4, 16      ;; both in bytes
   4328 00 00                 4     .db 0, 0    
   432A CC CC                 5     .dw 0xCCCC
   0009                      15 DefineEntityArray _enemy, max_entities, DefineEntityDefault
   432C 00                    1     _enemy_num:    .db 0    
   432D 2F 43                 2     _enemy_last:   .dw _enemy_array
   432F                       3     _enemy_array: 
                              4     .rept max_entities    
                              5         DefineEntityDefault
                              6     .endm
   000C                       1         DefineEntityDefault
   432F 01                    1     .db alive_type
   4330 DE AD                 2     .db 0xDE, 0xAD
   4332 04 10                 3     .db 4, 16  
   4334 DE AD                 4     .dw 0xADDE 
   4336 CC CC                 5     .dw 0xCCCC
                             16 
   0015                      17 DefineBombArray _bomb, max_bombs, DefineBombDefault
   4338 00                    1     _bomb_num:    .db 0    
   4339 3B 43                 2     _bomb_last:   .dw _bomb_array
   433B                       3     _bomb_array: 
                              4     .rept max_bombs    
                              5         DefineBombDefault
                              6     .endm
   0018                       1         DefineBombDefault
   433B FF                    1     .db max_timer   ;; timer    
   433C DE AD                 2     .db 0xDE,0xAD   ;; coordinates (x, y)
   433E 04 10                 3     .db #4, #16     ;; width, height -> both in bytes    
   4340 CC CC                 4     .dw 0xCCCC      ;; sprite  pointer (where it's in memory video)
                             18 
                             19 ;;########################################################
                             20 ;;                   PRIVATE FUNCTIONS                   #             
                             21 ;;########################################################
                             22 
                             23 ;;
                             24 ;;  Increases counter of entities and pointer to the last element.
                             25 ;;  INPUT:
                             26 ;;    none
                             27 ;;  RETURN: 
                             28 ;;    hl with memory address of free space for new entity
                             29 ;;    ix with memory address of last created entity
                             30 ;;  DESTROYED:
                             31 ;;    AF,DE,BC
   4342                      32 man_entity_new_entity::
   4342 3A 2C 43      [13]   33   ld    a, (_enemy_num)
   4345 3C            [ 4]   34   inc   a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   4346 32 2C 43      [13]   35   ld    (_enemy_num), a
                             36 
   4349 DD 2A 2D 43   [20]   37   ld    ix, (_enemy_last)    
   434D 2A 2D 43      [16]   38   ld    hl, (_enemy_last)    
   4350 01 09 00      [10]   39   ld    bc, #sizeof_e
   4353 09            [11]   40   add   hl, bc
   4354 22 2D 43      [16]   41   ld    (_enemy_last), hl
   4357 C9            [10]   42   ret
                             43 
                             44 ;;
                             45 ;;  Initialize data for all enemies and player.
                             46 ;;  INPUT:
                             47 ;;    ix with memory address of entity that must be initialized
                             48 ;;  RETURN: 
                             49 ;;    none
                             50 ;;  DESTROYED:
                             51 ;;    A
   4358                      52 man_entity_initialize_entity::  
   4358 DD 36 00 01   [19]   53   ld    e_type(ix), #alive_type  
                             54   
   435C DD 36 01 28   [19]   55   ld    e_x(ix), #40          ;; set X coordiante
   4360 DD 36 02 0C   [19]   56   ld    e_y(ix), #12           ;; set Y coordiante
                             57 
   4364 DD 36 05 00   [19]   58   ld    e_vx(ix), #0         ;; set X velocity  
   4368 DD 36 06 00   [19]   59   ld    e_vy(ix), #0          ;; set Y velocity    
                             60   
   436C DD 36 03 04   [19]   61   ld    e_w(ix), #4           ;; set sprite width
   4370 DD 36 04 10   [19]   62   ld    e_h(ix), #16          ;; set sprite height
                             63 
   4374 C9            [10]   64   ret
                             65 
                             66 
                             67 ;;
                             68 ;;  Increases counter of bombs and pointer to the last element.
                             69 ;;  INPUT:
                             70 ;;    none
                             71 ;;  RETURN: 
                             72 ;;    hl with memory address of free space for new bomb
                             73 ;;    ix with memory address of last created bomb
                             74 ;;  DESTROYED:
                             75 ;;    A,BC
   4375                      76 man_entity_new_bomb::
   4375 3A 38 43      [13]   77   ld    a, (_bomb_num)
   4378 3C            [ 4]   78   inc   a
   4379 32 38 43      [13]   79   ld    (_bomb_num), a
                             80 
   437C DD 2A 39 43   [20]   81   ld    ix, (_bomb_last)    
   4380 2A 39 43      [16]   82   ld    hl, (_bomb_last)    
   4383 01 07 00      [10]   83   ld    bc, #sizeof_b
   4386 09            [11]   84   add   hl, bc
   4387 22 39 43      [16]   85   ld    (_bomb_last), hl
   438A C9            [10]   86   ret
                             87 
                             88 ;;
                             89 ;;  Initialize data for all bombs.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                             90 ;;  INPUT:
                             91 ;;    ix  with memory address of entity that must be initialized
                             92 ;;    l   X coordinate where bomb must be positioned
                             93 ;;    h   Y coordinate where bomb must positioned
                             94 ;;  RETURN: 
                             95 ;;    none
                             96 ;;  DESTROYED:
                             97 ;;    A
   438B                      98 man_entity_initialize_bomb::    
   438B DD 75 01      [19]   99   ld    b_x(ix), l                  ;; set X velocity  
   438E DD 74 02      [19]  100   ld    b_y(ix), h                  ;; set Y velocity    
                            101   
   4391 DD 36 03 04   [19]  102   ld    b_w(ix), #4                 ;; set sprite width
   4395 DD 36 04 10   [19]  103   ld    b_h(ix), #16                ;; set sprite height
                            104       
   4399 DD 36 00 FF   [19]  105   ld    b_timer(ix), #max_timer     ;; set timer
   439D C9            [10]  106   ret
                            107 
                            108 
   439E                     109 man_entity_init_player::
   439E C9            [10]  110   ret
                            111 
                            112 ;;
                            113 ;;  Initialize data for all enemies and player.
                            114 ;;  INPUT:
                            115 ;;    none
                            116 ;;  RETURN: 
                            117 ;;    hl with memory address of free space for new entity
                            118 ;;    ix with memory address of last created entity
                            119 ;;  DESTROYED:
                            120 ;;    AF,DE,IX,HL,BC
   439F                     121 man_entity_init_entities::
   439F 3E 01         [ 7]  122   ld    a, #max_entities
   43A1 ED 5B 2D 43   [20]  123   ld    de, (_enemy_last)
   43A5                     124 init_loop:
   43A5 F5            [11]  125   push  af
                            126   
   43A6 CD 42 43      [17]  127   call  man_entity_new_entity
   43A9 CD 58 43      [17]  128   call  man_entity_initialize_entity
                            129   
   43AC F1            [10]  130   pop   af
   43AD 3D            [ 4]  131   dec   a
   43AE C8            [11]  132   ret   z
   43AF 18 F4         [12]  133   jr    init_loop
                            134 
                            135 ;;
                            136 ;;  Reset bombs data
                            137 ;;  INPUT:
                            138 ;;    none
                            139 ;;  RETURN: 
                            140 ;;    none
                            141 ;;  DESTROYED:
                            142 ;;    A,HL
   43B1                     143 man_entity_init_bombs::
   43B1 3E 00         [ 7]  144   ld    a, #0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



   43B3 32 38 43      [13]  145   ld    (_bomb_num), a
                            146 
   43B6 21 3B 43      [10]  147   ld    hl, #_bomb_array
   43B9 22 39 43      [16]  148   ld    (_bomb_last), hl
   43BC C9            [10]  149   ret
                            150 
                            151 
   43BD                     152 man_entity_player_update::
   43BD C9            [10]  153   ret
                            154 
                            155 
   43BE                     156 man_entity_enemies_update::
   43BE DD 21 2F 43   [14]  157   ld    ix, #_enemy_array
   43C2 3A 2C 43      [13]  158   ld     a, (_enemy_num)
   43C5 B7            [ 4]  159   or     a
   43C6 C8            [11]  160   ret    z
                            161 
   43C7                     162   enemies_update_loop:
   43C7 F5            [11]  163     push  af
                            164     
   43C8 DD 7E 00      [19]  165     ld    a, e_type(ix)         ;; load type of entity
   43CB E6 FE         [ 7]  166     and    #dead_type            ;; entity_type AND dead_type
                            167 
   43CD 28 2F         [12]  168     jr    z, enemies_increase_index
   43CF CD 8E 42      [17]  169     call  sys_render_remove_entity
                            170 
                            171     ;; _last_element_ptr now points to the last entity in the array
                            172     ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   43D2 3A 2D 43      [13]  173     ld    a, (_enemy_last)
   43D5 D6 09         [ 7]  174     sub   #sizeof_e
   43D7 32 2D 43      [13]  175     ld    (_enemy_last), a
   43DA DA E0 43      [10]  176     jp    c, enemies_overflow_update
   43DD C3 E7 43      [10]  177     jp    enemies_no_overflow_update    
                            178     
   43E0                     179   enemies_overflow_update:
   43E0 3A 2E 43      [13]  180     ld    a, (_enemy_last+1)
   43E3 3D            [ 4]  181     dec   a
   43E4 32 2E 43      [13]  182     ld    (_enemy_last+1), a
                            183 
   43E7                     184   enemies_no_overflow_update:
                            185     ;; move the last element to the hole left by the dead entity
   43E7 DD E5         [15]  186     push  ix  
   43E9 E1            [10]  187     pop   hl
   43EA 01 09 00      [10]  188     ld    bc, #sizeof_e       
   43ED ED 5B 2D 43   [20]  189     ld    de, (_enemy_last)
   43F1 EB            [ 4]  190     ex    de, hl
   43F2 ED B0         [21]  191     ldir                        
                            192     
   43F4 3A 2C 43      [13]  193     ld    a, (_enemy_num)
   43F7 3D            [ 4]  194     dec   a
   43F8 32 2C 43      [13]  195     ld    (_enemy_num), a  
                            196 
   43FB C3 03 44      [10]  197     jp    enemies_continue_update
                            198 
   43FE                     199   enemies_increase_index:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



   43FE 01 09 00      [10]  200     ld    bc, #sizeof_e
   4401 DD 09         [15]  201     add   ix, bc
   4403                     202   enemies_continue_update:
   4403 F1            [10]  203     pop   af
   4404 3D            [ 4]  204     dec   a
   4405 C8            [11]  205     ret   z
   4406 C3 C7 43      [10]  206     jp    enemies_update_loop
   4409 C9            [10]  207   ret
                            208 
                            209 
   440A                     210 man_entity_bombs_update::
   440A DD 21 3B 43   [14]  211   ld    ix, #_bomb_array
   440E 3A 38 43      [13]  212   ld     a, (_bomb_num)
   4411 B7            [ 4]  213   or     a
   4412 C8            [11]  214   ret    z
                            215 
   4413                     216   bombs_update_loop:
   4413 F5            [11]  217     push  af
                            218     
   4414 DD 7E 00      [19]  219     ld    a, b_timer(ix)         ;; load timer of bomb
   4417 E6 00         [ 7]  220     and   #zero_timer            ;; _bomb_timer AND zero_timer
                            221 
   4419 28 2F         [12]  222     jr    z, bombs_increase_index
   441B CD A0 42      [17]  223     call  sys_render_remove_bomb
                            224 
                            225     ;; _last_element_ptr now points to the last entity in the array
                            226     ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   441E 3A 39 43      [13]  227     ld    a, (_bomb_last)
   4421 D6 07         [ 7]  228     sub   #sizeof_b
   4423 32 39 43      [13]  229     ld    (_bomb_last), a
   4426 DA 2C 44      [10]  230     jp    c, bombs_overflow_update
   4429 C3 33 44      [10]  231     jp    bombs_no_overflow_update    
                            232     
   442C                     233   bombs_overflow_update:
   442C 3A 3A 43      [13]  234     ld    a, (_bomb_last+1)
   442F 3D            [ 4]  235     dec   a
   4430 32 3A 43      [13]  236     ld    (_bomb_last+1), a
                            237 
   4433                     238   bombs_no_overflow_update:
                            239     ;; move the last element to the hole left by the dead entity
   4433 DD E5         [15]  240     push  ix  
   4435 E1            [10]  241     pop   hl
   4436 01 07 00      [10]  242     ld    bc, #sizeof_b       
   4439 ED 5B 39 43   [20]  243     ld    de, (_bomb_last)
   443D EB            [ 4]  244     ex    de, hl
   443E ED B0         [21]  245     ldir                        
                            246     
   4440 3A 38 43      [13]  247     ld    a, (_bomb_num)
   4443 3D            [ 4]  248     dec   a
   4444 32 38 43      [13]  249     ld    (_bomb_num), a  
                            250 
   4447 C3 4F 44      [10]  251     jp    bombs_continue_update
                            252 
   444A                     253   bombs_increase_index:
   444A 01 07 00      [10]  254     ld    bc, #sizeof_b
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



   444D DD 09         [15]  255     add   ix, bc
   444F                     256   bombs_continue_update:
   444F F1            [10]  257     pop   af
   4450 3D            [ 4]  258     dec   a
   4451 C8            [11]  259     ret   z
   4452 C3 13 44      [10]  260     jp    bombs_update_loop  
   4455 C9            [10]  261   ret
                            262 
                            263 ;;########################################################
                            264 ;;                   PUBLIC FUNCTIONS                    #             
                            265 ;;########################################################
                            266 
                            267 ;;
                            268 ;;  Initialize data for all enemies, player and reset bombs data.
                            269 ;;  INPUT:
                            270 ;;    none
                            271 ;;  RETURN: 
                            272 ;;    none
                            273 ;;  DESTROYED:
                            274 ;;    AF,DE,IX,HL,BC
   4456                     275 man_entity_init::
   4456 CD 9E 43      [17]  276   call  man_entity_init_player
   4459 CD 9F 43      [17]  277   call  man_entity_init_entities
   445C CD B1 43      [17]  278   call  man_entity_init_bombs
   445F C9            [10]  279   ret
                            280 
                            281 
                            282 ;;
                            283 ;;  INPUT:
                            284 ;;    none
                            285 ;;  RETURN: 
                            286 ;;    none
                            287 ;;  DESTROYED:
                            288 ;;    AF,DE,IX,HL,BC
   4460                     289 man_entity_update::
   4460 CD BD 43      [17]  290   call  man_entity_player_update
   4463 CD BE 43      [17]  291   call  man_entity_enemies_update
   4466 CD 0A 44      [17]  292   call  man_entity_bombs_update
   4469 C9            [10]  293   ret
                            294 
                            295 
                            296 ;;
                            297 ;;  INPUT:
                            298 ;;    none
                            299 ;;  RETURN: 
                            300 ;;    hl with memory address of free space for new entity
                            301 ;;    ix with memory address of last created entity
                            302 ;;  DESTROYED:
                            303 ;;    A,HL,BC
   446A                     304 man_entity_create_entity::  
   446A 3E 01         [ 7]  305   ld    a, #max_entities
   446C 21 2C 43      [10]  306   ld    hl, #_enemy_num
   446F BE            [ 7]  307   cp   (hl)                  ;; max_entities - _enemy_num
   4470 C8            [11]  308   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                            309 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



   4471 CD 42 43      [17]  310   call  man_entity_new_entity
   4474 CD 58 43      [17]  311   call  man_entity_initialize_entity
   4477 C9            [10]  312   ret
                            313 
                            314 
                            315 ;;
                            316 ;;  INPUT:
                            317 ;;    none
                            318 ;;  RETURN: 
                            319 ;;    hl with memory address of free space for new bomb
                            320 ;;    ix with memory address of last created bomb
                            321 ;;  DESTROYED:
                            322 ;;    A,HL,BC
   4478                     323 man_entity_create_bomb::  
   4478 3E 01         [ 7]  324   ld    a, #max_bombs
   447A 21 38 43      [10]  325   ld    hl, #_bomb_num
   447D BE            [ 7]  326   cp   (hl)                  ;; max_bombs - _bomb_num
   447E C8            [11]  327   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                            328 
   447F CD 78 44      [17]  329   call  man_entity_create_bomb
   4482 CD 8B 43      [17]  330   call  man_entity_initialize_bomb
   4485 C9            [10]  331   ret
                            332 
                            333 
                            334 ;;
                            335 ;;  INPUT:
                            336 ;;    none
                            337 ;;  RETURN: 
                            338 ;;    ix with memory address of player
                            339 ;;  DESTROYED:
                            340 ;;    none
   4486                     341 man_entity_get_player::
   4486 DD 21 23 43   [14]  342   ld    ix, #_player
   448A C9            [10]  343   ret
                            344 
                            345 
                            346 ;;
                            347 ;;  INPUT:
                            348 ;;    none
                            349 ;;  RETURN: 
                            350 ;;    ix  begin of enemy array memory address
                            351 ;;    a   number of enemies in the array
                            352 ;;  DESTROYED:
                            353 ;;    none
   448B                     354 man_entity_get_enemy_array::
   448B DD 21 2F 43   [14]  355   ld    ix, #_enemy_array
   448F 3A 2C 43      [13]  356   ld     a, (_enemy_num)
   4492 C9            [10]  357   ret
                            358 
                            359 
                            360 ;;
                            361 ;;  INPUT:
                            362 ;;    none
                            363 ;;  RETURN: 
                            364 ;;    ix  begin of bomb array memory address
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 13.
Hexadecimal [16-Bits]



                            365 ;;    a   number of bombs in the array
                            366 ;;  DESTROYED:
                            367 ;;    none
   4493                     368 man_entity_get_bomb_array::
   4493 DD 21 3B 43   [14]  369   ld    ix, #_bomb_array
   4497 3A 38 43      [13]  370   ld     a, (_bomb_num)
   449A C9            [10]  371   ret
                            372 
                            373 
                            374 ;;
                            375 ;;  INPUT:
                            376 ;;    none
                            377 ;;  RETURN: 
                            378 ;;    ix  begin of player memory address
                            379 ;;  DESTROYED:
                            380 ;;    A
   449B                     381 man_entity_set_player_dead::
   449B DD 21 23 43   [14]  382   ld    ix, #_player
   449F 3E FE         [ 7]  383   ld     a, #dead_type
   44A1 DD 77 00      [19]  384   ld    e_type(ix), a
   44A4 C9            [10]  385   ret
                            386 
                            387 
                            388 ;;
                            389 ;;  INPUT:
                            390 ;;    ix with memory address of entity that must me marked as dead
                            391 ;;  RETURN: 
                            392 ;;    none
                            393 ;;  DESTROYED:
                            394 ;;    A
   44A5                     395 man_entity_set_enemy_dead::
   44A5 3E FE         [ 7]  396   ld    a, #dead_type
   44A7 DD 77 00      [19]  397   ld    e_type(ix), a
   44AA C9            [10]  398   ret
