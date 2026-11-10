;==========================================================================
; Define PPU Registers
;==========================================================================
PPU_CTRL           = $2000 ; PPU Control Register 1 (Write)
PPU_MASK           = $2001 ; PPU Control Register 2 (Write)
PPU_STATUS         = $2002 ; PPU Status Register (Read)
PPU_OAM_ADDR       = $2003 ; PPU SPR-RAM Address Register (Write)
PPU_OAM_DATA       = $2004 ; PPU SPR-RAM I/O Register (Write)
PPU_SCROLL         = $2005 ; PPU VRAM Address Register 1 (Write)
PPU_ADDR           = $2006 ; PPU VRAM Address Register 2 (Write)
PPU_DATA           = $2007 ; VRAM I/O Register (Read/Write)

;==========================================================================
; Define APU Registers
;==========================================================================
APU_DMC_CTRL       = $4010 ; APU Delta Modulation Control Register (Write)
APU_STATUS         = $4015 ; APU Sound/Vertical Clock Signal Register (Read/Write)
; !!!
; Same address, but different hardware behaviour!
; Weird NES historical stuff that same address used for Joypad 2 and APU
; counter. It can generate IRQ which leads to:
; - random IRQs
; - unstable timing
; - weird behaviour later
APU_FRAME_COUNTER  = $4017 ; APU Frame counter (Write)

