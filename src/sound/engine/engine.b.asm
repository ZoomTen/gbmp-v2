; ************************
;        CHANNEL 2
; ************************

Music_B_ParseNotes:
; check note duration
	ld a, [w_ch2_duration]
	and a
	jp z, .read		; jump if == 0
	dec a
	ld [w_ch2_duration], a
	jp .end			; => return
	
.read
; store so that
; de contains the current address
	ld a, [w_ch2_address+1]
	ld d, a
	ld a, [w_ch2_address]
	ld e, a	
	ld a, [de]
; read the contained byte
; dictionary parsing
	cp a, $49		; notes < $49
	jp c, .fx_playnote
	
	cp a, s_length
	jp z, .fx_length
	
	cp a, s_tie
	jp z, .fx_tie
	
	cp a, s_envelope
	jp z, .fx_setenvelope
	
	cp a, s_instrument
	jp z, .fx_setinstrument
	
	cp a, s_transpose
	jp z, .fx_transpose
	
	cp a, s_slide
	jp z, .fx_slide
	
	cp a, s_pitchmod
	jp z, .fx_pitchmod
	
	cp a, s_vibtype
	jp z, .fx_vibratoh
	
	cp a, s_output
	jp z, .fx_setoutput
	
	cp a, s_fine
	jp z, .fx_fine
	
	cp a, s_duty
	jp z, .fx_duty
	
	cp a, s_jump
	jp z, .fx_jump
	
	cp a, s_call
	jp z, .fx_call
	
	cp a, s_return
	jp z, .fx_return
	
	cp a, s_loop
	jp z, .fx_loop
	
	cp a, s_end
	jp z, .end
	
	jp .end			; other values will cause SE to crash

.fx_tie
; literally just this.
	jr .fx_playnote_next
	
.fx_setoutput
	inc de
	ld a, [de]
	ld [rNR51], a
	inc de
	jp .storeandcontinue
	
.fx_length
	inc de
	ld a, [de]
	ld [w_ch2_curlength], a
	inc de
	jp .storeandcontinue
	
.fx_pitchmod
	inc de
	ld a, [de]
	ld [w_ch2_slide_n], a
	inc de
	jp .storeandcontinue
	
.fx_vibratoh
	inc de
	ld a, [de]
	ld [w_ch2_vib], a
	call .VibToRAM
	inc de
	jp .storeandcontinue
	
.fx_slide
; read current note
	inc de
	ld a, [de]
	ld [w_ch2_curnote], a
	ld c, a
	ld a, [w_ch2_curtrps]	; add transpose yaddayaddayadda i'm tired
	add a, c
	call Music_B_GetNote
	ld a, [hli]
	ld c, a
	ld a, [w_ch2_curfine]	; add fine pitch offset
	add a, c
	ld [rNR23], a
	ld [w_ch2_lofreq], a
	ld a, [hl]
	ld [rNR24], a
	jr .fx_playnote_next	; fallback to note blah blah blah.,
	
.fx_playnote
	ld [w_ch2_curnote], a
; check for rest note...
	and a
	jp nz, .fx_playnote_do_note
	jr .fx_playnote_do_raw	; THIS DOESN'T MAKE SENSE AT ALL
.fx_playnote_do_note
; add transpose value...
	ld c, a
	ld a, [w_ch2_curtrps]
	add a, c
.fx_playnote_do_raw
; parse note and send to sound RAM
	call Music_B_GetNote
	ld a, [hli]
	ld c, a
	ld a, [w_ch2_curfine]	; add fine pitch offset
	add a, c
	ld [rNR23], a
	ld [w_ch2_lofreq], a
	ld a, [hl]
	set 7, a		; restart byte
	ld [rNR24], a
; apply volume
	ld a, [w_ch2_curvol]
	ld [rNR22], a
; restart instrument status
	ld a, [w_ch2_curinst]
	and a
	jr z, .fx_playnote_resetvib		; if no instrument define there's no need to waste Vblank time
	call .InstrumentToRAM
; restart instrument status
.fx_playnote_resetvib
	ld a, [w_ch2_vib]
	and a
	jr z, .fx_playnote_next		; if no instrument define there's no need to waste Vblank time
	call .VibToRAM
.fx_playnote_next
	ld a, [w_ch2_curlength]
	and a
	jr z, .fx_playnote_parseduration
	dec a				; hacky
	ld [w_ch2_duration], a
	jr .fx_playnote_continue
.fx_playnote_parseduration	
; parse note duration
	inc de
	ld a, [de]
	dec a				; hacky
	ld [w_ch2_duration], a
.fx_playnote_continue
; clear slide counter
	xor a
	ld [w_ch2_slide_x], a
; store next byte
	inc de
	jp .storeandend
	
.fx_fine
	inc de
	ld a, [de]
	ld [w_ch2_curfine], a
	inc de
	jp .storeandcontinue
	
.fx_setinstrument
	inc de
	ld a, [de]			; one-indexed
	ld [w_ch2_curinst], a
	inc de
	jp .storeandcontinue
	
.fx_setenvelope
	inc de
	ld a, [de]
	ld [w_ch2_curvol], a
	inc de
	jp .storeandcontinue
	
.fx_transpose
	inc de
	ld a, [de]
	ld [w_ch2_curtrps], a
	inc de
	jp .storeandcontinue
	
.fx_duty
	inc de
	ld a, [de]
	call Music_B_GetDuty
	inc de
	jp .storeandcontinue
	
.fx_jump
	inc de
	ld a, [de]
	ld [w_ch2_address], a
	inc de
	ld a, [de]
	ld [w_ch2_address+1], a
	jp .read
	
.fx_call
	inc de
	inc de
	inc de
; save current address to backtrack buffer...
	ld a, d
	ld [w_ch2_buffer+1], a
	ld a, e
	ld [w_ch2_buffer], a
; backtrack and put pointers
	dec de
	ld a, [de]
	ld [w_ch2_address+1], a
	dec de
	ld a, [de]
	ld [w_ch2_address], a
	jp .read
	
.fx_loop
	inc de
	inc de
	inc de
	inc de
; save current address to backtrack buffer...
	ld a, d
	ld [w_ch2_buffer+1], a
	ld a, e
	ld [w_ch2_buffer], a
; backtrack and put loop count
	dec de
	ld a, [de]
	ld [w_ch2_loopcount], a
; put pointers...	
	dec de
	ld a, [de]
	ld [w_ch2_address+1], a
	ld [w_ch2_loopbuffer+1], a
	dec de
	ld a, [de]
	ld [w_ch2_address], a
	ld [w_ch2_loopbuffer], a
	jp .read
	
.fx_return
; Check if loop...
	ld a, [w_ch2_loopcount]
	and a
	jr z, .fx_return_from_subroutine	; no more loops then return from main buffer
	dec a
	ld [w_ch2_loopcount], a			; decrease loop count
; get back from loop buffer
	ld a, [w_ch2_loopbuffer]
	ld [w_ch2_address], a
	ld a, [w_ch2_loopbuffer+1]
	ld [w_ch2_address+1], a
	jp .read
.fx_return_from_subroutine
; get back from main buffer
	ld a, [w_ch2_buffer]
	ld [w_ch2_address], a
	ld a, [w_ch2_buffer+1]
	ld [w_ch2_address+1], a
	jp .read
	
.InstrumentToRAM
	dec a			; since usually a = current instrument
; get instrument pointers
	ld hl, InstrumentTable
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
; pointed to instrument
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld h, b
	ld l, c
; store arpeggio address
	ld a, [hli]
	ld [w_ch2_arpaddr], a
	ld a, [hli]
	ld [w_ch2_arpaddr+1], a
; store duty cycle address
	ld a, [hli]
	ld [w_ch2_dutaddr], a
	ld a, [hl]
	ld [w_ch2_dutaddr+1], a
	ret
	
.VibToRAM
	dec a			; since usually a = current instrument
; get table pointers
	ld hl, VibratoTable
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
; store table address
	ld a, [hli]
	ld [w_ch2_vibaddr], a
	ld a, [hli]
	ld [w_ch2_vibaddr+1], a
	ret
	
.storeandcontinue
	ld a, d
	ld [w_ch2_address+1], a
	ld a, e
	ld [w_ch2_address], a
	jp .read
	
.storeandend
	ld a, d
	ld [w_ch2_address+1], a
	ld a, e
	ld [w_ch2_address], a
.end
	ret

Music_B_GetNote:
; where a = note value
	ld b, 0
	ld c, a
	ld hl, NotePitches
	add hl, bc
	add hl, bc
	ret
	
Music_B_GetDuty:
	rlca
	rlca
	rlca
	rlca
	rlca			; because duty is on bits 6 & 7
	rlca			; usually 0-3 duty
	ld [rNR21], a
	ld [w_ch2_curduty], a
	ret
	
Music_B_ParseInstruments:	
; fiddling with the arpeggio first
.arp_play
; fetch arpeggio address
	ld a, [w_ch2_arpaddr]
	ld l, a
	ld a, [w_ch2_arpaddr+1]
	ld h, a
	ld a, [hli]
	cp a, $FF
	jr z, .arp_play_end
; in action
	push hl			; hl is used for something else now
	ld c, a
	ld a, [w_ch2_curnote]
	add a, c		; add arp
	ld c, a
	ld a, [w_ch2_curtrps]
	add a, c		; add transpose
	call Music_B_GetNote
	ld a, [hli]
	ld c, a
	ld a, [w_ch2_curfine]	; add fine pitch...
	add a, c
	ld [rNR23], a
	ld [w_ch2_lofreq], a
	ld a, [hl]
	ld [rNR24], a
	pop hl
; store next arp address
	ld a, l
	ld [w_ch2_arpaddr], a
	ld a, h
	ld [w_ch2_arpaddr+1], a
	jr .duty_play
.arp_play_end
; store loop address
	ld a, [hli]
	ld [w_ch2_arpaddr], a
	ld a, [hl]
	ld [w_ch2_arpaddr+1], a
	jr .arp_play
; fiddling with the duty
.duty_play
; fetch
	ld a, [w_ch2_dutaddr]
	ld l, a
	ld a, [w_ch2_dutaddr+1]
	ld h, a
	ld a, [hli]
	cp a, $FF
	jr z, .duty_play_end
; in action
	call Music_B_GetDuty
; store
	ld a, l
	ld [w_ch2_dutaddr], a
	ld a, h
	ld [w_ch2_dutaddr+1], a
	ret
.duty_play_end
; store
	ld a, [hli]
	ld [w_ch2_dutaddr], a
	ld a, [hl]
	ld [w_ch2_dutaddr+1], a
	jr .duty_play
	
Music_B_ParseVibrato:
; fetch
	ld a, [w_ch2_vibaddr]
	ld l, a
	ld a, [w_ch2_vibaddr+1]
	ld h, a
	ld a, [hli]
	cp a, $80
	jr z, .end
; in action
	ld c, a
	ld a, [w_ch2_lofreq]
	add a, c
	ld [rNR23], a
; store
	ld a, l
	ld [w_ch2_vibaddr], a
	ld a, h
	ld [w_ch2_vibaddr+1], a
	ret
.end
; store
	ld a, [hli]
	ld [w_ch2_vibaddr], a
	ld a, [hl]
	ld [w_ch2_vibaddr+1], a
	jr Music_B_ParseVibrato
	
Music_B_DoSlide:
	ld a, [w_ch2_slide_n]
	ld c, a
	ld a, [w_ch2_slide_x]
	add a, c
	ld [w_ch2_slide_x], a
	ld c, a
	ld a, [w_ch2_lofreq]
	add a, c
	ld [rNR23], a
	ret
	
Music_B_ApplyFX:
	ld a, [w_ch2_curinst]
	and a
	jr z, .do_vib_B
	call Music_B_ParseInstruments
.do_vib_B
	ld a, [w_ch2_vib]
	and a
	jr z, .do_slide_B
	call Music_B_ParseVibrato
.do_slide_B
	ld a, [w_ch2_slide_n]
	and a
	ret z
	call Music_B_DoSlide
	ret 