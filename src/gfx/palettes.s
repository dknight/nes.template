.segment "RODATA"

;=================================================================
; Default palette table has 16 entries for backgrounds
; and 16 entries for sprites
;=================================================================
default_palette:
	; 4 background palettes
	.byte $0F,$15,$26,$37
	.byte $0F,$09,$19,$29
	.byte $0F,$01,$11,$21
	.byte $0F,$00,$10,$30

	; 4 sprite palettes
	.byte $0F,$18,$28,$38
	.byte $0F,$14,$24,$34
	.byte $0F,$1B,$2B,$3B
	.byte $0F,$12,$22,$32
