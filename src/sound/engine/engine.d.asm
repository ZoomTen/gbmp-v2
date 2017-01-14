; ************************
;        CHANNEL 4
; ************************

Music_D_ParseNotes:
; check note duration
	ld a, [w_ch4_duration]
	and a
	jp z, .read		; jump if == 0
	dec a
	ld [w_ch4_duration], a
	jp .end			; => return
	
.read
; store so that
; de contains the current address
	ld a, [w_ch4_address+1]
	ld d, a
	ld a, [w_ch4_address]
	ld e, a	
	ld a, [de]
; read the contained byte
; dictionary parsing
	cp a, $F0		; notes = drumset table
	jp c, .fx_playnote
	
	cp a, s_length
	jp z, .fx_length
	
	cp a, s_tie
	jp z, .fx_tie
	
	cp a, s_output
	jp z, .fx_setoutput
	
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
	ld [w_ch4_curlength], a
	inc de
	jp .storeandcontinue
	
.fx_playnote
	ld [w_ch4_curdrum], a
.fx_playnote_do_raw
; parse drum entry and store location
	call Music_D_GetDrumEntry
	ld a, [hli]
	ld [w_ch4_drumaddr], a
	ld a, [hl]
	ld [w_ch4_drumaddr+1], a
	xor a
	ld [w_ch4_drumtimer],a
; restart ch4
.fx_playnote_next
	ld a, [w_ch4_curlength]
	and a
	jr z, .fx_playnote_parseduration
	dec a				; hacky
	ld [w_ch4_duration], a
	jr .fx_playnote_continue
.fx_playnote_parseduration	
; parse note duration
	inc de
	ld a, [de]
	dec a				; hacky
	ld [w_ch4_duration], a
.fx_playnote_continue
; store next byte
	inc de
	jp .storeandend
	
.fx_jump
	inc de
	ld a, [de]
	ld [w_ch4_address], a
	inc de
	ld a, [de]
	ld [w_ch4_address+1], a
	jp .read
	
.fx_call
	inc de
	inc de
	inc de
; save current address to backtrack buffer...
	ld a, d
	ld [w_ch4_buffer+1], a
	ld a, e
	ld [w_ch4_buffer], a
; backtrack and put pointers
	dec de
	ld a, [de]
	ld [w_ch4_address+1], a
	dec de
	ld a, [de]
	ld [w_ch4_address], a
	jp .read
	
.fx_loop
	inc de
	inc de
	inc de
	inc de
; save current address to backtrack buffer...
	ld a, d
	ld [w_ch4_buffer+1], a
	ld a, e
	ld [w_ch4_buffer], a
; backtrack and put loop count
	dec de
	ld a, [de]
	ld [w_ch4_loopcount], a
; put pointers...	
	dec de
	ld a, [de]
	ld [w_ch4_address+1], a
	ld [w_ch4_loopbuffer+1], a
	dec de
	ld a, [de]
	ld [w_ch4_address], a
	ld [w_ch4_loopbuffer], a
	jp .read
	
.fx_return
; Check if loop...
	ld a, [w_ch4_loopcount]
	and a
	jr z, .fx_return_from_subroutine	; no more loops then return from main buffer
	dec a
	ld [w_ch4_loopcount], a			; decrease loop count
; get back from loop buffer
	ld a, [w_ch4_loopbuffer]
	ld [w_ch4_address], a
	ld a, [w_ch4_loopbuffer+1]
	ld [w_ch4_address+1], a
	jp .read
.fx_return_from_subroutine
; get back from main buffer
	ld a, [w_ch4_buffer]
	ld [w_ch4_address], a
	ld a, [w_ch4_buffer+1]
	ld [w_ch4_address+1], a
	jp .read

.storeandcontinue
	ld a, d
	ld [w_ch4_address+1], a
	ld a, e
	ld [w_ch4_address], a
	jp .read
	
.storeandend
	ld a, d
	ld [w_ch4_address+1], a
	ld a, e
	ld [w_ch4_address], a
.end
	ret

Music_D_GetDrumEntry:
; where a = note value
	ld b, 0
	ld c, a
	ld hl, DrumTable
	add hl, bc
	add hl, bc
	ret
	
Music_D_DoDrums:
; check if timer == 0
	ld a, [w_ch4_drumtimer]
	and a
	jr z, .get
	dec a
	ld [w_ch4_drumtimer], a
	ret
.get
; fetch
	ld a, [w_ch4_drumaddr]
	ld l, a
	ld a, [w_ch4_drumaddr+1]
	ld h, a
	ld a, [hli]
	cp a, $FF
	jr z, .end
; in action
	ld [rNR43], a		; store note
	ld a, [hli]
	ld [rNR42], a		; store envelope
	ld a, [hli]
	ld [w_ch4_drumtimer], a	; store note time
	ld a, $80
	ld [rNR44], a
; store
	ld a, l
	ld [w_ch4_drumaddr], a
	ld a, h
	ld [w_ch4_drumaddr+1], a
	ret
.end
; store
	ld a, [hli]
	ld [w_ch4_drumaddr], a
	ld a, [hl]
	ld [w_ch4_drumaddr+1], a
	jr Music_D_DoDrums
	
Music_D_Drums:
	ld a, [w_ch4_curdrum]
	and a
	ret z
	call Music_D_DoDrums
	ret