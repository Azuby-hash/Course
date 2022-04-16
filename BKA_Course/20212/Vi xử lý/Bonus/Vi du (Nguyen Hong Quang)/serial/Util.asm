;
;****************************************************************************
;
;  Purpose:
;	Assorted Utilities
;
;  Date:
;	11/23/96
;
;  Author:
;	John C. Wren
;
;  Modications:
;	02/04/97 - Added Description Fields For Archive
;
;  Processor:
;	Generic 8031
;
;  Assembler:
;	Avocet AVA51
;
;  Dependencies:
;	None
;
;  Files:
;	MACROS.INC
;
;  Comments:
;	I Use ETX To Terminate Strings, Which Is Usually 0x03.  Most People
;	Prefer To Use 0x00 As A String Terminator.  To Do This, Just Change
;	The Value Of ETX, And Re-assemble.
;
;  Philosophic:
;	Just A Bunch Of Utilties.  Some Are Of Little Value To Most People,
;	Some Are A Major Statement Of The Obvious, Some Look Too Short To
;	Be Worth Posting Alone But Are In The File Anyway.
; 
;****************************************************************************
;
;  Includes
;
;		%include "equates.inc"
		%include "macros.inc"
		seg	code
;
;****************************************************************************
;
;  Publics
;
		public	UTIL_ADCAD
		public	UTIL_ADCBAD
		public	UTIL_SUBBAD
		public	UTIL_SUBBBAD
		public	UTIL_INC16
		public	UTIL_UCOMPARE16
		public	UTIL_UCMPDPTRBA
		public	UTIL_SHIFT4L
		public	UTIL_LDDPTRC
		public	UTIL_LDDPTRD
		public	UTIL_STDPTRD
		public	UTIL_DPTRR01
		public	UTIL_DPTRR67
		public	UTIL_DPTR2C
		public	UTIL_DPTRDEC
		public	UTIL_DPTRASR1
		public	UTIL_DPTRSHR1
		public	UTIL_DPTRROL4
		public	UTIL_DPTRSHL4
		public	UTIL_R3R7RL4
		public	UTIL_DPTRX10
		public	UTIL_DPTRX100
		public	UTIL_DPTRX1000
		public	UTIL_CALLFUNC
		public	UTIL_TOLOWER
		public	UTIL_TOUPPER
		public	UTIL_HEXTOBIN
		public	UTIL_DECTOBIN
		public	UTIL_BCDTOBIN
		public	UTIL_ASC36TOBIN
		public	UTIL_BINTOASC
		public	UTIL_BINTOASC36
		public	UTIL_BINTOBCD
		public	UTIL_BINTOBCD12
		public	UTIL_BINTODEC
		public	UTIL_BINTOUDEC
		public	UTIL_VALDCDG
		public	UTIL_VALHXDG
		public	UTIL_VALALPHA
		public	UTIL_VALALPHAZ
		public	UTIL_CNTDG
		public	UTIL_UDIV
		public	UTIL_UMOD
		public	UTIL_DIV
		public	UTIL_MOD
		public	UTIL_COPYXTOI
		public	UTIL_COPYITOX
		public	UTIL_COPYCTODL
		public	UTIL_COPYCTODZ
		public	UTIL_COPYDTODL
		public	UTIL_COPYDTODZ
		public	UTIL_PUT_ETX
		public	UTIL_FIND_ETX
		public	UTIL_TRIM
		public	UTIL_STRLEN
;
;****************************************************************************
;
;  Equates
;
ETX		equ	3			; ASCII ETX Character
SPACE		equ	32			; ASCII Space Character
;
;****************************************************************************
;
;  Description:
;  	Add Acc To DPTR, Setting Carry If DPTR Overflows
;
;  Entry Requirements:
;	DPTR Has Value
;	Acc Has Value To Add
;
;  On Exit:
;	DPTR = DPTR + Acc, CY Set Accordingly
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Value Of CY On Entry Does Not Affect Result
;
UTIL_ADCAD	proc
		push	acc			; Make Sure Acc Gets Saved
		add	a,dpl			; Add 'A' To DPL
		mov	dpl,a			; Move Result To DPL
		mov	a,dph			; Get DPH
		addc	a,#000h 		; If Carry Set, This Will Increment
		mov	dph,a			; Move Bck To DPH
		pop	acc			; Recover Original 'A'
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Add B/Acc To DPTR, Setting Carry If DPTR Overflows
;
;  Entry Requirements:
;	DPTR Has Value
;	'B' Has High Of Value To Add, Acc Has Low Of Value To Add
;
;  On Exit:
;	DPTR = DPTR + B/Acc, CY Set Accordingly
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Value Of CY On Entry Does Not Affect Result
;
UTIL_ADCBAD	proc
		push	acc			; Make Sure Acc Gets Saved
		add	a,dpl			; Add 'A' To DPL
		mov	dpl,a			; Move Result To DPL
		mov	a,dph			; Get DPH
		addc	a,b 			; Add 'B' To DPH + CY
		mov	dph,a			; Move Bck To DPH
		pop	acc			; Recover Original 'A'
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Subtract Acc From DPTR, Setting Carry If DPTR Underflows
;
;  Entry Requirements:
;	DPTR Has Value
;	Acc Has Value To Subtract
;
;  On Exit:
;	DPTR = DPTR - Acc, CY Set Accordingly
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Value Of CY On Entry Does Not Affect Result
;
UTIL_SUBBAD	proc
		push	acc			; Make Sure Acc Gets Saved
		clr	c			; Clear For SUBB
		xch	a,dpl			; Swap
		subb	a,dpl			; Subtract
		mov	dpl,a			; Move Back To DPL
		mov	a,dph			; Get DPH
		subb	a,#000h 		; If Carry Set, This Will Decrement
		mov	dph,a			; Move Back To DPH
		pop	acc			; Recover Original 'A'
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Subtract B/Acc From DPTR, Setting Carry If DPTR Underflows
;
;  Entry Requirements:
;	DPTR Has Value
;	'B' Has High Of Value To Subtract, Acc Has Low Of Value To Subtract
;
;  On Exit:
;	DPTR = DPTR - B/Acc, CY Set Accordingly
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Value Of CY On Entry Does Not Affect Result
;
UTIL_SUBBBAD	proc
		push	acc			; Make Sure Acc Gets Saved
		clr	c			; Clear For SUBB
		xch	a,dpl			; Swap
		subb	a,dpl			; Subtract
		mov	dpl,a			; Move Back To DPL
		mov	a,dph			; Get DPH
		subb	a,b	 		; Subtract + CY
		mov	dph,a			; Move Back To DPH
		pop	acc			; Recover Original 'A'
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	R0 Points To A 16 Bit Location To Increment.  CY == 1 If Overflow.
;
;  Entry Requirements:
;	R0 Pointing To A 16 Bit Location In Internal RAM
;
;  On Exit:
;	CY Set Accordingly
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Might Be A Good Idea To Save The Accumulator
;
UTIL_INC16	proc
		inc	r0			; Point To Low Byte
		mov	a,@r0			; Get Low Byte
		add	a,#1			; Add 1
		mov	@r0,a			; Store Back
		dec	r0			; Point To High Byte
		mov	a,@r0			; Get High Byte
		addc	a,#0			; Add CY, If Set
		mov	@r0,a			; Store Back
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	R0 Points To A 16 Bit Location To Compare To DPTR.  Return CY == 1
;	If DPTR > @R0, Else CY == 0 If DPTR  <= @R0.  The Operation Is 
;	@R0 - DPTR.
;
;  Entry Requirements:
;	DPTR With Value To Be Compared Against
;	R0 Pointing To 16 Bit Location In Internal RAM To Compare
;
;  On Exit:
;	CY Set Accordingly
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Might Be A Good Idea To Save The Accumulator
;
UTIL_UCOMPARE16	proc
		clr	c			; Clear For Subtract
		inc	r0			; Point To Low Byte
		mov	a,@r0			; Get Low Byte
		subb	a,dpl			; Subtract DPL
		dec	r0			; Point To High Byte
		mov	a,@r0			; Get High Byte
		subb	a,dph			; Subtract DPH
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Compare DPTR To AB.  Return CY == 1 If DPTR > BA, Else CY == 0 If 
;	DPTR <= BA.  The Operation Is BA - DPTR.
;
;  Entry Requirements:
;	B/Acc With Value To Be Compared Against
;	DPTR Containing Value To Compare
;
;  On Exit:
;	CY Set Accordingly
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Might Be A Good Idea To Save The Accumulator
;
UTIL_UCMPDPTRBA	proc
		clr	c			; Clear For Subtract
		subb	a,dpl			; Subtract DPL
		mov	a,b			; Get High Byte
		subb	a,dph			; Subtract DPH
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	R0 Points To A 16 Bit Location To Shift 4 Bits Left.  Acc Contains 
;	The Value To OR In The Low 4 Bits.
;
;
;  Entry Requirements:
;	R0 Pointing To A 16 Bit Location In Internal RAM
;	Acc With Low 4 Bits To OR In (Top 4 Bits Don't Matter)
;
;  On Exit:
;	Acc Contains Value Of Low 8 Bits Of 16 Bit Value
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_SHIFT4L	proc
		push	acc			; Save Acc
		mov	a,@r0			; Get High Byte
		anl	a,#00fh 		; Keep Only Bits 8..11
		swap	a			; Move Bits 8..11 To 12..15
		mov	@r0,a			; Store Back
		inc	r0			; Point To Low Byte
		mov	a,@r0			; Get Low Byte
		swap	a			; Swap Bits 0..3 And 4..7
		mov	@r0,a			; Store Back
		anl	a,#00fh 		; Keep Only Bits 4..7
		dec	r0			; Points To High Byte
		orl	a,@r0			; OR In Bits 4..7 With 8.11
		mov	@r0,a			; Store Back
		inc	r0			; Point To Low Byte
		mov	a,@r0			; Get Low Byte
		anl	a,#0f0h 		; Clear Bits 4..7
		mov	@r0,a			; Store Back
		pop	acc			; Recover Value To OR In
		orl	a,@r0			; Update Bits 0..3
		mov	@r0,a			; Store Back
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Load DPTR From DPTR In Code Space
;
;  Entry Requirements:
;	DPTR Points To 16 Bit Value In Code Space To Load
;
;  On Exit:
;	DPTR = (DPTR)
;
;  Affected:
;	DPTR
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_LDDPTRC	proc
		push	acc			; Save Acc
		clr	a			; Clear For MOVC
		movc	a,@a+dptr		; Get High Byte
		push	acc			; Save It
		mov	a,#1			; Set For MOVC
		movc	a,@a+dptr		; Get Low Byte
		mov	dpl,a			; Move To DPL
		pop	dph			; Recover High To DPH
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Load DPTR From DPTR In External Memory Space
;
;  Entry Requirements:
;	DPTR Points To 16 Bit Value In External Memory Space To Load
;
;  On Exit:
;	DPTR = (DPTR)
;
;  Affected:
;	DPTR
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
; 	None
;
UTIL_LDDPTRD	proc
		push	acc			; Save Acc
		movx	a,@dptr			; Get High Byte
		push	acc			; Save It
		inc	dptr			; Point To Low Byte
		movx	a,@dptr			; Get Low Byte
		mov	dpl,a			; Move To DPL
		pop	dph			; Recover High To DPH
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Store R6/7 To DPTR In External Memory Space.  Return DPTR Pointing To
;	Next Location.
;
;  Entry Requirements:
;	DPTR Contains Location To Store R6/7
;	R6/7 Contains Value To Be Stored
;
;  On Exit:
;	(DPTR) = R6, (DPTR + 1) = R7
;
;  Affected:
;	None
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	I Often Use R6/7 As A Register Pair That Serves As A Second DPTR,
;	So This Is Used To Store R6/7 When Building Lists, Etc.
;
UTIL_STDPTRD	proc
		push	acc			; Save Acc
		mov	a,r6			; Get R6
		movx	@dptr,a			; Store High Byte
		inc	dptr			; Point To Low Byte
		mov	a,r7			; Get R7
		movx	@dptr,a			; Store Low Byte
		inc	dptr			; Point To Next Location
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Exchange R0/1 And DPTR
;
;  Entry Requirements:
;	DPTR Has 1st Value
;	R0/1 Has 2nd Value
;
;  On Exit:
;	DPTR <-> R0/1
;
;  Affected:
;	DPTR, R0, R1
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DPTRR01	proc
		push	acc			; Save Acc
		mov	a,dpl			; Get DPL
		mov	dpl,r1			; Move R1 To DPL
		mov	r1,a			; Move DPL To R1
		mov	a,dph			; Get DPL
		mov	dph,r0			; Move R0 To DPH
		mov	r0,a			; Move DPH To R0
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Exchange R6/7 And DPTR
;
;  Entry Requirements:
;	DPTR Has 1st Value
;	R6/7 Has 2nd Value
;
;  On Exit:
;	DPTR <-> R6/7
;
;  Affected:
;	DPTR, R6, R7
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DPTRR67	proc
		push	acc			; Save Acc
		mov	a,dpl			; Get DPL
		mov	dpl,r7			; Move R7 To DPL
		mov	r7,a			; Move DPL To R7
		mov	a,dph			; Get DPL
		mov	dph,r6			; Move R6 To DPH
		mov	r6,a			; Move DPH To R6
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Subtract 'DPTR' From 0, Setting Carry If DPTR Underflows
;
;  Entry Requirements:
;	DPTR Has Value To Perform 2's Complement On
;
;  On Exit:
;	DPTR = 0 - DPTR
;
;  Affected:
;	PSW.CY
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DPTR2C	proc
		push	acc			; Make Sure Acc Gets Saved
		clr	c			; Clear For SUBB
		clr	a			; Clear For Subtract
		subb	a,dpl			; Subtract
		mov	dpl,a			; Move Back To DPL
		clr	a			; Clear For Subtract
		subb	a,dph	 		; If Carry Set, This Will Decrement
		mov	dph,a			; Move Back To DPH
		pop	acc			; Recover Original 'A'
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Decrement DPTR.  CY == 1 If Underflow
;
;  Entry Requirements:
;	DPTR Has Value To Decrement
;
;  On Exit:
;	DPTR = DPTR - 1, CY Set Accordingly
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DPTRDEC	proc
		push	acc			; Save Acc
		clr	c			; Clear For SUBB
		mov	a,dpl			; Move Low Of DPTR To A
		subb	a,#1			; Subtract 1
		mov	dpl,a			; Store Back
		mov	a,dph			; Get High Of DPTR
		subb	a,#0			; Subtract CY If Set
		mov	dph,a			; Move Back
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Arithmetic Shift DPTR 1 Bit To Right
;
;  Entry Requirements:
;	DPTR Has Value To Shift Right
;
;  On Exit:
;
;  Affected:
;
;  Stack:
;	X Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;
UTIL_DPTRASR1	proc
		push	acc			; Save Acc
		mov	a,dph			; Get High Of DPTR
		mov	c,acc.7			; Preserve Sign
		rrc	a			; Shift Left
		mov	dph,a			; Store Back To DPH
		mov	a,dpl			; Get Low Of DPTR
		rrc	a			; Shift Left
		mov	dpl,a			; Store Back To DPL
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Shift DPTR 1 Bit To Right
;
;  Entry Requirements:
;	DPTR Has Value To Shift Right
;
;  On Exit:
;	DPTR = DPTR >> 1
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DPTRSHR1	proc
		push	acc			; Save Acc
		clr	c			; Clear For Shift
		mov	a,dph			; Get High Of DPTR
		rrc	a			; Shift Left
		mov	dph,a			; Store Back To DPH
		mov	a,dpl			; Get Low Of DPTR
		rrc	a			; Shift Left
		mov	dpl,a			; Store Back To DPL
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;*******************************************************************************
;
;  Description:
;	Rotate DPTR 4 Bits To Left, Bit 15 Moves To Bit 0
;
;  Entry Requirements:
;	DPTR Has Value To Rotate Left
;
;  On Exit:
;	DPTR = ((DPTR & 0xf000) >> 12) | (DPTR << 4)
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DPTRROL4	proc
		push	acc			; Save Acc
		push	0			; Save R0
		mov	r0,#4			; Number Times To Shift
l?p1		mov	a,dph			; Get High Byte
		mov	c,acc.7			; Get High Order Bit
		mov	a,dpl			; Get Low Of DPTR
		rlc	a			; Shift Left
		mov	dpl,a			; Store Back To DPL
		mov	a,dph			; Get High Of DPTR
		rlc	a			; Shift Left
		mov	dph,a			; Store Back To DPH
		djnz	r0,l?p1			; Repeat For R0 Bytes
		pop	0			; Recover R0
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Shift DPTR 4 Bits To Left, Shift 0 Into Low Bits
;
;  Entry Requirements:
;	DPTR Has Value To Shift Left
;
;  On Exit:
;	DPTR = DPTR << 4
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DPTRSHL4	proc
		push	acc			; Save Acc
		push	0			; Save R0
		mov	r0,#4			; Number Times To Shift
l?p1		clr	c			; Clear For Shift
		mov	a,dpl			; Get Low Of DPTR
		rlc	a			; Shift Left
		mov	dpl,a			; Store Back To DPL
		mov	a,dph			; Get High Of DPTR
		rlc	a			; Shift Left
		mov	dph,a			; Store Back To DPH
		djnz	r0,l?p1 		; Repeat For R0 Bytes
		pop	0			; Recover R0
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Shifts The 5 Byte Bank 0 Registers Group R3..R7 4 Bits Left.  It Is 
;	Not Affected By The Register Bank In Use.
;
;  Entry Requirements:
;	R3/4/5/6/7 Contains The 40 Bits Value To Shift Left 4 Bits
;
;  On Exit:
;	R4/5/6/7 = R3/4/5/6/7 << 4
;
;  Affected:
;	PSW.CY, R3, R4, R5, R6, R7
;
;  Stack:
;	4 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_R3R7RL4	proc
		push	acc			; Save Acc
		push	0			; Save R0
		push	1			; Save R1
		mov	r0,#4			; Number Times To Shift
l?p1		mov	a,#7			; Starting Register
		mov	c,rs0			; Low Of Register Select
		mov	acc.3,c			; Low Of Pointer
		mov	c,rs1			; High Of Register Select
		mov	acc.4,c			; High Of Pointer
		mov	r1,a			; Move To R1
		push	0			; Save R0
		mov	r0,#5			; Number Bytes To Shift
		clr	c			; Clear For Shift
l?p2		mov	a,@r1			; Get Low Of DPTR
		rlc	a			; Shift Left
		mov	@r1,a			; Store Back To DPL
		dec	r1			; Back One Register
		djnz	r0,l?p2 		; Repeat For R0 Bytes
		pop	0			; Recover Total Shift Count
		djnz	r0,l?p1 		; Repeat R0 Times
		pop	1			; Recover R1
		pop	0			; Recover R0
		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Multiply DPTR By 10.  Return CY == 1 If Overflow
;
;  Entry Requirements:
;	DPTR Has Value To Multiply By 10
;
;  On Exit:
;	DPTR = DPTR * 10
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	3 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DPTRX10	proc
		push	b			; Save B
		push	acc			; Save Acc
		mov	a,dpl			; Get Low Of Value
		mov	b,#10			; Multiplier
		mul	ab			; BA = DPL * 10
		mov	dpl,a			; Move Low Back To DPL
		push	b			; Save High Side
		mov	a,dph			; Get High Of Value
		mov	b,#10			; Multiplier
		mul	ab			; BA = DPH * 10
		pop	b			; Recover B
		add	a,b			; Add To Low
		mov	dph,a			; Move Back To DPH
		pop	acc			; Recover Acc
		pop	b			; Recover B
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Multiple DPTR By 100.  Return CY == 1 If Overflow
;
;  Entry Requirements:
;	DPTR Has Value To Multiply By 100
;
;  On Exit:
;	DPTR = DPTR * 100
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	If DPTR Overflows On The First Multiply, The Second Call Will Not
;	Reflect The Overflow.  DPTR Should Be Checked Before Entry.
;
UTIL_DPTRX100	proc
		call	UTIL_DPTRX10		; Multiply By 10
		call	UTIL_DPTRX10		; Multiply By 100
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Multiple DPTR By 1000.  Return CY == 1 If Overflow
;
;  Entry Requirements:
;	DPTR Has Value To Multiply By 1000
;
;  On Exit:
;	DPTR = DPTR * 1000
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	If DPTR Overflows On The First Or Second Multiply, The Third Call 
;	Will Not Reflect The Overflow.  DPTR Should Be Checked Before Entry.
;
UTIL_DPTRX1000	proc
		call	UTIL_DPTRX10		; Multiply By 10
		call	UTIL_DPTRX10		; Multiply By 100
		call	UTIL_DPTRX10		; Multiply By 1000
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Call Function Pointed To By DPTR.  Called Function Returns To 
;	Calling Function.
;
;  Entry Requirements:
;	DPTR Contains Address Of Function To Call
;
;  On Exit:
;	None
;
;  Affected:
;	None
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	This Is Useful For Making The Routines Look Clean, Instead Of Having
;	To Setup The Return Address In Calling Function.  Handy For When
;	Tables Of Address For Functions Are Used (Indexed Operations, Etc)
;
UTIL_CALLFUNC	proc
		push	dpl			; Push Low Of Address
		push	dph			; Push High Of Address
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert Character In Acc To Lower Case
;
;  Entry Requirements:
;	Acc Has Character To Convert To Lower Case
;
;  On Exit:
;	Acc Has Lower Case Character, Or Original If Not A..Z Range
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_TOLOWER	proc
		cjlt	a,#'A',l?p1		; If < 'A', Don't Change
		cjgt	a,#'Z',l?p1		; If > 'Z', Don't Change
		add	a,#'a'-'A'              ; Make Lower Case
l?p1		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert Character In Acc To Upper Case
;
;  Entry Requirements:
;	Acc Has Character To Convert To Upper Case
;
;  On Exit:
;	Acc Has Upper Case Character, Or Original If Not A..Z Range
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	X Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_TOUPPER	proc
		cjlt	a,#'a',l?p1		; If < 'a', Don't Change
		cjgt	a,#'z',l?p1		; If > 'z', Don't Change
		clr	c			; Clear For Subtract
		subb	a,#'a'-'A'              ; Make Upper Case
l?p1		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert ASCII Value In Acc To Binary.  Checks Value To See That It's
;	Legal Hex.  If Not, Return CY == 1, Else Return Converted Value In 
;	Acc, And CY == 0.
;
;  Entry Requirements:
;	Acc Has Character To Convert From ASCII Hex To Binary
;
;  On Exit:
;	Acc Has Binary Value, Or Original Character If Not Legal ASCII Hex
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_HEXTOBIN	proc
		call	UTIL_VALHXDG		; See If Good Digit
		jc	l?p3			; If Not, Return CY == 1
		subb	a,#'0'                  ; Make 0..16 Range
		cjne	a,#9+1,l?p1		; See If <= 9
l?p1		jc	l?p2			; Return Value, It's In Range
		subb	a,#7			; Make 00ah..00fh Range
l?p2		clr	c			; CY == 0 Means No Error
l?p3		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert ASCII Value In Acc To Binary.  Checks Value To See That It's 
;	Legal Decimal.  If Not, Return CY == 1, Else Return Converted Value 
;	In Acc, And CY == 0.
;
;  Entry Requirements:
;	Acc Has Character To Convert From ASCII Decimal To Binary
;
;  On Exit:
;	Acc Has Binary Value, Or Original Character If Not Legal ASCII Decimal
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_DECTOBIN	proc
		call	UTIL_VALDCDG		; See If Good Digit
		jc	l?p1			; If Not, Return CY == 1
		subb	a,#'0'                  ; Make 0..9 Range
		clr	c			; CY == 0 Means No Error
l?p1		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert BCD Value In Acc To Hex (i.e. 15h -> 00fh)
;
;  Entry Requirements:
;	Acc Has Value In BCD To Convert
;
;  On Exit:
;	Acc Has Entry Value Converted To Hex
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_BCDTOBIN	proc
		push	b			; Save B
		push	acc			; Save Value
		anl	a,#0f0h			; Keep High Bits
		swap	a			; Get To Low
		mov	b,#10			; 10 Decimal
		mul	ab			; Multiply
		mov	b,a			; Store In B
		pop	acc			; Recover BCD Value
		anl	a,#00fh			; Keep Low Nybble
		add	a,b			; Add In High
		pop	b			; Recover B
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert Base 36 Value In Acc To Hex (i.e. 'H' -> 011h)
;
;  Entry Requirements:
;	Acc Has Value In Base 36 (0..9, 'A'..'Z' (Case Significant)).  Values
;	None In Range Will Produce Inpredictable Results.
;
;  On Exit:
;	Acc Contains 0..35
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_ASC36TOBIN	proc
		cjge	a,#'G',l?p1		; If >= 'G', Special
		call	UTIL_HEXTOBIN		; Convert To Binary
		ret				; Return To Caller
;
l?p1		clr	c			; Clear For SUBB
		subb	a,#'G'-10h		; Make Binary
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert Value In Low 4 Bits Of Acc To A Hex Digit
;
;  Entry Requirements:
;	Low 4 Bits Of Acc Have Value To Convert To '0'..'9', 'A'..'Z'
;
;  On Exit:
;	Value Of Low 4 Bits In ASCII
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Near Trick From A Z80 Book Circa 1982.  Don't Know Who The Original
;	Author Is.
;
UTIL_BINTOASC	proc
		anl	a,#00fh 		; Keep Only Low Bits
		add	a,#090h 		; Add 144
		da	a			; Decimal Adjust
		addc	a,#040h 		; Add 64
		da	a			; Decimal Adjust
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert Value In Acc To Base 36 ASCII Character
;
;  Entry Requirements:
;	Acc Has Value To Convert.  Must Be 0..35 (0..23h)
;
;  On Exit:
;	Base 36 Value In ASCII
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Opposite Of UTIL_ASC36TOBIN
;
UTIL_BINTOASC36	proc
		cjge	a,#10h,l?p1		; If >= 0x10, Special
		add	a,#090h 		; Add 144
		da	a			; Decimal Adjust
		addc	a,#040h 		; Add 64
		da	a			; Decimal Adjust
		ret				; Return To Caller
;
l?p1		add	a,#'G'-10h		; Make 'G'..'Z'
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert Value In Acc From Hex To BCD.  
;
;  Entry Requirements:
;	Acc Has Value In Binary To Convert To BCD
;
;  On Exit:
;	Acc Has Entry Value Converted To BCD
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Values Greater Than 99 Will Not Work Properly.
;
UTIL_BINTOBCD	proc
		push	b			; Save B
		mov	b,#10			; Divide By 10
		div	ab			; Do Divide
		swap	a			; Move Result To High Of A
		orl	a,b			; OR In Remainder
		pop	b			; Recover B
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert Value In Acc From Hex To BCD.  
;
;  Entry Requirements:
;	Acc Has Value To Convert To BCD
;
;  On Exit:
;	DPTR Has Value Of Acc In BCD
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, DPTR
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Values Greater Than 255 Will Not Work Properly.  If Acc == 12, DPTR
;	== 0012.  If Acc = 255, DPTR = 0255.
;
UTIL_BINTOBCD12	proc
		push	b			; Save B
		push	acc			; Save Acc
		mov	b,#100			; Divide By 100
		div	ab			; Do Divide
		mov	dph,a			; Store In DPH
		pop	acc			; Recover Acc
		mov	b,#10			; Divide By 10
		div	ab			; Do Divide
		swap	a			; Move Result To High Of A
		orl	a,b			; OR In Remainder
		mov	dpl,a			; Move To DPL
		pop	b			; Recover B
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Convert 16 Bit Binary Value In DPTR To A Signed Decimal Number String.
;
;  Entry Requirements:
;	DPTR Has Value To Print As A Signed Decimal Number In External Memory
;
;  On Exit:
;	DPTR Points To Start Of Printable String
;
;  Affected:
;	PSW.Z, PSW.P, Acc
;
;  Stack:
;	11 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Buffer Is In External Memory, And Needs 7 Bytes (Sign, Plus 5 Digits
;	Plus ETX Terminator).  Buffer Is Defined At The End Of The File.
;	The Return String Is ETX Terminated.  Since Result Is Returned In
;	Buffer, It Will Need To Be Copied Or Saved If Additional Calls Are
;	Made, Since The Buffer Will Be Overwritten.
;
UTIL_BINTODEC	proc
		push	psw			; Save PSW
		push	0			; Save R0
		push	1			; Save R1
		push	2			; Save R2
		push	3			; Save R3
		push	4			; Save R4
		push	5			; Save R5
		push	6			; Save R6
		push	7			; Save R7
;
		mov	r6,dph			; Store High In R6
		mov	r7,dpl			; Store Low In R7
		mov	dptr,#X_BUFFER		; Point To Buffer
;
		mov	a,r6			; Get High Of Value
		jnb	acc.7,l?p1		; If <= 32767, Skip
		clr	c			; Clear For SUBB
		clr	a			; Clear For SUBB
		subb	a,r7			; Subtract Low
		mov	r7,a			; Move Back
		clr	a			; Clear For SUBB
		subb	a,r6			; Subtract High
		mov	r6,a			; Move Back
		mov	a,#'-'			; Number Is Negative
		movx	@dptr,a			; Store Sign
		inc	dptr			; Next Location
;
;  DPTR Contains Value From 0..32767. 
;
l?p1		mov	r0,#high 10000		; 10^5
		mov	r1,#low  10000		; 10^5
		clr	f0			; Haven't Stored Non-0 Value
;
;  R0/R1 Now Has Factor
;
l?p2		mov	r2,6			; Get Value To R2
		mov	r3,7			; Get Value To R3
		mov	r4,0			; Get Factor
		mov	r5,1			; Get Factor
		call	UTIL_UDIV		; Divide Value By Factor
		mov	r6,4			; Store Remainder High
		mov	r7,5			; Store Remainder Low
;
;  Quotient In R4/R5 Should Be In 0..9 Range.  If 0, Don't Store Unless We've
;  Stored A Previous Non-Zero Value
;
		mov	a,r3			; Get Low Of Quotient
		jnz	l?p3			; If Not 0, Store It
		jnb	f0,l?p4			; If No Non-0 Before, Don't Store
l?p3		setb	f0			; Non-0 Value
		call	UTIL_BINTOASC		; Make Printable
		movx	@dptr,a			; Store Character
		inc	dptr			; Next Location
;
;  Now Divide Factor By 10 For Next Time
;
l?p4		mov	r2,0			; Get Factor
		mov	r3,1			; Get Factor
		mov	r4,#high 10		; 10
		mov	r5,#low  10		; 10
		call	UTIL_UDIV		; Factor = Factor / 10
		mov	r0,2			; Update Factor High
		mov	r1,3			; Update Factor Low
;
		mov	a,r0			; Get Factor High
		orl	a,r1			; OR In Factor Low
		jnz	l?p2			; If Not 0, Repeat
;
;  Store The End Of String Marker And Print
;
		jb	f0,l?p5			; If We've Stored A Number, Skip
		mov	a,#'0'			; Put At Least 1 Zero
		movx	@dptr,a			; Store It
		inc	dptr			; Next Location
l?p5		mov	a,#ETX			; End Of String Marker
		movx	@dptr,a			; Store It
;
;  Now Return Pointer To Buffer
;
		mov	dptr,#X_BUFFER		; Point To Print Buffer
;
;  Recover Registers And Exit
;
		pop	7			; Recover R7
		pop	6			; Recover R6
		pop	5			; Recover R5
		pop	4			; Recover R4
		pop	3			; Recover R3
		pop	2			; Recover R2
		pop	1			; Recover R1
		pop	0			; Recover R0
		pop	psw			; Recover PSW
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
; 	Convert Hexadecimal Value In DPTR As A Unsigned Decimal Number.
;	Convert 16 Bit Binary Value In DPTR To An Unsigned Decimal Number 
;	String.
;
;  Entry Requirements:
;	DPTR Has Value To Print As An UnsSigned Decimal Number In External 
;	Memory
;
;  On Exit:
;	DPTR Points To Start Of Printable String
;
;  Affected:
;	PSW.Z, PSW.P, Acc
;
;  Stack:
;	11 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Buffer Is In External Memory, And Needs 7 Bytes (Sign, Plus 5 Digits
;	Plus ETX Terminator).  Buffer Is Defined At The End Of The File.
;	The Return String Is ETX Terminated.  Since Result Is Returned In
;	Buffer, It Will Need To Be Copied Or Saved If Additional Calls Are
;	Made, Since The Buffer Will Be Overwritten.
;
UTIL_BINTOUDEC	proc
		push	psw			; Save PSW
		push	0			; Save R0
		push	1			; Save R1
		push	2			; Save R2
		push	3			; Save R3
		push	4			; Save R4
		push	5			; Save R5
		push	6			; Save R6
		push	7			; Save R7
;
		mov	r6,dph			; Store High In R6
		mov	r7,dpl			; Store Low In R7
		mov	dptr,#X_BUFFER		; Point To Buffer
;
l?p1		mov	r0,#high 10000		; 10^5
		mov	r1,#low  10000		; 10^5
		clr	f0			; Haven't Stored Non-0 Value
;
;  R0/R1 Now Has Factor
;
l?p2		mov	r2,6			; Get Value To R2
		mov	r3,7			; Get Value To R3
		mov	r4,0			; Get Factor
		mov	r5,1			; Get Factor
		call	UTIL_UDIV		; Divide Value By Factor
		mov	r6,4			; Store Remainder High
		mov	r7,5			; Store Remainder Low
;
;  Quotient In R4/R5 Should Be In 0..9 Range.  If 0, Don't Store Unless We've
;  Stored A Previous Non-Zero Value
;
		mov	a,r3			; Get Low Of Quotient
		jnz	l?p3			; If Not 0, Store It
		jnb	f0,l?p4			; If No Non-0 Before, Don't Store
l?p3		setb	f0			; Non-0 Value
		call	UTIL_BINTOASC		; Make Printable
		movx	@dptr,a			; Store Character
		inc	dptr			; Next Location
;
;  Now Divide Factor By 10 For Next Time
;
l?p4		mov	r2,0			; Get Factor
		mov	r3,1			; Get Factor
		mov	r4,#high 10		; 10
		mov	r5,#low  10		; 10
		call	UTIL_UDIV		; Factor = Factor / 10
		mov	r0,2			; Update Factor High
		mov	r1,3			; Update Factor Low
;
		mov	a,r0			; Get Factor High
		orl	a,r1			; OR In Factor Low
		jnz	l?p2			; If Not 0, Repeat
;
;  Store The End Of String Marker And Print
;
		jb	f0,l?p5			; If We've Stored A Number, Skip
		mov	a,#'0'			; Put At Least 1 Zero
		movx	@dptr,a			; Store It
		inc	dptr			; Next Location
l?p5		mov	a,#ETX			; End Of String Marker
		movx	@dptr,a			; Store It
;
;  Now Return Pointer To Buffer
;
		mov	dptr,#X_BUFFER		; Point To Print Buffer
;
;  Recover Registers And Exit
;
		pop	7			; Recover R7
		pop	6			; Recover R6
		pop	5			; Recover R5
		pop	4			; Recover R4
		pop	3			; Recover R3
		pop	2			; Recover R2
		pop	1			; Recover R1
		pop	0			; Recover R0
		pop	psw			; Recover PSW
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Acc Contains An ASCII Value.  Determine If Valid Decimal DigitOr Not.
;	If Not, Return Acc Trashed, And CY == 1.  If Digit Is Valid, Return 
;	CY == 0.
;
;  Entry Requirements:
;	Acc Has ASCII Decimal Value To Validate
;
;  On Exit:
;	CY == 0 If Acc = '0'..'9', CY == 1 If Not
;
;  Affected:
;	PSW.CY
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_VALDCDG	proc
		call	UTIL_TOUPPER		; Make Upper Case
		cjlt	a,#'0',l?p1		; If < '0', Return CY == 1
		cjgt	a,#'9',l?p1		; If > '9', Return CY == 1
		clr	c			; CY == 0 Means Good Digit
		ret				; Return To Caller
;
l?p1		setb	c			; CY == 1 Means Bad Digit
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Acc Contains An ASCII Value.  Determine If Valid Hex Digit Or Not.
;	If Not, Return Acc Trashed, And CY == 1.  If Digit Is Valid, Return 
;	CY == 0.
;
;  Entry Requirements:
;	Acc Has ASCII Hex Value To Validate
;
;  On Exit:
;	CY == 0 If Acc = '0'..'9', 'a'..'f', 'A'..'F', CY == 1 If Not
;
;  Affected:
;	PSW.CY
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_VALHXDG	proc
		call	UTIL_TOUPPER		; Make Upper Case
		cjlt	a,#'0',l?p2		; If < '0', Return CY == 1
		cjle	a,#'9',l?p1		; If <= '9', Return CY == 0
		cjlt	a,#'A',l?p2		; If < 'A', Return CY == 1
		cjgt	a,#'F',l?p2		; If > 'F', Return CY == 1
;
l?p1		clr	c			; CY == 0 Means Good Digit
		ret				; Return To Caller
;
l?p2		setb	c			; CY == 1 Means Bad Digit
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Acc Has Character To Be Validate For A..Z, a..z, 0..9 Range.  
;
;  Entry Requirements:
;	Acc Has Character To Validate As A..Z, a..z, 0..9 Range
;
;  On Exit:
;	Return CY == 0 If Character In Range, Else Return CY == 1.
;
;  Affected:
;	PSW.CY
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_VALALPHA	proc
		call	UTIL_TOUPPER		; Make Upper Case
		cjlt	a,#'0',l?p2		; If < '0', Return CY == 1
		cjle	a,#'9',l?p1		; If <= '9', Return CY == 0
		cjlt	a,#'A',l?p2		; If < 'A', Return CY == 1
		cjgt	a,#'Z',l?p2		; If > 'Z', Return CY == 1
;
l?p1		clr	c			; CY == 0 Means Good Character
		ret				; Return To Caller
;
l?p2		setb	c			; CY == 1 Means Bad Character
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	DPTR Points To An ETX Terminated String In External Memory.  Verify 
;	That Characters In String Are A..Z, a..z, 0..9.  
;
;  Entry Requirements:
;	DPTR Points To An ETX Terminated String To Search
;
;  On Exit:
;	CY == 0 If No Other Characters, DPTR Points To ETX
;	CY == 1 If Non A..Z, a..z, 0..9 Characters, DPTR Points To Bad Character
;
;  Affected:
;	PSW.CY, DPTR
;
;  Stack:
;	3 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_VALALPHAZ	proc
		push	acc			; Save Acc
l?p1		movx	a,@dptr			; Get Character
		cjeq	a,#ETX,l?p2		; Exit Of End Of String (CY=0)
		call	UTIL_VALALPHA		; Validate Character
		jc	l?p2			; If Error, Exit
		inc	dptr			; Next Character
		jmp	l?p1			; Continue
l?p2		pop	acc			; Recover Acc
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	DPTR Points To An ETX Terminated String In External Memory.  Count 
;	The Number Of ASCII Digits In The String.  If The Number Of Digits 
;	Exceeds 255, Return CY == 1, Else Return Digit Count In Acc And 
;	CY == 0.  DPTR Is Modified.
;
;  Entry Requirements:
;	DPTR Points To ETX Terminated String In External Memory
;
;  On Exit:
;	CY == 0, Acc Has Number Of Digits ('0'..'9') Found
;	CY == 1, Number Of Digits Found Exceeds 255
;	DPTR Points To ETX
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, DPTR
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_CNTDG	proc
		push	0			; Save R0
		mov	r0,#0			; Clear Counter
l?p1		movx	a,@dptr			; Get Character
		cjeq	a,#ETX,l?p2		; Exit If End Of String
		inc	dptr			; Next Character
		cjlt	a,#'0',l?p1		; Skip If < '0'
		cjgt	a,#'9',l?p1		; Skip If > '9'
		inc	r0			; Increment Counter
		mov	a,r0			; Get Counter
		jnz	l?p1			; Repeat Count
		setb	c			; Too Many Digits
		pop	0			; Recover R0
		ret				; Return To Caller
;
l?p2		mov	a,r0			; Get Count To Acc
		clr	c			; Clear For No Error
		pop	0			; Recover R0
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Unsigned Divide Of R2/3 By R4/5
;
;  Entry Requirements:
;	Divisor In R4/5
;	Dividend In R2/3
;
;  On Exit:
;	Quotient In R2/3
;	Remainder In R4/5
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, B, R2, R3, R4, R5
;
;  Stack:
;	4 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_UDIV	proc
		push	0			; Save R0
		push	1			; Save R1
		call	DIVIDE			; Divide
		pop	1			; Recover R1
		pop	0			; Recover R0
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Unsigned Modulus Of R2/3 By R4/5
;
;  Entry Requirements:
;	Divisor In R4/5
;	Dividend In R2/3
;
;  On Exit:
;	Remainder In R4/5, R2/3
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, B, R2, R3, R4, R5
;
;  Stack:
;	4 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_UMOD	proc
		push	0			; Save R0
		push	1			; Save R1
		call	DIVIDE			; Divide
		pop	1			; Recover R1
		pop	0			; Recover R0
		mov	2,r4			; Get Remainder High To R2
		mov	3,r5			; Get Remainder Low To R2
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Signed Modulus Of R2/3 By R4/5
;
;  Entry Requirements:
;	Divisor In R4/5
;	Dividend In R2/3
;
;  On Exit:
;	Remainder In R2/3
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, B, R2, R3, R4, R5
;
;  Stack:
;	4 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Swiped From A Now Defunct 'C' Compiler
;
UTIL_MOD	proc
		push	0
		push	1
		mov	a,r4
		xrl	a,r2
		push	acc
		call	NEGEM
		call	DIVIDE
		mov	2,r4
		mov	3,r5
		pop	acc
		jnb	acc.7,l?p1
		clr	a
		clr	c
		subb	a,r3
		mov	r3,a
		clr	a
		subb	a,r2
		mov	r2,a
l?p1		pop	1
		pop	0
		ret
		endproc
;
;****************************************************************************
;
;  Description:
;	Signed Divide Of R2/3 By R4/5
;
;  Entry Requirements:
;	Divisor In R4/5
;	Dividend In R2/3
;
;  On Exit:
;	Quotient In R2/3
;	Remainder In R4/5
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, B, R2, R3, R4, R5
;
;  Stack:
;	5 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Swiped From A Now Defunct 'C' Compiler
;
UTIL_DIV	proc
		push	0
		push	1
		mov	a,r4
		xrl	a,r2
		push	acc
		call	NEGEM
		call	DIVIDE
		pop	acc
		jnb	acc.7,l?p1
		clr	a
		clr	c
		subb	a,r3
		mov	r3,a
		clr	a
		subb	a,r2
		mov	r2,a
l?p1		pop	1
		pop	0
		ret				; done!
		endproc
;
;****************************************************************************
;
;  Description:
;	Does Sign Fixup For Divide
;
;  Entry Requirements:
;	Divisor In R4/5
;	Dividend In R2/3
;
;  On Exit:
;	Divisor In R4/5, Sign Normalized
;	Dividend In R2/3, Sign Normalized
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, R2, R3, R4, R5
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Swiped From A Now Defunct 'C' Compiler
;
NEGEM		proc
		mov	a,r2
		jnb	acc.7,l?p1
		clr	a
		clr	c
		subb	a,r3
		mov	r3,a
		clr	a
		subb	a,r2
		mov	r2,a
;
l?p1		mov	a,r4
		jnb	acc.7,l?p2
		clr	a
		clr	c
		subb	a,r5
		mov	r5,a
		clr	a
		subb	a,r4
		mov	r4,a
l?p2		ret
		endproc
;
;****************************************************************************
;
;  Description:
;	Unsigned Divide Of R2/3 By R4/5
;
;  Entry Requirements:
;	Divisor In R4/5
;	Dividend In R2/3
;
;  On Exit:
;	Quotient In R2/3
;	Remainder In R4/5
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, B, R0, R1, R2, R3, R4, R5
;
;  Stack:
;	X Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	Swiped From A Now Defunct 'C' Compiler
;
DIVIDE		proc
		clr	a
		mov	b,a			; initialize count
		mov	r0,a			; zero quotient
		mov	r1,a
		mov	a,r2			; check for zero dividend
		orl	a,r3
		jz	l?p8
		mov	a,r4			; check for zero divisor
		orl	a,r5
		jnz	l?p3
		ret
;
l?p1		mov	a,r2
		clr	c
		subb	a,r4			; is divisor greater than dividend yet
		jc	l?p4			; yes, go no further
		jnz	l?p2
		mov	a,r3
		subb	a,r5
		jc	l?p4
;
l?p2		mov	a,r5			; shift divisor up one bit
		clr	c
		rlc	a
		mov	r5,a
		mov	a,r4
		rlc	a
		mov	r4,a
;
l?p3		inc	b			; increment count
		mov	a,r4			; check for safe to shift some more
		jnb	acc.7,l?p1		; loop if top bit clear
;
l?p4		mov	a,r2
		clr	c
		subb	a,r4			; is divisor greater than dividend
		jc	l?p5	
		jnz	l?p6
		mov	a,r3
		subb	a,r5
		jnc	l?p6
;
l?p5		clr	c
		sjmp	l?p7
;
l?p6		clr	c			; subtract divisor from dividend
		mov	a,r3
		subb	a,r5
		mov	r3,a
		mov	a,r2
		subb	a,r4
		mov	r2,a
		setb	c			; now set bit for quotient
;
l?p7		mov	a,r1
		rlc	a
		mov	r1,a
		mov	a,r0
		rlc	a
		mov	r0,a

		mov	a,r4			; shift divisor down
		clr	c
		rrc	a
		mov	r4,a
		mov	a,r5
		rrc	a
		mov	r5,a
		djnz	b,l?p4			; and continue with the rest
;
l?p8		mov	5,r3
		mov	4,r2
		mov	2,r0
		mov	3,r1
		ret
		endproc
;
;****************************************************************************
;
;  Description:
;	Copy String From External Memory To Internal Memory
;
;  Entry Requirements:
;	DPTR Points To Source In External Memory
;	R1 Points To Destination In Internal Memory
;	R0 Contains Number Of Bytes To Copy
;
;  On Exit:
;	DPTR = Points To End Of Source + 1
;	R1 Points To End Of Destination + 1
;	R0 = 0
;
;  Affected:
;	PSW.Z, PSW.P, Acc, R0, R1, DPTR
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_COPYXTOI	proc
l?p1		movx	a,@dptr			; Get Source Byte
		mov	@r1,a			; Store To Destination
		inc	dptr			; Next Source Byte
		inc	r1			; Next Destination Byte
		djnz	r0,l?p1			; Do For R0 Bytes
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Copy Bytes From Internal Memory To External Memory
;
;  Entry Requirements:
;	DPTR Points To Destination In External Memory
;	R1 Points To Source In Internal Memory
;	R0 Contains Number Of Bytes To Copy
;
;  On Exit:
;	DPTR = Points To End Of Destination + 1
;	R1 Points To End Of Source + 1
;	R0 = 0
;
;  Affected:
;	PSW.Z, PSW.P, Acc, R0, R1, DPTR
;
;  Stack:
;	0 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_COPYITOX	proc
l?p1		mov	a,@r1			; Get Source Byte
		movx	@dptr,a			; Store To Destination
		inc	r1			; Next Source Byte
		inc	dptr			; Next Destination Byte
		djnz	r0,l?p1			; Do For R0 Bytes
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Copy Bytes From Code Memory To External Memory
;
;  Entry Requirements:
;	DPTR Points To Destination In External Memory
;	R6/7 Points To Source In Code Memory
;	R0/1 Contains The Length
;
;  On Exit:
;	DPTR = Points To End Of Destination + 1
;	R6/7 = Points To End Of Source + 1
;	R0/1 = 0
;
;  Affected:
;	PSW.Z, PSW.P, Acc, DPTR, R0, R1, R6, R7
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_COPYCTODL	proc
		call	UTIL_DPTRR01		; DPTR=Len, R01=Src
		call	UTIL_DPTR2C		; 2's Complement
		call	UTIL_DPTRR01		; DPTR=Src, R01=Len
;
l?p1		call	UTIL_DPTRR67		; DPTR=Src, R67=Dest
		clr	a			; Clear For MOVC
		movc	a,@a+dptr		; Get Character
		inc	dptr			; Next Source Location
		call	UTIL_DPTRR67		; DPTR=Dest, R67=Src
		movx	@dptr,a			; Store It
		inc	dptr			; Next Destination Location
		call	UTIL_DPTRR01		; DPTR=Len, R01=Dest
		inc	dptr			; Increment Length
		mov	a,dph			; Get High
		orl	a,dpl			; OR In Low
		call	UTIL_DPTRR01		; DPTR=Dest, R01=Len
		jnz	l?p1			; Repeat Until 0
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Copies ETX Terminated String From Code Memory To External Memory.
;	ETX Is Copied.
;
;  Entry Requirements:
;	DPTR Points To Destination In External Memory
;	R6/7 Points To Source In Code Memory
;
;  On Exit:
;	DPTR = Points To Source ETX + 1
;	R6/7 = Points To Destination ETX + 1
;
;  Affected:
;	PSW.Z, PSW.P, Acc, DPTR, R6, R7
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_COPYCTODZ	proc
l?p1		call	UTIL_DPTRR67		; DPTR=Src, R67=Dest
		clr	a			; Clear For MOVC
		movc	a,@a+dptr		; Get Character
		inc	dptr			; Next Source Location
		call	UTIL_DPTRR67		; DPTR=Dest, R67=Src
		movx	@dptr,a			; Store It
		inc	dptr			; Next Destination Location
		cjne	a,#ETX,l?p1		; If ETX, Exit Copy
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Copy Bytes From External Memory To External Memory
;
;  Entry Requirements:
;	DPTR Points To Destination In External Memory
;	R6/7 Points To Source In External Memory
;	R0/1 Contains The Length
;
;  On Exit:
;	DPTR = Points To End Of Destination + 1
;	R6/7 = Points To End Of Source + 1
;	R0/1 = 0
;
;  Affected:
;	PSW.Z, PSW.P, Acc, DPTR, R0, R1, R6, R7
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_COPYDTODL	proc
		call	UTIL_DPTRR01		; DPTR=Len, R01=Src
		call	UTIL_DPTR2C		; 2's Complement
		call	UTIL_DPTRR01		; DPTR=Src, R01=Len
;
l?p1		call	UTIL_DPTRR67		; DPTR=Src, R67=Dest
		movx	a,@dptr			; Get Character
		inc	dptr			; Next Source Location
		call	UTIL_DPTRR67		; DPTR=Dest, R67=Src
		movx	@dptr,a			; Store It
		inc	dptr			; Next Destination Location
		call	UTIL_DPTRR01		; DPTR=Len, R01=Dest
		inc	dptr			; Increment Length
		mov	a,dph			; Get High
		orl	a,dpl			; OR In Low
		call	UTIL_DPTRR01		; DPTR=Dest, R01=Len
		jnz	l?p1			; Repeat Until 0
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Copies ETX Terminated String From External Memory To External Memory.
;	ETX Is Copied.
;
;  Entry Requirements:
;	DPTR Points To Destination In External Memory
;	R6/7 Points To Source In Code Memory
;
;  On Exit:
;	DPTR = Points To Source ETX + 1
;	R6/7 = Points To Destination ETX + 1
;
;  Affected:
;	PSW.Z, PSW.P, Acc, DPTR, R6, R7
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_COPYDTODZ	proc
l?p1		call	UTIL_DPTRR67		; DPTR=Src, R67=Dest
		movx	a,@dptr			; Get Character
		inc	dptr			; Next Source Location
		call	UTIL_DPTRR67		; DPTR=Dest, R67=Src
		movx	@dptr,a			; Store It
		inc	dptr			; Next Destination Location
		cjne	a,#ETX,l?p1		; If ETX, Exit Copy
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Search Data Memory DPTR Points To Until A 0x00 Is Found, Or R0 Is 0,
;	And Replace With An ETX.  DPTR Points To Data, R0 Contains Maximum 
;	Length To Search
;
;  Entry Requirements:
;	DPTR Points To A 0 Terminated String In External Memory
;	R0 Contains Maximum Length To Search
;
;  On Exit:
;	R0 = 0
;
;  Affected:
;	PSW.Z, PSW.P, Acc, DPTR, R0
;
;  Stack:
;	2 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_PUT_ETX	proc
		push	dph			; Save DPH
		push	dpl			; Save DPL
;
l?p1		movx	a,@dptr			; Get Character
		jz	l?p2			; If 0, Replace And Exit
		inc	dptr			; Next Location
		djnz	r0,l?p1			; Repeat For R0 Bytes
;
l?p2		mov	a,#ETX			; ETX Character
		movx	@dptr,a			; Store It
;
		pop	dpl			; Recover DPL
		pop	dph			; Recover DPH
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	If An ETX Is Found, Return With DPTR Pointing To It, And CY == 0.  If 
;	No ETX Found, Return DPTR Pointing At One Byte Past End, And CY == 1.
;
;  Entry Requirements:
;	DPTR Points To External Memory
;	R0 Contains Maximum Length To Search
;
;  On Exit:
;	CY == 0 Indicates ETX Found, DPTR Points To ETX
;	CY == 1 Indicated ETX Not Found, DPTR = DPTR + R0
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc, DPTR, R0
;
;  Stack:
;	1 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	None
;
UTIL_FIND_ETX	proc
		push	0			; Save R0
;
l?p1		movx	a,@dptr			; Get Character
		cjeq	a,#ETX,l?p2		; If ETX, Skip
		inc	dptr			; Next Location
		djnz	r0,l?p1			; Repeat Up To R0
;
		pop	0			; Recover R0
		setb	c			; ETX Not Found
		ret				; Return To Caller
;
l?p2		pop	0			; Recover R0
		clr	c			; ETX Found
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	Removes Trailing Spaces From A String In External Memory That Is
;	<= R0 In Length By Placing An ETX Character At The First Non-Space
;	Character From The End.
;
;  Entry Requirements:
;	DPTR Points To String In External Memory
;	R0 Contains Index Into String To Start Search From
;
;  On Exit:
;	DPTR Points To Location ETX Stored To
;	Acc = ETX
;
;  Affected:
;	PSW.Z, PSW.P, Acc, DPTR
;
;  Stack:
;	5 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	If No Spaces Are Found, An ETX Is Stored To The First Position In
;	The String.
;
UTIL_TRIM	proc
		push	0			; Save R0
		push	dph			; Save DPH
		push	dpl			; Save DPL
;
		mov	a,r0			; Get Length To Acc
		dec	a			; Make 0 Based, Not 1
		call	UTIL_ADCAD		; Point To Last Byte
l?p1		movx	a,@dptr			; Get Character From Buffer
		cjne	a,#SPACE,l?p2		; If Not Space, Exit
		call	UTIL_DPTRDEC		; Next Location Back
		djnz	r0,l?p1			; Repeat R0 Times
;
		pop	dpl			; Recover Buffer Start Low
		pop	dph			; Recover Buffer Start High
		mov	a,#ETX			; ETX Character
		movx	@dptr,a			; Store Terminator
		pop	0			; Recover R0
		ret				; Return To Caller
;
;  Now Get The Modem Index Number From The Modem Buffer, And Append It
;
l?p2		inc	dptr			; 1st Char Past Non-Space
		mov	a,#ETX			; ETX Character
		movx	@dptr,a			; Store Terminator
;
		pop	dpl			; Recover DPL
		pop	dph			; Recover DPH
		pop	0			; Recover R0
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Description:
;	DPTR Points To A String In External RAM To Determine The Length Of.  
;	The String Must Be 0 Terminated, And Less Than 256 Bytes In Length.  
;	The Length Is Returned In Acc.
;
;  Entry Requirements:
;	DPTR Points To An ETX Terminated String In External Memory
;
;  On Exit:
;	DPTR Points To ETX
;	Acc Has Length Of String
;
;  Affected:
;	PSW.CY, PSW.Z, PSW.P, Acc
;
;  Stack:
;	3 Bytes, Not Including Space Used By Called Routines
;
;  Comments:
;	If String Is Longer Than 255 Bytes, Acc Will Report Length Mod 256
;
UTIL_STRLEN	proc
		push	b			; Save B
		push	dph			; Save DPH
		push	dpl			; Save DPL
		mov	b,#0			; Clear Length Counter
;
l?p1		movx	a,@dptr			; Get Byte
		cjeq	a,#ETX,l?p2		; If ETX, End Found
		inc	dptr			; Next Location
		inc	b			; Increment Length
		jmp	l?p1			; Repeat Until 0x00
;
l?p2		mov	a,b			; Get Length To A
		pop	dpl			; Recover DPL
		pop	dph			; Recover DPH
		pop	b			; Recover B
		ret				; Return To Caller
		endproc
;
;****************************************************************************
;
;  Data Area
;
		seg	xdata
X_BUFFER	ds	7
;
;****************************************************************************
;
		end
