; Base notes
rs		EQU	$00
C_		EQU	$01
C#		EQU	$02
D_		EQU	$03
D#		EQU	$04
E_		EQU	$05
F_		EQU	$06
F#		EQU	$07
G_		EQU	$08
G#		EQU	$09
A_		EQU	$0A
A#		EQU	$0B
B_		EQU	$0C

; Command constants
s_end		EQU	$FF
s_loop		EQU	$FE
s_jump		EQU	$FD
s_call		EQU	$FC
s_transpose	EQU	$FB
s_instrument	EQU	$FA
s_envelope	EQU	$F9
s_length	EQU	$F8
s_fine		EQU	$F7
s_sweep		EQU	$F6
s_duty		EQU	$F5
s_wave		EQU	$F5	; f5 xx
s_return	EQU	$F4
s_tie		EQU	$F3
s_slide		EQU	$F2
s_vibtype	EQU	$F1	; f1 xx
s_output	EQU	$F0	; f0 xx
s_pitchmod	EQU	$E9	; e9 xx

; notes
; <xx yy>
; where xx is the note value
; and yy is the duration in frames
; if fixed note length, yy is not needed

;.fx_setinstrument
; <??? xx>
; where xx is the instrument number

;.fx_setenvelope
; <??? xy>
; where x is the initial volume
; and y determines the envelope
; (0-7 down, 8-F up)

;.fx_transpose
; <??? xx>
; where xx is the note offset

;.fx_sweep
; <??? xx>
; where xx is the sweep, according to pandoc

;.fx_duty
; <??? xx>
; where xx is the duty cycle
; useless in an instrument context

;.fx_jump
; <??? xxxx>
; where xxxx is the pointer in little endian

;.fx_call
; <??? xxxx>
; where xxxx is the pointer in little endian

;.fx_loop
; <??? xxxx yy>
; where xxxx is the pointer in little endian
; yy is loop count, 0 = once, 1 = twice etc.

;.fx_return
; <???>
; Return from subroutine (loop AND jump)

;.fx_tie
; <???>
; Extend a note

;.fx_fine
; <??? xx>
; where xx is the fine pitch

;.fx_length
; <??? xx>
; where xx is the fixed note length

; slide
; <?? xx yy>
; "slides" to a new note
; in reality it's just changing to a new note
; WITHOUT resetting everything
; equivalent to QFx on FamiTracker
; where xx is the note value
; and yy is the duration in frames
; if fixed note length, yy is not needed