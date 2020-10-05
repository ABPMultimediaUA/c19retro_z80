;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "man/entity_manager.h.s"
.include "sys/render_system.h.s"
.include "sys/physics_system.h.s"
.include "sys/input_system.h.s"
.include "assets/assets.h.s"

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

;;
;; Start of _CODE area
;; 
.area _CODE

;; 
;; Declare all function entry points as global symbols for the compiler.
;; (The linker will know what to do with them)
;; WARNING: Every global symbol declared will be linked, so DO NOT declare 
;; symbols for functions you do not use.
;;

;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::   
   ;; Disable firmware to prevent it from interfering with string drawing
   call cpct_disableFirmware_asm     

   ;;call  man_entity_init
   call  man_entity_init   
   call  sys_input_init
   call  sys_physics_init
   call  sys_render_init   

;; Loop forever
loop:
   call  sys_input_update
   call  sys_physics_update
   call  man_entity_update
   call  sys_render_update

   call wait_n_times
   jr    loop

wait_n_times:
   call  cpct_waitVSYNC_asm   
   halt
   halt
   halt
   halt
   call  cpct_waitVSYNC_asm   
   halt
   halt
   halt
   halt
   call  cpct_waitVSYNC_asm   
   halt
   halt
   halt
   halt
   ret