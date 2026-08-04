.include "../core/constants.inc"

.segment "RODATA"
;==========================================================================
; Nametable is used for backgrounds
;==========================================================================

.export attribute_table

attribute_table:
	.repeat 64
	.byte $00
	.endrepeat
