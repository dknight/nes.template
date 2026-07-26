;==========================================================
; Controllers
;==========================================================
JOYPAD1            = $4016 ; Joypad 1 (Read/Write)
JOYPAD2            = $4017 ; Joypad 2 (Read)

;==========================================================
; Gamepad bit values
;==========================================================
; PAD_A              = %00000001
; PAD_B              = $02
; PAD_SELECT         = $04
; PAD_START          = $08
; PAD_U              = $10
; PAD_D              = $20
; PAD_L              = $40
; PAD_R              = $80

BUTTON_A      = %00000001
BUTTON_B      = %00000010
BUTTON_SELECT = %00000100
BUTTON_START  = %00001000
BUTTON_UP     = %00010000
BUTTON_DOWN   = %00100000
BUTTON_LEFT   = %01000000
BUTTON_RIGHT  = %10000000