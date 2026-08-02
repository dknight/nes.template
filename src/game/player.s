.include "constants.inc"
.include "player.inc"
.include "collisions.inc"
.include "../include/macros.inc"
.include "../core/input.inc"
.include "../gfx/sprites.inc"
.include "../gfx/gfx.inc"

.exportzp player_x
.exportzp player_y
.exportzp player_next_x
.exportzp player_tile_x
.exportzp player_next_y
.exportzp player_tile_y
.export player_update
.export player_draw
.export player_init

.segment "ZEROPAGE"
player_x:       .res 1
player_y:       .res 1
player_next_x:  .res 1
player_tile_x:  .res 1
player_next_y:  .res 1
player_tile_y:  .res 1

.segment "CODE"
;==========================================================================
; Update player position
;==========================================================================
.if PLAYER_DIAGONAL_ENABLED
	.proc player_update
		JSR player_horizontal_movement
		JSR player_vertical_movement
		RTS
	.endproc
.else
	.proc player_update
		LDA controller01_state
		AND #(BUTTON_LEFT | BUTTON_RIGHT)
		BNE @horizontal

		JSR player_vertical_movement
		RTS

	@horizontal:
		JSR player_horizontal_movement
		RTS
	.endproc
.endif

;==========================================================================
; Move player horizontal movement
;==========================================================================
.proc player_horizontal_movement
	LDA controller01_state
	AND #(BUTTON_LEFT | BUTTON_RIGHT)

	CMP #BUTTON_LEFT
	BEQ @left

	CMP #BUTTON_RIGHT
	BEQ @right
	RTS

@left:
	JSR player_move_left
	RTS

@right:
	JSR player_move_right
	RTS
.endproc

;==========================================================================
; Move player vertical movement
;==========================================================================
.proc player_vertical_movement
	; 
    LDA controller01_state
    AND #(BUTTON_UP | BUTTON_DOWN)

    CMP #BUTTON_UP
    BEQ @up

    CMP #BUTTON_DOWN
    BEQ @down
    RTS

@up:
    JSR player_move_up
    RTS

@down:
    JSR player_move_down
    RTS
.endproc

;==========================================================================
; Move player to left direction
;==========================================================================
.proc player_move_left
	LDA player_x
	CMP #(PLAYER_MIN_X + PLAYER_SPEED)
	BCC @blocked

	SEC
	SBC #PLAYER_SPEED
	STA player_x
	RTS

@blocked:
	LDA #PLAYER_MIN_X
	STA player_x
	RTS
.endproc

;==========================================================================
; Move player to right direction
;==========================================================================
.proc player_move_right
	LDA player_x               ; next_x = player_x + PLAYER_SPEED
	CLC
	ADC #PLAYER_SPEED
	STA player_next_x          ; Save next X-coordinate next_x

	; Check screen max width, can be omitted if you use walls around
	; the level.
	CMP #PLAYER_MAX_X
	BCS @blocked

	; Calculate tile_x of right player border
	util_add_right_edge (PLAYER_WIDTH - 1)
	STA player_tile_x          ; A = tile_x

	; Calculate tile_y of bottom player border
	LDA player_y
	util_add_bottom_edge (PLAYER_HEIGHT - 1)
	STA player_tile_y          ; A = tile_y

	; Check collision at (tile_x, tile_y)
	LDA player_tile_x
	LDY player_tile_y
	JSR collisions_is_solid
	BCS @blocked

    ; Movement is allowed
	LDA player_next_x
	STA player_x

@blocked:
    RTS
.endproc

;==========================================================================
; Move player to up direction
;==========================================================================
.proc player_move_up
	LDA player_y
	CMP #(PLAYER_MIN_Y + PLAYER_SPEED)
	BCC @blocked

	SEC
	SBC #PLAYER_SPEED
	STA player_y
	RTS

@blocked:
	LDA #PLAYER_MIN_Y
	STA player_y
	RTS
.endproc

;==========================================================================
; Move player to bottom direction
;==========================================================================
.proc player_move_down
	LDA player_y
	CMP #(PLAYER_MAX_Y - PLAYER_SPEED)
	BCS @blocked

	CLC
	ADC #PLAYER_SPEED
	STA player_y
	RTS

@blocked:
	LDA #PLAYER_MAX_Y
	STA player_y
	RTS
.endproc

;==========================================================================
; Draw player
;==========================================================================
.proc player_draw
	sprite_draw $00, player_y, $04, OAM_PAL0, player_x
	RTS
.endproc

;==========================================================================
; Set initial player position
;
; Clobbers:
;  A
;==========================================================================
.proc player_init
	LDA #PLAYER_INIT_X
	STA player_x
	LDA #PLAYER_INIT_Y
	STA player_y
	RTS
.endproc

