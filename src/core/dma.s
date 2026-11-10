.include "../core/constants.inc"
.include "../core/ppu.inc"
.include "../gfx/gfx.inc"
.include "../core/memory/oam.inc"

.export dma_transfer

.segment "CODE"

;==========================================================================
; Copies OAM shadow buffer to PPU OAM using DMA.
; Must be called during VBlank.
;
; Clobbers:
;  A
;==========================================================================
.proc dma_transfer
	LDA #$00
	STA PPU_OAM_ADDR

	LDA #>oam
	STA OAM_DMA
	RTS
.endproc

