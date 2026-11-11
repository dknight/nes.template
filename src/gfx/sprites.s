.include "gfx.inc"

.import dma_transfer
.import oam
.importzp ptr_lo
.importzp ptr_hi

.export sprite_clear_oam
.export oam_begin
.export oam_end
.export sprite_draw
.export sprite_draw_meta
.exportzp oam_cursor

.segment "ZEROPAGE"

oam_cursor:   .res 1

sprite_y:     .res 1
sprite_tile:  .res 1
sprite_attr:  .res 1
sprite_x:     .res 1

metasprite_x: .res 1
metasprite_y: .res 1

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
; Begin OAM update.
;
; Input:
;   None
;
; Output:
;   OAM cursor reset to zero.
;
; Clobbers:
;   A
;==========================================================================
.proc oam_begin
	LDA #$00
	STA oam_cursor
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

;==========================================================================
; Draw a single 8x8 hardware sprite.
;
; Input:
;   A - Y coordinate
;   X - CHR tile index
;   Y - OAM attributes
;   sprite_x - X coordinate
;
; Output:
;   One sprite written to OAM.
;   OAM cursor advanced by 4 bytes.
;
; OAM format:
;   Y, TILE, ATTR, X
;
; Clobbers:
;   A, X, Y
;==========================================================================
.proc sprite_draw
	; Save input parameters.
	STA sprite_y
	STX sprite_tile
	STY sprite_attr

	; Get current OAM position.
	LDX oam_cursor

	; Y coordinate (NES OAM uses Y-1).
	LDA sprite_y
	SEC
	SBC #$01
	STA oam,X
	INX

	; CHR tile.
	LDA sprite_tile
	STA oam,X
	INX

	; OAM attributes.
	LDA sprite_attr
	STA oam,X
	INX

	; X coordinate.
	LDA sprite_x
	STA oam,X
	INX

	; Save updated OAM position.
	STX oam_cursor

	RTS
.endproc

;==========================================================================
; Draw a 16x16 metasprite using four 8x8 hardware sprites.
;
; Input:
;   ptr_lo / ptr_hi - pointer to metasprite data
;   A - Base X position
;   X - Base Y position
;
; Data format:
;   Y offset, CHR tile, OAM attributes, X offset
;
; Output:
;   Four sprites written to OAM.
;   OAM cursor advanced by 16 bytes.
;
; Clobbers:
;   A, X, Y
;==========================================================================
.proc sprite_draw_meta
	STA metasprite_x
	STX metasprite_y

	LDY #$00
	LDX oam_cursor

@loop:
	; Calculate Y position (NES OAM Y is offset by -1).
	LDA (ptr_lo),Y
	CLC
	ADC metasprite_y
	SEC
	SBC #$01
	STA oam,X
	INX
	INY

	; Copy CHR tile.
	LDA (ptr_lo),Y
	STA oam,X
	INX
	INY

	; Copy OAM attributes.
	LDA (ptr_lo),Y
	STA oam,X
	INX
	INY

	; Calculate X position.
	LDA (ptr_lo),Y
	CLC
	ADC metasprite_x
	STA oam,X
	INX
	INY

	; Four sprites = 16 bytes.
	CPY #16
	BNE @loop

	; Save updated OAM position.
	STX oam_cursor

	RTS
.endproc

