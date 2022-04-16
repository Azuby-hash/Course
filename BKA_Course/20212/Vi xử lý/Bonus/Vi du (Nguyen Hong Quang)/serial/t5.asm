 
	ORG 0 		; reset address
	SJMP START 	; jump over reserved area
	ORG 23H		; UART interrupt address
	SJMP RXBUF 	; jump to interrupt routine
	ORG 40H ; program start address

START: 	MOV SCON,#50H ; mode 1, REN enabled
	MOV TH1,#0FAH ; 9600 baud
	MOV TMOD,#20H ; timer 1 mode 2
	MOV IE,#90H ; UART interrupt enabled
	SETB TR1 ; turn timer 1 on
STAY:   SJMP STAY ; stay here, wait for interrupt

RXBUF: 	JNB RI,RXBUF ; check for received byte
	CLR RI ; clear RI
	MOV A,SBUF ; move character from buffer to A
	MOV P1,A ; hex value onto port 1
	RETI ; return from interrupt
	END ; no more assembly language
