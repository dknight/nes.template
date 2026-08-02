.include "constants.inc"
.include "collisions_level_01.inc"

.exportzp collisions_ptr
.exportzp collisions_row_ptr
.export collisions_is_wall
.export collisions_get_tile
.export collisions_load_level

.importzp scratch00

.segment "ZEROPAGE"
collisions_ptr: .res 2
collisions_row_ptr: .res 2

.segment "RODATA"
row_offset_lo:
.byte   0,32,64,96,128,160,192,224
.byte   0,32,64,96,128,160,192,224
.byte   0,32,64,96,128,160,192,224
.byte   0,32,64,96,128,160

row_offset_hi:
.byte   0,0,0,0,0,0,0,0
.byte   1,1,1,1,1,1,1,1
.byte   2,2,2,2,2,2,2,2
.byte   3,3,3,3,3,3

.segment "CODE"
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

;=============================================================
; Get tile at x, y
; A = player_tile_x
; Y = player_tile_y
;
; Returns:
;   A = tile
;=============================================================
.proc collisions_get_tile
    STA scratch00

    JSR collisions_get_row_ptr

    LDY scratch00
    LDA (collisions_row_ptr),Y

    RTS
.endproc

;=================================================================
; Get row from collision map
;=================================================================
.proc collisions_get_row_ptr
    LDA collisions_ptr
    CLC
    ADC row_offset_lo,Y
    STA collisions_row_ptr

    LDA collisions_ptr+1
    ADC row_offset_hi,Y
    STA collisions_row_ptr+1

    RTS
.endproc

;=================================================================
; Initialize collision pointer
;=================================================================
.proc collisions_load_level
    LDA #<collisions_level_01
    STA collisions_ptr

    LDA #>collisions_level_01
    STA collisions_ptr+1

    RTS
.endproc
