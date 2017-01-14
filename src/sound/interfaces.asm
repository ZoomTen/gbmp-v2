; === AUDIO INTERFACES ===

Music_Play:
	di			; disable interrupts
	ld b, a			; saves a to b temporarily
	call Music_Stop		; stops sound completely
	ld a, b			; brings it back because a is overwritten by 0
				; by now
; load table address to hl
	ld hl, Music_SongList
	ld c, a
	ld b, 0
; add a * 3
	add hl, bc
	add hl, bc
	add hl, bc
; set song speed
	ld a, [hli]
	ld [w_song_speed], a	; song speed...
; pointer to de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
; start reading entry,
; move de -> bc
	ld b, d
	ld c, e
	ld hl, w_ch1_address	; starting RAM address
; load individual channels... [1,2,3,4]
	ld c, 8
.loadchannels
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loadchannels
; enable sound play
	xor a
	inc a
	ld [w_song_enabled], a
	ld a, $FF
	ld [rNR50], a
	reti
	
Music_Stop:
	di
; disable SE
	xor a
	ld [w_song_enabled], a
; clear sound RAM
	ld c, se_ram_end - se_ram_start
	ld hl, se_ram_start
.clear
	ld [hli], a
	dec c
	jr nz, .clear
; disable access to sound registers
	ld [rNR50], a
	reti