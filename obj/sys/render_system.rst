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
                             24 .globl  Key_R
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 .include "../assets/assets.h.s"
                              1 .globl  _sp_player
                              2 .globl  _sp_enemy
                              3 .globl  _sp_bomb
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
   4196                      22 sys_render_player::
                     0002    23   player_ptr = .+2
   4196 DD 21 00 00   [14]   24   ld    ix, #0x0000  
                             25 
   419A CD 40 42      [17]   26   call  sys_render_remove_entity
                             27   
                             28   ;; Calculate a video-memory location for sprite
   419D 11 00 C0      [10]   29   ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   41A0 DD 4E 01      [19]   30   ld    c, e_x(ix)                  ;; C = x coordinate       
   41A3 DD 46 02      [19]   31   ld    b, e_y(ix)                  ;; B = y coordinate   
   41A6 CD 6D 46      [17]   32   call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                             33   
                             34   ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   41A9 DD 75 07      [19]   35   ld  e_sp_ptr_0(ix), l
   41AC DD 74 08      [19]   36   ld  e_sp_ptr_1(ix), h
                             37 
                             38   ;;  Draw sprite blended
   41AF EB            [ 4]   39   ex    de, hl                      ;; DE = Destination video memory pointer
   41B0 21 80 40      [10]   40   ld    hl, #_sp_player             ;; Source Sprite Pointer (array with pixel data)
   41B3 DD 4E 03      [19]   41   ld    c, e_w(ix)                  ;; Sprite width
   41B6 DD 46 04      [19]   42   ld    b, e_h(ix)                  ;; Sprite height
   41B9 CD AD 44      [17]   43   call  cpct_drawSprite_asm 
   41BC C9            [10]   44   ret
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
   41BD                      55 sys_render_enemies::
                     0029    56   enemy_ptr = .+2
   41BD DD 21 00 00   [14]   57   ld    ix, #0x0000
                     002C    58   enemy_num = .+1
   41C1 3E 00         [ 7]   59   ld     a, #0
   41C3                      60   render_enemies_loop:
   41C3 F5            [11]   61     push  af
                             62 
                             63     ;call  sys_render_remove_entity
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 8.
Hexadecimal [16-Bits]



                             64     
                             65     ;; Calculate a video-memory location for sprite
   41C4 11 00 C0      [10]   66     ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   41C7 DD 4E 01      [19]   67     ld    c, e_x(ix)                  ;; C = x coordinate       
   41CA DD 46 02      [19]   68     ld    b, e_y(ix)                  ;; B = y coordinate   
   41CD CD 6D 46      [17]   69     call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                             70     
                             71     ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   41D0 DD 75 07      [19]   72     ld  e_sp_ptr_0(ix), l
   41D3 DD 74 08      [19]   73     ld  e_sp_ptr_1(ix), h
                             74 
                             75     ;;  Draw sprite blended
   41D6 EB            [ 4]   76     ex    de, hl                      ;; DE = Destination video memory pointer
   41D7 21 40 40      [10]   77     ld    hl, #_sp_enemy              ;; Source Sprite Pointer (array with pixel data)
   41DA DD 46 03      [19]   78     ld    b, e_w(ix)                  ;; Sprite width
   41DD DD 4E 04      [19]   79     ld    c, e_h(ix)                  ;; Sprite height
   41E0 CD 45 46      [17]   80     call  cpct_drawSpriteBlended_asm    
                             81   
   41E3 01 09 00      [10]   82     ld   bc, #sizeof_e
   41E6 DD 09         [15]   83     add  ix, bc
                             84 
   41E8 F1            [10]   85     pop   af
   41E9 3D            [ 4]   86     dec   a
   41EA C8            [11]   87     ret   z
   41EB 18 D6         [12]   88     jr    render_enemies_loop
   41ED C9            [10]   89     ret
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
   41EE                     100 sys_render_bombs::
   41EE CD D0 43      [17]  101   call   man_entity_get_bomb_array
   41F1 B7            [ 4]  102   or     a   ;; _bomb_num OR _bomb_num: if Z=1, they're equal, 0 bombs in _bomb_array
   41F2 C8            [11]  103   ret    z
   41F3                     104   render_bombs_loop:
   41F3 F5            [11]  105     push af
                            106 
                            107     ;call  sys_render_remove_entity
                            108     
                            109     ;; Calculate a video-memory location for sprite
   41F4 11 00 C0      [10]  110     ld    de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to start of the screen
   41F7 DD 4E 01      [19]  111     ld    c, b_x(ix)                  ;; C = x coordinate       
   41FA DD 46 02      [19]  112     ld    b, b_y(ix)                  ;; B = y coordinate   
   41FD CD 6D 46      [17]  113     call  cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL
                            114     
                            115     ;;  Store in _sp_ptr the video-memory location where the sprite is going to be written
   4200 DD 75 05      [19]  116     ld  b_sp_ptr_0(ix), l
   4203 DD 74 06      [19]  117     ld  b_sp_ptr_1(ix), h
                            118 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 9.
Hexadecimal [16-Bits]



                            119     ;;  Draw sprite blended
   4206 EB            [ 4]  120     ex    de, hl                      ;; DE = Destination video memory pointer
   4207 21 00 40      [10]  121     ld    hl, #_sp_bomb               ;; Source Sprite Pointer (array with pixel data)    
   420A DD 46 03      [19]  122     ld    b, b_w(ix)                  ;; Sprite width
   420D DD 4E 04      [19]  123     ld    c, b_h(ix)                  ;; Sprite height
   4210 CD 45 46      [17]  124     call  cpct_drawSpriteBlended_asm    
                            125   
   4213 01 07 00      [10]  126     ld   bc, #sizeof_b
   4216 DD 09         [15]  127     add  ix, bc
                            128 
   4218 F1            [10]  129     pop   af
   4219 3D            [ 4]  130     dec   a
   421A C8            [11]  131     ret   z
   421B 18 D6         [12]  132     jr    render_bombs_loop
   421D C9            [10]  133     ret
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
   421E                     147 sys_render_init::  
   421E 0E 00         [ 7]  148   ld    c, #0
   4220 CD 57 45      [17]  149   call  cpct_setVideoMode_asm    
                            150 
   4223 2E 00         [ 7]  151   ld    l, #0
   4225 26 14         [ 7]  152   ld    h, #HW_BLACK
   4227 CD A3 44      [17]  153   call  cpct_setPALColour_asm
                            154 
   422A CD C3 43      [17]  155   call  man_entity_get_player
   422D DD 22 98 41   [20]  156   ld    (player_ptr), ix
                            157 
   4231 CD C8 43      [17]  158   call  man_entity_get_enemy_array
   4234 DD 22 BF 41   [20]  159   ld    (enemy_ptr), ix
   4238 32 C2 41      [13]  160   ld    (enemy_num), a    
   423B C9            [10]  161   ret
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
   423C                     172 sys_render_update::
   423C CD 96 41      [17]  173   call  sys_render_player
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 10.
Hexadecimal [16-Bits]



                            174   ;call  sys_render_enemies
                            175   ;call  sys_render_bombs
   423F C9            [10]  176   ret  
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
   4240                     187 sys_render_remove_entity::
   4240 DD 5E 07      [19]  188   ld    e, e_sp_ptr_0(ix)          
   4243 DD 56 08      [19]  189   ld    d, e_sp_ptr_1(ix)           ;; Destination video memory pointer
   4246 3E 00         [ 7]  190   ld    a, #0x00  ;;0xFF rojo
   4248 DD 4E 03      [19]  191   ld    c, e_w(ix)                  ;; Sprite width
   424B DD 46 04      [19]  192   ld    b, e_h(ix)                  ;; Sprite height
   424E CD A1 45      [17]  193   call  cpct_drawSolidBox_asm
   4251 C9            [10]  194   ret
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
   4252                     205 sys_render_remove_bomb::
                            206   ;ld    e, b_sp_ptr_0(ix)          
                            207   ;ld    d, b_sp_ptr_1(ix)           ;; Destination video memory pointer
                            208   ;ld    hl, #_sp_bomb               ;; Source Sprite Pointer (array with pixel data)
                            209   ;ld    b, b_w(ix)                  ;; Sprite width
                            210   ;ld    c, b_h(ix)                  ;; Sprite height
                            211   ;call  cpct_drawSpriteBlended_asm
   4252 C9            [10]  212   ret
