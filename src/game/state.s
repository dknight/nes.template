.include "state.inc"

.exportzp game_state
.exportzp game_flags
.export state_init
.export state_set
.export state_check
.export state_set_flags
.export state_clear_flags
.export state_check_flags

;=================================================================
; Game state
;=================================================================
.segment "ZEROPAGE"
game_state: .res 1
game_flags: .res 1

.segment "CODE"
;=================================================================
; Init game state
;=================================================================
.proc state_init
	LDA #STATE_TITLE
	STA game_state

	LDA #$00
	STA game_flags

	RTS
.endproc

;=================================================================
; Set state
; A = new state
;=================================================================
.proc state_set
	STA game_state
	RTS
.endproc

;=================================================================
; Check state
; A = state to compare
; Z = 1 if equal
;=================================================================
.proc state_check
	CMP game_state
	RTS
.endproc

;=================================================================
; Set flags
; A = flag mask
;=================================================================
.proc state_set_flags
	ORA game_flags
	STA game_flags
	RTS
.endproc

;=================================================================
; Clear flags
; A = flag mask
;=================================================================
.proc state_clear_flags
	EOR #$FF
	AND game_flags
	STA game_flags
	RTS
.endproc

;=================================================================
; Check flags
; A = flag mask
; Z = 1 if flag is NOT set
; Z = 0 if flag is set
;=================================================================
.proc state_check_flags
	AND game_flags
	RTS
.endproc

