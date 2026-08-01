.exportzp ptr_lo
.exportzp ptr_hi
.exportzp tmp00
.exportzp tmp01

.segment "ZEROPAGE"

;=================================================================
; 6502 Zero Page Memory (256 bytes $00-$FF)
;=================================================================
; Generic pointers
ptr_lo: .res 1
ptr_hi: .res 1

; Scratch (change variables when needed)
tmp00:  .res 1
tmp01:  .res 1
