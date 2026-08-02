.include "constants.inc"
.include "game.inc"
.include "collisions.inc"

.exportzp game_timer
.export game_init

.segment "ZEROPAGE"
game_timer: .res 1

.segment "CODE"

;==========================================================================
; Init game data
;==========================================================================
.proc game_init
	JSR collisions_load_level
	JSR state_init
	JSR player_init

	; Init game timer
	LDA #$08
	STA game_timer

	RTS
.endproc

