mus_entry:	MACRO
	db \1	; speed
	dw \2	; music pointers
ENDM

m_slide:	MACRO				; WITH DELAY
	db s_slide
	db (\1 + $c * (\2-1))
	db \3
	ENDM

slide:	MACRO				; FOR AUTO
	db s_slide
	db (\1 + $c * (\2-1))
	ENDM

m_note:	MACRO				; WITH DELAY
	db (\1 + $c * (\2-1))
	db \3
	ENDM

note:	MACRO				; FOR AUTO
	db (\1 + $c * (\2-1))
	ENDM

rest:	MACRO
	db $00
	ENDM
	
m_rest:	MACRO
	db $00, \1
	ENDM
	
drum:	MACRO
	db \1
	ENDM
	
m_drum:	MACRO
	db \1, \2
	ENDM
	
m_notetie:	MACRO			; WITH DELAY
	db s_tie, \1
	ENDM
	
notetie:	MACRO			; FOR AUTO
	db s_tie
	ENDM

goEnd: MACRO
	db s_end
ENDM

goReturn: MACRO
	db s_return
ENDM
	
goJump: MACRO
	db s_jump
	dw \1
ENDM

kickstartSound: MACRO
	db 0, 1				; rest with duration of 1
					; it's just that shitty
ENDM

goLoop: MACRO
	db s_loop
	dw \1
	db \2
ENDM
	
goCall: MACRO
	db s_call
	dw \1
ENDM

setTranspose: MACRO
	db s_transpose, \1
ENDM

useInstrument: MACRO
	db s_instrument, \1
ENDM

setEnvelope: MACRO
	db s_envelope, (\1 * $10 + \2)
ENDM

setLength: MACRO
	db s_length, \1
ENDM

setFine: MACRO
	db s_fine, \1
ENDM

setSweep: MACRO
	db s_sweep, \1
ENDM

setDuty: MACRO
	db s_duty, \1
ENDM

setWave: MACRO
	db s_wave, \1
ENDM

setVibrato: MACRO
	db s_vibtype, \1
ENDM

setOutput: MACRO
	db s_output, \1
ENDM

setPitchSlide: MACRO
	db s_pitchmod, \1
ENDM