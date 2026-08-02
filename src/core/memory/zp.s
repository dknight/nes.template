;==========================================================================
; 6502 Zero Page Memory (256 bytes $00-$FF)
;==========================================================================
.segment "ZEROPAGE"

.exportzp ptr_lo
.exportzp ptr_hi
.exportzp scratch00
.exportzp scratch01

; Generic pointers
ptr_lo:     .res 1
ptr_hi:     .res 1

; Scratch (change variables when needed)
scratch00:  .res 1
scratch01:  .res 1
