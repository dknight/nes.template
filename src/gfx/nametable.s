.export attribute_table
.export nametable

.segment "RODATA"

;==========================================================================
; Nametable is used for backgrounds
;==========================================================================
nametable:
	.repeat 32
		.byte $07     ; empty line
	.endrepeat

	.repeat 32
		.byte $02     ; upper wall
	.endrepeat

	.repeat 26
		.byte $02
		.repeat 30
			.byte $00
		.endrepeat
		.byte $02
	.endrepeat

	.repeat 32
		.byte $02     ; lower wall
	.endrepeat

	.repeat 32
		.byte $07     ; empty line
	.endrepeat

nametable_end:
	.assert (nametable_end - nametable) = 960, error, "Wrong map size"

attribute_table:
	.repeat 64
	.byte $00
	.endrepeat
