.include "player.inc"

.segment "ZEROPAGE"
player_x: .res 1
player_y: .res 1

.segment "CODE"

;=================================================================
; Update player position
;=================================================================
.proc player_update

	; Horizontal movement
	LDA controller01_state
	AND #(BUTTON_LEFT | BUTTON_RIGHT)
	
	CMP #BUTTON_LEFT
	BEQ @move_left
	
	CMP #BUTTON_RIGHT
	BEQ @move_right
	
	; none or both pressed
	JMP @vertical

@move_left:
	SEC
	LDA player_x
	SBC #PLAYER_SPEED
	STA player_x
	; Return here to disable diagonal movement, replace JMP to RTS
	; RTS
	JMP @vertical

@move_right:
	CLC
	LDA player_x
	ADC #PLAYER_SPEED
	STA player_x
	; Return here to disable diagonal movement, replace JMP to RTS
	; RTS
	JMP @vertical

; Vertical movement
@vertical:
	LDA controller01_state
	AND #(BUTTON_UP | BUTTON_DOWN)
	
	CMP #BUTTON_UP
	BEQ @move_up
	
	CMP #BUTTON_DOWN
	BEQ @move_down
	
	; none or both pressed
	RTS

@move_up:
	SEC
	LDA player_y
	SBC #PLAYER_SPEED
	STA player_y
	RTS

@move_down:
	CLC
	LDA player_y
	ADC #PLAYER_SPEED
	STA player_y
	RTS
.endproc

;=================================================================
; Draw player
;=================================================================
.proc player_draw
	sprite_draw $00, player_y, $04, OAM_PAL0, player_x
	RTS
.endproc

