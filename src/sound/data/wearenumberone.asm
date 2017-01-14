Mus_WeAreNumberOne:
	dw .ch1
	dw .ch2
	dw Music_DisableChannel
	dw .ch4
	
.ch1
	setEnvelope 7, 4
	kickstartSound
	m_notetie (5 * 16)
	m_notetie (5 * 16)
	m_notetie (5 * 16)
	m_notetie (5 * 16)
.ch1_
	setTranspose 0
	goLoop .ch1_loop1, 7
	setTranspose 3
	goLoop .ch1_loop1, 3
	setTranspose 0
	goLoop .ch1_loop1, 2
	goCall .ch1_loop2
	goJump .ch1_
.ch1_loop1
	useInstrument 0
	setEnvelope 5, 0
	setDuty 2
	setSweep $1b
	m_note F_, 4, (5 * 2)
	useInstrument 2
	setSweep 0
	setEnvelope 4, 2
	m_note F_, 3, (5 * 2)
	goReturn
.ch1_loop2
	useInstrument 0
	setEnvelope 5, 0
	setDuty 2
	setSweep $1c
	m_note F_, 4, (5 * 2)
	m_note F_, 4, (5 * 1)
	m_note F_, 4, (5 * 1)
	goReturn
	
.ch2
	setFine -2
	setEnvelope 6, 4
	kickstartSound
	setVibrato 1
	useInstrument 3
	setDuty 2
	setLength 0
	goCall .ch2_call1
	m_note C#, 4, (5 * 4)
	m_note D#, 4, (5 * 4)
	goCall .ch2_call2
.ch2_
	goCall .ch2_call1
	m_note C#, 4, (5 * 4)
	m_note D#, 4, (5 * 4)
	goCall .ch2_call2
	
	goCall .ch2_call1
	m_note D#, 4, (5 * 4)
	m_note C#, 4, (5 * 4)
	goCall .ch2_call2
	goJump .ch2_
.ch2_call1
	m_note F_, 3, (5 * 6)
	m_note C_, 4, (5 * 2)
	m_note B_, 3, (5 * 1)
	m_note C_, 4, (5 * 1)
	m_note B_, 3, (5 * 1)
	m_note C_, 4, (5 * 1)
	m_note B_, 3, (5 * 2)
	m_note C_, 4, (5 * 2)
	m_note G#, 3, (5 * 4)
	m_note F_, 3, (5 * 2)
	setPitchSlide -3
	m_notetie (5 * 4)
	setPitchSlide 0
	m_note F_, 3, (5 * 2)
	m_note G#, 3, (5 * 2)
	m_note C_, 4, (5 * 2)
	m_note C#, 4, (5 * 4)
	m_note G#, 3, (5 * 4)
	goReturn
.ch2_call2
	m_note C_, 4, (5 * 2)
	m_note C#, 4, (5 * 2)
	m_note C_, 4, (5 * 2)
	m_note C#, 4, (5 * 2)
	m_note C_, 4, (5 * 8)
	goReturn
	
.ch4
	setOutput %11111111
	kickstartSound
	m_notetie (5 * 16)
	m_notetie (5 * 16)
	m_notetie (5 * 16)
	m_notetie (5 * 8)
.ch4_
	setLength (5 * 2)
	rest
	rest
	drum 1
	rest
	goJump .ch4_