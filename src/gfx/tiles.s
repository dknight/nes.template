;==========================================================================
; Import pattern CHR data (tiles)
;==========================================================================
.segment "TILES"
.incbin  "../../assets/patterns.chr"

.segment "RODATA"

.export tile_to_chr

tile_to_chr:
	.byte $00 ; TILE_NOT_USED
	.byte $A0 ; TILE_FLOOR
	.byte $A2 ; TILE_WALL

