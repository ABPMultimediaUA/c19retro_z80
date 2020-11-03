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
;;  INPUT SYSTEM HEADER
;;

.globl  sys_input_init
.globl  sys_input_update
.globl  sys_input_press_play
.globl  sys_input_press_restart