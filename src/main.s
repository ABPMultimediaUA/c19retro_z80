; ; ; ; MIT License

; ; ; ; Copyright (c) 2020 Carlos Eduardo Arismendi Sánchez / Antón Chernysh / Sergio Cortés Espinosa

; ; ; ; Permission is hereby granted, free of charge, to any person obtaining a copy
; ; ; ; of this software and associated documentation files (the "Software"), to deal
; ; ; ; in the Software without restriction, including without limitation the rights
; ; ; ; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; ; ; ; copies of the Software, and to permit persons to whom the Software is
; ; ; ; furnished to do so, subject to the following conditions:

; ; ; ; The above copyright notice and this permission notice shall be included in all
; ; ; ; copies or substantial portions of the Software.

; ; ; ; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; ; ; ; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; ; ; ; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; ; ; ; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; ; ; ; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; ; ; ; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; ; ; ; SOFTWARE.

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
.include "man/game.h.s"
.include "sys/render_system.h.s"

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

;Input a
repeat_a::
   push af
   call  cpct_waitVSYNC_asm   
   call  sys_render_update 
   halt
   pop af
   dec a
   jr nz, repeat_a
   
   ret
;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::   
   ;; Disable firmware to prevent it from interfering with string drawing
   call  cpct_disableFirmware_asm
      
   cpctm_setBorder_asm #HW_BLACK
   call  sys_render_init_config
   
   call  man_game_menu
   call  man_game_init   
;; Loop forever
loop:
   call  man_game_update

   jr    loop   