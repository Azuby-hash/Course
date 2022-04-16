	RCAP2L EQU 0CAH ; sfr address
	RCAP2H EQU 0CBH ; sfr address
	T2CON EQU 0C8H
 
	ORG 0 ; reset address
	SJMP START ; jump over reserved area
	ORG 40H ; program start address

	START: MOV SCON,#42H ; serial mode 1, TI set

	MOV RCAP2H,#0FFH ; baudrate 9600
	MOV RCAP2L,#0B8H ;

	ORL T2CON,#34H ; turn Timer 2 on

 AGAIN: 
 	MOV SBUF, #'A'; ASCII of A into S0BUF

 HERE: JNB TI,HERE ; stay here till TI set
	CLR TI ; clear TI
	SJMP AGAIN ; repeat
	END ; end of assembly language
