.segment "CODE"

;=================================================================
; Copies OAM shadow buffer to PPU OAM using DMA.
; Must be called during VBlank.
;=================================================================
.proc dma_transfer
	LDA #$00
	STA PPU_SPRRAM_ADDRESS

	LDA #>oam
	STA SPRITE_DMA
	RTS
.endproc

