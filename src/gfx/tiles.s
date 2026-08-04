;==========================================================================
; Import pattern CHR data (tiles)
;==========================================================================
.segment "TILES"
.incbin  "../../assets/patterns.chr"

.segment "RODATA"

.export tile_to_chr

tile_to_chr:
.byte $40 ; TILE_NOT_USED
.byte $00 ; TILE_FLOOR
.byte $41 ; TIL_WALL

