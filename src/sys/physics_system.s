;;
;;  PHYSICS SYSTEM
;;

.include "../man/entity_manager.h.s"
.include "physics_system.h.s"
.include "../cpct_functions.h.s"

;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_physics_player_update::
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_physics_enemies_update::
  ret


;;
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_physics_bomb_update::
  ret



;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  none
;;  INPUT:
;;    none
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    none
sys_physics_init::
  ret


sys_physics_update::
  call  sys_physics_player_update
  call  sys_physics_enemies_update
  call  sys_physics_bomb_update
  ret
  
