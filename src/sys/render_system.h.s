;;
;;  RENDER SYSTEM HEADER
;;

.globl  sys_render_menu
.globl  sys_render_init_config
.globl  sys_render_init
.globl  sys_render_update
.globl  sys_render_remove_entity
.globl  sys_render_remove_menu
.globl  sys_render_remove_bomb
.globl  sys_render_map
.globl  sys_render_border_map
.globl  sys_render_end_menu
.globl  sys_render_remove_end_menu


;;########################################################
;;                       CONSTANTS                       #             
;;########################################################
video_mode = 0

;;  In pixels
screen_width = 160
screen_height = 200
window_resolution_px = 32000 ;screen_width*screen_height


border_block_w = 2
border_block_h = 8
