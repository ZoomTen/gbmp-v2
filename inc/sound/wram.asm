SECTION "WRAM Bank 0", WRAM0

se_ram_start::			; SOUND ENGINE START MARKER
; ==========================================================================
; === SONG ===
w_song_enabled::	ds 1	; song started?
				; 0000 0000	only lower nibbles are used
				;      4321 #channel
w_song_output::		ds 1	; output volume
w_song_timer::		ds 1	; clock
w_song_speed::		ds 1	; clock multiplier ($FF = original speed,
				;                   and the lower the value
				;		    the slower it is
				;		    Useful for finetuning tempo)

; === PLAYBACK / TRANSPORT ===

w_ch1_address::		ds 2	; current playback/read address
w_ch2_address::		ds 2	; all channels are in one group for this only
w_ch3_address::		ds 2
w_ch4_address::		ds 2

w_ch1_buffer::		ds 2	; continue address
w_ch1_loopbuffer::	ds 2	; original loop address
w_ch1_loopcount::	ds 1	; loop count
w_ch1_duration::	ds 1	; timer


w_ch2_buffer::		ds 2
w_ch2_loopbuffer::	ds 2
w_ch2_loopcount::	ds 1
w_ch2_duration::	ds 1


w_ch3_buffer::		ds 2
w_ch3_loopbuffer::	ds 2
w_ch3_loopcount::	ds 1
w_ch3_duration::	ds 1


w_ch4_buffer::		ds 2
w_ch4_loopbuffer::	ds 2
w_ch4_loopcount::	ds 1
w_ch4_duration::	ds 1

; === INSTRUMENTS ===

w_ch1_arpaddr::		ds 2	; arp address offset
w_ch1_dutaddr::		ds 2	; duty address offset
w_ch1_vibaddr::		ds 2	; vibrato address offset

w_ch2_arpaddr::		ds 2
w_ch2_dutaddr::		ds 2
w_ch2_vibaddr::		ds 2

w_ch3_arpaddr::		ds 2
w_ch3_voladdr::		ds 2
w_ch3_vibaddr::		ds 2

w_ch4_drumaddr::	ds 2

; === CHANNEL STATE ===

w_ch1_curnote::		ds 1	; current note
w_ch1_curinst::		ds 1	; current instrument
w_ch1_curvol::		ds 1	; current volume
w_ch1_curarp::		ds 2	; current arp-affected note pitch
w_ch1_curduty::		ds 1	; current duty shift
w_ch1_vib::		ds 1	; current vibrato table
w_ch1_curtrps::		ds 1	; current note shift
w_ch1_cursweep::	ds 1	; current sweep [CHANNEL 1 ONLY]
w_ch1_curfine::		ds 1	; fine pitch offset
w_ch1_curlength::	ds 1	; autolength
w_ch1_lofreq::		ds 1	; frequency, lower bytes
w_ch1_slide_n::		ds 1	; slide [PITCH MOD] amount
w_ch1_slide_x::		ds 1	; slide [PITCH MOD] counter

w_ch2_curnote::		ds 1
w_ch2_curinst::		ds 1
w_ch2_curvol::		ds 1
w_ch2_curarp::		ds 2
w_ch2_curduty::		ds 1
w_ch2_vib::		ds 1
w_ch2_curtrps::		ds 1
w_ch2_curfine::		ds 1
w_ch2_curlength::	ds 1
w_ch2_lofreq::		ds 1
w_ch2_slide_n::		ds 1
w_ch2_slide_x::		ds 1

w_ch3_curnote::		ds 1
w_ch3_curinst::		ds 1
w_ch3_curvol::		ds 1
w_ch3_curarp::		ds 2
w_ch3_curwave::		ds 1
w_ch3_vib::		ds 1
w_ch3_curtrps::		ds 1
w_ch3_curfine::		ds 1
w_ch3_curlength::	ds 1
w_ch3_lofreq::		ds 1
w_ch3_slide_n::		ds 1
w_ch3_slide_x::		ds 1

w_ch4_curdrum::		ds 1
w_ch4_curlength::	ds 1
w_ch4_drumtimer::	ds 1	; drum frame timer
; ==========================================================================
se_ram_end::			; SOUND ENGINE END MARKER

;ALL POINTERS ARE LITTLE ENDIAN