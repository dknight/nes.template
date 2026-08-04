;==========================================================================
; Define game constants and configurations
;==========================================================================
GAME_FPS                = 60
GAME_STATE_TITLE        = 0
GAME_STATE_GAMEPLAY     = 1
GAME_STATE_PAUSE        = 2
GAME_STATE_GAMEOVER     = 3
GAME_STATE_CREDITS      = 4
GAME_TOP_EDGE           = 8   ; 0+8 CRT overscan
GAME_RIGHT_EDGE         = 256 ; might be 256-4-4 CRT TV overscan
GAME_BOTTOM_EDGE        = 232 ; 240-16 CRT overscan
GAME_LEFT_EDGE          = 0   ; 0+8 CRT overscan
GAME_TIMER_COUNT        = 8

;==========================================================================
; Define player constants and configurations
;==========================================================================
PLAYER_SPEED            = 1
PLAYER_WIDTH            = 8
PLAYER_HEIGHT           = 8
PLAYER_MIN_X            = GAME_LEFT_EDGE
PLAYER_MAX_X            = GAME_RIGHT_EDGE - PLAYER_WIDTH
PLAYER_MIN_Y            = GAME_TOP_EDGE
PLAYER_MAX_Y            = GAME_BOTTOM_EDGE - PLAYER_WIDTH
PLAYER_DIAGONAL_ENABLED = 1
PLAYER_INIT_X           = 80 ; x-coord
PLAYER_INIT_Y           = 64 ; y-coord

;==========================================================================
; Collisions related constants
;==========================================================================
TILE_NOT_USED           = 0
TILE_FLOOR              = 1
TILE_WALL               = 2
; TILE_LADDER           = 2
; TILE_WATER            = 3
; TILE_SPIKES           = 4
; etc.
