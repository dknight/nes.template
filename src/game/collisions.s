.include "constants.inc"
.include "collisions_level_01.inc"

.exportzp collisions_ptr
.export collisions_is_wall
.export collisions_get_tile

.importzp tmp00

.segment "ZEROPAGE"
collisions_ptr: .res 2

.segment "CODE"

;=================================================================
; Get tile at x, y
; A = x coord
; Y = y coord
;=================================================================
.proc collisions_get_tile
    STA tmp00
    TYA

    ASL
    ASL
    ASL
    ASL
    ASL ; y*32

    CLC
    ADC tmp00
    TAY
    LDA (collisions_ptr),Y

    RTS
.endproc

;=================================================================
; Check wall at x, y. Player cannot move thourgh
; A = x_tile
; Y = y_tile
;=================================================================
.proc collisions_is_wall
	JSR collisions_get_tile

	CMP #TILE_WALL
	BEQ @wall
	; CMP #TILE_BRICK
	; BEQ @wall
	; CMP #TILE_METAL
	; BEQ @wall
	; etc.

	CLC
	RTS
@wall:
	SEC
	RTS
.endproc

