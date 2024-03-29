; ; ; ; MIT License
; ; ; ; 
; ; ; ; Copyright (c) 2020 Carlos Eduardo Arismendi Sánchez / Antón Chernysh / Sergio Cortés Espinosa
; ; ; ; 
; ; ; ; Permission is hereby granted, free of charge, to any person obtaining a copy
; ; ; ; of this software and associated documentation files (the "Software"), to deal
; ; ; ; in the Software without restriction, including without limitation the rights
; ; ; ; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; ; ; ; copies of the Software, and to permit persons to whom the Software is
; ; ; ; furnished to do so, subject to the following conditions:
; ; ; ; 
; ; ; ; The above copyright notice and this permission notice shall be included in all
; ; ; ; copies or substantial portions of the Software.
; ; ; ;
; ; ; ; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; ; ; ; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; ; ; ; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; ; ; ; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; ; ; ; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; ; ; ; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; ; ; ; SOFTWARE.

; ; ; ; ----------------- AUTHORS ------------------
; ; ; ; Code & Graphics: 
; ; ; ;     Anton Chernysh: anton_chernysh@outlook.es 
; ; ; ;     Carlos Eduardo Arismendi Sánchez: carlos.arismendisanchez@gmail.com
; ; ; ; Loading screen & Music: 
; ; ; ;     Sergio Cortes Espinosa: sercotes93@gmail.com
; ; ; ; ---------------------------------------------

; ; ; ; Third Party source code used
; ; ; ; ----------------------------
; ; ; ; CPCtelera - owned by ronaldo / (Cheesetea, Fremos, ByteRealms) - GNU Lesser General Public License.


;;
;;  ENTITY MANAGER
;;

.include "entity_manager.h.s"
.include "game.h.s"
.include "../sys/render_system.h.s"
.include "../cpct_functions.h.s"


;;########################################################
;;                        VARIABLES                      #             
;;########################################################

_player:    
  DefineEntity alive_type, 0,  0,   0,  0,   0,  0,   no_ghost

_enemy_num:
  .db 1

_enemy_last:
  .dw _enemy_array

_enemy_array:
  .dw enemies_map1


enemies_map1::
  .db 1
  DefineEntity alive_type,  8,  5,   4,  0,   40,  0,   no_ghost  
  ; DefineEntity alive_type,  6,  1,   1,  4,  15, 15,   ghost

enemies_map2::
  .db 2
  DefineEntity alive_type,  2,  5,   4,  0,  20,  0,   no_ghost
  DefineEntity alive_type, 17,  7,   4,  0,  20,  0,   no_ghost  

enemies_map3::
  .db 5
  DefineEntity alive_type,  3,  8,   0, 16,   0, 25,   no_ghost
  
  DefineEntity alive_type,  9,  2,   0, 16,   0, 12,   no_ghost
  DefineEntity alive_type, 12,  4,   0, 16,   0, 12,   no_ghost
  DefineEntity alive_type, 16,  8,   4,  0,  25,  0,   no_ghost
  DefineEntity alive_type, 16, 10,   4,  0,  34,  0,   no_ghost  


enemies_map4::
  .db 1
  DefineEntity alive_type,  6,  1,   1,  4,  34, 34,   ghost  

enemies_map5::
  .db 3
  DefineEntity alive_type,  6,  1,   1,  4,  15, 15,   ghost
  DefineEntity alive_type,  8,  7,   4,  0,   5,  0,   no_ghost
  DefineEntity alive_type,  9,  9,   4,  0,   9,  0,   no_ghost  

enemies_map6::
  .db 7
  DefineEntity alive_type,  0, 10,   1,  4,  15, 15,   ghost

  DefineEntity alive_type,  6,  4,   0, 16,   0,  7,   no_ghost
  DefineEntity alive_type,  7,  5,   4,  0,  17,  0,   no_ghost
  DefineEntity alive_type, 11,  5,   4,  0,  17,  0,   no_ghost

  DefineEntity alive_type, 17,  7,   0, 16,   0, 12,   no_ghost
  DefineEntity alive_type,  2,  9,   0, 16,   0,  7,   no_ghost
  DefineEntity alive_type,  6, 10,   0, 16,   0,  7,   no_ghost  

enemies_map7::
  .db 6
  DefineEntity alive_type,  3,  1,   1,  4,  15, 15,   ghost

  DefineEntity alive_type,  5,  1,   0, 16,   0,  8,   no_ghost
  DefineEntity alive_type, 14,  4,   4,  0,   7,  0,   no_ghost
  DefineEntity alive_type, 14,  6,   4,  0,   8,  0,   no_ghost

  DefineEntity alive_type, 18,  6,   4,  0,   6,  0,   no_ghost
  DefineEntity alive_type, 14,  8,   4,  0,  10,  0,   no_ghost  

enemies_map8::
  .db 5
  ; DefineEntity alive_type,  5,  0,   1,  4,  15, 15,   ghost  

  DefineEntity alive_type,  2,  8,   4,  0,  20,  0,   no_ghost
  DefineEntity alive_type, 12,  1,   0, 16,   0, 25,   no_ghost  
  DefineEntity alive_type,  0,  2,   4,  0,  20,  0,   no_ghost  

  DefineEntity alive_type, 11,  6,   0, 16,   0, 40,   no_ghost  
  DefineEntity alive_type, 15,  8,   0, 16,   0, 40,   no_ghost

enemies_map9::
  .db 6
  DefineEntity alive_type,  0,  2,   4,  0,  30,  0,   no_ghost 
  DefineEntity alive_type,  1,  8,   4,  0,  35,  0,   no_ghost 
  DefineEntity alive_type,  14, 5,   4,  0,  30,  0,   no_ghost 
  DefineEntity alive_type,  3,  2,   0,  16,  0,  35,   no_ghost 
  DefineEntity alive_type,  6,  2,   0,  16,  0,  35,   no_ghost 
  DefineEntity alive_type,  12, 2,   0,  16,  0,  35,   no_ghost 

enemies_map10::
  .db 6
  DefineEntity alive_type,  3,  2,   0, 16,    0, 40,   no_ghost
  DefineEntity alive_type,  5,  4,   0, 16,    0, 40,   no_ghost
  DefineEntity alive_type,  7,  2,   0, 16,    0, 50,   no_ghost
  DefineEntity alive_type, 11,  2,   0, 16,    0, 40,   no_ghost
  DefineEntity alive_type, 18,  4,   4,  0,   25,  0,   no_ghost
  DefineEntity alive_type, 12,  8,   4,  0,   50,  0,   no_ghost
;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################


;;
;;  Initialize data for all enemies and player.
;;  INPUT:
;;    ix  with memory address of entity that must be initialized
;;    b   X coordinate
;;    c   Y coordinate
;;    h   X cell
;;    l   Y cell
;;    d   X velocity
;;    e   Y velocity
;;  RETURN: 
;;    none
;;  DESTROYED:
;;    A
man_entity_initialize_entity::  
  ld    e_type(ix), #alive_type  
  
  ld    e_x(ix), b        ;; set X coordiante
  ld    e_y(ix), c        ;; set Y coordiante

  ld    e_xcell(ix), h      ;; set X coordiante cell  
  ld    e_ycell(ix), l      ;; set Y coordiante cell 

  ld    e_vx(ix), d      ;; set X velocity  
  ld    e_vy(ix), e      ;; set Y velocity    
  
  ld    e_w(ix), #4       ;; set sprite width
  ld    e_h(ix), #16      ;; set sprite height

  ld    hl, #CPCT_VMEM_START_ASM+402
  ld    e_sp_ptr_0(ix), h
  ld    e_sp_ptr_1(ix), l

  ld    e_l(ix),  #max_lifes

  ld    bomb_type+sizeof_e_solo(ix), #invalid_type
  ld    bomb_w+sizeof_e_solo(ix), #4
  ld    bomb_h+sizeof_e_solo(ix), #16   

  ret


man_entity_init_player::
  ld    ix, #_player
  ld    b, #min_map_x_coord_valid
  ld    c, #min_map_y_coord_valid
  ld    h, #0     ;; set X coordiante cell  
  ld    l, #0     ;; set Y coordiante cell        
  ld    d, #0     ;; set X velocity
  ld    e, #0     ;; set Y velocity
  call  man_entity_initialize_entity
  ld    e_map_index(ix), #0
  ret


man_entity_player_update::
  ret


;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  Initialize data for all enemies, player and reset bombs data.
;;  INPUT:  
;;    A with level map number
;;  DESTROYED:
;;    AF,DE,IX,HL,BC
man_entity_init::
  call  man_entity_init_enemies
  call  man_entity_init_player  
  ;call  man_entity_init_entities
  ret

;;
;;  Initialize data for all enemies, player and reset bombs data.
;;  INPUT:  
;;    A with level map number
;;  DESTROYED:
;;    AF,DE,IX,HL,BC
man_entity_next_lvl::
  call  man_entity_init_enemies
  
  ld    ix, #_player
  ld    e_x(ix), #min_map_x_coord_valid
  ld    e_y(ix), #min_map_y_coord_valid
  ld    e_xcell(ix), #0
  ld    e_ycell(ix), #0
  ld    hl, #CPCT_VMEM_START_ASM+402
  ld    e_sp_ptr_0(ix), h
  ld    e_sp_ptr_1(ix), l
  ld    e_map_index(ix), #0

  ;call  man_entity_init_entities
  ret

;;  DESTROYED:
;;    AF,DE,IX,HL,BC
man_entity_update::
  call  man_entity_player_update
  ret


;;  RETURN: 
;;    ix with memory address of player
man_entity_get_player::
  ld    ix, #_player
  ret


;;  RETURN: 
;;    ix  begin of enemy array memory address
;;    a   number of enemies in the array
man_entity_get_enemy_array::
  ld    ix, (_enemy_array)
  ld    a, 0(ix)
  inc   ix
  ret


man_entity_terminate::
  ; ld  a, #_enemy_array
  ; ld  (_enemy_last), a

  ; ld  a, #0
  ; ld  (_enemy_num), a
  ret


;input A with level number
man_entity_init_enemies::
  ld    b, a
  xor    #1
  jr    z, lvl_1

  ld    a, b
  xor    #2
  jr    z, lvl_2

  ld    a, b
  xor    #3
  jr    z, lvl_3
  
  ld    a, b
  xor    #4
  jr    z, lvl_4

  ld    a, b
  xor    #5
  jr    z, lvl_5

  ld    a, b
  xor    #6
  jr    z, lvl_6

  ld    a, b
  xor    #7
  jr    z, lvl_7

  ld    a, b
  xor    #8
  jr    z, lvl_8

  ld    a, b
  xor    #9
  jr    z, lvl_9

   ld    a, b
  xor    #10
  jr    z, lvl_10

  ret
lvl_1:
  ld    hl, #enemies_map1
  ld    (_enemy_array), hl
  ; ld    ix, (_enemy_array)
  ; ld    (_enemy_num), 0(ix)
  ret
lvl_2:
  ld    hl, #enemies_map2
  ld    (_enemy_array), hl
  ret

lvl_3:
  ld    hl, #enemies_map3
  ld    (_enemy_array), hl  
  ret

lvl_4:
  ld    hl, #enemies_map4
  ld    (_enemy_array), hl 
  ret
lvl_5:
  ld    hl, #enemies_map5
  ld    (_enemy_array), hl 
  ret
lvl_6:
  ld    hl, #enemies_map6
  ld    (_enemy_array), hl 
  ret
  
lvl_7:
  ld    hl, #enemies_map7
  ld    (_enemy_array), hl 
  ret

lvl_8:
  ld    hl, #enemies_map8
  ld    (_enemy_array), hl 
  ret

lvl_9:
  ld    hl, #enemies_map9
  ld    (_enemy_array), hl 
  ret

lvl_10:
  ld    hl, #enemies_map10
  ld    (_enemy_array), hl 
  ret