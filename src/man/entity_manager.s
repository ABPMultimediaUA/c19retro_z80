;;
;;  ENTITY MANAGER
;;

.include "entity_manager.h.s"


;;########################################################
;;                        VARIABLES                      #             
;;########################################################

empty_type: .db 0x00
alive_type: .db 0x01
dead_type: .db 0xFE
invalid_type: .db 0xFF

_num_entities: .db 0x0A
_last_elem_ptr: .dw _entity_array
_entity_array:
  ;.ds max_entities*sizeof_e
  DefineStar alive_type, 79, 1,  -1, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 4,  -2, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 7,  -3, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 10, -1, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 13, -3, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 1,  -1, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 4,  -2, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 7,  -3, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 10, -1, -1, 0x88, 0xCCCC
  DefineStar alive_type, 79, 13, -3, -1, 0x88, 0xCCCC

default: DefineStar 0xFF, 0x28, 0x28, 0xFE, 0xFE, 0xFF, 0xCCCC

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
  ;ld ix, #_entity_array
  ;ld  a, (_num_entities)
;
  ;ld  c, e_type(ix)
  ret
;

;;
;; RETURN: 
;;  ix  begin of entity array memory address
;;  a   last element pointer (free space)
;;
get_entity_array::
  ld ix, #_entity_array
  ld  a, (_num_entities)
  ret
