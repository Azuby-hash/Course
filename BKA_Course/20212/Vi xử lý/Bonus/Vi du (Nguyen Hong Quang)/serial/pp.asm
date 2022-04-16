Begin:
		Mov A,# 0		; (A) = 0
		MOV P1,A		; G?i ra c?ng P1
		Call	wait		; G?i chuong trình t?o tr? 
		Mov A,# 255	; (A) =255
		Mov P1,A		; G?i  ra c?ng P1
		Call	Wait		; G?i chuong trình t?o tr?
		Jmp   Begin		; Nh?y tr? l?i Begin
Wait:
		Mov R7, #255	; (R7)=255 - S? d?m vòng ngoài 
	Schl1:	Mov R6, #255	;(R6)= 255- S? d?m vòng trong
	Schl2:	Djnz R6, Schl2	;N?u (R6) ? 0 thi quay l?i Schl 2
		Djnz R7, Schl1	; N?u (R7) ? 0 thi quay l?i Schl 1
		Ret			
End
