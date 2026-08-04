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
; Update player position.
;
; Processes controller input and updates the player's position.
;
; Input:
;   controller01_state
;
; Output:
;   player_x and/or player_y may be updated.
;
; Clobbers:
;   A, X, Y
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
; Process horizontal player movement.
;
; Input:
;   controller01_state
;
; Output:
;   player_x may be updated.
;
; Clobbers:
;   A, Y
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
; Process vertical player movement.
;
; Input:
;   controller01_state
;
; Output:
;   player_y may be updated.
;
; Clobbers:
;   A, Y
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
; Move player left by PLAYER_SPEED if movement is allowed.
;
; Input:
;   player_x (pixels)
;   player_y (pixels)
;
; Output:
;   player_x updated if no collision is detected.
;
; Clobbers:
;   A, Y
;==========================================================================
.proc player_move_left
 LDA player_x
	CMP #(PLAYER_MIN_X + PLAYER_SPEED)
	BCC @blocked

	SEC
	SBC #PLAYER_SPEED
	STA player_next_x

	; Calculate tile_x of left player border
	LDA player_next_x
	util_pixel_to_tile
	STA player_tile_x

	; Calculate tile_y of bottom player border
	LDA player_y
	util_add_bottom_edge (PLAYER_HEIGHT - 1)
	STA player_tile_y

	; Check collision
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
; Move player right by PLAYER_SPEED if movement is allowed.
;
; Input:
;   player_x
;   player_y
;
; Output:
;   player_x updated if no collision is detected.
;
; Clobbers:
;   A, Y
;==========================================================================
.proc player_move_right
	LDA player_x
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
; Move player up by PLAYER_SPEED if movement is allowed.
;
; Input:
;   player_x
;   player_y
;
; Output:
;   player_y updated if no collision is detected.
;
; Clobbers:
;   A, Y
;==========================================================================
.proc player_move_up
	LDA player_y
	CMP #(PLAYER_MIN_Y + PLAYER_SPEED)
	BCC @blocked

	SEC
	SBC #PLAYER_SPEED
	STA player_next_y

	; Calculate tile_x of left player border
	LDA player_x
	util_pixel_to_tile
	STA player_tile_x

	; Calculate tile_y of top player border
	LDA player_next_y
	util_pixel_to_tile
	STA player_tile_y

	; Check collision
	LDA player_tile_x
	LDY player_tile_y
	JSR collisions_is_solid
	BCS @blocked

	; Movement is allowed
	LDA player_next_y
	STA player_y

@blocked:
	RTS
.endproc

;==========================================================================
; Move player down by PLAYER_SPEED if movement is allowed.
;
; Input:
;   player_x
;   player_y
;
; Output:
;   player_y updated if no collision is detected.
;
; Clobbers:
;   A, Y
;==========================================================================
.proc player_move_down
	LDA player_y
	CLC
	ADC #PLAYER_SPEED
	STA player_next_y

	; Check screen bottom boundary
	CMP #PLAYER_MAX_Y
	BCS @blocked

	; Calculate tile_x of left player border
	LDA player_x
	util_pixel_to_tile
	STA player_tile_x

    ; Calculate tile_y of bottom player border
    LDA player_next_y
    util_add_bottom_edge (PLAYER_HEIGHT - 1)
    STA player_tile_y

	; Check collision at (tile_x, tile_y)
	LDA player_tile_x
	LDY player_tile_y
	JSR collisions_is_solid
	BCS @blocked

	; Movement is allowed
	LDA player_next_y
	STA player_y

@blocked:
	RTS
.endproc

;==========================================================================
; Draw player sprite.
;
; Input:
;   player_x
;   player_y
;
; Output:
;   Player sprite written to OAM.
;
; Clobbers:
;   A
;==========================================================================
.proc player_draw
	; TODO $42 currently hardcoded player sprite
	sprite_draw $00, player_y, $42, OAM_PAL0, player_x
	RTS
.endproc

;==========================================================================
; Initialize player position.
;
; Input:
;   None
;
; Output:
;   player_x = PLAYER_INIT_X
;   player_y = PLAYER_INIT_Y
;
; Clobbers:
;   A
;==========================================================================
.proc player_init
	LDA #PLAYER_INIT_X
	STA player_x
	LDA #PLAYER_INIT_Y
	STA player_y
	RTS
.endproc

