; Audio Test

STARTING_SONG	EQU	1

; Sound engine constants and stuff
INCLUDE	"./inc/sound_engine/macros.asm"
INCLUDE	"./inc/sound_engine/constants.asm"
INCLUDE "./inc/hardware_constants.inc"
INCLUDE	"./inc/sound_engine/wram.asm"

; VRAM location macro
hlCoord:MACRO
; \1 = X
; \2 = Y
	ld hl, $9800 + \1 + (\2 * $20)
	ENDM
	
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
DisableLCD:
	ld a, [rLCDC]
	rlca			; put highest bit on carry flag
	ret nc			; exit if screen is off already
.wait:
	ld a,[rLY]
	cp 144			; V-blank?
	jr c,.wait		; keep waiting if not
	ld a,[rLCDC]
	res 7,a			; reset LCD enabled flag
	ld [rLCDC],a
	ret
	
EnableLCD:
; is it really as simple as this?
	ld a, [rLCDC]
	set 7, a
	ld [rLCDC], a
	ret

WaitVRAM:
	di
	ld a, [rSTAT]
	bit 1, a		; checks the "is busy" flag
	jr nz, WaitVRAM		; if 1, wait
	reti
	
FillVRAM:
; a  = value
; hl = dest
; bc = bytecount
; d  = backup for a
	push de
	ld d, a
.loop
	call WaitVRAM
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop de
	ret
	
	
CopyVRAM:
; hl = dest
; de = src
; bc = bytecount
	call WaitVRAM
	ld a, [de]
	inc de
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, CopyVRAM
	ret
	
FillRAM:
; a  = value
; hl = dest
; bc = bytecount
; d  = backup for a
	push de
	ld d, a
.loop
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop de
	ret
	
	
CopyRAM:
; hl = dest
; de = src
; bc = bytecount
	ld a, [de]
	inc de
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, CopyRAM
	ret
	
CopyRAM1bpp:
; for 1bpp fonts
; hl = dest
; de = src
; bc = bytecount
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, CopyRAM1bpp
	ret
	
PrintByte:
; hl = print address
; de = pointer to byte
	ld a, [de]		; fetch byte
; get high nibble
	and a, %11110000
	swap a
	call .determinenum	; print 1st number
; get lower nibble
	ld a, [de]
	and a, %00001111
	call .determinenum	; print 2nd number
	ret
.determinenum
	cp 10
	jr nc, .hex		; if byte >= $A
	add $30			; decimal numbers
	jr .print
.hex
	sub 9
	add $40			; hex
.print
	ld b, a
	call WaitVRAM
	ld a, b
	ld [hli], a
	ret
	
PrintNote:
	push hl
	ld hl, NoteText
	ld a, [de]
	ld d, 0
	ld e, a
; get note
	add hl, de
	add hl, de
	add hl, de
	add hl, de
; swap de and hl
	pop de
	push hl
	push de
	pop hl
	pop de
	ld bc, 4		; 4 letters
	jp CopyVRAM
	
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
	
	call DisableLCD			; LCD needs to be off to copy tiles
; Load the tiles
	ld hl, vChars0
	ld de, FontStart
	ld bc, FontEnd-FontStart
	call CopyRAM1bpp
; Load map
	ld a, $20			; space
	hlCoord 0, 0
	ld bc, $9c00 - $9800
	call FillRAM			; fill with blank spaces
; make seperator
	ld a, "-"
	hlCoord 0, 5
	ld bc, $14
	call FillRAM
	ld a, "-"
	hlCoord 0, $c
	ld bc, $e
	call FillRAM
; channel numbers
	ld a, "1"
	hlCoord 1, 6
	ld bc, 1
	call FillRAM	; 1
	ld a, "2"
	hlCoord 1, 7
	ld bc, 1
	call FillRAM	; 2
	ld a, "3"
	hlCoord 1, 8
	ld bc, 1
	call FillRAM	; 3
	ld a, "4"
	hlCoord 1, 9
	ld bc, 1
	call FillRAM	; 4
	
	ld a, "1"
	hlCoord 1, $d
	ld bc, 1
	call FillRAM	; 1
	ld a, "2"
	hlCoord 1, $e
	ld bc, 1
	call FillRAM	; 2
	ld a, "3"
	hlCoord 1, $f
	ld bc, 1
	call FillRAM	; 3
	ld a, "4"
	hlCoord 1, $10
	ld bc, 1
	call FillRAM	; 4
; text
	hlCoord 2, 1
	ld de, Text0_S
	ld bc, Text0_E-Text0_S
	call CopyRAM
	
	hlCoord 1, 2
	ld de, Text1_S
	ld bc, Text1_E-Text1_S
	call CopyRAM
	
	hlCoord 0, 4
	ld de, Text2_S
	ld bc, Text2_E-Text2_S
	call CopyRAM
	
	hlCoord 0, $b
	ld de, Text3_S
	ld bc, Text3_E-Text3_S
	call CopyRAM
	
	hlCoord $F, $D
	ld de, Text4_S
	ld bc, Text4_E-Text4_S
	call CopyRAM
	
	hlCoord $F, $E
	ld de, Text5_S
	ld bc, Text5_E-Text5_S
	call CopyRAM
	
	hlCoord $c, 2
	ld de, RAMSize
	call PrintByte
	
	ld a, %10010001		; bg on at 9800, tiles at 8000, lcd on
	ld [rLCDC], a
	
	ld a, STARTING_SONG
	call PlaySound
	
	ld a,%00000001  ; Enable V-blank interrupt
	ld [rIE], a
Loop:
	call PrintPointers
	call PrintLength
	call PrintSpeed
	call PrintFinepitch
	call PrintNotes
	call PrintTranspose
	call PrintEnvelope
	call PrintFlags
	jr Loop

PrintFlags:
	hlCoord $12, $d
	ld de, seIsPlaying
	call PrintByte
	hlCoord $12, $e
	ld de, seNumChannels
	call PrintByte
	ret
	
PrintEnvelope:
	hlCoord $b, $d
	ld de, seCh1CurEnvelope
	call PrintByte
	hlCoord $b, $e
	ld de, seCh2CurEnvelope
	call PrintByte
	hlCoord $b, $f
	ld de, seCh3CurEnvelope
	call PrintByte
	hlCoord $b, $10
	ld de, seCh4CurEnvelope
	call PrintByte
	ret
	
PrintTranspose:
	hlCoord 8, $d
	ld de, seCh1Transpose
	call PrintByte
	hlCoord 8, $e
	ld de, seCh2Transpose
	call PrintByte
	hlCoord 8, $f
	ld de, seCh3Transpose
	call PrintByte
	hlCoord 8, $10
	ld de, seCh4Transpose
	call PrintByte
	ret
	
PrintNotes:
	hlCoord 3, $d
	ld de, seCh1CurNote
	call PrintNote
	hlCoord 3, $e
	ld de, seCh2CurNote
	call PrintNote
	hlCoord 3, $f
	ld de, seCh3CurNote
	call PrintNote
	hlCoord 4, $10
	ld de, seCh4CurNote
	call PrintByte
	ret
	
PrintFinepitch:
; Print 1st channel's FP	
	hlCoord $10, 6
	ld de, seCh1FinePitch
	call PrintByte
; Print 2nd channel's FP	
	hlCoord $10, 7
	ld de, seCh2FinePitch
	call PrintByte
; Print 3rd channel's FP	
	hlCoord $10, 8
	ld de, seCh3FinePitch
	call PrintByte
; Print 4th channel's FP	
	hlCoord $10, 9
	ld de, seCh4FinePitch
	call PrintByte
	ret
	
PrintSpeed:
; Print 1st channel's speed	
	hlCoord $d, 6
	ld de, seCh1Speed
	call PrintByte
; Print 2nd channel's speed	
	hlCoord $d, 7
	ld de, seCh2Speed
	call PrintByte
; Print 3rd channel's speed	
	hlCoord $d, 8
	ld de, seCh3Speed
	call PrintByte
; Print 4th channel's speed	
	hlCoord $d, 9
	ld de, seCh4Speed
	call PrintByte
	ret
	
PrintLength:
; Print 1st channel's length	
	hlCoord 8, 6
	ld de, seCh1Delay
	call PrintByte
	hlCoord $a, 6
	ld de, seCh1Length
	call PrintByte
; Print 2nd channel's length	
	hlCoord 8, 7
	ld de, seCh2Delay
	call PrintByte
	hlCoord $a, 7
	ld de, seCh2Length
	call PrintByte
; Print 3rd channel's length	
	hlCoord 8, 8
	ld de, seCh3Delay
	call PrintByte
	hlCoord $a, 8
	ld de, seCh3Length
	call PrintByte
; Print 4th channel's length	
	hlCoord 8, 9
	ld de, seCh4Delay
	call PrintByte
	hlCoord $a, 9
	ld de, seCh4Length
	call PrintByte
	ret
	
PrintPointers:
; Print 1st channel's pointer	
	hlCoord 3, 6
	ld de, seCh1CurPointer+1
	call PrintByte
	hlCoord 5, 6
	ld de, seCh1CurPointer
	call PrintByte
; Print 2nd channel's pointer	
	hlCoord 3, 7
	ld de, seCh2CurPointer+1
	call PrintByte
	hlCoord 5, 7
	ld de, seCh2CurPointer
	call PrintByte
; Print 3rd channel's pointer	
	hlCoord 3, 8
	ld de, seCh3CurPointer+1
	call PrintByte
	hlCoord 5, 8
	ld de, seCh3CurPointer
	call PrintByte
; Print 4th channel's pointer
	hlCoord 3, 9
	ld de, seCh4CurPointer+1
	call PrintByte
	hlCoord 5, 9
	ld de, seCh4CurPointer
	call PrintByte
	ret
	
RAMSize::
	dw SoundRamEnd - SoundRamStart
	
INCLUDE "./inc/sound_engine/interfaces.asm"
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
INCLUDE "./inc/sound_engine/engine.asm"
INCLUDE "./inc/sound_engine/data.asm"

FontStart:
INCBIN	"./inc/soundtest/font.1bpp"
FontEnd:

Text0_S:
	db "Sound Engine Test"
Text0_E:

Text1_S:
	db "RAM used: $XX bytes"
Text1_E:

Text2_S:
	db "Ch ChPt Leng Sp FP"
Text2_E:

Text3_S:
	db "Ch Note TR EV  Flags"
Text3_E:

Text4_S:
	db "PL:XX"
Text4_E:

Text5_S:
	db "CH:XX"
Text5_E:

NoteText:
	db "    "
	
	db "C  3"
	db "C# 3"
	db "D  3"
	db "D# 3"
	db "E  3"
	db "F  3"
	db "F# 3"
	db "G  3"
	db "G# 3"
	db "A  3"
	db "A# 3"
	db "B  3"
	
	db "C  4"
	db "C# 4"
	db "D  4"
	db "D# 4"
	db "E  4"
	db "F  4"
	db "F# 4"
	db "G  4"
	db "G# 4"
	db "A  4"
	db "A# 4"
	db "B  4"
	
	db "C  5"
	db "C# 5"
	db "D  5"
	db "D# 5"
	db "E  5"
	db "F  5"
	db "F# 5"
	db "G  5"
	db "G# 5"
	db "A  5"
	db "A# 5"
	db "B  5"
	
	db "C  6"
	db "C# 6"
	db "D  6"
	db "D# 6"
	db "E  6"
	db "F  6"
	db "F# 6"
	db "G  6"
	db "G# 6"
	db "A  6"
	db "A# 6"
	db "B  6"
	
	db "C  7"
	db "C# 7"
	db "D  7"
	db "D# 7"
	db "E  7"
	db "F  7"
	db "F# 7"
	db "G  7"
	db "G# 7"
	db "A  7"
	db "A# 7"
	db "B  7"
	
	db "C  8"
	db "C# 8"
	db "D  8"
	db "D# 8"
	db "E  8"
	db "F  8"
	db "F# 8"
	db "G  8"
	db "G# 8"
	db "A  8"
	db "A# 8"
	db "B  8"
