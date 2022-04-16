	ORG 0 ; reset address
	SJMP START ; short jump over reserved area
	ORG 40H ; program start address at 0040H

	START: MOV TMOD,#02H ; put Timer 0 into mode 2
	MOV TH0,#47H ; auto-reload base number into TH0
AGAIN: SETB P1.7 ; pin 7 port1 to logic 1 (5 volts)

	ACALL DELAY ; go to 0.5ms delay
	CLR P1.7 ; pin 7 port1 to logic 0 (0 volts)
	ACALL DELAY ; go to 0.5ms delay
	SJMP AGAIN ; repeat

	DELAY: SETB TR0 ; turn Timer 0 on
FLAG: JNB TF0,FLAG ; repeat until rollover when TF0¼1
	CLR TR0 ; turn Timer 0 off
	CLR TF0 ; clear TF0 back to 0
	RET ; return from delay subroutine
	END ; no more assembly language after here
