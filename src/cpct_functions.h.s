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



.globl  cpct_disableFirmware_asm

;; Video-render functions
.globl  cpct_setVideoMode_asm
.globl  cpct_getScreenPtr_asm
.globl  cpct_waitVSYNC_asm
.globl  cpct_setPALColour_asm
.globl  cpct_setPalette_asm

.globl  CPCT_VMEM_START_ASM

;; Draw functions
.globl  cpct_drawSpriteBlended_asm
.globl  cpct_drawSolidBox_asm
.globl  cpct_drawSprite_asm

;; Chars and string functions
.globl  cpct_drawStringM0_asm
.globl  cpct_setDrawCharM0_asm


;; keyboard functions and utils
.globl  cpct_scanKeyboard_f_asm
.globl  cpct_isKeyPressed_asm

.globl  Key_O
.globl  Key_P
.globl  Key_Q
.globl  Key_A
.globl  Key_R
.globl  Key_Space
.globl  Key_Esc


;; Music functions
.globl  cpct_akp_musicInit_asm
.globl  cpct_akp_musicPlay_asm

;; HW COLORS
.globl  HW_BLACK 
.globl  HW_BLUE 
.globl  HW_BRIGHT_BLUE
.globl  HW_RED
.globl  HW_BRIGHT_RED
.globl  HW_GREEN
.globl  HW_SKY_BLUE
.globl  HW_BRIGHT_YELLOW
.globl  HW_WHITE
.globl  HW_PINK
.globl  HW_BRIGHT_GREEN
.globl  HW_SEA_GREEN 
.globl  HW_BRIGHT_CYAN
.globl  HW_LIME
.globl  HW_PASTEL_GREEN
.globl  HW_BRIGHT_WHITE