.include "constants.inc"
.include "game.inc"
.include "collisions.inc"
.include "level.inc"

.exportzp game_timer
.export game_init

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

