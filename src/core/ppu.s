.include "ppu.inc"

.export ppu_load_palette
.export ppu_load_nametable
.export ppu_load_attributes

.segment "CODE"
;=================================================================
; Load palette into PPU
;=================================================================
.proc ppu_load_palette
	; reset PPU latch
	LDA PPU_STATUS
	
	; set VRAM address = $3F00
	LDA #$3F
	STA PPU_ADDR
	LDA #$00
	STA PPU_ADDR
	
	LDX #$00

palette_loop:
	LDA default_palette,X
	STA PPU_DATA
	
	INX
	CPX #$20
	BNE palette_loop
	
	RTS
.endproc

.proc ppu_load_nametable
	; reset latch
	LDA PPU_STATUS

	; VRAM = $2000
	LDA #$20
	STA PPU_ADDR

	LDA #$00
	STA PPU_ADDR

	; pointer -> nametable
	LDA #<nametable
	STA ptr_lo

	LDA #>nametable
	STA ptr_hi

	; First 768 bytes
	LDX #$03

page_loop:
	LDY #$00

page_bytes:
	LDA (ptr_lo),Y
	STA PPU_DATA

	INY
	BNE page_bytes

	INC ptr_hi
	DEX
	BNE page_loop

	; Last 192 bytes
	; pointer now = background_map + 768
	LDY #$00

last_chunk:
	LDA (ptr_lo),Y
	STA PPU_DATA

	INY
	CPY #192
	BNE last_chunk
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

attr_loop:
	LDA attribute_table,X
	STA PPU_DATA

	INX
	CPX #64
	BNE attr_loop

	RTS
.endproc
