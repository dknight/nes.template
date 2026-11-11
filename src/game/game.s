.include "constants.inc"

.import collisions_load_level
.import player_init
.import state_init
.import level_load

.export game_init
.exportzp game_timer

.segment "ZEROPAGE"

game_timer: .res 1

.segment "CODE"

;==========================================================================
; Initialize game state.
;
; Input:
;   None
;
; Output:
;   Game systems initialized and the first level loaded.
;
; Clobbers:
;   A, X, Y
;==========================================================================
.proc game_init
	JSR collisions_load_level
	JSR level_load
	JSR state_init
	JSR player_init

	; Init game timer
	LDA #$08
	STA game_timer

	RTS
.endproc

