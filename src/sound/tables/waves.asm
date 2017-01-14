Waveforms::			; wave channel waveforms
	dw .w0	;0
	dw .w1	;1
	dw .w2	;2
	dw .w3	;3
	dw .w4	;4
	dw .w5	;5
	dw .w6	;6
	dw .w7	;7
	dw .w8	;8
	dw .w0	;9
	dw .w0	;a
	dw .w0	;b
	dw .w0	;c
	dw .w0	;d
	dw .w0	;e
	dw .w0	;f
.w0			; saw wave
	db $00,$11,$22,$33,$44,$55,$66,$77,$88,$99,$aa,$bb,$cc,$dd,$ee,$ff
.w1			; thingamabob
	db $00,$10,$11,$22,$20,$33,$30,$44,$40,$55,$50,$66,$60,$77,$70,$78
.w2			; pokemon smooth wave #1
	db $02,$46,$8A,$CE,$FF,$FE,$ED,$DC,$CB,$A9,$87,$65,$44,$33,$22,$11
.w3			; pokemon smooth wave #2
	db $02,$46,$8A,$CE,$EF,$FF,$FE,$EE,$DD,$CB,$A9,$87,$65,$43,$22,$11
.w4			; pokemon smooth wave #3
	db $02,$46,$8A,$CD,$EF,$FE,$DE,$FF,$EE,$DC,$BA,$98,$76,$54,$32,$10
.w5			; pokemon smooth wave #4
	db $13,$69,$BD,$EE,$EE,$FF,$FF,$ED,$DE,$FF,$FF,$EE,$EE,$DB,$96,$31
.w6			; pokemon saw wave
	db $01,$23,$45,$67,$8A,$CD,$EE,$F7,$7F,$EE,$DC,$A8,$76,$54,$32,$10
.w7			; basic triangle wave
	db $01,$23,$45,$67,$89,$AB,$CD,$EF,$FE,$DC,$BA,$98,$76,$54,$32,$10
.w8			; derp wave
	db $91,$11,$12,$22,$34,$56,$78,$9a,$bc,$cd,$de,$88,$76,$64,$21,$00