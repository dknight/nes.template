.include "../core/constants.inc"
.include "../core/ppu.inc"
.include "../core/nmi.inc"

.exportzp frame_ready
.exportzp vblank_counter
.export nmi
.export irq

;==========================================================================
; NMI related related memory reservation
;==========================================================================
.segment "ZEROPAGE"
frame_ready:        .res 1
vblank_counter:     .res 1

.segment "CODE"
;==========================================================================
; NMI Routine: called every vBlank
;
; Clobbers:
;  A
;  X
;  Y
;==========================================================================
.proc nmi
	; Save registers
	PHA
	TXA
	PHA
	TYA
	PHA
	
	JSR dma_transfer

	; Frame ready to process/update.
	; It is better than `INC frame_ready` in case of lag.
	LDA #$01
	STA frame_ready
	
	; Reset scroll
	LDA PPU_STATUS
	LDA #$00
	STA PPU_SCROLL ; two values X and Y
	STA PPU_SCROLL
	
	; Restore registers
	PLA
	TAY
	PLA
	TAX
	PLA
	
	RTI
.endproc

;==========================================================================
; IRQ Clock Interrupt Routine
;==========================================================================
irq:
	RTI
