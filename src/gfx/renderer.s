.include "renderer.inc"

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

