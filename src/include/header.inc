.segment "HEADER"

;==========================================================================
; Define NES cartridge Header
;==========================================================================
INES_MAPPER = 0 ; 0 = NROM
INES_MIRROR = 0 ; 0 = horizontal mirroring, 1 = vertical mirroring
INES_SRAM   = 0 ; 1 = battery backed SRAM at $6000-7FFF

.byte $4E, $45, $53, $1A             ; 'N', 'E', 'S', $1A
.byte $02                            ; 16k PRG bank count ; 16k * 2
.byte $01                            ; 8k CHR bank count
.byte INES_MIRROR | (INES_SRAM << 1) | ((INES_MAPPER & $0f) << 4)
.byte (INES_MAPPER & %11110000)
.byte $00, $00, $00, $00, $00, $00, $00, $00 ; padding filled with zeroes

