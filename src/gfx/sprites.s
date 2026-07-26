.include "gfx.inc"

.segment "CODE"
; =========================================================
; SPRITE macro
; =========================================================
.macro sprite_draw base, ypos, tile, attr, xpos
    ; Y position from variable
    lda ypos
    sta oam + base + OAM_Y

    ; Tile index immediate
    lda #tile
    sta oam + base + OAM_TILE

    ; Attribute immediate
    lda #attr
    sta oam + base + OAM_ATTR
;	76543210  OAM_ATTR
;	||||||||
;	||||||++- palette (0-3)
;	|||||+--- unused
;	||||+---- priority
;	|||+----- flip horizontal
;	||+------ flip vertical
;	++------- unused

    ; X position from variable
    lda xpos
    sta oam + base + OAM_X
.endmacro

;=================================================================
; Builing metasprites procedure.
;=================================================================
.macro draw_metasprite
; TODO implement
.endmacro

;=================================================================
; Clear OAM segment
;=================================================================
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

;=================================================================
; Begin OAM segment
;=================================================================
.proc oam_begin
    LDX #$00
    STX oam
    RTS
.endproc

;=================================================================
; End OAM segment
;=================================================================
.proc oam_end
    JSR dma_transfer
    RTS
.endproc
