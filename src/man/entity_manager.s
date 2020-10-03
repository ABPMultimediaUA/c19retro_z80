;;
;;  ENTITY MANAGER
;;

.include "entity_manager.h.s"
.include "../sys/render_system.h.s"
.include "../cpct_functions.h.s"


;;########################################################
;;                        VARIABLES                      #             
;;########################################################
DefineStarArray _entity, max_entities, DefineStarDefault

;;########################################################
;;                   PRIVATE FUNCTIONS                   #             
;;########################################################

;;
;;  RETURN
;;    hl with memory address of free space for new entity
;;    ix with memory address of last created entity
;;
entityman_new_entity::
  ld    a, (_entity_num)
  inc   a
  ld    (_entity_num), a

  ld    ix, (_entity_last)    
  ld    hl, (_entity_last)    
  ld    bc, #sizeof_e
  add   hl, bc
  ld    (_entity_last), hl
  ret

;;
;;  INPUT: 
;;    ix with memory address of entity that must be initialized
;;
entityman_initialize_rand::  
  ld    e_type(ix), #alive_type    ;; set Y velocity  

  ld    a, #0
  ld    e_vy(ix), a               ;; set Y velocity  

  call cpct_getRandom_mxor_u8_asm
  ld    a, l
  ld    e_y(ix), a                ;; set Y coordiante

  ld    e_vx(ix), #0xFF               ;; set X velocity  

  ld    a, #0x50                   
  ld    e_x(ix), a               ;; set X coordinate to the most right possible byte
  ret

;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

entityman_create_one::  
  ld    a, #invalid_type
  ld    hl, (_entity_last)
  cp   (hl)                  ;; last entity type - invalid_type 
  ret   z                    ;; IF Z=1 THEN array is full ELSE create more

  call  entityman_new_entity
  call  entityman_initialize_rand
  ret


entityman_init::
  ld    a, #max_entities
  ld    de, (_entity_last)
init_loop:
  push  af
  
  call  entityman_new_entity
  call  entityman_initialize_rand
  
  pop   af
  dec   a
  ret   z
  jr    init_loop


entityman_update::
  ld    ix, #_entity_array
  ld     a, (_entity_num)
  or     a
  ret    z

entityman_loop:
  push  af
  
  ld    a, e_type(ix)         ;; load type of entity
  and   #dead_type            ;; entity_type AND dead_type

  jr    z, inc_index
  call  rendersys_delete_entity

  ;; _last_element_ptr now points to the last entity in the array
  ;; si A 02, al hacer A-sizeOf, puede pasar por debajo de 0 -> FE por ejemplo, lo cual debería restar
  ld    a, (_entity_last)
  sub   #sizeof_e
  ld    (_entity_last), a
  jp    c, overflow
  jp    no_overflow    
  
overflow:
  ld    a, (_entity_last+1)
  dec   a
  ld    (_entity_last+1), a

no_overflow:
  ;; move the last element to the hole left by the dead entity
  push  ix  
  pop   hl
  ld    bc, #sizeof_e       
  ld    de, (_entity_last)
  ex    de, hl
  ldir                        
  
  ld    a, (_entity_num)
  dec   a
  ld    (_entity_num), a  

  jp    continue_update

inc_index:
  ld    bc, #sizeof_e
  add   ix, bc
continue_update:
  pop   af
  dec   a
  ret   z
  jp    entityman_loop
;

;;
;; RETURN: 
;;  ix  begin of entity array memory address
;;  a   number of valid and alive entities
;;
get_entity_array::
  ld ix, #_entity_array
  ld  a, (_entity_num)
  ret


;;
;;  INPUT: 
;;    ix with memory address of entity that must me marked as dead
;;
entityman_set_dead::
  ld  a, #dead_type
  ld  e_type(ix), a
  ret
