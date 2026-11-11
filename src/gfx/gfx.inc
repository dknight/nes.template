;==========================================================================
; OAM (Object Attribute Memory) sprite layout
;==========================================================================
; Each sprite in NES OAM uses 4 bytes:
;
; byte 0 = Y position
; byte 1 = tile index
; byte 2 = attributes
; byte 3 = X position
;==========================================================================
OAM_OFFSET_Y        = $00
OAM_OFFSET_TILE     = $01
OAM_OFFSET_ATTR     = $02
OAM_OFFSET_X        = $03

;==========================================================================
; Attribute flags
;==========================================================================
; Palette selection
OAM_PALETTE_0       = %00000000
OAM_PALETTE_1       = %00000001
OAM_PALETTE_2       = %00000010
OAM_PALETTE_3       = %00000011

; Sprite priority
OAM_PRIORITY_FRONT  = %00000000
OAM_PRIORITY_BACK   = %00100000

; Sprite flipping
OAM_FLIP_HORIZONTAL = %01000000
OAM_FLIP_VERTICAL   = %10000000

; Sprite DMA Register
OAM_DMA             = $4014
