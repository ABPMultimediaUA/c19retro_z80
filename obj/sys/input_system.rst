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



                              7 .include "input_system.h.s"
                              1 ;;
                              2 ;;  INPUT SYSTEM HEADER
                              3 ;;
                              4 
                              5 .globl  sys_input_init
                              6 .globl  sys_input_update
                              7 
                              8 
                              9 ;;########################################################
                             10 ;;                       CONSTANTS                       #             
                             11 ;;########################################################
                             12 
                             13 ;; in bytes
                     0004    14 move_right = 4
                     FFFFFFFC    15 move_left = -move_right
                     0010    16 move_down = 16
                     FFFFFFF0    17 move_up = -move_down
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              8 
                              9 ;;########################################################
                             10 ;;                   PRIVATE FUNCTIONS                   #             
                             11 ;;########################################################
                             12 
                             13 
                             14 ;;########################################################
                             15 ;;                   PUBLIC FUNCTIONS                    #             
                             16 ;;########################################################
                             17 
                             18 ;;
                             19 ;;  INPUT:
                             20 ;;    none
                             21 ;;  RETURN: 
                             22 ;;    none
                             23 ;;  DESTROYED:
                             24 ;;    none
   414D                      25 sys_input_init::
   414D C9            [10]   26   ret
                             27 
                             28 
                             29 ;;
                             30 ;;  INPUT:
                             31 ;;    none
                             32 ;;  RETURN: 
                             33 ;;    none
                             34 ;;  DESTROYED:
                             35 ;;    none
   414E                      36 sys_input_update::
   414E CD A6 43      [17]   37   call  man_entity_get_player
                             38 
                             39   ;; Reset velocities
   4151 DD 36 05 00   [19]   40   ld    e_vx(ix), #0
   4155 DD 36 06 00   [19]   41   ld    e_vy(ix), #0
                             42 
   4159 CD CB 43      [17]   43   call  cpct_scanKeyboard_f_asm
                             44 
   415C 21 08 20      [10]   45   ld    hl, #Key_A;O
   415F CD 35 44      [17]   46   call  cpct_isKeyPressed_asm
   4162 28 05         [12]   47   jr    z, O_NotPressed
   4164                      48 O_Pressed:
   4164 DD 36 05 FC   [19]   49     ld    e_vx(ix), #move_left
   4168 C9            [10]   50     ret
   4169                      51 O_NotPressed:
                             52 
   4169 21 07 20      [10]   53     ld    hl, #Key_D;P
   416C CD 35 44      [17]   54     call  cpct_isKeyPressed_asm
   416F 28 05         [12]   55     jr    z, P_NotPressed
                             56 
   4171                      57 P_Pressed:
   4171 DD 36 05 04   [19]   58     ld    e_vx(ix), #move_right
   4175 C9            [10]   59     ret
   4176                      60 P_NotPressed:
                             61 
   4176 21 07 08      [10]   62     ld    hl, #Key_W;Q
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



   4179 CD 35 44      [17]   63     call  cpct_isKeyPressed_asm
   417C 28 05         [12]   64     jr    z, Q_NotPressed
   417E                      65 Q_Pressed:
   417E DD 36 06 F0   [19]   66     ld    e_vy(ix), #move_up
   4182 C9            [10]   67     ret
   4183                      68 Q_NotPressed:
                             69 
   4183 21 07 10      [10]   70     ld    hl, #Key_S;A
   4186 CD 35 44      [17]   71     call  cpct_isKeyPressed_asm
   4189 28 04         [12]   72     jr    z, A_NotPressed
   418B                      73 A_Pressed:
   418B DD 36 06 10   [19]   74     ld    e_vy(ix), #move_down    
   418F                      75 A_NotPressed:    
   418F C9            [10]   76     ret
