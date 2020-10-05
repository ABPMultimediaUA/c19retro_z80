;;
;;  RENDER SYSTEM HEADER
;;

.globl  sys_render_init
.globl  sys_render_update
.globl  sys_render_remove_entity
.globl  sys_render_remove_bomb


;;########################################################
;;                       CONSTANTS                       #             
;;########################################################
video_mode = 0

;;  In pixels
screen_width = 160
screen_height = 200

;;  In bytes
;;  The max constants are max+1 because this way they represent the first pixel where border begins.
;;  This way, when calculating the last allowed position where an entity may be positioned, it is easier and cleaner.
min_map_y_coord_valid = 4     ;;  [0-3] border, >=4 map
max_map_y_coord_valid = 196    ;;  [196-199] border, <=195 map

;;  Screen width is 160px, each char is 8px, so there are 20 chars. Each bomberman cell is 2width*2height chars, so
;;  20 width chars == 10 bomberman cells. 0.75 cell as left border + 3 cells as left extra info + 6 cells map + 0.25 cell as right border = 10 cells
;;  1 cell = 2w char = 16px --> 3.75 cells on the left of the map = 3.75*16=60px. 
;;  2px = 1 byte  --> 60px*1byte/2px=30bytes on the left of the map
;;  Same reasoning for right border: 0.25cell=1char=4px=2byte of right border
min_map_x_coord_valid = 30      ;;  [0-29] border, >=30 map
max_map_x_coord_valid = 78    ;;  [78-79] border, <=77 map