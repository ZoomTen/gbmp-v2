INCLUDE "./inc/sound/macros.inc"

Music_SongList:
	mus_entry $f5, Mus_WeAreNumberOne
	mus_entry $E3, Mus_Test

Music_DisableChannel::
	goEnd				;.
	
INCLUDE "./src/sound/data/wearenumberone.asm"
INCLUDE "./src/sound/data/test.asm"