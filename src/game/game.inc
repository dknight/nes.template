;==========================================================================
; Define game constants and configurations
;==========================================================================
GAME_FPS                = 60
GAME_TOP_EDGE           = 8   ; 0+8 CRT overscan
GAME_RIGHT_EDGE         = 256 ; might be 256-4-4 CRT TV overscan
GAME_BOTTOM_EDGE        = 232 ; 240-16 CRT overscan
GAME_LEFT_EDGE          = 0   ; 0+8 CRT overscan
GAME_TIMER_COUNT        = 8

; Game states
GAME_STATE_TITLE        = 0
GAME_STATE_GAMEPLAY     = 1
GAME_STATE_PAUSE        = 2
GAME_STATE_GAMEOVER     = 3
GAME_STATE_CREDITS      = 4

; Game flags in bits might be useful
GAME_FLAG_PAUSED        = %00000001
GAME_FLAG_FADE          = %00000010
GAME_FLAG_DEBUG         = %00000100

