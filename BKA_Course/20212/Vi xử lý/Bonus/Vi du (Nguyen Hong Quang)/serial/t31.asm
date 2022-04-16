
	ORG 0 		; reset address
	SJMP START	; jump over reserved area
	ORG 40H 	; program start address
	
START: 	MOV SCON,#42H ; serial mode 1, TI set
	MOV TMOD,#20H ; timer 1 mode 2
	MOV TH1,#0FAH ; baudrate 9600
	MOV TL1,#0FAH ; TL1 also initially set
	SETB TR1 ; turn timer 1 on

TEXT: MOV DPTR,#MSG1 ; Data Pointer to message address

NEXTCH: MOV A,#0 ; zero the previous character
	MOVC A,@A + DPTR ; character into A
	CJNE A,#0,TRXCH ; checking end of message, ¼ 7EH
	MOV A,#0DH ; carriage return ¼ 0DH
	ACALL SEND ; call up send routine
	MOV A,#0AH ; line feed ¼ 0AH
	ACALL SEND ; call up send routine
	SJMP TEXT ; repeat line of text

TRXCH: ACALL SEND ; send text character
	INC DPTR ; increment data pointer
	SJMP NEXTCH ; prepare to send next character

SEND: 	JNB TI,SEND ; check SBUF clear to send
	CLR TI ; clear TI
	MOV SBUF,A ; send contents of A
	RET ; return from subroutine

MSG1: 	DB  "This is test for serial windows",0 ; text message

	END ; no more assembly language
