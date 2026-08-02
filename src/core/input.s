.include "input.inc"

.exportzp controller01_state
.export input_poll

.segment "ZEROPAGE"
controller01_state: .res 1

.segment "CODE"

;==========================================================================
; Read controllers
;
; Clobbers:
;   A
;==========================================================================
.proc input_poll
	LDA #$01
	STA JOYPAD1
	
	LDA #$00
	STA JOYPAD1
	
	LDX #$08
	LDA #$00
	STA controller01_state

@read_loop:
	LDA JOYPAD1
	LSR A
	ROR controller01_state
	
	DEX
	BNE @read_loop
	
	RTS
.endproc

