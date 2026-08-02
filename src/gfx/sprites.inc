.import dma_transfer
.import oam

; =========================================================
; Draw sprite macro
; =========================================================
.macro sprite_draw base, ypos, tile, attr, xpos
	; Y position from variable
	LDA ypos
	; Compensate NES y-1 offset
	SEC
	SBC #$01
	STA oam + base + OAM_Y

	; Tile index immediate
	LDA #tile
	STA oam + base + OAM_TILE

	; Attribute immediate
	LDA #attr
	STA oam + base + OAM_ATTR
;	76543210  OAM_ATTR
;	||||||||
;	||||||++- palette (0-3)
;	|||||+--- unused
;	||||+---- priority
;	|||+----- flip horizontal
;	||+------ flip vertical
;	++------- unused

	; X position from variable
	LDA xpos
	STA oam + base + OAM_X
.endmacro

;=================================================================
; Draw metasprites macro
;=================================================================
.macro sprite_draw_metasprite
; TODO implement
.endmacro

