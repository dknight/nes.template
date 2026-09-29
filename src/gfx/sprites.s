.include "gfx.inc"
.include "sprites.inc"

.export sprite_clear_oam
.export oam_begin
.export oam_end

.segment "CODE"

;==========================================================================
; Input:
;   None
;
; Output:
;   Clear OAM segment
;
; Clobbers:
;   A,X
;==========================================================================
.proc sprite_clear_oam
	LDA #$FF
	LDX #$00

clear_loop:
	STA oam,X
	
	INX
	INX
	INX
	INX
	
	BNE clear_loop
	
	RTS
.endproc

;==========================================================================
; Input:
;   None
;
; Output:
;   Begin OAM segment
;
; Clobbers:
;   X
;==========================================================================
.proc oam_begin
    LDX #$00
    STX oam
    RTS
.endproc

;==========================================================================
; Input:
;   None
;
; Output:
;   End OAM segment
;
; Clobbers:
;   None
;==========================================================================
.proc oam_end
    JSR dma_transfer
    RTS
.endproc
