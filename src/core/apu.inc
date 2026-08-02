;==========================================================================
; Define APU Registers
;==========================================================================
APU_DM_CONTROL     = $4010 ; APU Delta Modulation Control Register (Write)
APU_CLOCK          = $4015 ; APU Sound/Vertical Clock Signal Register (Read/Write)
; !!!
; Same address, but different hardware behaviour!
; Weird NES historical stuff that same address used for Joypad 2 and APU
; counter. It can generate IRQ which leads to:
; - random IRQs
; - unstable timing
; - weird behaviour later
APU_FRAME_COUNTER  = $4017 ; APU Frame counter (Write)
