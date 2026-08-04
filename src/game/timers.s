.include "constants.inc"
.include "timers.inc"

.export timers_update
.export wait_frame

.segment "CODE"

;==========================================================================
; Update game timers.
;
; Increments the VBlank counter and updates the game timer.
;
; Input:
;   None
;
; Output:
;   vblank_counter incremented.
;   game_timer decremented or reloaded.
;
; Clobbers:
;   A
;==========================================================================
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

;==========================================================================
; Wait for the next frame.
;
; Blocks until frame_ready is set by the NMI handler, then clears the flag.
;
; Input:
;   None
;
; Output:
;   frame_ready cleared.
;
; Clobbers:
;   A
;==========================================================================
.proc wait_frame
@wait:
    LDA frame_ready
    BEQ @wait

    LDA #$00
    STA frame_ready
    RTS
.endproc

