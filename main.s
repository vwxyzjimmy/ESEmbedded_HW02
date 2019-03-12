.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	nop

	//
	//branch w/o link
	//
	movs	r1, #1
	movs	r2, #2
	movs	r3, #3

	push	{r1, r2, r3}
	pop		{r4, r5, r6}

	movs	r4, #0
	movs	r5, #0
	movs	r6, #0

	push	{r3, r2, r1}
	pop		{r4, r5, r6}

	movs	r4, #0
	movs	r5, #0
	movs	r6, #0

	push	{r1, r2, r3}
	pop		{r6, r5, r4}
	b	label01

label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.
