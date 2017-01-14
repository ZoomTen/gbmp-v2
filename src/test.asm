; Sound engine constants and stuff
INCLUDE "./inc/hardware_constants.inc"
INCLUDE	"./inc/sound/wram.asm"

; The rst vectors are unused.
SECTION "rst 00", ROM0 [$00]
	reti
SECTION "rst 08", ROM0 [$08]
	reti
SECTION "rst 10", ROM0 [$10]
	reti
SECTION "rst 18", ROM0 [$18]
	reti
SECTION "rst 20", ROM0 [$20]
	reti
SECTION "rst 28", ROM0 [$28]
	reti
SECTION "rst 30", ROM0 [$30]
	reti
SECTION "rst 38", ROM0 [$38]
	reti
; Hardware interrupts
SECTION "vblank", ROM0 [$40]
	jp Vblank
SECTION "hblank", ROM0 [$48]
	reti
SECTION "timer",  ROM0 [$50]
	reti
SECTION "serial", ROM0 [$58]
	reti
SECTION "joypad", ROM0 [$60]
	reti
	
SECTION "Program Entry",HOME[$100]
ProgramEntry:
	nop
	jp Start
	
SECTION "Main Program",HOME[$150]
	
Start:
	di			; init the whole thing
	ld sp, $FFFF		; set stack
	ld a, %11100100		; set background palette
	ld [rBGP],a
	
	xor a
	ld [rSCX],a		; reset scroll
	ld [rSCY],a
	ld hl, $c000
	ld bc, $dfff - $c000
.clearwram
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .clearwram
	ld a,%00000001  ; Enable V-blank interrupt
	ld [rIE], a
	ld a, 1
	call Music_Play
	ei
.loop
	halt
	nop
	jp .loop
	
Vblank:
	push af
	push bc
	push de
	push hl
	call UpdateMusic
	pop hl
	pop de
	pop bc
	pop af
	reti

INCLUDE "./inc/sound/constants.inc"
INCLUDE "./src/sound/engine.asm"
INCLUDE "./src/sound/interfaces.asm"
INCLUDE "./src/sound/sounds.asm"