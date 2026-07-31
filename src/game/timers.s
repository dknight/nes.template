.include "constants.inc"
.include "timers.inc"

.export timers_update
.export wait_frame

.segment "CODE"

;=================================================================
; Game timers
;=================================================================
.proc timers_update
    INC vblank_counter

    LDA game_timer
    BEQ @reload

    DEC game_timer
    RTS
@reload:
    LDA #GAME_TIMER_COUNT
    STA game_timer
    RTS
.endproc

;=================================================================
; Wait for the next frame
;=================================================================
.proc wait_frame
@wait:
    LDA frame_ready
    BEQ @wait

    LDA #$00
    STA frame_ready
    RTS
.endproc
