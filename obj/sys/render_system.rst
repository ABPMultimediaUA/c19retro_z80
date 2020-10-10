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



                              6 .include "../cpct_functions.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 .include "../assets/assets.h.s"
                              1 .globl  _sp_player
                              2 .globl  _sp_enemy
                              3 .globl  _sp_bomb
                              4 .globl  _sp_border_block
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                              9 
                             10 
                             11 ;;########################################################
                             12 ;;                   PRIVATE FUNCTIONS                   #             
                             13 ;;########################################################
                             14 ;;
                             15 ;;  Render player and update its sp_ptr
                             16 ;;  INPUT:
                             17 ;;    none
                             18 ;;  RETURN: 
                             19 ;;    none
                             20 ;;  DESTROYED:
                             21 ;;    DE,BC,HL,IX
   41E4                      22 sys_render_player::
                     0002    23   player_ptr = .+2
   41E4 DD 21 00 00   [14]   24   ld    ix, #0x0000  
                             25 
   41E8 CD 8E 42      [17]   26   call  sys_render_remove_entity
                             27   
                             28   ;; Calculate a video-memory location for sprite
   41EB 11 00 C0      [10]   29   ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   41EE DD 4E 01      [19]   30   ld    c, e_x(ix)                  ;; C = x coordinate       
   41F1 DD 46 02      [19]   31   ld    b, e_y(ix)                  ;; B = y coordinate   
   41F4 CD EB 46      [17]   32   call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                             33   
                             34   ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   41F7 DD 75 07      [19]   35   ld  e_sp_ptr_0(ix), l
   41FA DD 74 08      [19]   36   ld  e_sp_ptr_1(ix), h
                             37 
                             38   ;;  Draw sprite blended
   41FD EB            [ 4]   39   ex    de, hl                      ;; DE = Destination video memory pointer
   41FE 21 C0 40      [10]   40   ld    hl, #_sp_player             ;; Source Sprite Pointer (array with pixel data)
   4201 DD 4E 03      [19]   41   ld    c, e_w(ix)                  ;; Sprite width
   4204 DD 46 04      [19]   42   ld    b, e_h(ix)                  ;; Sprite height
   4207 CD 2B 45      [17]   43   call  cpct_drawSprite_asm 
   420A C9            [10]   44   ret
                             45 
                             46 
                             47 ;;
                             48 ;;  Render enemies and update their sp_ptr
                             49 ;;  INPUT:
                             50 ;;    none
                             51 ;;  RETURN: 
                             52 ;;    none
                             53 ;;  DESTROYED:
                             54 ;;    A,DE,BC,HL,IX
   420B                      55 sys_render_enemies::
                     0029    56   enemy_ptr = .+2
   420B DD 21 00 00   [14]   57   ld    ix, #0x0000
                     002C    58   enemy_num = .+1
   420F 3E 00         [ 7]   59   ld     a, #0
   4211                      60   render_enemies_loop:
   4211 F5            [11]   61     push  af
                             62 
                             63     ;call  sys_render_remove_entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                             64     
                             65     ;; Calculate a video-memory location for sprite
   4212 11 00 C0      [10]   66     ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   4215 DD 4E 01      [19]   67     ld    c, e_x(ix)                  ;; C = x coordinate       
   4218 DD 46 02      [19]   68     ld    b, e_y(ix)                  ;; B = y coordinate   
   421B CD EB 46      [17]   69     call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                             70     
                             71     ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   421E DD 75 07      [19]   72     ld  e_sp_ptr_0(ix), l
   4221 DD 74 08      [19]   73     ld  e_sp_ptr_1(ix), h
                             74 
                             75     ;;  Draw sprite blended
   4224 EB            [ 4]   76     ex    de, hl                      ;; DE = Destination video memory pointer
   4225 21 80 40      [10]   77     ld    hl, #_sp_enemy              ;; Source Sprite Pointer (array with pixel data)
   4228 DD 46 03      [19]   78     ld    b, e_w(ix)                  ;; Sprite width
   422B DD 4E 04      [19]   79     ld    c, e_h(ix)                  ;; Sprite height
   422E CD C3 46      [17]   80     call  cpct_drawSpriteBlended_asm    
                             81   
   4231 01 09 00      [10]   82     ld   bc, #sizeof_e
   4234 DD 09         [15]   83     add  ix, bc
                             84 
   4236 F1            [10]   85     pop   af
   4237 3D            [ 4]   86     dec   a
   4238 C8            [11]   87     ret   z
   4239 18 D6         [12]   88     jr    render_enemies_loop
   423B C9            [10]   89     ret
                             90 
                             91 
                             92 ;;
                             93 ;;  Render bombs and update their sp_ptr
                             94 ;;  INPUT:
                             95 ;;    none
                             96 ;;  RETURN: 
                             97 ;;    none
                             98 ;;  DESTROYED:
                             99 ;;    A,DE,BC,HL,IX
   423C                     100 sys_render_bombs::
   423C CD 93 44      [17]  101   call   man_entity_get_bomb_array
   423F B7            [ 4]  102   or     a   ;; _bomb_num OR _bomb_num: if Z=1, they're equal, 0 bombs in _bomb_array
   4240 C8            [11]  103   ret    z
   4241                     104   render_bombs_loop:
   4241 F5            [11]  105     push af
                            106 
                            107     ;call  sys_render_remove_entity
                            108     
                            109     ;; Calculate a video-memory location for sprite
   4242 11 00 C0      [10]  110     ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   4245 DD 4E 01      [19]  111     ld    c, b_x(ix)                  ;; C = x coordinate       
   4248 DD 46 02      [19]  112     ld    b, b_y(ix)                  ;; B = y coordinate   
   424B CD EB 46      [17]  113     call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                            114     
                            115     ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   424E DD 75 05      [19]  116     ld  b_sp_ptr_0(ix), l
   4251 DD 74 06      [19]  117     ld  b_sp_ptr_1(ix), h
                            118 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                            119     ;;  Draw sprite blended
   4254 EB            [ 4]  120     ex    de, hl                      ;; DE = Destination video memory pointer
   4255 21 40 40      [10]  121     ld    hl, #_sp_bomb               ;; Source Sprite Pointer (array with pixel data)    
   4258 DD 46 03      [19]  122     ld    b, b_w(ix)                  ;; Sprite width
   425B DD 4E 04      [19]  123     ld    c, b_h(ix)                  ;; Sprite height
   425E CD C3 46      [17]  124     call  cpct_drawSpriteBlended_asm    
                            125   
   4261 01 07 00      [10]  126     ld   bc, #sizeof_b
   4264 DD 09         [15]  127     add  ix, bc
                            128 
   4266 F1            [10]  129     pop   af
   4267 3D            [ 4]  130     dec   a
   4268 C8            [11]  131     ret   z
   4269 18 D6         [12]  132     jr    render_bombs_loop
   426B C9            [10]  133     ret
                            134 
                            135 ;;########################################################
                            136 ;;                   PUBLIC FUNCTIONS                    #             
                            137 ;;########################################################
                            138 
                            139 ;;
                            140 ;;  Set video mode and palette
                            141 ;;  INPUT:
                            142 ;;    none
                            143 ;;  RETURN: 
                            144 ;;    none
                            145 ;;  DESTROYED:
                            146 ;;    AF,BC,DE,HL
   426C                     147 sys_render_init::  
   426C 0E 00         [ 7]  148   ld    c, #0
   426E CD D5 45      [17]  149   call  cpct_setVideoMode_asm    
                            150 
   4271 2E 00         [ 7]  151   ld    l, #0
   4273 26 14         [ 7]  152   ld    h, #HW_BLACK
   4275 CD 21 45      [17]  153   call  cpct_setPALColour_asm
                            154 
   4278 CD 86 44      [17]  155   call  man_entity_get_player
   427B DD 22 E6 41   [20]  156   ld    (player_ptr), ix
                            157 
   427F CD 8B 44      [17]  158   call  man_entity_get_enemy_array
   4282 DD 22 0D 42   [20]  159   ld    (enemy_ptr), ix
   4286 32 10 42      [13]  160   ld    (enemy_num), a    
   4289 C9            [10]  161   ret
                            162 
                            163 
                            164 ;;
                            165 ;;  Updates the sprites on screen (video-memory)
                            166 ;;  INPUT:
                            167 ;;    none
                            168 ;;  RETURN: 
                            169 ;;    none
                            170 ;;  DESTROYED:
                            171 ;;    A,DE,BC,HL,IX
   428A                     172 sys_render_update::
   428A CD E4 41      [17]  173   call  sys_render_player
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



                            174   ; call  sys_render_enemies
                            175   ; call  sys_render_bombs
   428D C9            [10]  176   ret  
                            177 
                            178 
                            179 ;;
                            180 ;;  Remove an entity from screen (video-memory)
                            181 ;;  INPUT:
                            182 ;;    ix  with memory address of entity that must be removed
                            183 ;;  RETURN: 
                            184 ;;    none
                            185 ;;  DESTROYED:
                            186 ;;    AF,BC,DE,HL
   428E                     187 sys_render_remove_entity::
   428E DD 5E 07      [19]  188   ld    e, e_sp_ptr_0(ix)          
   4291 DD 56 08      [19]  189   ld    d, e_sp_ptr_1(ix)           ;; Destination video memory pointer
   4294 3E 00         [ 7]  190   ld    a, #0x00  ;;0xFF rojo
   4296 DD 4E 03      [19]  191   ld    c, e_w(ix)                  ;; Sprite width
   4299 DD 46 04      [19]  192   ld    b, e_h(ix)                  ;; Sprite height
   429C CD 1F 46      [17]  193   call  cpct_drawSolidBox_asm
   429F C9            [10]  194   ret
                            195 
                            196 
                            197 ;;
                            198 ;;  Remove an entity from screen (video-memory)
                            199 ;;  INPUT:
                            200 ;;    ix  with memory address of entity that must be removed
                            201 ;;  RETURN: 
                            202 ;;    none
                            203 ;;  DESTROYED:
                            204 ;;    AF,BC,DE,HL
   42A0                     205 sys_render_remove_bomb::
                            206   ;ld    e, b_sp_ptr_0(ix)          
                            207   ;ld    d, b_sp_ptr_1(ix)           ;; Destination video memory pointer
                            208   ;ld    hl, #_sp_bomb               ;; Source Sprite Pointer (array with pixel data)
                            209   ;ld    b, b_w(ix)                  ;; Sprite width
                            210   ;ld    c, b_h(ix)                  ;; Sprite height
                            211   ;call  cpct_drawSpriteBlended_asm
   42A0 C9            [10]  212   ret
                            213 
                            214 
                            215 ;  Render map
                            216 ;;  INPUT:
                            217 ;;    C = x coordinate       
                            218 ;;    B = y coordinate 
                            219 ;;  RETURN: 
                            220 ;;    none
                            221 ;;  DESTROYED:
                            222 ;;    DE,BC,HL,IX
   42A1                     223 sys_render_one_border_block::
   42A1 11 00 C0      [10]  224   ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen 
   42A4 CD EB 46      [17]  225   call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                            226 
                            227   ;;  Draw sprite blended
   42A7 EB            [ 4]  228   ex    de, hl                      ;; DE = Destination video memory pointer
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 11.
Hexadecimal [16-Bits]



   42A8 21 00 40      [10]  229   ld    hl, #_sp_border_block          ;; Source Sprite Pointer (array with pixel data)
   42AB 0E 04         [ 7]  230   ld    c, #4                 ;; Sprite width
   42AD 06 10         [ 7]  231   ld    b, #16            ;; Sprite height
   42AF CD 2B 45      [17]  232   call  cpct_drawSprite_asm 
   42B2 C9            [10]  233   ret
                            234 ;================================================================
   42B3                     235 sys_render_min_row_map::
   42B3 0E 1E         [ 7]  236   ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
   42B5 06 04         [ 7]  237   ld    b, #min_map_y_coord_valid         ;; B = y coordinate  
                            238 
   42B7                     239 min_row:
   42B7 C5            [11]  240   push bc
   42B8 CD A1 42      [17]  241   call sys_render_one_border_block 
   42BB C1            [10]  242   pop bc
   42BC 21 04 00      [10]  243   ld  hl, #0x0004
   42BF 09            [11]  244   add hl, bc
   42C0 44            [ 4]  245   ld b, h
   42C1 4D            [ 4]  246   ld c, l
                            247   
   42C2 3E 4A         [ 7]  248   ld a, #max_map_x_coord_valid-4
   42C4 B9            [ 4]  249   cp c
   42C5 30 F0         [12]  250   jr  nc, min_row
   42C7 C9            [10]  251   ret
                            252   ;================================================================
   42C8                     253 sys_render_max_row_map::
   42C8 0E 1E         [ 7]  254   ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
   42CA 06 B4         [ 7]  255   ld    b, #max_map_y_coord_valid-16         ;; B = y coordinate  
                            256 
   42CC                     257 max_row:
   42CC C5            [11]  258   push bc
   42CD CD A1 42      [17]  259   call sys_render_one_border_block 
   42D0 C1            [10]  260   pop bc
   42D1 21 04 00      [10]  261   ld  hl, #0x0004
   42D4 09            [11]  262   add hl, bc
   42D5 44            [ 4]  263   ld b, h
   42D6 4D            [ 4]  264   ld c, l
                            265   
   42D7 3E 4A         [ 7]  266   ld a, #max_map_x_coord_valid-4
   42D9 B9            [ 4]  267   cp c
   42DA 30 F0         [12]  268   jr  nc, max_row
   42DC C9            [10]  269   ret
                            270 ;================================================================
   42DD                     271 sys_render_min_col_map::
   42DD 0E 1E         [ 7]  272   ld    c, #min_map_x_coord_valid         ;; C = x coordinate       
   42DF 06 04         [ 7]  273   ld    b, #min_map_y_coord_valid         ;; B = y coordinate  
                            274 
   42E1                     275 min_col:
   42E1 C5            [11]  276   push bc
   42E2 CD A1 42      [17]  277   call sys_render_one_border_block 
   42E5 C1            [10]  278   pop bc
   42E6 21 00 10      [10]  279   ld  hl, #0x1000 ;+16
   42E9 09            [11]  280   add hl, bc
   42EA 44            [ 4]  281   ld b, h
   42EB 4D            [ 4]  282   ld c, l
                            283   
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 12.
Hexadecimal [16-Bits]



   42EC 3E B4         [ 7]  284   ld a, #max_map_y_coord_valid-16
   42EE B8            [ 4]  285   cp b
   42EF 30 F0         [12]  286   jr  nc, min_col
   42F1 C9            [10]  287   ret
                            288 ;================================================================
   42F2                     289 sys_render_max_col_map::
   42F2 0E 4A         [ 7]  290   ld    c, #max_map_x_coord_valid-4         ;; C = x coordinate       
   42F4 06 04         [ 7]  291   ld    b, #min_map_y_coord_valid         ;; B = y coordinate  
                            292 
   42F6                     293 max_col:
   42F6 C5            [11]  294   push bc
   42F7 CD A1 42      [17]  295   call sys_render_one_border_block 
   42FA C1            [10]  296   pop bc
   42FB 21 00 10      [10]  297   ld  hl, #0x1000 ;+16
   42FE 09            [11]  298   add hl, bc
   42FF 44            [ 4]  299   ld b, h
   4300 4D            [ 4]  300   ld c, l
                            301   
   4301 3E B4         [ 7]  302   ld a, #max_map_y_coord_valid-16
   4303 B8            [ 4]  303   cp b
   4304 30 F0         [12]  304   jr  nc, max_col
   4306 C9            [10]  305   ret
                            306 
                            307 
                            308 ;  Render map
                            309 ;;  INPUT:
                            310 ;;    none
                            311 ;;  RETURN: 
                            312 ;;    none
                            313 ;;  DESTROYED:
                            314 ;;    DE,BC,HL,IX
   4307                     315 sys_render_map::
   4307 CD B3 42      [17]  316   call sys_render_min_row_map
   430A CD C8 42      [17]  317   call sys_render_max_row_map
   430D CD DD 42      [17]  318   call sys_render_min_col_map
   4310 CD F2 42      [17]  319   call sys_render_max_col_map
   4313 C9            [10]  320   ret
                            321   
                            322 
                            323   
                            324 
