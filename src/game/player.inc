.importzp controller01_state
.import oam

.macro player_add_right_edge width
	CLC
	ADC #width
	macro_pixel_to_tile
.endmacro

.macro player_add_bottom_edge height
	CLC
	ADC #height
	macro_pixel_to_tile
.endmacro

.macro player_add_top_edge height
	SEC
	SBC #height
	macro_pixel_to_tile
.endmacro

.macro player_add_left_edge width
	SEC
	SBC #width
	macro_pixel_to_tile
.endmacro

