DrumTable:
	dw .empty		;0
	dw .PokemonSnare	;1
	dw .hat	;2
	
.empty
	db $00, $00, $01
	db $FF
	dw .empty
	
.PokemonSnare
; format = Note, envelope, length
	db $33, $c1, $C
.PokemonSnare_
	db $00, $00, $01
	db $FF
	dw .PokemonSnare_
	
.hat
; format = Note, envelope, length
	db $33, $c1, $11
.hat_
	db $00, $00, $01
	db $FF
	dw .hat_