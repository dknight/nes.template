.import dma_transfer
.import oam

; =========================================================
; Draw sprite macro
; =========================================================
.macro sprite_draw base, ypos, tile, attr, xpos
    ; Y position from variable
    lda ypos
    sta oam + base + OAM_Y

    ; Tile index immediate
    lda #tile
    sta oam + base + OAM_TILE

    ; Attribute immediate
    lda #attr
    sta oam + base + OAM_ATTR
;	76543210  OAM_ATTR
;	||||||||
;	||||||++- palette (0-3)
;	|||||+--- unused
;	||||+---- priority
;	|||+----- flip horizontal
;	||+------ flip vertical
;	++------- unused

    ; X position from variable
    lda xpos
    sta oam + base + OAM_X
.endmacro

;=================================================================
; Draw metasprites macro
;=================================================================
.macro sprite_draw_metasprite
; TODO implement
.endmacro

