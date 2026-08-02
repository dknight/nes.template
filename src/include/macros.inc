; =========================================================
; Define custom or utility macros
; =========================================================
.macro util_pixel_to_tile
	LSR
	LSR
	LSR
.endmacro

; TODO:
; player_left_edge_to_tile
; player_top_edge_to_tile

.macro util_add_right_edge width
	CLC
	ADC #width
	util_pixel_to_tile
.endmacro

.macro util_add_bottom_edge height
	CLC
	ADC #height
	util_pixel_to_tile
.endmacro
