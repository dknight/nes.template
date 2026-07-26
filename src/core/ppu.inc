;=================================================================
; Define PPU Registers
;=================================================================
PPU_CONTROL        = $2000 ; PPU Control Register 1 (Write)
PPU_MASK           = $2001 ; PPU Control Register 2 (Write)
PPU_STATUS         = $2002 ; PPU Status Register (Read)
PPU_SPRRAM_ADDRESS = $2003 ; PPU SPR-RAM Address Register (Write)
PPU_SPRRAM_IO      = $2004 ; PPU SPR-RAM I/O Register (Write)
PPU_SCROLL         = $2005 ; PPU VRAM Address Register 1 (Write)
PPU_ADDR           = $2006 ; PPU VRAM Address Register 2 (Write)
PPU_DATA           = $2007 ; VRAM I/O Register (Read/Write)
