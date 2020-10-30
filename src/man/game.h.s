;;
;;  GAME MANAGER HEADER
;;

.globl  man_game_menu
.globl  man_game_init
.globl  man_game_update
.globl  man_game_terminate
.globl  man_game_init_next_lvl
.globl  man_game_end
.globl  man_game_terminate_dead


;;########################################################
;;                       CONSTANTS                       #             
;;########################################################

;; in bytes
move_right = 4
move_left = -move_right
move_down = 16
move_up = -move_down



;;  In bytes
;;  The max constants are max+1 because this way they represent the first pixel where border begins.
;;  This way, when calculating the last allowed position where an entity may be positioned, it is easier and cleaner.
min_map_y_coord_valid = 12     ;;  [0-3] border, >=4 map
max_map_y_coord_valid = 188    ;;  [196-199] border, <=195 map
map_height_px = max_map_y_coord_valid - min_map_y_coord_valid  ;176
map_height_cell = map_height_px / 16    ;11

;;  Screen width is 160px, each char is 8px, so there are 20 chars. Each Cell Block cell is 2width*2height chars, so
;;  20 width chars == 10 Cell Block cells. 0.75 cell as left border + 3 cells as left extra info + 6 cells map + 0.25 cell as right border = 10 cells
;;  1 cell = 2w char = 16px --> 3.75 cells on the left of the map = 3.75*16=60px. 
;;  2px = 1 byte  --> 60px*1byte/2px=30bytes on the left of the map
;;  Same reasoning for right border: 0.25cell=1char=4px=2byte of right border
min_map_x_coord_valid = 30-4*7      ;;  [0-29] border, >=30 map
max_map_x_coord_valid = 78    ;;  [78-79] border, <=77 map
map_width_px = max_map_x_coord_valid - min_map_x_coord_valid   ;48
map_width_cell = map_width_px / 4   ;12

map_resolution_px = map_height_px * map_width_px
map_resolution_cell = map_height_cell * map_width_cell