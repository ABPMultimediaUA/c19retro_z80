;;
;;  ENTITY MANAGER
;;

.include "entity_manager.h.s"
.include "../sys/render_system.h.s"


;;########################################################
;;                        VARIABLES                      #             
;;########################################################

empty_type = 0x00
alive_type = 0x01
dead_type = 0xFE
invalid_type = 0xFF

_num_entities: .db 0x0A
_last_elem_ptr: .dw max_entities*sizeof_e+_entity_array
_entity_array:
  ;.ds max_entities*sizeof_e
  DefineStar alive_type, 79, 1,  0xFE, 0x00, 0x80, 0xCCCC
  DefineStar alive_type, 79, 3,  0xFD, 0x00, 0x08, 0xCCCC
  DefineStar alive_type, 79, 5,  0xFC, 0x00, 0x88, 0xCCCC
  DefineStar alive_type, 79, 7, 0xFD, 0x00, 0x30, 0xCCCC
  DefineStar alive_type, 79, 9, 0xFC, 0x00, 0x03, 0xCCCC
  DefineStar alive_type, 79, 11,  0xFE, 0x00, 0x33, 0xCCCC
  DefineStar alive_type, 79, 13,  0xFA, 0x00, 0x70, 0xCCCC
  DefineStar alive_type, 79, 15,  0xF9, 0x00, 0x07, 0xCCCC
  DefineStar alive_type, 79, 17, 0xFF, 0x00, 0x77, 0xCCCC
  DefineStar alive_type, 79, 19, 0xFE, 0x00, 0xF0, 0xCCCC
  .db empty_type

default: DefineStar alive_type, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xCCCC

;;########################################################
;;                   PUBLIC FUNCTIONS                    #             
;;########################################################

;;
;;  INPUT: 
;;    hl with memory address of default entity
;;    de with memory address of free space for new entity
;;  RETURN
;;    hl with memory address of free space for new entity
;;
entityman_create::  
  ld    bc, #sizeof_e
  ldir

  ld    a, (_num_entities)
  inc   a
  ld    (_num_entities), a

  ld    hl, (_last_elem_ptr)    
  ld    bc, #sizeof_e
  add   hl, bc
  ld    (_last_elem_ptr), hl

  ret

entityman_init::
  ld    a, #max_entities  
  ld    de, (_last_elem_ptr)
init_loop:
  push  af
  
  ld    hl, #default  
  call  entityman_create
  ex    de, hl
  
  pop   af
  dec   a
  ret   z
  jr    init_loop


entityman_update::
  ld    ix, #_entity_array
  ld     a, (_num_entities)
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
  ld    a, (_last_elem_ptr)
  sub   #sizeof_e
  ld    (_last_elem_ptr), a
  jp    c, overflow
  jp    no_overflow    
  
overflow:
  ld    a, (_last_elem_ptr+1)
  dec   a
  ld    (_last_elem_ptr+1), a

no_overflow:
  ;; move the last element to the hole left by the dead entity
  push  ix  
  pop   hl
  ld    bc, #sizeof_e       
  ld    de, (_last_elem_ptr)
  ex    de, hl
  ldir                        
  
  ld    a, (_num_entities)
  dec   a
  ld    (_num_entities), a  

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
  ld  a, (_num_entities)
  ret


;;
;;  INPUT: 
;;    ix with memory address of entity that must me marked as dead
;;
entityman_set_dead::
  ld  a, #dead_type
  ld  e_type(ix), a
  ret
