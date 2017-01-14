INCLUDE "./inc/hardware_constants.inc"
INCLUDE	"./inc/sound/wram.asm"
INCLUDE "./inc/sound/constants.inc"

SECTION "GBS Header", ROM0[$0]
	db "GBS"	; identifier
	db 1		; GBS spec version
	db 2		; number of songs
	db 1		; first song
	dw Start	; load address
	dw Start	; init address
	dw Play		; play address
	dw $DFFF	; stack address
	db 0		; timer modulo; unused
	db 0		; timer control; unused
	
SECTION "GBS Title", ROM0[$10]
	db "Sound Engine v2 Test"	; title
	
SECTION "GBS Author", ROM0[$30]
	db "ZoomTen"		; composer
	
SECTION "GBS Copyright", ROM0[$50]
	db "2017 ZoomTen"	; copyright

SECTION "Actual Code", ROM0[$470]	; load/init/play has to be $400 - $7fff
					; according to specs
Start:
	call Music_Play
	ei
	ret
Play:
INCLUDE "./src/sound/engine.asm"
INCLUDE "./src/sound/interfaces.asm"
INCLUDE "./src/sound/sounds.asm"