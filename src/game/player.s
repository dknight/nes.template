.include "game.inc"
.include "player.inc"
.include "../include/macros.inc"
.include "../core/input.inc"
.include "../gfx/gfx.inc"

.importzp ptr_lo
.importzp ptr_hi
.importzp controller01_state
.import oam
.import sprite_draw_meta
.import collisions_is_solid
.import collisions_get_tile
.import collisions_load_level

.exportzp player_x
.exportzp player_y
.exportzp player_next_x
.exportzp player_tile_x
.exportzp player_next_y
.exportzp player_tile_y
.exportzp player_collision_end_y
.exportzp player_collision_end_x
.export player_update
.export player_draw
.export player_init

.segment "ZEROPAGE"

player_x:               .res 1
player_y:               .res 1
player_next_x:          .res 1
player_tile_x:          .res 1
player_next_y:          .res 1
player_tile_y:          .res 1
player_collision_end_y: .res 1
player_collision_end_x: .res 1

.segment "RODATA"

;==========================================================================
; Player metasprite (16x16).
;
; Each entry follows the standard NES OAM format:
;   Y, TILE, ATTR, X
;==========================================================================
player_metasprite:
    ; Y, TILE, ATTR, X
    .byte 0, $40, OAM_PALETTE_0, 0
    .byte 0, $41, OAM_PALETTE_0, 8
    .byte 8, $50, OAM_PALETTE_0, 0
    .byte 8, $51, OAM_PALETTE_0, 8

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
; Move player up by PLAYER_SPEED if movement is allowed.
;
; Input:
;   player_x (pixels)
;   player_y (pixels)
;
; Output:
;   player_y updated if no collision is detected.
;
; Clobbers:
;   A, Y
;==========================================================================
.proc player_move_up
	; Calculate next position
	LDA player_y
	SEC
	SBC #PLAYER_SPEED
	STA player_next_y

	; Check screen boundary
	CMP #PLAYER_MIN_Y
	BCC @blocked

	; Check vertical collision
	JSR player_check_vertical_collision
	BCS @blocked

	; Apply movement
	LDA player_next_y
	STA player_y

@blocked:
	RTS
.endproc

;==========================================================================
; Move player right by PLAYER_SPEED if movement is allowed.
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
.proc player_move_right
    ; Calculate next position
    LDA player_x
    CLC
    ADC #PLAYER_SPEED
    STA player_next_x

    ; Check screen boundary
    CMP #(PLAYER_MAX_X + 1)
    BCS @blocked

    ; Check horizontal collision
    JSR player_check_horizontal_collision
    BCS @blocked

    ; Apply movement
    LDA player_next_x
    STA player_x

@blocked:
    RTS

.endproc

;==========================================================================
; Move player down by PLAYER_SPEED if movement is allowed.
;
; Input:
;   player_x (pixels)
;   player_y (pixels)
;
; Output:
;   player_y updated if no collision is detected.
;
; Clobbers:
;   A, Y
;==========================================================================
.proc player_move_down
	; Calculate next position
	LDA player_y
	CLC
	ADC #PLAYER_SPEED
	STA player_next_y

	; Check screen boundary
	CMP #(PLAYER_MAX_Y + 1)
	BCS @blocked

	; Check vertical collision
	JSR player_check_vertical_collision
	BCS @blocked

	; Apply movement
	LDA player_next_y
	STA player_y

@blocked:
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
	; Calculate next position
	LDA player_x
	SEC
	SBC #PLAYER_SPEED
	STA player_next_x

	; Check screen boundary
	CMP #PLAYER_MIN_X
	BCC @blocked

	; Check horizontal collision
	JSR player_check_horizontal_collision
	BCS @blocked

	; Apply movement
	LDA player_next_x
	STA player_x

@blocked:
	RTS
.endproc

;==========================================================================
; Check vertical collision along the player's leading edge.
;
; Input:
;   player_y       Current Y position.
;   player_next_y  Proposed Y position.
;
; Output:
;   C = 1 if collision detected.
;   C = 0 if movement is allowed.
;
; Clobbers:
;   A, Y
;==========================================================================
.proc player_check_vertical_collision
	; Determine movement direction
	LDA player_next_y
	CMP player_y
	BCC @moving_up

@moving_down:
	; Calculate bottom edge of the proposed position
	LDA player_next_y
	player_add_bottom_edge (PLAYER_HEIGHT - 1)
	STA player_tile_y
	JMP @calculate_horizontal_range

@moving_up:
	; Calculate top edge of the proposed position
	LDA player_next_y
	macro_pixel_to_tile
	STA player_tile_y

@calculate_horizontal_range:
	; Calculate left tile
	LDA player_x
	macro_pixel_to_tile
	STA player_tile_x

	; Calculate right tile
	LDA player_x
	player_add_right_edge (PLAYER_WIDTH - 1)
	STA player_collision_end_x

@check_column:
	; Check current tile
	LDA player_tile_x
	LDY player_tile_y
	JSR collisions_is_solid
	BCS @collision

	; Have we checked the last column
	LDA player_tile_x
	CMP player_collision_end_x
	BEQ @no_collision

	; Move to the next column
	INC player_tile_x
	JMP @check_column

@collision:
	SEC
	RTS

@no_collision:
	CLC
	RTS
.endproc

;==========================================================================
; Check horizontal collision along the player's leading edge.
;
; Determines movement direction and checks every tile along the
; corresponding vertical edge of the player's bounding box.
;
; Input:
;   player_x       Current X position.
;   player_y       Current Y position.
;   player_next_x  Proposed X position.
;
; Output:
;   C = 1 if collision detected.
;   C = 0 if movement is allowed.
;
; Clobbers:
;   A, Y
;
; Uses:
;   player_tile_x
;   player_tile_y
;   player_collision_end_y
;==========================================================================
.proc player_check_horizontal_collision
    ; Determine movement direction
    LDA player_next_x
    CMP player_x
    BCC @moving_left

@moving_right:
    ; Calculate right edge of the proposed position
    LDA player_next_x
    player_add_right_edge (PLAYER_WIDTH - 1)
    STA player_tile_x
    JMP @calculate_vertical_range

@moving_left:
    ; Calculate left edge of the proposed position
    LDA player_next_x
    macro_pixel_to_tile
    STA player_tile_x

@calculate_vertical_range:
    ; Calculate top tile
    LDA player_y
    macro_pixel_to_tile
    STA player_tile_y

    ; Calculate bottom tile
    LDA player_y
    player_add_bottom_edge (PLAYER_HEIGHT - 1)
    STA player_collision_end_y

@check_row:
    ; Check current tile
    LDA player_tile_x
    LDY player_tile_y
    JSR collisions_is_solid
    BCS @collision

    ; Have we checked the last row?
    LDA player_tile_y
    CMP player_collision_end_y
    BEQ @no_collision

    ; Move to the next row
    INC player_tile_y
    JMP @check_row

@collision:
    SEC
    RTS

@no_collision:
    CLC
    RTS
.endproc

;==========================================================================
; Draw player sprite.
;
; Input:
;   player_x (pixels)
;   player_y (pixels)
;
; Output:
;   Player sprite written to OAM.
;
; Clobbers:
;   A
;==========================================================================
.proc player_draw
	; Load metasprite pointer
	LDA #<player_metasprite
	STA ptr_lo

	LDA #>player_metasprite
	STA ptr_hi

	; Pass player coordinates
	LDA player_x
	LDX player_y

	JSR sprite_draw_meta

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

