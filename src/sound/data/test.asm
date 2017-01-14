Mus_Test:
	dw .ch1
	dw .ch2
	dw .ch3

.ch1
	setEnvelope 6, 3
	kickstartSound
.ch1_
	setFine -4
	useInstrument 0
	setDuty 2
	setSweep $1b
	setLength (32 * 1)
	note C_, 6
	note C_, 6
	note C_, 6
	note C_, 6
	setLength (16 * 1)
	note C_, 6
	note C_, 6
	note C_, 6
	note C_, 6
	note C_, 6
	note C_, 6
	setLength (8 * 1)
	note C_, 6
	note C_, 6
	setLength (4 * 1)
	note C_, 6
	note C_, 6
	setLength (2 * 1)
	note C_, 6
	note C_, 6
	setLength (1)
	note C_, 6
	note C_, 6
	note C_, 6
	note C_, 6
	goJump .ch1_
	goEnd
		
		
.ch2
	setEnvelope 6, 3
	kickstartSound
.ch2_
	useInstrument 2
	setLength (2 * 1)
	note C_, 4
	slide B_, 3
	slide A_, 3
	slide G_, 3
	slide F_, 3
	slide E_, 3
	slide D_, 3
	slide C_, 3
	useInstrument 3
	setLength (8 * 1)
	note C_, 4
	note D_, 4
	slide E_, 4
	note F_, 4
	goJump .ch2_
	
	
.ch3
	setOutput %11101101
	setEnvelope 0, 2
	setWave 6
	kickstartSound
.ch3_
	setLength (2 * 1)
	note C_, 4
	slide B_, 3
	slide A_, 3
	slide G_, 3
	slide F_, 3
	slide E_, 3
	slide D_, 3
	slide C_, 3
	goJump .ch3_