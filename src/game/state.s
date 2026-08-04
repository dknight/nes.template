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
; Initialize game state.
;
; Input:
;   None
;
; Output:
;   game_state = STATE_TITLE
;   game_flags = $00
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
; Set current game state.
;
; Input:
;   A = new game state
;
; Output:
;   game_state updated.
;
; Clobbers:
;   A
;==========================================================================
.proc state_set
	STA game_state
	RTS
.endproc

;==========================================================================
; Compare current game state.
;
; Input:
;   A = game state to compare
;
; Output:
;   Z = 1 if states are equal.
;   Z = 0 otherwise.
;
; Clobbers:
;   P (status flags)
;==========================================================================
.proc state_check
	CMP game_state
	RTS
.endproc

;==========================================================================
; Set game flags.
;
; Input:
;   A = flag mask
;
; Output:
;   Specified flags set in game_flags.
;
; Clobbers:
;   A
;==========================================================================
.proc state_set_flags
	ORA game_flags
	STA game_flags
	RTS
.endproc

;==========================================================================
; Clear game flags.
;
; Input:
;   A = flag mask
;
; Output:
;   Specified flags cleared in game_flags.
;
; Clobbers:
;   A
;==========================================================================
.proc state_clear_flags
	EOR #$FF
	AND game_flags
	STA game_flags
	RTS
.endproc

;==========================================================================
; Check game flags.
;
; Input:
;   A = flag mask
;
; Output:
;   Z = 1 if none of the specified flags are set.
;   Z = 0 if any specified flag is set.
;==========================================================================
.proc state_check_flags
	AND game_flags
	RTS
.endproc

