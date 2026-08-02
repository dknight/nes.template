.include "state.inc"

.exportzp game_state
.exportzp game_flags
.export state_init
.export state_set
.export state_check
.export state_set_flags
.export state_clear_flags
.export state_check_flags

;==========================================================================
; Game state
;==========================================================================
.segment "ZEROPAGE"
game_state: .res 1
game_flags: .res 1

.segment "CODE"
;==========================================================================
; Init game state
;
; Clobbers:
;   A
;==========================================================================
.proc state_init
	LDA #STATE_TITLE
	STA game_state

	LDA #$00
	STA game_flags

	RTS
.endproc

;==========================================================================
; Set game state
;
; Input:
;   A = new state
;==========================================================================
.proc state_set
	STA game_state
	RTS
.endproc

;==========================================================================
; Check game state
;
; Input:
;   A = state to compare
;
; Output:
;   Z = 1 if equal
;   Z = 0 otherwise
;==========================================================================
.proc state_check
	CMP game_state
	RTS
.endproc

;==========================================================================
; Set game flags
;
; Input:
;   A = flag mask
;==========================================================================
.proc state_set_flags
	ORA game_flags
	STA game_flags
	RTS
.endproc

;==========================================================================
; Clear game flags
; Input:
;   A = flag mask
;==========================================================================
.proc state_clear_flags
	EOR #$FF
	AND game_flags
	STA game_flags
	RTS
.endproc

;==========================================================================
; Check game flags
; Input:
;   A = flag mask
;
; Output:
;   Z = 1 if no flags match
;   Z = 0 if any flag matches
;==========================================================================
.proc state_check_flags
	AND game_flags
	RTS
.endproc

