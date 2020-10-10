ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



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
