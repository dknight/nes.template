.include "constants.inc"
.include "player.inc"
.include "collisions.inc"
.include "../core/input.inc"
.include "../gfx/sprites.inc"
.include "../gfx/gfx.inc"

.exportzp player_x
.exportzp player_y
.export player_update
.export player_draw
.export player_init

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

	LDA player_x
	LDY player_y
	JSR collisions_is_wall
	BCS @movement_blocked
	
	; none or both pressed
	JMP @vertical

@move_left:
	LDA player_x
	CMP #(PLAYER_MIN_X + PLAYER_SPEED)
	BCC @left_stop

	SEC
	SBC #PLAYER_SPEED
	STA player_x
	; Return here to disable diagonal movement, replace JMP to RTS
	; RTS
	JMP @vertical

@left_stop:
	LDA #PLAYER_MIN_X
	STA player_x
	; Return here to disable movement along the wall, replace JMP to RTS
	; RTS
	JMP @vertical

@move_right:
	LDA player_x
	CMP #(PLAYER_MAX_X - PLAYER_SPEED)
	BCS @right_stop

	CLC
	ADC #PLAYER_SPEED
	STA player_x
	; Return here to disable diagonal movement, replace JMP to RTS
	; RTS
	JMP @vertical

@right_stop:
	LDA #PLAYER_MAX_X
	STA player_x
	; Return here to disable movement along the wall, replace JMP to RTS
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

@movement_blocked:
	RTS

@move_up:
	LDA player_y
	CMP #(PLAYER_MIN_Y + PLAYER_SPEED)
	BCC @up_stop

	SEC
	SBC #PLAYER_SPEED
	STA player_y
	RTS

@up_stop:
	LDA #PLAYER_MIN_Y
	STA player_y
	RTS

@move_down:
	LDA player_y
	CMP #(PLAYER_MAX_Y - PLAYER_SPEED)
	BCS @down_stop

	CLC
	ADC #PLAYER_SPEED
	STA player_y
	RTS

@down_stop:
	LDA #PLAYER_MAX_Y
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

;=================================================================
; Set initial player position
;=================================================================
.proc player_init
	LDA #$50
	STA player_x
	LDA #$40
	STA player_y
.endproc
