/*********************************************************************/
/*                                                                   */
/*             Optimized BLAS libraries                              */
/*                     By Kazushige Goto <kgoto@tacc.utexas.edu>     */
/*                                                                   */
/* Copyright (c) The University of Texas, 2009. All rights reserved. */
/* UNIVERSITY EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES CONCERNING  */
/* THIS SOFTWARE AND DOCUMENTATION, INCLUDING ANY WARRANTIES OF      */
/* MERCHANTABILITY, FITNESS FOR ANY PARTICULAR PURPOSE,              */
/* NON-INFRINGEMENT AND WARRANTIES OF PERFORMANCE, AND ANY WARRANTY  */
/* THAT MIGHT OTHERWISE ARISE FROM COURSE OF DEALING OR USAGE OF     */
/* TRADE. NO WARRANTY IS EITHER EXPRESS OR IMPLIED WITH RESPECT TO   */
/* THE USE OF THE SOFTWARE OR DOCUMENTATION.                         */
/* Under no circumstances shall University be liable for incidental, */
/* special, indirect, direct or consequential damages or loss of     */
/* profits, interruption of business, or related expenses which may  */
/* arise from use of Software or Documentation, including but not    */
/* limited to those resulting from defects in Software and/or        */
/* Documentation, or loss or inaccuracy of data of any kind.         */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"

#ifndef WINDOWS_ABI
#define M	ARG1
#define X	ARG4
#define INCX	ARG5
#define Y	ARG6
#define INCY	ARG2
#else
#define M	ARG1
#define X	ARG2
#define INCX	ARG3
#define Y	ARG4
#define INCY	%rbx
#endif

#include "l1param.h"

	PROLOGUE
	PROFCODE

#ifndef WINDOWS_ABI
	movq	8(%rsp), INCY
#else
	pushq	%rbx

	movq	48(%rsp), X
	movq	56(%rsp), INCX
	movq	64(%rsp), Y
	movq	72(%rsp), INCY
#endif

	SAVEREGISTERS

	leaq	(, INCX, SIZE), INCX
	leaq	(, INCY, SIZE), INCY

	cmpq	$SIZE, INCX
	jne	.L40
	cmpq	$SIZE, INCY
	jne	.L40

	testq	$SIZE, Y
	je	.L10

	movsd	0 * SIZE(X), %xmm0
	movsd	0 * SIZE(Y), %xmm8

	movsd	%xmm8, 0 * SIZE(X)
	movsd	%xmm0, 0 * SIZE(Y)

	addq	$1 * SIZE, X
	addq	$1 * SIZE, Y
	decq	M
	jle	.L19
	ALIGN_4

.L10:
	subq	$-16 * SIZE, X
	subq	$-16 * SIZE, Y
	
	testq	$SIZE, X
	jne	.L20

	movq	M,  %rax
	sarq	$4, %rax
	jle	.L13
	ALIGN_3

.L11:
#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(X)
#endif

	movaps	-16 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-16 * SIZE(Y)
	movaps	%xmm1, 	-16 * SIZE(X)

	movaps	-14 * SIZE(X), %xmm0
	movaps	-14 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-14 * SIZE(Y)
	movaps	%xmm1, 	-14 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(Y)
#endif

	movaps	-12 * SIZE(X), %xmm0
	movaps	-12 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-12 * SIZE(Y)
	movaps	%xmm1, 	-12 * SIZE(X)

	movaps	-10 * SIZE(X), %xmm0
	movaps	-10 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-10 * SIZE(Y)
	movaps	%xmm1, 	-10 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(X)
#endif

	movaps	 -8 * SIZE(X), %xmm0
	movaps	 -8 * SIZE(Y), %xmm1

	movaps	%xmm0, 	 -8 * SIZE(Y)
	movaps	%xmm1, 	 -8 * SIZE(X)

	movaps	 -6 * SIZE(X), %xmm0
	movaps	 -6 * SIZE(Y), %xmm1

	movaps	%xmm0, 	 -6 * SIZE(Y)
	movaps	%xmm1, 	 -6 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(Y)
#endif

	movaps	 -4 * SIZE(X), %xmm0
	movaps	 -4 * SIZE(Y), %xmm1

	movaps	%xmm0, 	 -4 * SIZE(Y)
	movaps	%xmm1, 	 -4 * SIZE(X)

	movaps	 -2 * SIZE(X), %xmm0
	movaps	 -2 * SIZE(Y), %xmm1

	movaps	%xmm0, 	 -2 * SIZE(Y)
	movaps	%xmm1, 	 -2 * SIZE(X)

	subq	$-16 * SIZE, Y
	subq	$-16 * SIZE, X

	decq	%rax
	jg	.L11
	ALIGN_3

.L13:
	testq	$8, M
	jle	.L14

	movaps	-16 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-16 * SIZE(Y)
	movaps	%xmm1, 	-16 * SIZE(X)

	movaps	-14 * SIZE(X), %xmm0
	movaps	-14 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-14 * SIZE(Y)
	movaps	%xmm1, 	-14 * SIZE(X)

	movaps	-12 * SIZE(X), %xmm0
	movaps	-12 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-12 * SIZE(Y)
	movaps	%xmm1, 	-12 * SIZE(X)

	movaps	-10 * SIZE(X), %xmm0
	movaps	-10 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-10 * SIZE(Y)
 	movaps	%xmm1, 	-10 * SIZE(X)

	addq	$8 * SIZE, X
	addq	$8 * SIZE, Y
	ALIGN_3

.L14:
	testq	$4, M
	jle	.L15

	movaps	-16 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-16 * SIZE(Y)
	movaps	%xmm1, 	-16 * SIZE(X)

	movaps	-14 * SIZE(X), %xmm0
	movaps	-14 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-14 * SIZE(Y)
	movaps	%xmm1, 	-14 * SIZE(X)

	addq	$4 * SIZE, X
	addq	$4 * SIZE, Y
	ALIGN_3

.L15:
	testq	$2, M
	jle	.L16

	movaps	-16 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-16 * SIZE(Y)
	movaps	%xmm1, 	-16 * SIZE(X)

	addq	$2 * SIZE, X
	addq	$2 * SIZE, Y
	ALIGN_3

.L16:
	testq	$1, M
	jle	.L19

	movsd	-16 * SIZE(X), %xmm0
	movsd	-16 * SIZE(Y), %xmm1

	movlps	%xmm1, 	-16 * SIZE(X)
	movlps	%xmm0, 	-16 * SIZE(Y)
	ALIGN_3

.L19:
	xorq	%rax,%rax

	RESTOREREGISTERS

#ifdef WINDOWS_ABI
	popq	%rbx
#endif

	ret
	ALIGN_3

.L20:
	movhps	 -16 * SIZE(X), %xmm0
	movaps	 -16 * SIZE(Y), %xmm1

	movlps	%xmm1, -16 * SIZE(X)
	decq	M
	jle	.L29

	movq	M,  %rax
	sarq	$4, %rax
	jle	.L23
	ALIGN_4

.L21:
#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(X)
#endif

	movaps	-15 * SIZE(X), %xmm2
	movaps	-14 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -16 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -15 * SIZE(X)

	movaps	-13 * SIZE(X), %xmm0
	movaps	-12 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -14 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -13 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(Y)
#endif

	movaps	-11 * SIZE(X), %xmm2
	movaps	-10 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -12 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -11 * SIZE(X)

	movaps	 -9 * SIZE(X), %xmm0
	movaps	 -8 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -10 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3,  -9 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(X)
#endif

	movaps	 -7 * SIZE(X), %xmm2
	movaps	 -6 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0,  -8 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1,  -7 * SIZE(X)

	movaps	 -5 * SIZE(X), %xmm0
	movaps	 -4 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2,  -6 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3,  -5 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(Y)
#endif

	movaps	 -3 * SIZE(X), %xmm2
	movaps	 -2 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0,  -4 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1,  -3 * SIZE(X)

	movaps	 -1 * SIZE(X), %xmm0
	movaps	  0 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2,  -2 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3,  -1 * SIZE(X)

	subq	$-16 * SIZE, X
	subq	$-16 * SIZE, Y

	decq	%rax
	jg	.L21
	ALIGN_3

.L23:
	testq	$8, M
	jle	.L24

	movaps	-15 * SIZE(X), %xmm2
	movaps	-14 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -16 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -15 * SIZE(X)

	movaps	-13 * SIZE(X), %xmm0
	movaps	-12 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -14 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -13 * SIZE(X)

	movaps	-11 * SIZE(X), %xmm2
	movaps	-10 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -12 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -11 * SIZE(X)

	movaps	 -9 * SIZE(X), %xmm0
	movaps	 -8 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -10 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3,  -9 * SIZE(X)

	addq	$8 * SIZE, X
	addq	$8 * SIZE, Y
	ALIGN_3

.L24:
	testq	$4, M
	jle	.L25

	movaps	-15 * SIZE(X), %xmm2
	movaps	-14 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -16 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -15 * SIZE(X)

	movaps	-13 * SIZE(X), %xmm0
	movaps	-12 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -14 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -13 * SIZE(X)

	addq	$4 * SIZE, X
	addq	$4 * SIZE, Y
	ALIGN_3

.L25:
	testq	$2, M
	jle	.L26

	movaps	-15 * SIZE(X), %xmm2
	movaps	-14 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -15 * SIZE(X)
	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -16 * SIZE(Y)

	movaps	%xmm2, %xmm0
	movaps	%xmm3, %xmm1

	addq	$2 * SIZE, X
	addq	$2 * SIZE, Y
	ALIGN_3

.L26:
	testq	$1, M
	jle	.L29

	movhps	%xmm0, -16 * SIZE(Y)
	movhps	-15 * SIZE(X), %xmm0
	movhps	%xmm1, -15 * SIZE(X)

	addq	$SIZE, X
	addq	$SIZE, Y
	ALIGN_3

.L29:
	movhps	%xmm0, -16 * SIZE(Y)

	xorq	%rax,%rax

	RESTOREREGISTERS

#ifdef WINDOWS_ABI
	popq	%rbx
#endif

	ret
	ALIGN_3

.L40:
	movq	M,  %rax
	sarq	$3, %rax
	jle	.L45
	ALIGN_3

.L41:
	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	addq	INCX, X
	movsd	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	addq	INCX, X
	movsd	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	addq	INCX, X
	movsd	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	addq	INCX, X
	movsd	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	addq	INCX, X
	movsd	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	addq	INCX, X
	movsd	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	addq	INCX, X
	movsd	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	addq	INCX, X
	movsd	%xmm0, (Y)
	addq	INCY, Y

	decq	%rax
	jg	.L41
	ALIGN_3

.L45:
	movq	M,  %rax
	andq	$7, %rax
	jle	.L47
	ALIGN_3

.L46:
	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movsd	%xmm1, (X)
	movsd	%xmm0, (Y)

	addq	INCX, X
	addq	INCY, Y
	decq	%rax
	jg	.L46
	ALIGN_3

.L47:
	xorq	%rax, %rax

	RESTOREREGISTERS

#ifdef WINDOWS_ABI
	popq	%rbx
#endif

	ret

	EPILOGUE
