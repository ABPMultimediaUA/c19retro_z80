ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;
                              2 ;;  RENDER SYSTEM
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



                              9 .include "../assets/assets.h.s"
                              1 .globl  _sp_player
                              2 .globl  _sp_enemy
                              3 .globl  _sp_bomb
                              4 .globl  _sp_border_block
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                             10 
                             11 
                             12 ;;########################################################
                             13 ;;                   PRIVATE FUNCTIONS                   #             
                             14 ;;########################################################
                             15 ;;
                             16 ;;  Render player and update its sp_ptr
                             17 ;;  INPUT:
                             18 ;;    none
                             19 ;;  RETURN: 
                             20 ;;    none
                             21 ;;  DESTROYED:
                             22 ;;    DE,BC,HL,IX
   41D6                      23 sys_render_player::
                     0002    24   player_ptr = .+2
   41D6 DD 21 00 00   [14]   25   ld    ix, #0x0000  
                             26 
   41DA CD 83 42      [17]   27   call  sys_render_remove_entity
                             28   
                             29   ;; Calculate a video-memory location for sprite
   41DD 11 00 C0      [10]   30   ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   41E0 DD 4E 01      [19]   31   ld    c, e_x(ix)                  ;; C = x coordinate       
   41E3 DD 46 02      [19]   32   ld    b, e_y(ix)                  ;; B = y coordinate   
   41E6 CD 14 47      [17]   33   call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                             34   
                             35   ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   41E9 DD 75 07      [19]   36   ld  e_sp_ptr_0(ix), l
   41EC DD 74 08      [19]   37   ld  e_sp_ptr_1(ix), h
                             38 
                             39   ;;  Draw sprite blended
   41EF EB            [ 4]   40   ex    de, hl                      ;; DE = Destination video memory pointer
   41F0 21 C0 40      [10]   41   ld    hl, #_sp_player             ;; Source Sprite Pointer (array with pixel data)
   41F3 DD 4E 03      [19]   42   ld    c, e_w(ix)                  ;; Sprite width
   41F6 DD 46 04      [19]   43   ld    b, e_h(ix)                  ;; Sprite height
   41F9 CD 54 45      [17]   44   call  cpct_drawSprite_asm 
   41FC C9            [10]   45   ret
                             46 
                             47 
                             48 ;;
                             49 ;;  Render enemies and update their sp_ptr
                             50 ;;  INPUT:
                             51 ;;    none
                             52 ;;  RETURN: 
                             53 ;;    none
                             54 ;;  DESTROYED:
                             55 ;;    A,DE,BC,HL,IX
   41FD                      56 sys_render_enemies::
                     0029    57   enemy_ptr = .+2
   41FD DD 21 00 00   [14]   58   ld    ix, #0x0000
                     002C    59   enemy_num = .+1
   4201 3E 00         [ 7]   60   ld     a, #0
   4203                      61   render_enemies_loop:
   4203 F5            [11]   62     push  af
                             63 
                             64     ;call  sys_render_remove_entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                             65     
                             66     ;; Calculate a video-memory location for sprite
   4204 11 00 C0      [10]   67     ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   4207 DD 4E 01      [19]   68     ld    c, e_x(ix)                  ;; C = x coordinate       
   420A DD 46 02      [19]   69     ld    b, e_y(ix)                  ;; B = y coordinate   
   420D CD 14 47      [17]   70     call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                             71     
                             72     ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   4210 DD 75 07      [19]   73     ld  e_sp_ptr_0(ix), l
   4213 DD 74 08      [19]   74     ld  e_sp_ptr_1(ix), h
                             75 
                             76     ;;  Draw sprite blended
   4216 EB            [ 4]   77     ex    de, hl                      ;; DE = Destination video memory pointer
   4217 21 80 40      [10]   78     ld    hl, #_sp_enemy              ;; Source Sprite Pointer (array with pixel data)
   421A DD 46 03      [19]   79     ld    b, e_w(ix)                  ;; Sprite width
   421D DD 4E 04      [19]   80     ld    c, e_h(ix)                  ;; Sprite height
   4220 CD EC 46      [17]   81     call  cpct_drawSpriteBlended_asm    
                             82   
   4223 01 09 00      [10]   83     ld   bc, #sizeof_e
   4226 DD 09         [15]   84     add  ix, bc
                             85 
   4228 F1            [10]   86     pop   af
   4229 3D            [ 4]   87     dec   a
   422A C8            [11]   88     ret   z
   422B 18 D6         [12]   89     jr    render_enemies_loop
   422D C9            [10]   90     ret
                             91 
                             92 
                             93 ;;
                             94 ;;  Render bombs and update their sp_ptr
                             95 ;;  INPUT:
                             96 ;;    none
                             97 ;;  RETURN: 
                             98 ;;    none
                             99 ;;  DESTROYED:
                            100 ;;    A,DE,BC,HL,IX
   422E                     101 sys_render_bombs::
   422E CD A7 44      [17]  102   call   man_entity_get_bomb_array
   4231 B7            [ 4]  103   or     a   ;; _bomb_num OR _bomb_num: if Z=1, they're equal, 0 bombs in _bomb_array
   4232 C8            [11]  104   ret    z
   4233                     105   render_bombs_loop:
   4233 F5            [11]  106     push af
                            107 
                            108     ;call  sys_render_remove_entity
                            109     
                            110     ;; Calculate a video-memory location for sprite
   4234 11 00 C0      [10]  111     ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   4237 DD 4E 01      [19]  112     ld    c, b_x(ix)                  ;; C = x coordinate       
   423A DD 46 02      [19]  113     ld    b, b_y(ix)                  ;; B = y coordinate   
   423D CD 14 47      [17]  114     call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                            115     
                            116     ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   4240 DD 75 05      [19]  117     ld  b_sp_ptr_0(ix), l
   4243 DD 74 06      [19]  118     ld  b_sp_ptr_1(ix), h
                            119 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



                            120     ;;  Draw sprite blended
   4246 EB            [ 4]  121     ex    de, hl                      ;; DE = Destination video memory pointer
   4247 21 40 40      [10]  122     ld    hl, #_sp_bomb               ;; Source Sprite Pointer (array with pixel data)    
   424A DD 46 03      [19]  123     ld    b, b_w(ix)                  ;; Sprite width
   424D DD 4E 04      [19]  124     ld    c, b_h(ix)                  ;; Sprite height
   4250 CD EC 46      [17]  125     call  cpct_drawSpriteBlended_asm    
                            126   
   4253 01 07 00      [10]  127     ld   bc, #sizeof_b
   4256 DD 09         [15]  128     add  ix, bc
                            129 
   4258 F1            [10]  130     pop   af
   4259 3D            [ 4]  131     dec   a
   425A C8            [11]  132     ret   z
   425B 18 D6         [12]  133     jr    render_bombs_loop
   425D C9            [10]  134     ret
                            135 
                            136 ;;########################################################
                            137 ;;                   PUBLIC FUNCTIONS                    #             
                            138 ;;########################################################
                            139 
                            140 ;;
                            141 ;;  Set video mode and palette
                            142 ;;  INPUT:
                            143 ;;    none
                            144 ;;  RETURN: 
                            145 ;;    none
                            146 ;;  DESTROYED:
                            147 ;;    AF,BC,DE,HL
   425E                     148 sys_render_init::  
   425E CD FC 42      [17]  149   call sys_render_map
   4261 0E 00         [ 7]  150   ld    c, #0
   4263 CD FE 45      [17]  151   call  cpct_setVideoMode_asm    
                            152 
   4266 2E 00         [ 7]  153   ld    l, #0
   4268 26 14         [ 7]  154   ld    h, #HW_BLACK
   426A CD 4A 45      [17]  155   call  cpct_setPALColour_asm
                            156 
   426D CD 9A 44      [17]  157   call  man_entity_get_player
   4270 DD 22 D8 41   [20]  158   ld    (player_ptr), ix
                            159 
   4274 CD 9F 44      [17]  160   call  man_entity_get_enemy_array
   4277 DD 22 FF 41   [20]  161   ld    (enemy_ptr), ix
   427B 32 02 42      [13]  162   ld    (enemy_num), a    
   427E C9            [10]  163   ret
                            164 
                            165 
                            166 ;;
                            167 ;;  Updates the sprites on screen (video-memory)
                            168 ;;  INPUT:
                            169 ;;    none
                            170 ;;  RETURN: 
                            171 ;;    none
                            172 ;;  DESTROYED:
                            173 ;;    A,DE,BC,HL,IX
   427F                     174 sys_render_update::
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



   427F CD D6 41      [17]  175   call  sys_render_player
                            176   ;call  sys_render_enemies
                            177   ;call  sys_render_bombs
   4282 C9            [10]  178   ret  
                            179 
                            180 
                            181 ;;
                            182 ;;  Remove an entity from screen (video-memory)
                            183 ;;  INPUT:
                            184 ;;    ix  with memory address of entity that must be removed
                            185 ;;  RETURN: 
                            186 ;;    none
                            187 ;;  DESTROYED:
                            188 ;;    AF,BC,DE,HL
   4283                     189 sys_render_remove_entity::
   4283 DD 5E 07      [19]  190   ld    e, e_sp_ptr_0(ix)          
   4286 DD 56 08      [19]  191   ld    d, e_sp_ptr_1(ix)           ;; Destination video memory pointer
   4289 3E 00         [ 7]  192   ld    a, #0x00  ;;0xFF rojo
   428B DD 4E 03      [19]  193   ld    c, e_w(ix)                  ;; Sprite width
   428E DD 46 04      [19]  194   ld    b, e_h(ix)                  ;; Sprite height
   4291 CD 48 46      [17]  195   call  cpct_drawSolidBox_asm
   4294 C9            [10]  196   ret
                            197 
                            198 
                            199 ;;
                            200 ;;  Remove an entity from screen (video-memory)
                            201 ;;  INPUT:
                            202 ;;    ix  with memory address of entity that must be removed
                            203 ;;  RETURN: 
                            204 ;;    none
                            205 ;;  DESTROYED:
                            206 ;;    AF,BC,DE,HL
   4295                     207 sys_render_remove_bomb::
                            208   ;ld    e, b_sp_ptr_0(ix)          
                            209   ;ld    d, b_sp_ptr_1(ix)           ;; Destination video memory pointer
                            210   ;ld    hl, #_sp_bomb               ;; Source Sprite Pointer (array with pixel data)
                            211   ;ld    b, b_w(ix)                  ;; Sprite width
                            212   ;ld    c, b_h(ix)                  ;; Sprite height
                            213   ;call  cpct_drawSpriteBlended_asm
   4295 C9            [10]  214   ret
                            215 
                            216 
                            217 ;  Render map
                            218 ;;  INPUT:
                            219 ;;    C = x coordinate       
                            220 ;;    B = y coordinate 
                            221 ;;  RETURN: 
                            222 ;;    none
                            223 ;;  DESTROYED:
                            224 ;;    DE,BC,HL,IX
   4296                     225 sys_render_one_border_block::
   4296 11 00 C0      [10]  226   ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen 
   4299 CD 14 47      [17]  227   call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                            228 
                            229   ;;  Draw sprite blended
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



   429C EB            [ 4]  230   ex    de, hl                      ;; DE = Destination video memory pointer
   429D 21 00 40      [10]  231   ld    hl, #_sp_border_block          ;; Source Sprite Pointer (array with pixel data)
   42A0 0E 04         [ 7]  232   ld    c, #4                 ;; Sprite width
   42A2 06 10         [ 7]  233   ld    b, #16            ;; Sprite height
   42A4 CD 54 45      [17]  234   call  cpct_drawSprite_asm 
   42A7 C9            [10]  235   ret
                            236 ;================================================================
   42A8                     237 sys_render_min_row_map::
   42A8 0E 1E         [ 7]  238   ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
   42AA 06 04         [ 7]  239   ld    b, #min_map_y_coord_valid         ;; B = y coordinate  
                            240 
   42AC                     241 min_row:
   42AC C5            [11]  242   push bc
   42AD CD 96 42      [17]  243   call sys_render_one_border_block 
   42B0 C1            [10]  244   pop bc
   42B1 21 04 00      [10]  245   ld  hl, #0x0004
   42B4 09            [11]  246   add hl, bc
   42B5 44            [ 4]  247   ld b, h
   42B6 4D            [ 4]  248   ld c, l
                            249   
   42B7 3E 4A         [ 7]  250   ld a, #max_map_x_coord_valid-4
   42B9 B9            [ 4]  251   cp c
   42BA 30 F0         [12]  252   jr  nc, min_row
   42BC C9            [10]  253   ret
                            254   ;================================================================
   42BD                     255 sys_render_max_row_map::
   42BD 0E 1E         [ 7]  256   ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
   42BF 06 B4         [ 7]  257   ld    b, #max_map_y_coord_valid-16         ;; B = y coordinate  
                            258 
   42C1                     259 max_row:
   42C1 C5            [11]  260   push bc
   42C2 CD 96 42      [17]  261   call sys_render_one_border_block 
   42C5 C1            [10]  262   pop bc
   42C6 21 04 00      [10]  263   ld  hl, #0x0004
   42C9 09            [11]  264   add hl, bc
   42CA 44            [ 4]  265   ld b, h
   42CB 4D            [ 4]  266   ld c, l
                            267   
   42CC 3E 4A         [ 7]  268   ld a, #max_map_x_coord_valid-4
   42CE B9            [ 4]  269   cp c
   42CF 30 F0         [12]  270   jr  nc, max_row
   42D1 C9            [10]  271   ret
                            272 ;================================================================
   42D2                     273 sys_render_min_col_map::
   42D2 0E 1E         [ 7]  274   ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
   42D4 06 04         [ 7]  275   ld    b, #min_map_y_coord_valid         ;; B = y coordinate  
                            276 
   42D6                     277 min_col:
   42D6 C5            [11]  278   push bc
   42D7 CD 96 42      [17]  279   call sys_render_one_border_block 
   42DA C1            [10]  280   pop bc
   42DB 21 00 10      [10]  281   ld  hl, #0x1000 ;+16
   42DE 09            [11]  282   add hl, bc
   42DF 44            [ 4]  283   ld b, h
   42E0 4D            [ 4]  284   ld c, l
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 13.
Hexadecimal [16-Bits]



                            285   
   42E1 3E B4         [ 7]  286   ld a, #max_map_y_coord_valid-16
   42E3 B8            [ 4]  287   cp b
   42E4 30 F0         [12]  288   jr  nc, min_col
   42E6 C9            [10]  289   ret
                            290 ;================================================================
   42E7                     291 sys_render_max_col_map::
   42E7 0E 4A         [ 7]  292   ld    c, #max_map_x_coord_valid-4         ;; C = x coordinate       
   42E9 06 04         [ 7]  293   ld    b, #min_map_y_coord_valid         ;; B = y coordinate  
                            294 
   42EB                     295 max_col:
   42EB C5            [11]  296   push bc
   42EC CD 96 42      [17]  297   call sys_render_one_border_block 
   42EF C1            [10]  298   pop bc
   42F0 21 00 10      [10]  299   ld  hl, #0x1000 ;+16
   42F3 09            [11]  300   add hl, bc
   42F4 44            [ 4]  301   ld b, h
   42F5 4D            [ 4]  302   ld c, l
                            303   
   42F6 3E B4         [ 7]  304   ld a, #max_map_y_coord_valid-16
   42F8 B8            [ 4]  305   cp b
   42F9 30 F0         [12]  306   jr  nc, max_col
   42FB C9            [10]  307   ret
                            308 
                            309 
                            310 ;  Render map
                            311 ;;  INPUT:
                            312 ;;    none
                            313 ;;  RETURN: 
                            314 ;;    none
                            315 ;;  DESTROYED:
                            316 ;;    DE,BC,HL,IX
   42FC                     317 sys_render_map::
   42FC CD A8 42      [17]  318   call sys_render_min_row_map
   42FF CD BD 42      [17]  319   call sys_render_max_row_map
   4302 CD D2 42      [17]  320   call sys_render_min_col_map
   4305 CD E7 42      [17]  321   call sys_render_max_col_map
   4308 C9            [10]  322   ret
                            323   
                            324 
                            325   
                            326 
