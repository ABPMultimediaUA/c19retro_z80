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
                             24 .macro DefineEntity _type,_x,_y,_w,_h,_vx,_vy,_sp_ptr_0
                             25     .db _type
                             26     .db _x, _y
                             27     .db _w, _h      ;; both in bytes
                             28     .db _vx, _vy    
                             29     .dw _sp_ptr_0
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
                              9 
                             10 
                             11 ;;########################################################
                             12 ;;                       CONSTANTS                       #             
                             13 ;;########################################################
                     0000    14 video_mode = 0
                             15 
                             16 ;; in pixels
                     00A0    17 screen_width = 160
                     00C8    18 screen_height = 200
                             19 
                             20 ;;  1 byte for each +-1 Y coordinate (1px)
                             21 ;;  200px = 25 char -> 1 bomberman cell = 2height*2width chars
                             22 ;;  25chars*1cell/2char = 12 cells, rest 1 char
                             23 ;;  1 char = 8px -> so the map is centered, 4px up, 4px down
                     0004    24 min_map_y_coord_valid = 4      ;;  [0-3] border, >=4 map
                     00B3    25 max_map_y_coord_valid = 195-16    ;;  [196-199] border, <=195 map -16px
                             26 
                             27 ;;  1 byte for each +-2 X coordinate (2px)
                             28 ;;  160px = 20 char -> 1 bomberman cell = 2height*2width chars
                             29 ;;  20chars*1cell/2char = 10 cells -> 4 cells left border, 5 cells map
                             30 ;;  rest 1 cell=2 char, 1 char left border, 1 char right border
                             31 ;;  1 char = 8px -> so the map is centered, 4px up, 4px down
                             32 ;;  9 char left map, 10 char map, 1 char right map
                             33 ;;  9char*8px*1byte/2px = 36, 19char*8px*1byte/2=76
                     0024    34 min_map_x_coord_valid = 36      ;;  [0-35] border, >=35 map
                     004F    35 max_map_x_coord_valid = 79    ;;  [78-79] border, <=77 map
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 
                              9 
                             10 ;;########################################################
                             11 ;;                        VARIABLES                      #             
                             12 ;;########################################################
                             13 
   0000                      14 _player:  DefineEntity alive_type, min_map_x_coord_valid, max_map_y_coord_valid, 4, 16, 0, 0, 0xCCCC
   4238 01                    1     .db alive_type
   4239 24 B3                 2     .db min_map_x_coord_valid, max_map_y_coord_valid
   423B 04 10                 3     .db 4, 16      ;; both in bytes
   423D 00 00                 4     .db 0, 0    
   423F CC CC                 5     .dw 0xCCCC
   0009                      15 DefineEntityArray _enemy, max_entities, DefineEntityDefault
   4241 00                    1     _enemy_num:    .db 0    
   4242 44 42                 2     _enemy_last:   .dw _enemy_array
   4244                       3     _enemy_array: 
                              4     .rept max_entities    
                              5         DefineEntityDefault
                              6     .endm
   000C                       1         DefineEntityDefault
   4244 01                    1     .db alive_type
   4245 DE AD                 2     .db 0xDE, 0xAD
   4247 04 10                 3     .db 4, 16  
   4249 DE AD                 4     .dw 0xADDE 
   424B CC CC                 5     .dw 0xCCCC
                             16 
   0015                      17 DefineBombArray _bomb, max_bombs, DefineBombDefault
   424D 00                    1     _bomb_num:    .db 0    
   424E 50 42                 2     _bomb_last:   .dw _bomb_array
   4250                       3     _bomb_array: 
                              4     .rept max_bombs    
                              5         DefineBombDefault
                              6     .endm
   0018                       1         DefineBombDefault
   4250 FF                    1     .db max_timer   ;; timer    
   4251 DE AD                 2     .db 0xDE,0xAD   ;; coordinates (x, y)
   4253 04 10                 3     .db #4, #16     ;; width, height -> both in bytes    
   4255 CC CC                 4     .dw 0xCCCC      ;; sprite  pointer (where it's in memory video)
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
   4257                      32 man_entity_new_entity::
   4257 3A 41 42      [13]   33   ld    a, (_enemy_num)
   425A 3C            [ 4]   34   inc   a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   425B 32 41 42      [13]   35   ld    (_enemy_num), a
                             36 
   425E DD 2A 42 42   [20]   37   ld    ix, (_enemy_last)    
   4262 2A 42 42      [16]   38   ld    hl, (_enemy_last)    
   4265 01 09 00      [10]   39   ld    bc, #sizeof_e
   4268 09            [11]   40   add   hl, bc
   4269 22 42 42      [16]   41   ld    (_enemy_last), hl
   426C C9            [10]   42   ret
                             43 
                             44 ;;
                             45 ;;  Initialize data for all enemies and player.
                             46 ;;  INPUT:
                             47 ;;    ix with memory address of entity that must be initialized
                             48 ;;  RETURN: 
                             49 ;;    none
                             50 ;;  DESTROYED:
                             51 ;;    A
   426D                      52 man_entity_initialize_entity::  
   426D DD 36 00 01   [19]   53   ld    e_type(ix), #alive_type  
                             54   
   4271 DD 36 01 28   [19]   55   ld    e_x(ix), #40          ;; set X coordiante
   4275 DD 36 02 0C   [19]   56   ld    e_y(ix), #12           ;; set Y coordiante
                             57 
   4279 DD 36 05 00   [19]   58   ld    e_vx(ix), #0         ;; set X velocity  
   427D DD 36 06 00   [19]   59   ld    e_vy(ix), #0          ;; set Y velocity    
                             60   
   4281 DD 36 03 04   [19]   61   ld    e_w(ix), #4           ;; set sprite width
   4285 DD 36 04 10   [19]   62   ld    e_h(ix), #16          ;; set sprite height
                             63 
   4289 C9            [10]   64   ret
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
   428A                      76 man_entity_new_bomb::
   428A 3A 4D 42      [13]   77   ld    a, (_bomb_num)
   428D 3C            [ 4]   78   inc   a
   428E 32 4D 42      [13]   79   ld    (_bomb_num), a
                             80 
   4291 DD 2A 4E 42   [20]   81   ld    ix, (_bomb_last)    
   4295 2A 4E 42      [16]   82   ld    hl, (_bomb_last)    
   4298 01 07 00      [10]   83   ld    bc, #sizeof_b
   429B 09            [11]   84   add   hl, bc
   429C 22 4E 42      [16]   85   ld    (_bomb_last), hl
   429F C9            [10]   86   ret
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
   42A0                      98 man_entity_initialize_bomb::    
   42A0 DD 75 01      [19]   99   ld    b_x(ix), l                  ;; set X velocity  
   42A3 DD 74 02      [19]  100   ld    b_y(ix), h                  ;; set Y velocity    
                            101   
   42A6 DD 36 03 04   [19]  102   ld    b_w(ix), #4                 ;; set sprite width
   42AA DD 36 04 10   [19]  103   ld    b_h(ix), #16                ;; set sprite height
                            104       
   42AE DD 36 00 FF   [19]  105   ld    b_timer(ix), #max_timer     ;; set timer
   42B2 C9            [10]  106   ret
                            107 
                            108 
                            109 ;;
                            110 ;;  Initialize data for all enemies and player.
                            111 ;;  INPUT:
                            112 ;;    none
                            113 ;;  RETURN: 
                            114 ;;    hl with memory address of free space for new entity
                            115 ;;    ix with memory address of last created entity
                            116 ;;  DESTROYED:
                            117 ;;    AF,DE,IX,HL,BC
   42B3                     118 man_entity_init_entities::
   42B3 3E 01         [ 7]  119   ld    a, #max_entities
   42B5 ED 5B 42 42   [20]  120   ld    de, (_enemy_last)
   42B9                     121 init_loop:
   42B9 F5            [11]  122   push  af
                            123   
   42BA CD 57 42      [17]  124   call  man_entity_new_entity
   42BD CD 6D 42      [17]  125   call  man_entity_initialize_entity
                            126   
   42C0 F1            [10]  127   pop   af
   42C1 3D            [ 4]  128   dec   a
   42C2 C8            [11]  129   ret   z
   42C3 18 F4         [12]  130   jr    init_loop
                            131 
                            132 ;;
                            133 ;;  Reset bombs data
                            134 ;;  INPUT:
                            135 ;;    none
                            136 ;;  RETURN: 
                            137 ;;    none
                            138 ;;  DESTROYED:
                            139 ;;    A,HL
   42C5                     140 man_entity_init_bombs::
   42C5 3E 00         [ 7]  141   ld    a, #0
   42C7 32 4D 42      [13]  142   ld    (_bomb_num), a
                            143 
   42CA 21 50 42      [10]  144   ld    hl, #_bomb_array
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



   42CD 22 4E 42      [16]  145   ld    (_bomb_last), hl
   42D0 C9            [10]  146   ret
                            147 
                            148 
   42D1                     149 man_entity_player_update::
   42D1 C9            [10]  150   ret
                            151 
   42D2                     152 man_entity_enemies_update::
   42D2 DD 21 44 42   [14]  153   ld    ix, #_enemy_array
   42D6 3A 41 42      [13]  154   ld     a, (_enemy_num)
   42D9 B7            [ 4]  155   or     a
   42DA C8            [11]  156   ret    z
                            157 
   42DB                     158   enemies_update_loop:
   42DB F5            [11]  159     push  af
                            160     
   42DC DD 7E 00      [19]  161     ld    a, e_type(ix)         ;; load type of entity
   42DF E6 FE         [ 7]  162     and    #dead_type            ;; entity_type AND dead_type
                            163 
   42E1 28 2F         [12]  164     jr    z, enemies_increase_index
   42E3 CD 25 42      [17]  165     call  sys_render_remove_entity
                            166 
                            167     ;; _last_element_ptr now points to the last entity in the array
                            168     ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   42E6 3A 42 42      [13]  169     ld    a, (_enemy_last)
   42E9 D6 09         [ 7]  170     sub   #sizeof_e
   42EB 32 42 42      [13]  171     ld    (_enemy_last), a
   42EE DA F4 42      [10]  172     jp    c, enemies_overflow_update
   42F1 C3 FB 42      [10]  173     jp    enemies_no_overflow_update    
                            174     
   42F4                     175   enemies_overflow_update:
   42F4 3A 43 42      [13]  176     ld    a, (_enemy_last+1)
   42F7 3D            [ 4]  177     dec   a
   42F8 32 43 42      [13]  178     ld    (_enemy_last+1), a
                            179 
   42FB                     180   enemies_no_overflow_update:
                            181     ;; move the last element to the hole left by the dead entity
   42FB DD E5         [15]  182     push  ix  
   42FD E1            [10]  183     pop   hl
   42FE 01 09 00      [10]  184     ld    bc, #sizeof_e       
   4301 ED 5B 42 42   [20]  185     ld    de, (_enemy_last)
   4305 EB            [ 4]  186     ex    de, hl
   4306 ED B0         [21]  187     ldir                        
                            188     
   4308 3A 41 42      [13]  189     ld    a, (_enemy_num)
   430B 3D            [ 4]  190     dec   a
   430C 32 41 42      [13]  191     ld    (_enemy_num), a  
                            192 
   430F C3 17 43      [10]  193     jp    enemies_continue_update
                            194 
   4312                     195   enemies_increase_index:
   4312 01 09 00      [10]  196     ld    bc, #sizeof_e
   4315 DD 09         [15]  197     add   ix, bc
   4317                     198   enemies_continue_update:
   4317 F1            [10]  199     pop   af
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



   4318 3D            [ 4]  200     dec   a
   4319 C8            [11]  201     ret   z
   431A C3 DB 42      [10]  202     jp    enemies_update_loop
   431D C9            [10]  203   ret
                            204 
   431E                     205 man_entity_bombs_update::
   431E DD 21 44 42   [14]  206   ld    ix, #_enemy_array
   4322 3A 41 42      [13]  207   ld     a, (_enemy_num)
   4325 B7            [ 4]  208   or     a
   4326 C8            [11]  209   ret    z
                            210 
   4327                     211   bombs_update_loop:
   4327 F5            [11]  212     push  af
                            213     
   4328 DD 7E 00      [19]  214     ld    a, b_timer(ix)         ;; load timer of bomb
   432B E6 00         [ 7]  215     and   #zero_timer            ;; _bomb_timer AND zero_timer
                            216 
   432D 28 2F         [12]  217     jr    z, bombs_increase_index
   432F CD 37 42      [17]  218     call  sys_render_remove_bomb
                            219 
                            220     ;; _last_element_ptr now points to the last entity in the array
                            221     ;; si A=02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
   4332 3A 42 42      [13]  222     ld    a, (_enemy_last)
   4335 D6 09         [ 7]  223     sub   #sizeof_e
   4337 32 42 42      [13]  224     ld    (_enemy_last), a
   433A DA 40 43      [10]  225     jp    c, bombs_overflow_update
   433D C3 47 43      [10]  226     jp    bombs_no_overflow_update    
                            227     
   4340                     228   bombs_overflow_update:
   4340 3A 4F 42      [13]  229     ld    a, (_bomb_last+1)
   4343 3D            [ 4]  230     dec   a
   4344 32 4F 42      [13]  231     ld    (_bomb_last+1), a
                            232 
   4347                     233   bombs_no_overflow_update:
                            234     ;; move the last element to the hole left by the dead entity
   4347 DD E5         [15]  235     push  ix  
   4349 E1            [10]  236     pop   hl
   434A 01 07 00      [10]  237     ld    bc, #sizeof_b       
   434D ED 5B 4E 42   [20]  238     ld    de, (_bomb_last)
   4351 EB            [ 4]  239     ex    de, hl
   4352 ED B0         [21]  240     ldir                        
                            241     
   4354 3A 4D 42      [13]  242     ld    a, (_bomb_num)
   4357 3D            [ 4]  243     dec   a
   4358 32 4D 42      [13]  244     ld    (_bomb_num), a  
                            245 
   435B C3 63 43      [10]  246     jp    bombs_continue_update
                            247 
   435E                     248   bombs_increase_index:
   435E 01 07 00      [10]  249     ld    bc, #sizeof_b
   4361 DD 09         [15]  250     add   ix, bc
   4363                     251   bombs_continue_update:
   4363 F1            [10]  252     pop   af
   4364 3D            [ 4]  253     dec   a
   4365 C8            [11]  254     ret   z
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



   4366 C3 27 43      [10]  255     jp    bombs_update_loop  
   4369 C9            [10]  256   ret
                            257 
                            258 ;;########################################################
                            259 ;;                   PUBLIC FUNCTIONS                    #             
                            260 ;;########################################################
                            261 
                            262 ;;
                            263 ;;  Initialize data for all enemies, player and reset bombs data.
                            264 ;;  INPUT:
                            265 ;;    none
                            266 ;;  RETURN: 
                            267 ;;    none
                            268 ;;  DESTROYED:
                            269 ;;    AF,DE,IX,HL,BC
   436A                     270 man_entity_init::
   436A CD B3 42      [17]  271   call  man_entity_init_entities
   436D CD C5 42      [17]  272   call  man_entity_init_bombs
   4370 C9            [10]  273   ret
                            274 
                            275 
                            276 ;;
                            277 ;;  INPUT:
                            278 ;;    none
                            279 ;;  RETURN: 
                            280 ;;    none
                            281 ;;  DESTROYED:
                            282 ;;    AF,DE,IX,HL,BC
   4371                     283 man_entity_update::
   4371 CD D1 42      [17]  284   call  man_entity_player_update
   4374 CD D2 42      [17]  285   call  man_entity_enemies_update
   4377 CD 1E 43      [17]  286   call  man_entity_bombs_update
   437A C9            [10]  287   ret
                            288 
                            289 
                            290 ;;
                            291 ;;  INPUT:
                            292 ;;    none
                            293 ;;  RETURN: 
                            294 ;;    hl with memory address of free space for new entity
                            295 ;;    ix with memory address of last created entity
                            296 ;;  DESTROYED:
                            297 ;;    A,HL,BC
   437B                     298 man_entity_create_entity::  
   437B 3E 01         [ 7]  299   ld    a, #max_entities
   437D 21 41 42      [10]  300   ld    hl, #_enemy_num
   4380 BE            [ 7]  301   cp   (hl)                  ;; max_entities - _enemy_num
   4381 C8            [11]  302   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                            303 
   4382 CD 57 42      [17]  304   call  man_entity_new_entity
   4385 CD 6D 42      [17]  305   call  man_entity_initialize_entity
   4388 C9            [10]  306   ret
                            307 
                            308 
                            309 ;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



                            310 ;;  INPUT:
                            311 ;;    none
                            312 ;;  RETURN: 
                            313 ;;    hl with memory address of free space for new bomb
                            314 ;;    ix with memory address of last created bomb
                            315 ;;  DESTROYED:
                            316 ;;    A,HL,BC
   4389                     317 man_entity_create_bomb::  
   4389 3E 01         [ 7]  318   ld    a, #max_bombs
   438B 21 4D 42      [10]  319   ld    hl, #_bomb_num
   438E BE            [ 7]  320   cp   (hl)                  ;; max_bombs - _bomb_num
   438F C8            [11]  321   ret   z                    ;; IF Z=1 THEN array is full ELSE create more
                            322 
   4390 CD 89 43      [17]  323   call  man_entity_create_bomb
   4393 CD A0 42      [17]  324   call  man_entity_initialize_bomb
   4396 C9            [10]  325   ret
                            326 
                            327 
                            328 ;;
                            329 ;;  INPUT:
                            330 ;;    none
                            331 ;;  RETURN: 
                            332 ;;    ix with memory address of player
                            333 ;;  DESTROYED:
                            334 ;;    none
   4397                     335 man_entity_get_player::
   4397 DD 21 38 42   [14]  336   ld    ix, #_player
   439B C9            [10]  337   ret
                            338 
                            339 
                            340 ;;
                            341 ;;  INPUT:
                            342 ;;    none
                            343 ;;  RETURN: 
                            344 ;;    ix  begin of enemy array memory address
                            345 ;;    a   number of enemies in the array
                            346 ;;  DESTROYED:
                            347 ;;    none
   439C                     348 man_entity_get_enemy_array::
   439C DD 21 44 42   [14]  349   ld    ix, #_enemy_array
   43A0 3A 41 42      [13]  350   ld     a, (_enemy_num)
   43A3 C9            [10]  351   ret
                            352 
                            353 
                            354 ;;
                            355 ;;  INPUT:
                            356 ;;    none
                            357 ;;  RETURN: 
                            358 ;;    ix  begin of bomb array memory address
                            359 ;;    a   number of bombs in the array
                            360 ;;  DESTROYED:
                            361 ;;    none
   43A4                     362 man_entity_get_bomb_array::
   43A4 DD 21 50 42   [14]  363   ld    ix, #_bomb_array
   43A8 3A 4D 42      [13]  364   ld     a, (_bomb_num)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 13.
Hexadecimal [16-Bits]



   43AB C9            [10]  365   ret
                            366 
                            367 
                            368 ;;
                            369 ;;  INPUT:
                            370 ;;    none
                            371 ;;  RETURN: 
                            372 ;;    ix  begin of player memory address
                            373 ;;  DESTROYED:
                            374 ;;    A
   43AC                     375 man_entity_set_player_dead::
   43AC DD 21 38 42   [14]  376   ld    ix, #_player
   43B0 3E FE         [ 7]  377   ld     a, #dead_type
   43B2 DD 77 00      [19]  378   ld    e_type(ix), a
   43B5 C9            [10]  379   ret
                            380 
                            381 
                            382 ;;
                            383 ;;  INPUT:
                            384 ;;    ix with memory address of entity that must me marked as dead
                            385 ;;  RETURN: 
                            386 ;;    none
                            387 ;;  DESTROYED:
                            388 ;;    A
   43B6                     389 man_entity_set_enemy_dead::
   43B6 3E FE         [ 7]  390   ld    a, #dead_type
   43B8 DD 77 00      [19]  391   ld    e_type(ix), a
   43BB C9            [10]  392   ret
