.include "inc/constants.s"
.include "inc/header.s"
.include "inc/vectors.s"

;=================================================================
; 6502 Zero Page Memory (256 bytes)
;=================================================================
.segment "ZEROPAGE"
controller1:   .res 1
frame_counter: .res 1
frame_ready:   .res 1
player_x:      .res 1
player_y:      .res 1

;=================================================================
; Sprite OAM Data area - copied to VRAM in NMI routine
;=================================================================
.segment "OAM"
oam: .res 256

;=================================================================
; Import both the background and sprite character sets
;=================================================================
.segment "TILES"
.incbin  "chr/example.chr" ; contains alpha num symbols

;=================================================================
; Reset code
;=================================================================
.segment "CODE"
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
	
	JSR init_game

; wait for second vBlank
wait_vblank2:
	BIT PPU_STATUS
	BPL wait_vblank2
	
	JSR clear_oam
	JSR load_palette
	JSR build_oam
	
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

;=================================================================
; Init game data
;=================================================================
.proc init_game
	; Set player position
	LDA #120
	STA player_x
	LDA #100
	STA player_y
	RTS
.endproc

;=================================================================
; NMI Routine:  called every vBlank
;=================================================================
.segment "CODE"
.proc nmi
	; Save registers
	PHA
	TXA
	PHA
	TYA
	PHA
	
	; OAM DMA
	LDA #$00
	STA PPU_SPRRAM_ADDRESS
	
	LDA #>oam
	STA SPRITE_DMA
	
	; Frame ready to process/update.
	; It is better than `INC frame_ready` in case of lag.
	LDA #$01
	STA frame_ready
	
	; Increment frame counter
	INC frame_counter
	
	; Restore registers
	PLA
	TAY
	PLA
	TAX
	PLA
	
	RTI
.endproc

;=================================================================
; IRQ Clock Interrupt Routine
;=================================================================
.segment "CODE"
irq:
	RTI

;=================================================================
; Our default palette table has 16 entries for ti
; and 16 entries for sprites
;=================================================================
.segment "RODATA"
default_palette:
; 4 background palettes
.byte $0F,$15,$26,$37
.byte $0F,$09,$19,$29
.byte $0F,$01,$11,$21
.byte $0F,$00,$10,$30
; 4 sprite palettes
.byte $0F,$18,$28,$38
.byte $0F,$14,$24,$34
.byte $0F,$1B,$2B,$3B
.byte $0F,$12,$22,$32

;=================================================================
; Load palette into PPU
;=================================================================
.proc load_palette
	; reset PPU latch
	LDA PPU_STATUS
	
	; set VRAM address = $3F00
	LDA #$3F
	STA PPU_ADDR
	
	; upload 32 bytes
	LDA #$00
	STA PPU_ADDR
	
	LDX #$00

palette_loop:
	LDA default_palette,X
	STA PPU_DATA
	
	INX
	CPX #32
	BNE palette_loop
	
	RTS
.endproc

;=================================================================
; Hide all sprites by setting Y=255
;=================================================================
.proc clear_oam
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
; Builing test sprite. 64 x 4 = 256 bytes
; Sprite structure {Y, INDEX, ATTRS, X}
;=================================================================
.proc build_oam
	; @ (player)
	; Y position
	LDA player_y
	STA oam+0
	
	; Sprite index
	LDA #$40
	STA oam+1
	
	; Attribute Byte
	LDA #$00
	STA oam+2
;		76543210
;		||||||||
;		||||||++- palette (0-3)
;		|||||+--- unused
;		||||+---- priority
;		|||+----- flip horizontal
;		||+------ flip vertical
;		++------- unused
	
	; X position
	LDA player_x
	STA oam+3
	
	RTS
.endproc

;*****************************************************************
; Read controller #1
;*****************************************************************
.proc read_controller1
	LDA #$01
	STA JOYPAD1
	
	LDA #$00
	STA JOYPAD1
	
	LDX #$08
	LDA #$00
	STA controller1

read_loop:
	LDA JOYPAD1
	LSR A
	ROL controller1
	
	DEX
	BNE read_loop
	
	RTS
.endproc

;=================================================================
; Update player position
;=================================================================
.proc update_player

check_right:
	   LDA controller1
	   AND #%00000001
	   BEQ check_left
	   INC player_x

check_left:
	   LDA controller1
	   AND #%00000010
	   BEQ check_down
	   DEC player_x

check_down:
	   LDA controller1
	   AND #%00000100
	   BEQ check_up
	   INC player_y

check_up:
	   LDA controller1
	   AND #%00001000
	   BEQ done
	   DEC player_y

done:
    RTS
.endproc

.proc update_game
	JSR update_player
	RTS
.endproc

;=================================================================
; Main application logic section includes the game loop
;=================================================================
.segment "CODE"
.proc main

main_loop:

wait_frame:
	LDA frame_ready
	BEQ wait_frame
	
	LDA #$00
	STA frame_ready

	JSR read_controller1
	JSR build_oam
	JSR update_game
	
	JMP main_loop
.endproc

