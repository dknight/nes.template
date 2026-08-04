.include "../core/constants.inc"
.include "maps.inc"

.segment "CODE"

.export level_load

.importzp ptr_lo
.importzp ptr_hi
.importzp page_count
.import tile_to_chr
.import level_map_01
.import nametable

;==========================================================================
; Load level into VRAM
;
; Loads the current level map into the first nametable.
; Each logical tile ID is translated into a CHR tile index through the
; tile_to_chr lookup table before being written to PPU_DATA.
;
; VRAM destination:
;   $2000-$23BF (960 bytes)
;
; Requirements:
;   - Rendering must be disabled or the PPU must be in VBlank.
;   - level_map_01 contains 960 logical tiles.
;   - tile_to_chr contains the tile translation table.
;
; Clobbers:
;   A, X, Y
;
; Uses:
;   ptr_lo
;   ptr_hi
;   page_count
;==========================================================================
.proc level_load
    ; Reset PPU latch
    LDA PPU_STATUS

    ; VRAM = $2000
    LDA #$20
    STA PPU_ADDR
    LDA #$00
    STA PPU_ADDR

    ; Pointer -> level_map_01
    LDA #<level_map_01
    STA ptr_lo
    LDA #>level_map_01
    STA ptr_hi

    ; Three full pages (3 × 256 = 768 bytes)
    LDA #$03
    STA page_count

@page_loop:
    LDY #$00

@page_bytes:
    ; Read logical tile
    LDA (ptr_lo),Y

    ; Convert to CHR tile
    TAX
    LDA tile_to_chr,X

    ; Write to PPU
    STA PPU_DATA

    INY
    BNE @page_bytes

    INC ptr_hi

    DEC page_count
    BNE @page_loop

    ; Last 192 bytes
    LDY #$00

@last_chunk:
    LDA (ptr_lo),Y
    TAX
    LDA tile_to_chr,X
    STA PPU_DATA

    INY
    CPY #$C0
    BNE @last_chunk

    RTS
.endproc

