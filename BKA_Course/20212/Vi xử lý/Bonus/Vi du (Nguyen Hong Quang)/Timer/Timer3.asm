
RCAP2H 	EQU 	0CBH 		; sfr address ¼ CBH 	 
RCAP2L 	EQU 	0CAH 		; sfr address ¼ CAH 	 
IEN1 	EQU 	0A8H 		; 	ser 	address ¼ E8H 	 
T2CON 	EQU 	0C8H 		; sfr address ¼ C8H 	 
	ORG 	0 		; 	reset 	address 	 
	SJMP 	START 		; jump 	over 	reserved 	area 	 
	ORG 	2BH 		; Timer2 interrupt address 	 
	SJMP 	TASK 		; jump 	to 	interrupt task 	 
	ORG 	40H 		; program 	start 	address 	 
START: 	MOV 	RCAP2H,#0B7H	 ; B7H into RCAP2H 	 
	MOV 	RCAP2L,#0FFH 	; FFH into RCAP2L 	 
	SETB 	EA 		; enable all interrupts 	 
	ORL 	IEN1,#20H 	; enable Timer2(ET2) interrupt 	 
	ORL 	T2CON,#04H 	; 	turn 	Timer2 	on 	 
AGAIN: 	SJMP 	AGAIN 		; stay here till interrupt 	 
TASK: 	CPL 	P1.7 		; toggle P1.7 	 
	ANL 	T2CON,#7FH 	; clear Timer2 flag(TF2) 	 
	RETI 			; 	return 	from interrupt 	 
	END 			; end of assembly language 	 
