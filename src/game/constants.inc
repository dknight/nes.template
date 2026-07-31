;=================================================================
; Define game constants and configurations
;=================================================================
GAME_FPS              = 60
GAME_STATE_TITLE      = 0
GAME_STATE_GAMEPLAY   = 1
GAME_STATE_PAUSE      = 2
GAME_STATE_GAMEOVER   = 3
GAME_STATE_CREDITS    = 4
; 8 pixels from top because OAM Y is offset by 1
GAME_TOP_EDGE         = 7   ; 0+8 CRT TV overscan
GAME_RIGHT_EDGE       = 256 ; might be 256-4-4 CRT TV overscan
; 232 pixels from top because OAM Y is offset by 1
GAME_BOTTOM_EDGE      = 231 ; might be 240-8 CRT TV overscan
GAME_LEFT_EDGE        = 0   ; might be 0+4+4 CRT TV overscan
GAME_TIMER_COUNT      = 8

;==========================================================
; Define player constants and configurations
;==========================================================
PLAYER_SPEED          = 1
PLAYER_WIDTH          = 8
PLAYER_HEIGHT         = 8
PLAYER_MIN_X          = GAME_LEFT_EDGE
PLAYER_MAX_X          = GAME_RIGHT_EDGE - PLAYER_WIDTH
PLAYER_MIN_Y          = GAME_TOP_EDGE
PLAYER_MAX_Y          = GAME_BOTTOM_EDGE - PLAYER_WIDTH
