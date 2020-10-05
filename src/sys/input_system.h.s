;;
;;  INPUT SYSTEM HEADER
;;

.globl  sys_input_init
.globl  sys_input_update


;;########################################################
;;                       CONSTANTS                       #             
;;########################################################

;; in bytes
move_right = 2
move_left = -move_right
move_down = 16
move_up = -move_down