.segment "CODE"

;=================================================================
; Simple renderer engine
;=================================================================
.proc render
    JSR oam_begin
    JSR player_draw
    JSR enemies_draw
    ; JSR draw_ui
    JSR oam_end
    RTS
.endproc
