.include "constants.inc"
.include "maps.inc"

.exportzp collisions_ptr
.exportzp collisions_row_ptr
.export collisions_is_solid
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

;==========================================================================
; Check whether the tile is solid.
;
; Input:
;   A = tile_x (0..31)
;   Y = tile_y (0..29)
;
; Output:
;   C = 1 if the tile is solid.
;   C = 0 if the tile is passable.
;
; Clobbers:
;   A
;==========================================================================
.proc collisions_is_solid
	JSR collisions_get_tile

	CMP #TILE_WALL
	BEQ @wall
	CMP #TILE_NOT_USED
	BEQ @wall
	; CMP #TILE_BRICK
	; BEQ @wall
	; CMP #TILE_WATER
	; BEQ @wall
	; etc.

	CLC
	RTS
@wall:
	SEC
	RTS
.endproc

;==========================================================================
; Get logical tile ID at tile coordinates.
;
; Input:
;   A = tile_x (0..31)
;   Y = tile_y (0..29)
;
; Output:
;   A = logical tile ID
;
; Clobbers:
;   Y
;
; Uses:
;   scratch00
;==========================================================================
.proc collisions_get_tile
    STA scratch00

    JSR collisions_get_row_ptr

    LDY scratch00
    LDA (collisions_row_ptr),Y

    RTS
.endproc

;==========================================================================
; Calculate pointer to the specified tile row.
;
; Input:
;   Y = tile_y
;
; Output:
;   collisions_row_ptr = collisions_ptr + tile_y * 32
;
; Clobbers:
;   A
;==========================================================================
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

;==========================================================================
; Initialize collision map pointer.
;
; Input:
;   None
;
; Output:
;   collisions_ptr points to the current level map.
;
; Clobbers:
;   A
;==========================================================================
.proc collisions_load_level
    LDA #<level_map_01
    STA collisions_ptr

    LDA #>level_map_01
    STA collisions_ptr+1

    RTS
.endproc

