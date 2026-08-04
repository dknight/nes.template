.include "tick.inc"

.export game_tick

.segment "CODE"

;==========================================================================
; Input:
;   None
;
; Output:
;   All game systems updated for one game tick.
;
; Clobbers:
;   A, X, Y
;==========================================================================
.proc game_tick
    JSR player_update
    JSR enemies_update
    JSR projectiles_update
    JSR camera_update
    RTS
.endproc