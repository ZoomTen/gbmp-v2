; **************************************
; *** ZoomTen's GameBoy Music Player ***
; ***          Version 2.0           ***
; ***                                ***
; ***  2017-01-14                    ***
; **************************************
; **************************************
; **** now with ARPEGGIOS!           ***
; ****           DUTY CYCLES!        ***
; ****            FANCY EFFECTS!     ***
; ****      MORE POSSIBILITIES!      ***
; ****     PRECISE TEMPO CONTROL!    ***
; **************************************
; **************************************

; -----------------------------------------------------------
; Sound system
; -----------------------------------------------------------
UpdateMusic:
; Check if song started
	ld a, [w_song_enabled]
	and a
	ret z			; Skip everything if SE stopped
; Increment timer
; A factor of $FF means original speed
	ld a, [w_song_speed]
	ld c, a
	ld a, [w_song_timer]
	add a, c
	ld [w_song_timer], a
; If timer doesn't overflow do sound FX (arps, duty cycling) instead
;	ret nc			; if slow down fx too
	jr nc, .do_FX
.do_notes
; Parse notes
	call Music_A_ParseNotes
	call Music_B_ParseNotes
	call Music_C_ParseNotes
	call Music_D_ParseNotes
.do_FX
	call Music_A_ApplyFX	; Then do instrument playback
	call Music_B_ApplyFX
	call Music_C_ApplyFX
	call Music_D_Drums
.return
	ret

; -----------------------------------------------------------
; The BULK™ wh
; -----------------------------------------------------------

include	"src/sound/engine/engine.a.asm"
include	"src/sound/engine/engine.b.asm"
include	"src/sound/engine/engine.c.asm"
include	"src/sound/engine/engine.d.asm"

; -----------------------------------------------------------
; Sound engine data
; -----------------------------------------------------------

; lookup tables

include	"src/sound/tables/pitches.asm"
include	"src/sound/tables/instruments.asm"
include	"src/sound/tables/vibrato.asm"
include	"src/sound/tables/waves.asm"
include	"src/sound/tables/drums.asm"

