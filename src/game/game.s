.include "game.inc"

.exportzp game_timer
.export game_init

.segment "ZEROPAGE"
game_timer: .res 1

.segment "CODE"

;=================================================================
; Init game data
;=================================================================
.proc game_init
	JSR state_init

	; Init game timer
	LDA #$08
	STA game_timer

	; Set player position
	LDA #$50
	STA player_x
	LDA #$40
	STA player_y

	RTS
.endproc

