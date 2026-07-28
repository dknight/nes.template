.importzp player_x
.importzp player_y
.import state_init

;=================================================================
; Define game constants and configurations
;=================================================================
GAME_FPS              = 60
GAME_STATE_TITLE      = 0
GAME_STATE_GAMEPLAY   = 1
GAME_STATE_PAUSE      = 2
GAME_STATE_GAMEOVER   = 3
GAME_STATE_CREDITS    = 4
GAME_VISIBLE_WIDTH    = 248 ; 256 - 4 - 4 CRT TV overscan
GAME_VISIBLE_HEIGHT   = 224 ; 240 - 8 - 8 CRT TV overscan
GAME_TIMER_COUNT      = 8
