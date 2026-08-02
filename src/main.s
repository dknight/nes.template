.include "include/header.inc"
.include "include/macros.inc"
.include "include/vectors.inc"

.export main

.import nmi
.import irq
.import render
.import game_tick
.import game_poll
.import wait_frame
.import timers_update
.import input_poll
.import reset

;==========================================================================
; Main application logic section includes the game loop
;==========================================================================
.segment "CODE"

.proc main
@loop:
	JSR wait_frame
	JSR input_poll
	JSR timers_update
	JSR game_tick
	JSR render
	JMP @loop
.endproc

