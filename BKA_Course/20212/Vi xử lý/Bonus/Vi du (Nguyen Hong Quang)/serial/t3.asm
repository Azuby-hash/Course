	org 	00h
	mov 	tmod, #20h
	mov	th1, #0fdh
	
	mov 	scon, #50h
	mov 	tcon, #40h
	
	mov 	r0, #60h

lup:	acall 	getch
	mov 	@r0,a
	inc	r0
	clr	c
	subb	a,#32
	acall	putch
	sjmp	lup

getch:	jnb	ri,getch
	mov	a,sbuf
	clr	ri
	ret

putch:	clr	ti
	mov	sbuf,a
gone:	jnb	ti, gone
	ret
	end	
