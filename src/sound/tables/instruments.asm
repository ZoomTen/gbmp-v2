InstrumentTable:
	dw Instrument_Blank		; 01
	dw Instrument_Arp070		; 02
	dw Instrument_Lead		; 03
	dw Instrument_WHAT		; 04
	
; FOR CHANNEL 1 & 2	=>	ARPEGGIO AND DUTY
; FOR CHANNEL 3		=>	ARPEGGIO AND VOLUME
	
Instrument_Blank:
	dw .arpeggio
	dw .duty
.arpeggio
	db 0			; (note offset)
	db $FF			; loop byte
	dw .arpeggio
.duty
	db 0			; (duty value)
	db $FF			; loop byte
	dw .duty
	
Instrument_Blank2:
	dw .arpeggio
	dw .duty
.arpeggio
	db 0			; (note offset)
	db $FF			; loop byte
	dw .arpeggio
.duty
	db 2			; (duty value)
	db $FF			; loop byte
	dw .duty

Instrument_Arp070:
	dw .arpeggio
	dw .duty
.arpeggio
	db 7-12, 0, 7			; (note offset)
	db $FF			; loop byte
	dw .arpeggio
.duty
	db 2			; (duty value)
	db $FF			; loop byte
	dw .duty
	
Instrument_Lead:
	dw .arpeggio
	dw .duty
.arpeggio
	db 0
	db $FF			; loop byte
	dw .arpeggio
.duty
	db 2			; (duty value)
	db 2			; (duty value)
	db 2			; (duty value)
.duty_
	db 0
	db $FF			; loop byte
	dw .duty_
	
Instrument_WHAT:
	dw .arpeggio
	dw .duty
.arpeggio
	db 12, 12			; (note offset)
.arpeggio_
	db 0			; (note offset)
	db $FF			; loop byte
	dw .arpeggio_
.duty
	db 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3
.duty_
	db 0			; (duty value)
	db $FF			; loop byte
	dw .duty_