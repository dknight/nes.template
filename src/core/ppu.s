.include "constants.inc"
.include "ppu.inc"

.export ppu_load_palette
.export ppu_load_attributes

.segment "CODE"
;==========================================================================
; Load palette into PPU
;
; Clobbers:
;  A
;==========================================================================
.proc ppu_load_palette
	; reset PPU latch
	LDA PPU_STATUS
	
	; set VRAM address = $3F00
	LDA #$3F
	STA PPU_ADDR
	LDA #$00
	STA PPU_ADDR
	
	LDX #$00

@palette_loop:
	LDA default_palette,X
	STA PPU_DATA
	
	INX
	CPX #$20
	BNE @palette_loop
	
	RTS
.endproc

.proc ppu_load_attributes
	; reset latch
	LDA PPU_STATUS

	; VRAM = $23C0
	LDA #$23
	STA PPU_ADDR
	LDA #$C0
	STA PPU_ADDR

	LDX #$00

@attr_loop:
	LDA attribute_table,X
	STA PPU_DATA

	INX
	CPX #$40
	BNE @attr_loop

	RTS
.endproc

