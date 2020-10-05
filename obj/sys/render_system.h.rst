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
