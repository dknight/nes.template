;==========================================================================
; Convert pixel coordinate in A to tile coordinate.
;==========================================================================
.macro macro_pixel_to_tile
	LSR
	LSR
	LSR
.endmacro

