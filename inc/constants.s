;=================================================================
; Define NES control register values
;=================================================================

; Define PPU Registers
PPU_CONTROL        = $2000 ; PPU Control Register 1 (Write)
PPU_MASK           = $2001 ; PPU Control Register 2 (Write)
PPU_STATUS         = $2002 ; PPU Status Register (Read)
PPU_SPRRAM_ADDRESS = $2003 ; PPU SPR-RAM Address Register (Write)
PPU_SPRRAM_IO      = $2004 ; PPU SPR-RAM I/O Register (Write)
PPU_SCROLL         = $2005 ; PPU VRAM Address Register 1 (Write)
PPU_ADDR           = $2006 ; PPU VRAM Address Register 2 (Write)
PPU_DATA           = $2007 ; VRAM I/O Register (Read/Write)
SPRITE_DMA         = $4014 ; Sprite DMA Register

; Define APU Registers
APU_DM_CONTROL     = $4010 ; APU Delta Modulation Control Register (Write)
APU_CLOCK          = $4015 ; APU Sound/Vertical Clock Signal Register (Read/Write)

; Controller values
JOYPAD1            = $4016 ; Joypad 1 (Read/Write)
JOYPAD2            = $4017 ; Joypad 2 (Read)
; !!!
; Same address, but different hardware behaviour!
; Weird NES historical stuff that same address used for Joypad 2 and APU
; counter. It can generate IRQ which leads to:
; - random IRQs
; - unstable timing
; - weird behaviour later
APU_FRAME_COUNTER  = $4017 ; APU Frame counter (Write)

;==========================================================
; Gamepad bit values
;==========================================================
PAD_A              = $01
PAD_B              = $02
PAD_SELECT         = $04
PAD_START          = $08
PAD_U              = $10
PAD_D              = $20
PAD_L              = $40
PAD_R              = $80

;==========================================================
; OAM sprite layout
;==========================================================
;
; Each sprite in NES OAM uses 4 bytes:
;
; byte 0 = Y position
; byte 1 = tile index
; byte 2 = attributes
; byte 3 = X position
;
;==========================================================
OAM_Y     = $00
OAM_TILE  = $01
OAM_ATTR  = $02
OAM_X     = $03

;==========================================================
; Attribute flags
;==========================================================
OAM_PAL0  = %00000000
OAM_PAL1  = %00000001
OAM_PAL2  = %00000010
OAM_PAL3  = %00000011

OAM_FRONT = %00000000
OAM_BACK  = %00100000

OAM_FLIP_H = %01000000
OAM_FLIP_V = %10000000

