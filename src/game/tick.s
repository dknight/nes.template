;=================================================================
; Game one tick
;=================================================================
.proc game_tick
    JSR player_update
    JSR enemies_update
    JSR projectiles_update
    JSR camera_update
    RTS
.endproc
