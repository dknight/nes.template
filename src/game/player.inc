;==========================================================================
; Define player constants and configurations
;==========================================================================
; If player speed is more than 8, there is possibiliy of "tunneling effect"
; when player can go through thin obstacle.
PLAYER_SPEED            = 1
PLAYER_WIDTH            = 16
PLAYER_HEIGHT           = 16
PLAYER_MIN_X            = GAME_LEFT_EDGE
PLAYER_MAX_X            = GAME_RIGHT_EDGE - PLAYER_WIDTH
PLAYER_MIN_Y            = GAME_TOP_EDGE
PLAYER_MAX_Y            = GAME_BOTTOM_EDGE - PLAYER_HEIGHT
PLAYER_DIAGONAL_ENABLED = 1
PLAYER_INIT_X           = 80 ; x-coord
PLAYER_INIT_Y           = 64 ; y-coord

;==========================================================================
; Calculate player's top edge tile coordinate.
; Expects player's Y position in A.
;==========================================================================
.macro player_add_top_edge height
	SEC
	SBC #height
	macro_pixel_to_tile
.endmacro

;==========================================================================
; Calculate player's right edge tile coordinate.
; Expects player's X position in A.
;==========================================================================
.macro player_add_right_edge width
	CLC
	ADC #width
	macro_pixel_to_tile
.endmacro

;==========================================================================
; Calculate player's bottom edge tile coordinate.
; Expects player's Y position in A.
;==========================================================================
.macro player_add_bottom_edge height
	CLC
	ADC #height
	macro_pixel_to_tile
.endmacro

;==========================================================================
; Calculate player's left edge tile coordinate.
; Expects player's X position in A.
;==========================================================================
.macro player_add_left_edge width
	SEC
	SBC #width
	macro_pixel_to_tile
.endmacro

