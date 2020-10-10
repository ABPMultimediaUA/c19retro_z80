.include "man/game_manager.h.s"
.include "man/entity_manager.h.s"

.include "sys/render_system.h.s"
.include "sys/physics_system.h.s"
.include "sys/input_system.h.s"

.include "assets/assets.h.s"

;;########################################################
;;                        VARIABLES                      #             
;;########################################################


;;=================================================================================
;; Public functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initializes the game manager
;; INPUT:
;; DESTROYS:
;;
man_game_init2::
    
    ;; Init Entities managers:
    ;; - Player: Entity
    ;; - Enemies: array<Entity>
    ;; - Bombs: array<Bomb>
    call man_entity_init

    ;; Init systems
    call sys_input_init
    call sys_physics_init
    call sys_render_init

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Updates 1 Game Cycle
;; INPUT:
;; DESTROYS:
;;
;; TODO
man_game_update2::
    ; call man_entity_update      ;; check state of entities to delete them

    ; ; call man_entity_get_bomb_array
    ; call sys_physics_bomb_update

    ; ; call man_entity_get_enemy_array
    ; ; call sys_ai_update
    ; call sys_physics_enemies_update
    
    ; ; call man_entity_get_player
    ; ; call sys_input_update
    ; call sys_physics_player_update

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Render 1 Game Cycle
;; INPUT:
;; DESTROYS:
;;
man_game_render::
    ; call man_entity_getBombs
    ; call sys_render_update_bombs

    ; call man_entity_getEnemies
    ; call sys_render_update_enemies
    
    ; call man_entity_getPlayer
    ; call sys_render_update_player

    ret


    





