;;
;;  RENDER SYSTEM HEADER
;;

.globl  sys_render_init
.globl  sys_render_update
.globl  sys_render_remove_entity
.globl  sys_render_remove_bomb
.globl  sys_render_map


;;########################################################
;;                       CONSTANTS                       #             
;;########################################################
video_mode = 0

;; in pixels
screen_width = 160
screen_height = 200

;;  1 byte for each +-1 Y coordinate (1px)
;;  200px = 25 char -> 1 bomberman cell = 2height*2width chars
;;  25chars*1cell/2char = 12 cells, rest 1 char
;;  1 char = 8px -> so the map is centered, 4px up, 4px down
min_map_y_coord_valid = 4      ;;  [0-3] border, >=4 map
max_map_y_coord_valid = 195-16    ;;  [196-199] border, <=195 map -16px

;;  1 byte for each +-2 X coordinate (2px)
;;  160px = 20 char -> 1 bomberman cell = 2height*2width chars
;;  20chars*1cell/2char = 10 cells -> 4 cells left border, 5 cells map
;;  rest 1 cell=2 char, 1 char left border, 1 char right border
;;  1 char = 8px -> so the map is centered, 4px up, 4px down
;;  9 char left map, 10 char map, 1 char right map
;;  9char*8px*1byte/2px = 36, 19char*8px*1byte/2=76
;; anton: we need to do the map bigger so i make left = 5 char
;;  5char*8px*1byte/2px = 36, 19char*8px*1byte/2=76
min_map_x_coord_valid = 20      ;;  [0-35] border, >=35 map
max_map_x_coord_valid = 75    ;;  [78-79] border, <=77 map