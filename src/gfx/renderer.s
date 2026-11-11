.import enemies_draw
.import player_draw
.import oam_begin
.import oam_end
.import sprite_clear_oam

.export render

.segment "CODE"

;==========================================================================
; Simple renderer engine
;==========================================================================
.proc render
	JSR oam_begin
	JSR sprite_clear_oam

	JSR player_draw
	JSR enemies_draw

	JSR oam_end

	RTS
.endproc

