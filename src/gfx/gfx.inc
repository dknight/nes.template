;==========================================================
; OAM (Object Attribute Memory) sprite layout
;==========================================================
; Each sprite in NES OAM uses 4 bytes:
;
; byte 0 = Y position
; byte 1 = tile index
; byte 2 = attributes
; byte 3 = X position
;==========================================================
OAM_Y     = $00
OAM_TILE  = $01
OAM_ATTR  = $02
OAM_X     = $03

;==========================================================
; Attribute flags
;==========================================================
OAM_PAL0   = %00000000
OAM_PAL1   = %00000001
OAM_PAL2   = %00000010
OAM_PAL3   = %00000011
OAM_FRONT  = %00000000
OAM_BACK   = %00100000
OAM_FLIP_H = %01000000
OAM_FLIP_V = %10000000

; Sprite DMA Register
SPRITE_DMA = $4014 
