.include "gfx.inc"
.include "sprites.inc"

.export sprite_clear_oam
.export oam_begin
.export oam_end

.segment "CODE"
;==========================================================================
; Clear OAM segment
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
; Begin OAM segment
;==========================================================================
.proc oam_begin
    LDX #$00
    STX oam
    RTS
.endproc

;==========================================================================
; End OAM segment
;==========================================================================
.proc oam_end
    JSR dma_transfer
    RTS
.endproc
