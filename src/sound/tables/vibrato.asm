VibratoTable:				; blech.,
	dw .v020			; 01
	dw .v040			; 02
	
.v020
	db 0, -1, -2, -2, -1, 0, 1, 2, 2, 1
	db $80
	dw .v020
.v040
	db 0, -1
	db $80
	dw .v040