.include "constants.inc"
.include "apu.inc"
.include "reset.inc"

.import game_init
.export reset

.segment "CODE"

;==========================================================================
; Reset code
;==========================================================================
.proc reset
	SEI						; mask interrupts
	LDA #$00
	STA PPU_CONTROL			; disable NMI
	STA PPU_MASK			; disable rendering
	STA APU_DM_CONTROL		; disable DMC IRQ
	LDA #$40
	STA APU_FRAME_COUNTER	; disable APU frame IRQ
	
	CLD						; disable decimal mode
	LDX #$FF
	TXS						; initialise stack

wait_vblank:
	BIT PPU_STATUS
	BPL wait_vblank
	
	; clear all RAM to 0
	LDA #$00
	LDX #$00
clear_ram:
	STA $0000,X
	;STA $0200,X -- $0200 is OAM and cleaned in clear_oam
	STA $0100,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	STA $0600,X
	STA $0700,X
	INX

	BNE clear_ram
	
	JSR game_init

; wait for second vBlank
wait_vblank2:
	BIT PPU_STATUS
	BPL wait_vblank2
	
	JSR ppu_load_palette
	; JSR ppu_load_nametable
	JSR ppu_load_attributes
	JSR sprite_clear_oam

	; Reset PPU scroll/address after VRAM updates.
	; Without this the screen may start rendering with an unexpected offset.
	LDA PPU_STATUS      ; reset latch
	LDA #$00
	STA PPU_SCROLL      ; Two values X and Y
	STA PPU_SCROLL
	LDA #$20
	STA PPU_ADDR
	LDA #$00
	STA PPU_ADDR
	
	; enable rendering
	LDA #%00011110
	        ;|||||
	        ;||||+-- grayscale
	        ;|||+--- show bg left 8 px
	        ;||+---- show sprites left 8 px
	        ;|+----- show background
	        ;+------ show sprites
	STA PPU_MASK
	
	; enable NMI
	LDA #%10000000
	;VPHBSINN
	;||||||||
	;||||||++-- base nametable
	;|||||+---- VRAM increment
	;||||+----- sprite pattern table
	;|||+------ background pattern table
	;||+------- sprite size
	;|+-------- PPU master/slave
	;+--------- enable NMI
	STA PPU_CONTROL
	
	JMP main
.endproc
