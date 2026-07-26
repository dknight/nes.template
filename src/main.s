.include "core/header.s"
.include "core/macros.s"
.include "core/vectors.s"
.include "core/reset.s"
.include "core/nmi.s"
.include "core/input.s"
.include "core/ppu.s"
.include "core/apu.s"
.include "core/dma.s"
.include "core/memory/zp.s"
.include "core/memory/oam.s"

.include "gfx/renderer.s"
.include "gfx/sprites.s"
.include "gfx/tiles.s"
.include "gfx/palettes.s"
.include "gfx/nametable.s"

.include "game/state.s"
.include "game/game.s"
.include "game/timers.s"
.include "game/tick.s"
.include "game/player.s"
.include "game/enemies.s"
.include "game/projectiles.s"
.include "game/camera.s"

;=================================================================
; Main application logic section includes the game loop
;=================================================================
.segment "CODE"

.proc main
@loop:
	JSR wait_frame
	JSR input_poll
	JSR timers_update
	JSR game_tick
	JSR render
	JMP @loop
.endproc

