;==========================================================================
; Define custom or utility macros
;==========================================================================
.macro util_pixel_to_tile
	LSR
	LSR
	LSR
.endmacro

.macro util_add_left_edge width
	SEC
	SBC #width
	util_pixel_to_tile
.endmacro

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

.macro util_add_top_edge height
	SEC
	SBC #height
	util_pixel_to_tile
.endmacro
