	.file	"boids-flocks.adb"
	.text
	.section	.rodata
.LC5:
	.ascii	"boids-flocks.ads"
	.zero	1
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC6:
	.string	"failed precondition from boids-flocks.adb:37"
	.section	.rodata
.LC7:
	.ascii	"boids-flocks.adb"
	.zero	1
	.section	.rodata.str1.8
	.align 8
.LC8:
	.string	"failed postcondition from boids-flocks.adb:38"
	.section	.rodata
	.align 8
.LC2:
	.long	1
	.long	44
	.align 8
.LC3:
	.long	1
	.long	45
	.text
	.align 2
	.p2align 4
	.type	boids__flocks__steer, @function
boids__flocks__steer:
.LFB19:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%r8, %rbx
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	(%rdi), %r8d
	cmpl	$2000, %r8d
	ja	.L18
	movq	72(%rdi), %r15
	movq	%rdi, %rbp
	cmpq	64(%rdi), %r15
	movq	%rdx, %r13
	setge	%al
	movq	24(%rdi), %rdi
	cmpq	%rdi, 32(%rbp)
	movl	%esi, %r12d
	setle	%dl
	movq	%rcx, %r14
	andl	%edx, %eax
	movl	%eax, %esi
	testl	%r8d, %r8d
	jne	.L19
.L3:
	movl	%esi, %eax
	xorl	$1, %eax
	cmpl	%r8d, %r12d
	jg	.L4
	testb	%al, %al
	jne	.L4
	movq	%r13, %rax
	movq	%r14, %rdx
	xorl	%esi, %esi
	imulq	%r13, %rax
	imulq	%r14, %rdx
	addq	%rdx, %rax
	movq	%rax, %rdi
	jne	.L20
.L9:
	movslq	%r12d, %rcx
	movq	%rdi, %rax
	movq	$-16777216, %rdi
	movq	80(%rbp), %rdx
	movabsq	$-6640827866535438581, %r12
	addq	$2, %rcx
	salq	$5, %rcx
	addq	%rbp, %rcx
	subq	8(%rcx), %rax
	cmpq	%rdi, %rax
	cmovl	%rdi, %rax
	movl	$16777216, %edi
	cmpq	%rdi, %rax
	cmovg	%rdi, %rax
	subq	16(%rcx), %rsi
	movq	$-16777216, %rcx
	cmpq	%rcx, %rsi
	cmovl	%rcx, %rsi
	movl	$16777216, %ecx
	movq	%rax, %rdi
	cmpq	%rcx, %rsi
	cmovg	%rcx, %rsi
	call	boids__limit@PLT
	imulq	%rbx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	imulq	%r12
	movq	$-16777216, %rax
	leaq	(%rdx,%rdi), %rcx
	sarq	$63, %rdi
	sarq	$6, %rcx
	subq	%rdi, %rcx
	cmpq	%rax, %rcx
	cmovl	%rax, %rcx
	movl	$16777216, %eax
	cmpq	%rax, %rcx
	cmovg	%rax, %rcx
	imulq	%rbx, %rsi
	movq	%rsi, %rax
	imulq	%r12
	movq	$-16777216, %rax
	addq	%rsi, %rdx
	sarq	$63, %rsi
	sarq	$6, %rdx
	subq	%rsi, %rdx
	movq	%rcx, %rsi
	movq	80(%rbp), %rcx
	cmpq	%rax, %rdx
	cmovl	%rax, %rdx
	movl	$16777216, %eax
	cmpq	%rax, %rdx
	cmovg	%rax, %rdx
	imulq	%rbx, %rcx
	movq	%rdx, %rdi
	movq	%rcx, %rax
	imulq	%r12
	movq	%rsi, %rax
	movq	%rdi, %rsi
	movq	%rax, %rdi
	addq	%rcx, %rdx
	sarq	$63, %rcx
	sarq	$6, %rdx
	subq	%rcx, %rdx
	call	boids__limit@PLT
	imulq	80(%rbp), %rbx
	movq	%rax, %rsi
	movq	%rdx, %rcx
	movq	%rcx, %rdi
	movq	%rbx, %rax
	imulq	%rcx, %rdi
	imulq	%r12
	movq	%rsi, %rax
	imulq	%rsi, %rax
	addq	%rbx, %rdx
	sarq	$63, %rbx
	sarq	$6, %rdx
	addq	%rdi, %rax
	subq	%rbx, %rdx
	imulq	%rdx, %rdx
	cmpq	%rax, %rdx
	jl	.L21
	movq	%rsi, %rax
	movq	%rcx, %rdx
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L19:
	.cfi_restore_state
	movq	8(%rbp), %rdi
	movq	16(%rbp), %r9
	leal	1(%r8), %r10d
	movl	$1, %ecx
	.p2align 4
	.p2align 3
.L5:
	movq	%rcx, %rdx
	salq	$5, %rdx
	addq	%rbp, %rdx
	movq	64(%rdx), %rax
	cmpq	%rdi, 56(%rdx)
	jge	.L4
	cmpq	%r9, %rax
	jge	.L4
	addq	$1, %rcx
	cmpq	%r10, %rcx
	jne	.L5
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L20:
	movq	%rax, 8(%rsp)
	call	boids__isqrt@PLT
	movq	8(%rsp), %rdi
	addq	$1, %rax
	movq	%rax, (%rsp)
	je	.L22
	call	boids__isqrt@PLT
	addq	$1, %rax
	movq	%rax, %rcx
	je	.L23
	movq	%r13, %rax
	movq	$-16777216, %rdi
	movq	$-16777216, %rsi
	imulq	%r15, %rax
	cqto
	idivq	(%rsp)
	cmpq	%rdi, %rax
	cmovge	%rax, %rdi
	movl	$16777216, %eax
	cmpq	%rax, %rdi
	cmovg	%rax, %rdi
	movq	%r15, %rax
	imulq	%r14, %rax
	cqto
	idivq	%rcx
	cmpq	%rsi, %rax
	cmovge	%rax, %rsi
	movl	$16777216, %eax
	cmpq	%rax, %rsi
	cmovg	%rax, %rsi
	jmp	.L9
.L4:
	leaq	.LC6(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L18:
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L21:
	leaq	.LC8(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L22:
	movl	$30, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Divide_By_Zero@PLT
.L23:
	movl	$31, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Divide_By_Zero@PLT
	.cfi_endproc
.LFE19:
	.size	boids__flocks__steer, .-boids__flocks__steer
	.align 2
	.p2align 4
	.globl	boids__flocks__paramsIP
	.type	boids__flocks__paramsIP, @function
boids__flocks__paramsIP:
.LFB2:
	.cfi_startproc
	movl	$262144, %eax
	movq	%rax, %xmm0
	movl	$100, %eax
	punpcklqdq	%xmm0, %xmm0
	movups	%xmm0, (%rdi)
	movdqa	.LC10(%rip), %xmm0
	movups	%xmm0, 16(%rdi)
	movq	%rax, %xmm0
	punpcklqdq	%xmm0, %xmm0
	movups	%xmm0, 32(%rdi)
	movdqa	.LC12(%rip), %xmm0
	movups	%xmm0, 48(%rdi)
	movdqa	.LC13(%rip), %xmm0
	movups	%xmm0, 64(%rdi)
	ret
	.cfi_endproc
.LFE2:
	.size	boids__flocks__paramsIP, .-boids__flocks__paramsIP
	.align 2
	.p2align 4
	.globl	boids__flocks__birdIP
	.type	boids__flocks__birdIP, @function
boids__flocks__birdIP:
.LFB3:
	.cfi_startproc
	pxor	%xmm0, %xmm0
	movups	%xmm0, (%rdi)
	movups	%xmm0, 16(%rdi)
	ret
	.cfi_endproc
.LFE3:
	.size	boids__flocks__birdIP, .-boids__flocks__birdIP
	.align 2
	.p2align 4
	.globl	boids__flocks__Tbird_arrayBIP
	.type	boids__flocks__Tbird_arrayBIP, @function
boids__flocks__Tbird_arrayBIP:
.LFB4:
	.cfi_startproc
	movl	(%rsi), %eax
	movl	4(%rsi), %edx
	cmpl	%edx, %eax
	jg	.L26
	addl	$1, %edx
	pxor	%xmm0, %xmm0
	subl	%eax, %edx
	xorl	%eax, %eax
	.p2align 5
	.p2align 4
	.p2align 3
.L28:
	addl	$1, %eax
	movups	%xmm0, (%rdi)
	addq	$32, %rdi
	movups	%xmm0, -16(%rdi)
	cmpl	%edx, %eax
	jb	.L28
.L26:
	ret
	.cfi_endproc
.LFE4:
	.size	boids__flocks__Tbird_arrayBIP, .-boids__flocks__Tbird_arrayBIP
	.align 2
	.p2align 4
	.globl	boids__flocks__Tvec_arrayBIP
	.type	boids__flocks__Tvec_arrayBIP, @function
boids__flocks__Tvec_arrayBIP:
.LFB5:
	.cfi_startproc
	movl	(%rsi), %edx
	movl	4(%rsi), %eax
	cmpl	%eax, %edx
	jg	.L30
	subl	%edx, %eax
	pxor	%xmm0, %xmm0
	salq	$4, %rax
	leaq	16(%rdi,%rax), %rax
	movq	%rax, %rdx
	subq	%rdi, %rdx
	andl	$16, %edx
	je	.L32
	movups	%xmm0, (%rdi)
	addq	$16, %rdi
	cmpq	%rax, %rdi
	je	.L30
	.p2align 4
	.p2align 4
	.p2align 3
.L32:
	movups	%xmm0, (%rdi)
	addq	$32, %rdi
	movups	%xmm0, -16(%rdi)
	cmpq	%rax, %rdi
	jne	.L32
.L30:
	ret
	.cfi_endproc
.LFE5:
	.size	boids__flocks__Tvec_arrayBIP, .-boids__flocks__Tvec_arrayBIP
	.align 2
	.p2align 4
	.globl	boids__flocks__flockIP
	.type	boids__flocks__flockIP, @function
boids__flocks__flockIP:
.LFB6:
	.cfi_startproc
	movl	$262144, %eax
	movl	$0, (%rdi)
	leaq	64088(%rdi), %rdx
	movq	%rax, %xmm0
	movl	$100, %eax
	punpcklqdq	%xmm0, %xmm0
	movups	%xmm0, 8(%rdi)
	movdqa	.LC10(%rip), %xmm0
	movups	%xmm0, 24(%rdi)
	movq	%rax, %xmm0
	leaq	88(%rdi), %rax
	punpcklqdq	%xmm0, %xmm0
	movups	%xmm0, 40(%rdi)
	movdqa	.LC12(%rip), %xmm0
	movups	%xmm0, 56(%rdi)
	movdqa	.LC13(%rip), %xmm0
	movups	%xmm0, 72(%rdi)
	pxor	%xmm0, %xmm0
	.p2align 4
	.p2align 4
	.p2align 3
.L40:
	movups	%xmm0, (%rax)
	addq	$32, %rax
	movups	%xmm0, -16(%rax)
	cmpq	%rdx, %rax
	jne	.L40
	addq	$96088, %rdi
	pxor	%xmm0, %xmm0
	movq	%rdi, %rax
	subq	%rdx, %rax
	testb	$16, %al
	je	.L41
	movups	%xmm0, (%rdx)
	addq	$16, %rdx
	cmpq	%rdx, %rdi
	je	.L49
	.p2align 4
	.p2align 4
	.p2align 3
.L41:
	movups	%xmm0, (%rdx)
	addq	$32, %rdx
	movups	%xmm0, -16(%rdx)
	cmpq	%rdx, %rdi
	jne	.L41
.L49:
	ret
	.cfi_endproc
.LFE6:
	.size	boids__flocks__flockIP, .-boids__flocks__flockIP
	.align 2
	.p2align 4
	.globl	boids__flocks__Tindex_listBIP
	.type	boids__flocks__Tindex_listBIP, @function
boids__flocks__Tindex_listBIP:
.LFB7:
	.cfi_startproc
	ret
	.cfi_endproc
.LFE7:
	.size	boids__flocks__Tindex_listBIP, .-boids__flocks__Tindex_listBIP
	.align 2
	.p2align 4
	.globl	boids__flocks__valid_params
	.type	boids__flocks__valid_params, @function
boids__flocks__valid_params:
.LFB8:
	.cfi_startproc
	movq	64(%rdi), %rax
	cmpq	%rax, 56(%rdi)
	movq	16(%rdi), %rcx
	setle	%al
	cmpq	%rcx, 24(%rdi)
	setle	%dl
	andl	%edx, %eax
	ret
	.cfi_endproc
.LFE8:
	.size	boids__flocks__valid_params, .-boids__flocks__valid_params
	.align 2
	.p2align 4
	.globl	boids__flocks__in_world
	.type	boids__flocks__in_world, @function
boids__flocks__in_world:
.LFB9:
	.cfi_startproc
	movl	(%rdi), %eax
	cmpl	$2000, %eax
	ja	.L63
	testl	%eax, %eax
	je	.L57
	movq	8(%rdi), %rsi
	movq	16(%rdi), %r8
	leal	1(%rax), %r9d
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L56:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rdi, %rax
	movq	64(%rax), %rcx
	cmpq	56(%rax), %rsi
	jle	.L58
	cmpq	%rcx, %r8
	jle	.L58
	addq	$1, %rdx
	cmpq	%rdx, %r9
	jne	.L56
.L57:
	movl	$1, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L58:
	xorl	%eax, %eax
	ret
.L63:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.cfi_endproc
.LFE9:
	.size	boids__flocks__in_world, .-boids__flocks__in_world
	.align 2
	.p2align 4
	.globl	boids__flocks__valid
	.type	boids__flocks__valid, @function
boids__flocks__valid:
.LFB10:
	.cfi_startproc
	movq	72(%rdi), %rax
	cmpq	%rax, 64(%rdi)
	setle	%al
	movq	24(%rdi), %rsi
	cmpq	%rsi, 32(%rdi)
	setle	%dl
	andl	%edx, %eax
	movl	(%rdi), %edx
	cmpl	$2000, %edx
	ja	.L77
	testl	%edx, %edx
	je	.L64
	movq	8(%rdi), %r8
	movq	16(%rdi), %r9
	leal	1(%rdx), %r10d
	movl	$1, %ecx
	.p2align 4
	.p2align 3
.L68:
	movq	%rcx, %rdx
	salq	$5, %rdx
	addq	%rdi, %rdx
	movq	64(%rdx), %rsi
	cmpq	%r8, 56(%rdx)
	jge	.L69
	cmpq	%r9, %rsi
	jge	.L69
	addq	$1, %rcx
	cmpq	%r10, %rcx
	jne	.L68
.L64:
	ret
	.p2align 4,,10
	.p2align 3
.L69:
	xorl	%eax, %eax
	ret
.L77:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.cfi_endproc
.LFE10:
	.size	boids__flocks__valid, .-boids__flocks__valid
	.align 2
	.p2align 4
	.globl	boids__flocks__speeds_clamped
	.type	boids__flocks__speeds_clamped, @function
boids__flocks__speeds_clamped:
.LFB11:
	.cfi_startproc
	movl	(%rdi), %eax
	cmpl	$2000, %eax
	ja	.L92
	testl	%eax, %eax
	je	.L80
	movq	64(%rdi), %rsi
	movq	72(%rdi), %r8
	leal	1(%rax), %r9d
	movl	$1, %ecx
	imulq	%rsi, %rsi
	imulq	%r8, %r8
	jmp	.L84
	.p2align 4,,10
	.p2align 3
.L93:
	cmpq	%rax, %r8
	jl	.L81
	addq	$1, %rcx
	cmpq	%rcx, %r9
	je	.L80
.L84:
	leaq	2(%rcx), %rdx
	salq	$5, %rdx
	addq	%rdi, %rdx
	movq	8(%rdx), %rax
	movq	16(%rdx), %rdx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rdx, %rax
	cmpq	%rax, %rsi
	jle	.L93
.L81:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L80:
	movl	$1, %eax
	ret
.L92:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$50, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.cfi_endproc
.LFE11:
	.size	boids__flocks__speeds_clamped, .-boids__flocks__speeds_clamped
	.section	.rodata.str1.8
	.align 8
.LC15:
	.string	"failed precondition from boids-flocks.ads:55"
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__dx
	.type	boids__flocks__dx, @function
boids__flocks__dx:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movl	(%rdi), %ebp
	cmpl	$2000, %ebp
	ja	.L104
	movq	72(%rdi), %rax
	cmpq	%rax, 64(%rdi)
	movslq	%edx, %r8
	setle	%al
	movq	24(%rdi), %rbx
	cmpq	%rbx, 32(%rdi)
	setle	%dl
	andl	%edx, %eax
	movl	%eax, %r9d
	testl	%ebp, %ebp
	je	.L96
	movq	8(%rdi), %r10
	movq	16(%rdi), %r11
	leal	1(%rbp), %ebx
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L98:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rdi, %rax
	movq	64(%rax), %rcx
	cmpq	%r10, 56(%rax)
	jge	.L97
	cmpq	%r11, %rcx
	jge	.L97
	addq	$1, %rdx
	cmpq	%rbx, %rdx
	jne	.L98
.L96:
	movl	%r9d, %eax
	movl	%r8d, %edx
	xorl	$1, %eax
	cmpl	%r8d, %esi
	cmovge	%esi, %edx
	cmpl	%ebp, %edx
	jg	.L97
	testb	%al, %al
	jne	.L97
	movslq	%esi, %rsi
	salq	$5, %r8
	movq	8(%rdi), %rdx
	salq	$5, %rsi
	movq	56(%rdi,%r8), %rcx
	movq	56(%rdi,%rsi), %rax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	movq	%rcx, %rsi
	popq	%rbp
	.cfi_def_cfa_offset 8
	movq	%rax, %rdi
	jmp	boids__torus_delta@PLT
.L104:
	.cfi_restore_state
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L97:
	leaq	.LC15(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE12:
	.size	boids__flocks__dx, .-boids__flocks__dx
	.section	.rodata.str1.8
	.align 8
.LC16:
	.string	"failed precondition from boids-flocks.ads:59"
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__dy
	.type	boids__flocks__dy, @function
boids__flocks__dy:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movl	(%rdi), %ebp
	cmpl	$2000, %ebp
	ja	.L115
	movq	72(%rdi), %rax
	cmpq	%rax, 64(%rdi)
	movslq	%edx, %r8
	setle	%al
	movq	24(%rdi), %rbx
	cmpq	%rbx, 32(%rdi)
	setle	%dl
	andl	%edx, %eax
	movl	%eax, %r9d
	testl	%ebp, %ebp
	je	.L107
	movq	8(%rdi), %r10
	movq	16(%rdi), %r11
	leal	1(%rbp), %ebx
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L109:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rdi, %rax
	movq	64(%rax), %rcx
	cmpq	%r10, 56(%rax)
	jge	.L108
	cmpq	%r11, %rcx
	jge	.L108
	addq	$1, %rdx
	cmpq	%rbx, %rdx
	jne	.L109
.L107:
	movl	%r9d, %eax
	movl	%r8d, %edx
	xorl	$1, %eax
	cmpl	%r8d, %esi
	cmovge	%esi, %edx
	cmpl	%ebp, %edx
	jg	.L108
	testb	%al, %al
	jne	.L108
	movslq	%esi, %rsi
	salq	$5, %r8
	movq	16(%rdi), %rdx
	salq	$5, %rsi
	movq	64(%rdi,%r8), %rcx
	movq	64(%rdi,%rsi), %rax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	movq	%rcx, %rsi
	popq	%rbp
	.cfi_def_cfa_offset 8
	movq	%rax, %rdi
	jmp	boids__torus_delta@PLT
.L115:
	.cfi_restore_state
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L108:
	leaq	.LC16(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE13:
	.size	boids__flocks__dy, .-boids__flocks__dy
	.section	.rodata.str1.8
	.align 8
.LC17:
	.string	"failed precondition from boids-flocks.ads:64"
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__dist2
	.type	boids__flocks__dist2, @function
boids__flocks__dist2:
.LFB14:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movl	(%rdi), %ecx
	cmpl	$2000, %ecx
	ja	.L124
	movq	72(%rdi), %rax
	cmpq	%rax, 64(%rdi)
	movslq	%esi, %r14
	movslq	%edx, %r12
	setle	%al
	movq	24(%rdi), %rsi
	cmpq	%rsi, 32(%rdi)
	movl	%r12d, %ebp
	setle	%dl
	movq	%rdi, %rbx
	andl	%edx, %eax
	cmpl	%r12d, %r14d
	cmovge	%r14d, %ebp
	movl	%eax, %r10d
	cmpl	%ebp, %ecx
	setl	%r11b
	testl	%ecx, %ecx
	jne	.L138
	testb	%al, %al
	je	.L119
	testb	%r11b, %r11b
	jne	.L119
	movq	8(%rdi), %rsi
.L131:
	movq	%r12, %rax
	movq	%r14, %rdx
	salq	$5, %rax
	salq	$5, %rdx
	movq	56(%rbx,%rax), %rax
	movq	56(%rbx,%rdx), %rdi
	movq	%rsi, %rdx
	movq	%rax, %rsi
	call	boids__torus_delta@PLT
	movl	(%rbx), %r9d
	movq	%rax, %r13
	cmpl	$2000, %r9d
	ja	.L124
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	setle	%al
	movq	24(%rbx), %rdi
	cmpq	%rdi, 32(%rbx)
	setle	%dl
	andl	%edx, %eax
	testl	%r9d, %r9d
	je	.L125
	movq	8(%rbx), %rsi
	movq	16(%rbx), %rdi
	leal	1(%r9), %r10d
	movl	$1, %ecx
	.p2align 4
	.p2align 3
.L127:
	movq	%rcx, %rdx
	salq	$5, %rdx
	addq	%rbx, %rdx
	movq	64(%rdx), %r8
	cmpq	%rsi, 56(%rdx)
	jge	.L126
	cmpq	%rdi, %r8
	jge	.L126
	addq	$1, %rcx
	cmpq	%r10, %rcx
	jne	.L127
.L125:
	xorl	$1, %eax
	cmpl	%ebp, %r9d
	jl	.L126
	testb	%al, %al
	jne	.L126
	movq	%r14, %r9
	salq	$5, %r12
	movq	16(%rbx), %rdx
	imulq	%r13, %r13
	salq	$5, %r9
	movq	64(%rbx,%r12), %rsi
	movq	64(%rbx,%r9), %rdi
	call	boids__torus_delta@PLT
	imulq	%rax, %rax
	addq	%r13, %rax
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L138:
	.cfi_restore_state
	movq	8(%rdi), %rsi
	movl	$1, %edx
	movq	16(%rdi), %rdi
	jmp	.L120
	.p2align 4,,10
	.p2align 3
.L132:
	addq	$1, %rdx
.L120:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r8
	cmpq	%rsi, 56(%rax)
	jge	.L119
	cmpq	%rdi, %r8
	jge	.L119
	cmpq	%rcx, %rdx
	jne	.L132
	testb	%r10b, %r10b
	je	.L119
	testb	%r11b, %r11b
	jne	.L119
	movl	$1, %edx
	jmp	.L121
	.p2align 4,,10
	.p2align 3
.L139:
	cmpq	%r8, %rdi
	jle	.L123
	cmpq	%rcx, %rdx
	je	.L131
	addq	$1, %rdx
.L121:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r8
	cmpq	56(%rax), %rsi
	jg	.L139
.L123:
	leaq	.LC15(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L124:
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L119:
	leaq	.LC17(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L126:
	leaq	.LC16(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE14:
	.size	boids__flocks__dist2, .-boids__flocks__dist2
	.section	.rodata.str1.8
	.align 8
.LC18:
	.string	"failed precondition from boids-flocks.ads:69"
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__is_neighbour
	.type	boids__flocks__is_neighbour, @function
boids__flocks__is_neighbour:
.LFB15:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movl	(%rdi), %r10d
	cmpl	$2000, %r10d
	ja	.L152
	movq	72(%rdi), %rax
	movq	%rdi, %rbx
	cmpq	%rax, 64(%rdi)
	movslq	%edx, %r13
	setle	%al
	movq	24(%rdi), %rdi
	cmpq	%rdi, 32(%rbx)
	movslq	%esi, %r14
	setle	%dl
	andl	%edx, %eax
	movl	%eax, %r11d
	testl	%r10d, %r10d
	jne	.L166
	cmpl	%r13d, %r14d
	movl	%r13d, %ebp
	cmovge	%r14d, %ebp
	testl	%ebp, %ebp
	setg	%dl
	xorl	$1, %eax
	orb	%dl, %al
	jne	.L143
	cmpl	%r13d, %r14d
	je	.L140
	movq	8(%rbx), %rcx
.L147:
	movq	%r13, %rax
	movq	%rcx, %rdx
	salq	$5, %rax
	movq	56(%rbx,%rax), %rsi
	movq	%r14, %rax
	salq	$5, %rax
	movq	56(%rbx,%rax), %rdi
	call	boids__torus_delta@PLT
	movl	(%rbx), %r8d
	movq	%rax, %r12
	cmpl	$2000, %r8d
	ja	.L152
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	movq	24(%rbx), %rdi
	setle	%al
	cmpq	%rdi, 32(%rbx)
	setle	%dl
	andl	%edx, %eax
	movl	%eax, %edi
	testl	%r8d, %r8d
	je	.L153
	movq	8(%rbx), %rcx
	movq	16(%rbx), %rsi
	leal	1(%r8), %r10d
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L155:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r9
	cmpq	%rcx, 56(%rax)
	jge	.L154
	cmpq	%rsi, %r9
	jge	.L154
	addq	$1, %rdx
	cmpq	%r10, %rdx
	jne	.L155
.L153:
	movl	%edi, %eax
	xorl	$1, %eax
	cmpl	%r8d, %ebp
	jg	.L154
	testb	%al, %al
	jne	.L154
	movq	%r13, %r8
	movq	16(%rbx), %rdx
	imulq	%r12, %r12
	movq	%r14, %rdi
	salq	$5, %r8
	salq	$5, %rdi
	movq	64(%rbx,%r8), %rsi
	movq	64(%rbx,%rdi), %rdi
	call	boids__torus_delta@PLT
	movq	24(%rbx), %rdx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rax, %r12
	cmpq	%r12, %rdx
	setg	%al
.L140:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L166:
	.cfi_restore_state
	movq	8(%rbx), %rcx
	movq	16(%rbx), %rsi
	leal	1(%r10), %ebp
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L144:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r9
	cmpq	%rcx, 56(%rax)
	jge	.L143
	cmpq	%rsi, %r9
	jge	.L143
	addq	$1, %rdx
	cmpq	%rbp, %rdx
	jne	.L144
	cmpl	%r13d, %r14d
	movl	%r13d, %ebp
	movl	%r11d, %eax
	cmovge	%r14d, %ebp
	cmpl	%ebp, %r10d
	setl	%dl
	xorl	$1, %eax
	orb	%dl, %al
	jne	.L143
	movl	$1, %edx
	cmpl	%r13d, %r14d
	jne	.L149
	jmp	.L140
	.p2align 4,,10
	.p2align 3
.L159:
	addq	$1, %rdx
.L149:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r9
	cmpq	%rcx, 56(%rax)
	jge	.L148
	cmpq	%rsi, %r9
	jge	.L148
	cmpq	%r10, %rdx
	jne	.L159
	movl	$1, %edx
	jmp	.L151
	.p2align 4,,10
	.p2align 3
.L167:
	cmpq	%r9, %rsi
	jle	.L150
	cmpq	%r10, %rdx
	je	.L147
	addq	$1, %rdx
.L151:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r9
	cmpq	56(%rax), %rcx
	jg	.L167
.L150:
	leaq	.LC15(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L152:
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L143:
	leaq	.LC18(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L154:
	leaq	.LC16(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L148:
	leaq	.LC17(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE15:
	.size	boids__flocks__is_neighbour, .-boids__flocks__is_neighbour
	.align 2
	.p2align 4
	.globl	boids__flocks__cap
	.type	boids__flocks__cap, @function
boids__flocks__cap:
.LFB16:
	.cfi_startproc
	movabsq	$-6640827866535438581, %rax
	imulq	72(%rdi), %rsi
	imulq	%rsi
	leaq	(%rdx,%rsi), %rax
	sarq	$63, %rsi
	sarq	$6, %rax
	subq	%rsi, %rax
	ret
	.cfi_endproc
.LFE16:
	.size	boids__flocks__cap, .-boids__flocks__cap
	.section	.rodata.str1.8
	.align 8
.LC19:
	.string	"failed precondition from boids-flocks.ads:77"
	.align 8
.LC21:
	.string	"Loop_Invariant failed at boids-flocks.adb:14"
	.align 8
.LC22:
	.string	"Loop_Invariant failed at boids-flocks.adb:16"
	.align 8
.LC23:
	.string	"Loop_Invariant failed at boids-flocks.adb:19"
	.align 8
.LC24:
	.string	"Loop_Invariant failed at boids-flocks.adb:21"
	.align 8
.LC25:
	.string	"failed postcondition from boids-flocks.ads:78"
	.align 8
.LC26:
	.string	"failed postcondition from boids-flocks.ads:82"
	.align 8
.LC27:
	.string	"failed postcondition from boids-flocks.ads:81"
	.align 8
.LC28:
	.string	"failed postcondition from boids-flocks.ads:79"
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__find_neighbours
	.type	boids__flocks__find_neighbours, @function
boids__flocks__find_neighbours:
.LFB17:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movl	(%rdi), %r8d
	movl	%esi, 12(%rsp)
	movq	%rdx, 32(%rsp)
	movl	%r8d, 24(%rsp)
	cmpl	$2000, %r8d
	ja	.L179
	movq	72(%rdi), %rax
	movq	%rdi, %rbx
	cmpq	%rax, 64(%rdi)
	setle	%al
	movq	24(%rdi), %rdi
	cmpq	%rdi, 32(%rbx)
	setle	%dl
	andl	%edx, %eax
	movl	%eax, %ecx
	testl	%r8d, %r8d
	je	.L171
	movq	8(%rbx), %r9
	movq	16(%rbx), %rdi
	leal	1(%r8), %r10d
	movl	$1, %edx
.L173:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rsi
	cmpq	%r9, 56(%rax)
	jge	.L172
	cmpq	%rdi, %rsi
	jge	.L172
	addq	$1, %rdx
	cmpq	%r10, %rdx
	jne	.L173
.L171:
	movl	%ecx, %eax
	xorl	$1, %eax
	cmpl	%r8d, 12(%rsp)
	jg	.L172
	testb	%al, %al
	jne	.L172
	movq	32(%rsp), %rax
	pcmpeqd	%xmm0, %xmm0
	psrld	$31, %xmm0
	leaq	8000(%rax), %rdx
	.p2align 4
	.p2align 4
	.p2align 3
.L177:
	movups	%xmm0, (%rax)
	addq	$32, %rax
	movups	%xmm0, -16(%rax)
	cmpq	%rdx, %rax
	jne	.L177
	testl	%r8d, %r8d
	je	.L169
	movslq	12(%rsp), %rbp
	movl	%r8d, %eax
	movl	$1, %ecx
	movl	%r8d, %r14d
	movq	%rax, 48(%rsp)
	salq	$5, %rbp
	movl	$0, 24(%rsp)
	addq	%rbx, %rbp
	movq	%rbp, %r13
.L240:
	cmpl	$2000, %r14d
	ja	.L179
	testl	%r14d, %r14d
	jne	.L366
	.p2align 4
	.p2align 3
.L267:
	leaq	.LC18(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L169:
	movl	24(%rsp), %eax
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L366:
	.cfi_restore_state
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	movl	%r14d, %edi
	movl	$1, %r10d
	jmp	.L181
	.p2align 4,,10
	.p2align 3
.L287:
	addq	$1, %r10
.L181:
	movq	%r10, %rsi
	salq	$5, %rsi
	addq	%rbx, %rsi
	movq	64(%rsi), %r9
	cmpq	%rdx, 56(%rsi)
	jge	.L267
	cmpq	%rax, %r9
	jge	.L267
	cmpq	%rdi, %r10
	jne	.L287
	movq	72(%rbx), %rsi
	cmpq	%rsi, 64(%rbx)
	movl	%ecx, %r15d
	setle	%sil
	movq	24(%rbx), %r11
	cmpq	%r11, 32(%rbx)
	setle	%r10b
	andl	%r10d, %esi
	xorl	$1, %esi
	cmpl	%r14d, 12(%rsp)
	setg	%r10b
	orb	%r10b, %sil
	jne	.L267
	cmpl	%ecx, %r14d
	jl	.L267
	movl	$1, %r8d
	cmpl	%ecx, 12(%rsp)
	jne	.L186
	jmp	.L184
	.p2align 4,,10
	.p2align 3
.L288:
	addq	$1, %r8
.L186:
	movq	%r8, %rsi
	salq	$5, %rsi
	addq	%rbx, %rsi
	movq	64(%rsi), %r9
	cmpq	56(%rsi), %rdx
	jle	.L272
	cmpq	%r9, %rax
	jle	.L272
	cmpq	%rdi, %r8
	jne	.L288
	movl	$1, %r8d
	jmp	.L187
	.p2align 4,,10
	.p2align 3
.L289:
	addq	$1, %r8
.L187:
	movq	%r8, %rsi
	salq	$5, %rsi
	addq	%rbx, %rsi
	movq	64(%rsi), %r9
	cmpq	56(%rsi), %rdx
	jle	.L275
	cmpq	%r9, %rax
	jle	.L275
	cmpq	%rdi, %r8
	jne	.L289
	movq	%rcx, %rax
	movq	56(%r13), %rdi
	movq	%rcx, 16(%rsp)
	salq	$5, %rax
	movq	56(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	movl	(%rbx), %r8d
	movq	%rax, %rbp
	cmpl	$2000, %r8d
	ja	.L179
	testl	%r8d, %r8d
	jne	.L367
	.p2align 4
	.p2align 3
.L277:
	leaq	.LC16(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L184:
	cmpl	%r15d, 24(%rsp)
	jg	.L196
	movl	24(%rsp), %esi
	testl	%esi, %esi
	jg	.L368
.L199:
	movslq	24(%rsp), %rax
	movq	32(%rsp), %rdi
	movq	%rcx, 16(%rsp)
	movq	%r13, %r15
	movl	$1, %r14d
	movq	%rax, 40(%rsp)
	leaq	(%rdi,%rax,4), %r12
	.p2align 4
	.p2align 3
.L238:
	movl	(%rbx), %r10d
	cmpl	$2000, %r10d
	ja	.L179
	testl	%r10d, %r10d
	je	.L267
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	movl	%r10d, %edi
	movl	$1, %esi
	jmp	.L223
	.p2align 4,,10
	.p2align 3
.L292:
	addq	$1, %rsi
.L223:
	movq	%rsi, %rcx
	salq	$5, %rcx
	addq	%rbx, %rcx
	movq	64(%rcx), %r8
	cmpq	%rdx, 56(%rcx)
	jge	.L267
	cmpq	%rax, %r8
	jge	.L267
	cmpq	%rdi, %rsi
	jne	.L292
	movq	72(%rbx), %rsi
	cmpq	%rsi, 64(%rbx)
	movl	%r14d, %ebp
	movq	24(%rbx), %rsi
	setle	%cl
	cmpq	%rsi, 32(%rbx)
	setle	%sil
	andl	%esi, %ecx
	xorl	$1, %ecx
	cmpl	%r10d, 12(%rsp)
	setg	%sil
	orb	%cl, %sil
	jne	.L267
	cmpl	%r14d, %r10d
	jl	.L267
	movl	$1, %esi
	cmpl	%r14d, 12(%rsp)
	jne	.L228
	jmp	.L226
	.p2align 4,,10
	.p2align 3
.L293:
	addq	$1, %rsi
.L228:
	movq	%rsi, %rcx
	salq	$5, %rcx
	addq	%rbx, %rcx
	movq	64(%rcx), %r8
	cmpq	56(%rcx), %rdx
	jle	.L272
	cmpq	%r8, %rax
	jle	.L272
	cmpq	%rdi, %rsi
	jne	.L293
	movl	$1, %esi
	jmp	.L229
	.p2align 4,,10
	.p2align 3
.L294:
	addq	$1, %rsi
.L229:
	movq	%rsi, %rcx
	salq	$5, %rcx
	addq	%rbx, %rcx
	movq	64(%rcx), %r8
	cmpq	56(%rcx), %rdx
	jle	.L275
	cmpq	%r8, %rax
	jle	.L275
	cmpq	%rdi, %rsi
	jne	.L294
	movq	%r14, %rax
	movq	56(%r15), %rdi
	salq	$5, %rax
	movq	56(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	movl	(%rbx), %edi
	movq	%rax, %r13
	cmpl	$2000, %edi
	ja	.L179
	testl	%edi, %edi
	je	.L277
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	leal	1(%rdi), %r10d
	movl	$1, %esi
	.p2align 4
	.p2align 3
.L233:
	movq	%rsi, %rcx
	salq	$5, %rcx
	addq	%rbx, %rcx
	movq	64(%rcx), %r8
	cmpq	%rdx, 56(%rcx)
	jge	.L277
	cmpq	%rax, %r8
	jge	.L277
	addq	$1, %rsi
	cmpq	%rsi, %r10
	jne	.L233
	movq	72(%rbx), %rdx
	cmpq	%rdx, 64(%rbx)
	setle	%dl
	movq	24(%rbx), %rsi
	cmpq	%rsi, 32(%rbx)
	setle	%cl
	andl	%ecx, %edx
	xorl	$1, %edx
	cmpl	%edi, 12(%rsp)
	setg	%cl
	orb	%cl, %dl
	jne	.L277
	cmpl	%edi, %ebp
	jg	.L277
	movq	%r14, %rdx
	movq	64(%r15), %rdi
	imulq	%r13, %r13
	salq	$5, %rdx
	movq	64(%rbx,%rdx), %rsi
	movq	%rax, %rdx
	call	boids__torus_delta@PLT
	movq	24(%rbx), %rdx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rax, %r13
	cmpq	%rdx, %r13
	jge	.L226
	movl	24(%rsp), %ecx
	testl	%ecx, %ecx
	jle	.L236
	movq	32(%rsp), %rax
	jmp	.L237
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L369:
	addq	$4, %rax
	cmpq	%rax, %r12
	je	.L236
.L237:
	cmpl	(%rax), %ebp
	jne	.L369
	.p2align 4
	.p2align 3
.L226:
	movq	16(%rsp), %rax
	leaq	1(%r14), %rdx
	cmpq	%rax, %r14
	je	.L370
	movq	%rdx, %r14
	jmp	.L238
.L370:
	movq	%rax, %rcx
	movq	%r15, %r13
	movq	40(%rsp), %rax
	cmpq	48(%rsp), %rcx
	je	.L239
	movl	(%rbx), %r14d
	movq	%rdx, %rcx
	jmp	.L240
.L367:
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	leal	1(%r8), %r10d
	movl	$1, %edi
	movq	16(%rsp), %rcx
	.p2align 4
	.p2align 3
.L191:
	movq	%rdi, %rsi
	salq	$5, %rsi
	addq	%rbx, %rsi
	movq	64(%rsi), %r9
	cmpq	%rdx, 56(%rsi)
	jge	.L277
	cmpq	%rax, %r9
	jge	.L277
	addq	$1, %rdi
	cmpq	%r10, %rdi
	jne	.L191
	movq	72(%rbx), %rdi
	cmpq	%rdi, 64(%rbx)
	setle	%dl
	movq	24(%rbx), %rdi
	cmpq	%rdi, 32(%rbx)
	setle	%sil
	andl	%esi, %edx
	xorl	$1, %edx
	cmpl	%r8d, 12(%rsp)
	setg	%sil
	orb	%sil, %dl
	jne	.L277
	cmpl	%r15d, %r8d
	jl	.L277
	movq	%rcx, %rdx
	movq	64(%r13), %rdi
	movq	%rcx, 16(%rsp)
	imulq	%rbp, %rbp
	salq	$5, %rdx
	movq	64(%rbx,%rdx), %rsi
	movq	%rax, %rdx
	call	boids__torus_delta@PLT
	movq	24(%rbx), %rdx
	movq	16(%rsp), %rcx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rax, %rbp
	cmpq	%rdx, %rbp
	jge	.L184
	movl	24(%rsp), %eax
	leal	1(%rax), %ebp
	cmpl	$2000, %ebp
	ja	.L371
	cmpl	$1999, 24(%rsp)
	ja	.L372
	movq	32(%rsp), %rdi
	movl	%ebp, %eax
	movl	%ecx, -4(%rdi,%rax,4)
	cmpl	%r15d, %ebp
	jg	.L196
.L197:
	movq	32(%rsp), %r9
	movq	%rcx, 24(%rsp)
	movq	%r13, %r14
	movl	%ebp, 16(%rsp)
	movl	%r15d, %ebp
	leaq	(%r9,%rax,4), %rax
	movq	%r9, %r13
	movq	%rax, 40(%rsp)
.L216:
	movl	0(%r13), %r12d
	cmpl	%ebp, %r12d
	jg	.L200
	movl	(%rbx), %r9d
	cmpl	$2000, %r9d
	ja	.L179
	testl	%r9d, %r9d
	je	.L201
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rsi
	leal	1(%r9), %r10d
	movl	$1, %edi
	.p2align 4
	.p2align 3
.L203:
	movq	%rdi, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rdx, 56(%rax)
	jge	.L267
	cmpq	%rsi, %rcx
	jge	.L267
	addq	$1, %rdi
	cmpq	%rdi, %r10
	jne	.L203
.L201:
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	setle	%al
	movq	24(%rbx), %rdi
	cmpq	%rdi, 32(%rbx)
	setle	%dl
	andl	%edx, %eax
	xorl	$1, %eax
	cmpl	%r9d, 12(%rsp)
	setg	%dl
	orb	%dl, %al
	jne	.L267
	cmpl	%r9d, %r12d
	jg	.L267
	cmpl	%r12d, 12(%rsp)
	je	.L200
	testl	%r9d, %r9d
	jne	.L357
	movq	8(%rbx), %rdx
.L206:
	movslq	%r12d, %r15
	movq	56(%r14), %rdi
	movq	%r15, %rax
	salq	$5, %rax
	movq	56(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	movl	(%rbx), %r9d
	movq	%rax, %r11
	cmpl	$2000, %r9d
	ja	.L179
	testl	%r9d, %r9d
	je	.L211
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rsi
	leal	1(%r9), %r10d
	movl	$1, %edi
.L213:
	movq	%rdi, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rdx, 56(%rax)
	jge	.L277
	cmpq	%rsi, %rcx
	jge	.L277
	addq	$1, %rdi
	cmpq	%rdi, %r10
	jne	.L213
.L211:
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	setle	%al
	movq	24(%rbx), %rdi
	cmpq	%rdi, 32(%rbx)
	setle	%dl
	andl	%edx, %eax
	xorl	$1, %eax
	cmpl	%r9d, 12(%rsp)
	setg	%dl
	orb	%dl, %al
	jne	.L277
	cmpl	%r9d, %r12d
	jg	.L277
	salq	$5, %r15
	movq	16(%rbx), %rdx
	movq	64(%r14), %rdi
	movq	%r11, 56(%rsp)
	movq	64(%rbx,%r15), %rsi
	call	boids__torus_delta@PLT
	movq	56(%rsp), %r11
	movq	24(%rbx), %rdx
	imulq	%rax, %rax
	imulq	%r11, %r11
	imulq	%rdx, %rdx
	addq	%rax, %r11
	cmpq	%rdx, %r11
	jl	.L373
.L200:
	leaq	.LC22(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L357:
	movl	%r9d, %edi
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rsi
	movl	$1, %r9d
	jmp	.L208
.L290:
	addq	$1, %r9
.L208:
	movq	%r9, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rdx, 56(%rax)
	jge	.L272
	cmpq	%rsi, %rcx
	jge	.L272
	cmpq	%rdi, %r9
	jne	.L290
	movl	$1, %r9d
	jmp	.L209
.L374:
	cmpq	%rcx, %rsi
	jle	.L275
	cmpq	%r9, %rdi
	je	.L206
	addq	$1, %r9
.L209:
	movq	%r9, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	56(%rax), %rdx
	jg	.L374
	.p2align 4
	.p2align 3
.L275:
	leaq	.LC15(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L373:
	addq	$4, %r13
	cmpq	40(%rsp), %r13
	jne	.L216
	movl	16(%rsp), %ebp
	movq	24(%rsp), %rcx
	movq	%r14, %r13
	cmpl	$1, %ebp
	je	.L218
	movq	32(%rsp), %rdi
	leal	-2(%rbp), %eax
	leaq	(%rdi,%rax,4), %rdx
	leaq	7996(%rdi), %rsi
	movq	%rdi, %rax
	jmp	.L219
	.p2align 4,,10
	.p2align 3
.L376:
	cmpq	%rdx, %rax
	je	.L218
	addq	$4, %rax
	cmpq	%rsi, %rax
	je	.L375
.L219:
	movl	4(%rax), %edi
	cmpl	%edi, (%rax)
	jl	.L376
	leaq	.LC23(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L218:
	movl	%ebp, 24(%rsp)
	jmp	.L199
.L179:
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L239:
	movl	(%rbx), %ecx
	cmpl	24(%rsp), %ecx
	jl	.L377
	movl	24(%rsp), %edx
	testl	%edx, %edx
	jle	.L243
	movslq	12(%rsp), %rdx
	movq	32(%rsp), %r13
	movq	%rax, 40(%rsp)
	movq	%r12, 16(%rsp)
	salq	$5, %rdx
	leaq	(%rbx,%rdx), %r12
.L242:
	movl	0(%r13), %r15d
	cmpl	%ecx, %r15d
	jg	.L244
	cmpl	$2000, %ecx
	ja	.L179
	testl	%ecx, %ecx
	je	.L245
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	leal	1(%rcx), %r11d
	movl	$1, %edi
.L247:
	movq	%rdi, %rsi
	salq	$5, %rsi
	addq	%rbx, %rsi
	movq	64(%rsi), %r8
	cmpq	%rdx, 56(%rsi)
	jge	.L267
	cmpq	%rax, %r8
	jge	.L267
	addq	$1, %rdi
	cmpq	%rdi, %r11
	jne	.L247
.L245:
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	setle	%dl
	movq	24(%rbx), %rax
	cmpq	%rax, 32(%rbx)
	setle	%al
	testb	%al, %dl
	je	.L267
	cmpl	%ecx, 12(%rsp)
	jg	.L267
	cmpl	%r15d, 12(%rsp)
	je	.L244
	testl	%ecx, %ecx
	jne	.L359
	movq	8(%rbx), %rdx
.L250:
	movslq	%r15d, %r14
	movq	56(%r12), %rdi
	movq	%r14, %rax
	salq	$5, %rax
	movq	56(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	movl	(%rbx), %ecx
	movq	%rax, %rbp
	cmpl	$2000, %ecx
	ja	.L179
	testl	%ecx, %ecx
	je	.L255
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	leal	1(%rcx), %r10d
	movl	$1, %esi
.L257:
	movq	%rsi, %rdi
	salq	$5, %rdi
	addq	%rbx, %rdi
	movq	64(%rdi), %r8
	cmpq	%rdx, 56(%rdi)
	jge	.L277
	cmpq	%rax, %r8
	jge	.L277
	addq	$1, %rsi
	cmpq	%rsi, %r10
	jne	.L257
.L255:
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	setle	%al
	movq	24(%rbx), %rdi
	cmpq	%rdi, 32(%rbx)
	setle	%dl
	andl	%edx, %eax
	xorl	$1, %eax
	cmpl	%ecx, 12(%rsp)
	setg	%dl
	orb	%dl, %al
	jne	.L277
	cmpl	%ecx, %r15d
	jg	.L277
	salq	$5, %r14
	movq	16(%rbx), %rdx
	movq	64(%r12), %rdi
	imulq	%rbp, %rbp
	movq	64(%rbx,%r14), %rsi
	call	boids__torus_delta@PLT
	movq	24(%rbx), %rdx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rax, %rbp
	cmpq	%rdx, %rbp
	jl	.L378
.L244:
	leaq	.LC28(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L359:
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	movl	$1, %esi
	jmp	.L252
.L297:
	addq	$1, %rsi
.L252:
	movq	%rsi, %rdi
	salq	$5, %rdi
	addq	%rbx, %rdi
	movq	64(%rdi), %r8
	cmpq	%rdx, 56(%rdi)
	jge	.L272
	cmpq	%rax, %r8
	jge	.L272
	cmpq	%rsi, %rcx
	jne	.L297
	movl	$1, %esi
	jmp	.L253
	.p2align 4,,10
	.p2align 3
.L379:
	cmpq	%r8, %rax
	jle	.L275
	cmpq	%rcx, %rsi
	je	.L250
	addq	$1, %rsi
.L253:
	movq	%rsi, %rdi
	salq	$5, %rdi
	addq	%rbx, %rdi
	movq	64(%rdi), %r8
	cmpq	56(%rdi), %rdx
	jg	.L379
	jmp	.L275
.L378:
	addq	$4, %r13
	cmpq	16(%rsp), %r13
	je	.L260
	movl	(%rbx), %ecx
	jmp	.L242
.L260:
	movq	40(%rsp), %rax
	cmpl	$1, 24(%rsp)
	je	.L360
	movl	24(%rsp), %edx
	movq	32(%rsp), %rdi
	subl	$2, %edx
	leaq	7996(%rdi), %rsi
	leaq	(%rdi,%rdx,4), %rcx
	movq	%rdi, %rdx
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L381:
	cmpq	%rdx, %rcx
	je	.L360
	addq	$4, %rdx
	cmpq	%rdx, %rsi
	je	.L380
.L261:
	movl	4(%rdx), %edi
	cmpl	%edi, (%rdx)
	jl	.L381
	leaq	.LC27(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L360:
	movl	(%rbx), %ecx
.L243:
	cmpl	$2000, %ecx
	ja	.L382
	testl	%ecx, %ecx
	je	.L169
	movslq	%ecx, %rdi
	movslq	12(%rsp), %r15
	movl	$1, %r12d
	movq	%rdi, 16(%rsp)
	movq	32(%rsp), %rdi
	salq	$5, %r15
	leaq	(%rdi,%rax,4), %rbp
	leaq	(%r15,%rbx), %r13
	movq	%rbp, %r14
.L283:
	movl	(%rbx), %r10d
	cmpl	$2000, %r10d
	ja	.L179
	testl	%r10d, %r10d
	je	.L267
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	movl	%r10d, %esi
	movl	$1, %edi
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L299:
	addq	$1, %rdi
.L268:
	movq	%rdi, %rcx
	salq	$5, %rcx
	addq	%rbx, %rcx
	movq	64(%rcx), %r8
	cmpq	%rdx, 56(%rcx)
	jge	.L267
	cmpq	%rax, %r8
	jge	.L267
	cmpq	%rdi, %rsi
	jne	.L299
	movq	72(%rbx), %rdi
	cmpq	%rdi, 64(%rbx)
	movl	%r12d, %r15d
	movq	24(%rbx), %rdi
	setle	%cl
	cmpq	%rdi, 32(%rbx)
	setle	%dil
	andl	%edi, %ecx
	xorl	$1, %ecx
	cmpl	%r10d, 12(%rsp)
	setg	%dil
	orb	%dil, %cl
	jne	.L267
	cmpl	%r12d, %r10d
	jl	.L267
	movl	$1, %edi
	cmpl	%r12d, 12(%rsp)
	jne	.L273
	jmp	.L271
	.p2align 4,,10
	.p2align 3
.L300:
	addq	$1, %rdi
.L273:
	movq	%rdi, %rcx
	salq	$5, %rcx
	addq	%rbx, %rcx
	movq	64(%rcx), %r8
	cmpq	56(%rcx), %rdx
	jle	.L272
	cmpq	%r8, %rax
	jle	.L272
	cmpq	%rdi, %rsi
	jne	.L300
	movl	$1, %edi
	jmp	.L274
	.p2align 4,,10
	.p2align 3
.L301:
	addq	$1, %rdi
.L274:
	movq	%rdi, %rcx
	salq	$5, %rcx
	addq	%rbx, %rcx
	movq	64(%rcx), %r8
	cmpq	56(%rcx), %rdx
	jle	.L275
	cmpq	%r8, %rax
	jle	.L275
	cmpq	%rdi, %rsi
	jne	.L301
	movq	%r12, %rax
	movq	56(%r13), %rdi
	salq	$5, %rax
	movq	56(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	movl	(%rbx), %edi
	movq	%rax, %rbp
	cmpl	$2000, %edi
	ja	.L179
	testl	%edi, %edi
	je	.L277
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rax
	leal	1(%rdi), %r10d
	movl	$1, %esi
	.p2align 4
	.p2align 3
.L278:
	movq	%rsi, %rcx
	salq	$5, %rcx
	addq	%rbx, %rcx
	movq	64(%rcx), %r8
	cmpq	%rdx, 56(%rcx)
	jge	.L277
	cmpq	%rax, %r8
	jge	.L277
	addq	$1, %rsi
	cmpq	%rsi, %r10
	jne	.L278
	movq	72(%rbx), %rdx
	cmpq	%rdx, 64(%rbx)
	setle	%dl
	movq	24(%rbx), %rsi
	cmpq	%rsi, 32(%rbx)
	setle	%cl
	andl	%ecx, %edx
	xorl	$1, %edx
	cmpl	%edi, 12(%rsp)
	setg	%cl
	orb	%cl, %dl
	jne	.L277
	cmpl	%edi, %r15d
	jg	.L277
	movq	%r12, %rdx
	movq	64(%r13), %rdi
	imulq	%rbp, %rbp
	salq	$5, %rdx
	movq	64(%rbx,%rdx), %rsi
	movq	%rax, %rdx
	call	boids__torus_delta@PLT
	movq	24(%rbx), %rdx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rax, %rbp
	cmpq	%rdx, %rbp
	jge	.L271
	movl	24(%rsp), %eax
	testl	%eax, %eax
	jle	.L281
	movq	32(%rsp), %rax
	jmp	.L282
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L383:
	addq	$4, %rax
	cmpq	%rax, %r14
	je	.L281
.L282:
	cmpl	%r15d, (%rax)
	jne	.L383
.L271:
	cmpq	%r12, 16(%rsp)
	je	.L169
	addq	$1, %r12
	jmp	.L283
.L368:
	movl	24(%rsp), %eax
	movq	%rax, %rbp
	jmp	.L197
	.p2align 4,,10
	.p2align 3
.L272:
	leaq	.LC17(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L236:
	leaq	.LC24(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L375:
	movl	$19, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Index_Check@PLT
.L377:
	leaq	.LC25(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L380:
	movl	$81, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Index_Check@PLT
.L281:
	leaq	.LC26(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L382:
	movl	$82, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L172:
	leaq	.LC19(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L371:
	movl	$11, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L372:
	movl	$12, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Index_Check@PLT
.L196:
	leaq	.LC21(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE17:
	.size	boids__flocks__find_neighbours, .-boids__flocks__find_neighbours
	.section	.rodata.str1.8
	.align 8
.LC29:
	.string	"failed precondition from boids-flocks.ads:93"
	.align 8
.LC30:
	.string	"failed postcondition from boids-flocks.ads:95"
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__separation
	.type	boids__flocks__separation, @function
boids__flocks__separation:
.LFB21:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movl	(%rdi), %r12d
	movl	%esi, 8(%rsp)
	cmpl	$2000, %r12d
	ja	.L396
	movq	64(%rdi), %rax
	cmpq	%rax, 72(%rdi)
	movq	%rdi, %rbx
	movq	%rdx, %r9
	setge	%r11b
	movq	32(%rdi), %r10
	cmpq	24(%rdi), %r10
	movl	%ecx, %r8d
	setle	%al
	andl	%eax, %r11d
	testl	%r12d, %r12d
	je	.L386
	movq	8(%rdi), %rdi
	movq	16(%rbx), %rsi
	leal	1(%r12), %ebp
	movl	$1, %ecx
	jmp	.L388
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L461:
	addq	$1, %rcx
	cmpq	%rcx, %rbp
	je	.L386
.L388:
	movq	%rcx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	cmpq	%rdi, 56(%rax)
	setge	%dl
	cmpq	%rsi, 64(%rax)
	setge	%al
	orb	%al, %dl
	je	.L461
	testl	%r8d, %r8d
	jle	.L391
.L435:
	movq	%r9, %r14
	leaq	(%r9,%r8,4), %r11
	movq	%r9, %rax
	jmp	.L392
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L463:
	addq	$4, %rax
	cmpq	%r11, %rax
	je	.L462
.L392:
	cmpl	%r12d, (%rax)
	jle	.L463
.L391:
	leaq	.LC29(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L386:
	movl	8(%rsp), %eax
	xorl	$1, %r11d
	cmpl	%r8d, %eax
	cmovl	%r8d, %eax
	cmpl	%eax, %r12d
	setl	%dl
	orl	%r11d, %edx
	testl	%r8d, %r8d
	jg	.L435
	testb	%dl, %dl
	jne	.L391
	xorl	%r8d, %r8d
	xorl	%ecx, %ecx
.L394:
	movq	%r8, %rax
	movq	%rcx, %rdx
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L462:
	.cfi_restore_state
	testb	%dl, %dl
	jne	.L391
	imulq	%r10, %r10
	movslq	8(%rsp), %r15
	movq	%r11, 24(%rsp)
	xorl	%ebp, %ebp
	movq	$0, 16(%rsp)
	salq	$5, %r15
	movq	%r10, (%rsp)
	leaq	(%r15,%rbx), %r13
	.p2align 4
	.p2align 3
.L434:
	cmpl	$2000, %r12d
	ja	.L396
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	setle	%r11b
	movq	24(%rbx), %rax
	cmpq	%rax, 32(%rbx)
	setle	%al
	movl	(%r14), %r8d
	andl	%eax, %r11d
	testl	%r12d, %r12d
	je	.L397
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rcx
	movl	%r12d, %edi
	movl	$1, %esi
	jmp	.L399
	.p2align 4,,10
	.p2align 3
.L436:
	addq	$1, %rsi
.L399:
	movq	%rsi, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r9
	cmpq	%rdx, 56(%rax)
	jge	.L398
	cmpq	%rcx, %r9
	jge	.L398
	cmpq	%rdi, %rsi
	jne	.L436
	xorl	$1, %r11d
	cmpl	%r12d, 8(%rsp)
	setg	%al
	orb	%al, %r11b
	jne	.L398
	cmpl	%r12d, %r8d
	jg	.L398
	movl	$1, %esi
	jmp	.L400
	.p2align 4,,10
	.p2align 3
.L438:
	addq	$1, %rsi
.L400:
	movq	%rsi, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r9
	cmpq	56(%rax), %rdx
	jle	.L411
	cmpq	%r9, %rcx
	jle	.L411
	cmpq	%rdi, %rsi
	jne	.L438
.L403:
	movslq	%r8d, %r15
	movq	56(%r13), %rdi
	movl	%r8d, 12(%rsp)
	movq	%r15, %rax
	salq	$5, %rax
	movq	56(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	movl	(%rbx), %edi
	movq	%rax, %r12
	cmpl	$2000, %edi
	ja	.L396
	testl	%edi, %edi
	movl	12(%rsp), %r8d
	je	.L404
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rcx
	leal	1(%rdi), %r10d
	movl	$1, %esi
	.p2align 4
	.p2align 3
.L406:
	movq	%rsi, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r9
	cmpq	%rdx, 56(%rax)
	jge	.L423
	cmpq	%rcx, %r9
	jge	.L423
	addq	$1, %rsi
	cmpq	%r10, %rsi
	jne	.L406
.L404:
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	setle	%al
	movq	24(%rbx), %rcx
	cmpq	%rcx, 32(%rbx)
	setle	%dl
	andl	%edx, %eax
	xorl	$1, %eax
	cmpl	%edi, 8(%rsp)
	setg	%dl
	orb	%dl, %al
	jne	.L423
	cmpl	%edi, %r8d
	jg	.L423
	salq	$5, %r15
	movq	16(%rbx), %rdx
	movq	64(%r13), %rdi
	imulq	%r12, %r12
	movq	64(%rbx,%r15), %rsi
	call	boids__torus_delta@PLT
	imulq	%rax, %rax
	addq	%rax, %r12
	cmpq	%r12, (%rsp)
	jle	.L409
	movl	(%rbx), %edi
	cmpl	$2000, %edi
	ja	.L396
	testl	%edi, %edi
	je	.L410
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rcx
	leal	1(%rdi), %r8d
	movl	$1, %eax
	.p2align 4
	.p2align 3
.L412:
	movq	%rax, %rsi
	salq	$5, %rsi
	addq	%rbx, %rsi
	movq	64(%rsi), %r9
	cmpq	%rdx, 56(%rsi)
	jge	.L411
	cmpq	%rcx, %r9
	jge	.L411
	addq	$1, %rax
	cmpq	%r8, %rax
	jne	.L412
.L410:
	movq	72(%rbx), %rcx
	cmpq	%rcx, 64(%rbx)
	setle	%dl
	movq	24(%rbx), %rcx
	cmpq	%rcx, 32(%rbx)
	setle	%cl
	movslq	(%r14), %rax
	andl	%ecx, %edx
	xorl	$1, %edx
	cmpl	%edi, 8(%rsp)
	setg	%cl
	orb	%cl, %dl
	jne	.L411
	cmpl	%edi, %eax
	jg	.L411
	salq	$5, %rax
	movq	8(%rbx), %rdx
	movq	56(%r13), %rdi
	movq	56(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	movq	(%rsp), %rcx
	movq	%rcx, %r15
	subq	%r12, %r15
	imulq	%r15, %rax
	jo	.L420
	cqto
	idivq	%rcx
	subq	%rax, %rbp
	jo	.L420
	movabsq	$4611686018427387904, %rax
	addq	%rbp, %rax
	js	.L464
	movl	(%rbx), %edi
	cmpl	$2000, %edi
	ja	.L396
	testl	%edi, %edi
	je	.L422
	movq	8(%rbx), %rdx
	movq	16(%rbx), %rcx
	leal	1(%rdi), %r8d
	movl	$1, %esi
	.p2align 4
	.p2align 3
.L424:
	movq	%rsi, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r9
	cmpq	%rdx, 56(%rax)
	jge	.L423
	cmpq	%rcx, %r9
	jge	.L423
	addq	$1, %rsi
	cmpq	%rsi, %r8
	jne	.L424
.L422:
	movq	72(%rbx), %rcx
	cmpq	%rcx, 64(%rbx)
	setle	%dl
	movq	24(%rbx), %rcx
	cmpq	%rcx, 32(%rbx)
	setle	%cl
	movslq	(%r14), %rax
	andl	%ecx, %edx
	xorl	$1, %edx
	cmpl	%edi, 8(%rsp)
	setg	%cl
	orb	%cl, %dl
	jne	.L423
	cmpl	%edi, %eax
	jg	.L423
	salq	$5, %rax
	movq	16(%rbx), %rdx
	movq	64(%r13), %rdi
	movq	64(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	imulq	%r15, %rax
	jo	.L432
	cqto
	idivq	(%rsp)
	movq	16(%rsp), %rdx
	subq	%rax, %rdx
	jo	.L432
	movabsq	$4611686018427387904, %rax
	addq	%rdx, %rax
	js	.L465
	movq	$-16777216, %rax
	cmpq	%rax, %rbp
	cmovl	%rax, %rbp
	movl	$16777216, %eax
	cmpq	%rax, %rbp
	cmovg	%rax, %rbp
	movq	$-16777216, %rax
	cmpq	%rax, %rdx
	cmovge	%rdx, %rax
	movq	%rax, %rdi
	movl	$16777216, %eax
	cmpq	%rax, %rdi
	cmovle	%rdi, %rax
	movq	%rax, 16(%rsp)
.L409:
	addq	$4, %r14
	cmpq	%r14, 24(%rsp)
	je	.L458
	movl	(%rbx), %r12d
	jmp	.L434
	.p2align 4,,10
	.p2align 3
.L397:
	movl	8(%rsp), %eax
	xorl	$1, %r11d
	testl	%eax, %eax
	setg	%al
	orb	%al, %r11b
	jne	.L398
	testl	%r8d, %r8d
	jg	.L398
	movq	8(%rbx), %rdx
	jmp	.L403
.L458:
	movq	16(%rsp), %r9
	movq	%rbp, %rax
	imulq	%rbp, %rax
	movq	%r9, %rdx
	imulq	%r9, %rdx
	addq	%rdx, %rax
	movq	%rax, %rcx
	je	.L439
	movq	40(%rbx), %r8
	movl	8(%rsp), %esi
	movq	%r9, %rcx
	movq	%rbx, %rdi
	movq	%rbp, %rdx
	call	boids__flocks__steer
	movq	80(%rbx), %rdi
	imulq	40(%rbx), %rdi
	movq	%rax, %rsi
	movq	%rax, %r8
	movq	%rdx, %r9
	movq	%rdx, %rcx
	movabsq	$-6640827866535438581, %rax
	imulq	%rsi, %rsi
	imulq	%rdi
	imulq	%r9, %r9
	leaq	(%rdx,%rdi), %rax
	sarq	$63, %rdi
	sarq	$6, %rax
	leaq	(%rsi,%r9), %rdx
	subq	%rdi, %rax
	imulq	%rax, %rax
	cmpq	%rdx, %rax
	jge	.L394
	leaq	.LC30(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L439:
	xorl	%r8d, %r8d
	jmp	.L394
.L396:
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.p2align 4,,10
	.p2align 3
.L411:
	leaq	.LC15(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L420:
	movl	$61, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Overflow_Check@PLT
	.p2align 4,,10
	.p2align 3
.L423:
	leaq	.LC16(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L398:
	leaq	.LC17(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L432:
	movl	$62, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Overflow_Check@PLT
.L465:
	movl	$62, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L464:
	movl	$61, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
	.cfi_endproc
.LFE21:
	.size	boids__flocks__separation, .-boids__flocks__separation
	.section	.rodata.str1.8
	.align 8
.LC31:
	.string	"failed precondition from boids-flocks.ads:99"
	.align 8
.LC32:
	.string	"failed postcondition from boids-flocks.ads:101"
	.section	.rodata
	.align 8
.LC4:
	.long	1
	.long	46
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__alignment
	.type	boids__flocks__alignment, @function
boids__flocks__alignment:
.LFB23:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movl	(%rdi), %r9d
	cmpl	$2000, %r9d
	ja	.L488
	movq	64(%rdi), %rax
	cmpq	%rax, 72(%rdi)
	movq	%rdx, %r8
	movl	%ecx, %r10d
	setge	%al
	movq	24(%rdi), %rbx
	cmpq	%rbx, 32(%rdi)
	setle	%dl
	andl	%edx, %eax
	movl	%eax, %r11d
	testl	%r9d, %r9d
	je	.L468
	movq	8(%rdi), %rbp
	movq	16(%rdi), %rbx
	leal	1(%r9), %r12d
	movl	$1, %ecx
	jmp	.L470
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L489:
	addq	$1, %rcx
	cmpq	%rcx, %r12
	je	.L468
.L470:
	movq	%rcx, %rax
	salq	$5, %rax
	addq	%rdi, %rax
	cmpq	%rbp, 56(%rax)
	setge	%dl
	cmpq	%rbx, 64(%rax)
	setge	%al
	orb	%al, %dl
	je	.L489
	testl	%r10d, %r10d
	jle	.L473
.L479:
	leaq	(%r8,%r10,4), %r10
	movq	%r8, %rax
	jmp	.L474
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L491:
	addq	$4, %rax
	cmpq	%rax, %r10
	je	.L490
.L474:
	cmpl	%r9d, (%rax)
	jle	.L491
.L473:
	leaq	.LC31(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L468:
	movl	%r11d, %eax
	movl	%r10d, %edx
	xorl	$1, %eax
	cmpl	%r10d, %esi
	cmovge	%esi, %edx
	cmpl	%edx, %r9d
	setl	%dl
	orl	%eax, %edx
	testl	%r10d, %r10d
	jg	.L479
	testb	%dl, %dl
	jne	.L473
	testl	%r10d, %r10d
	je	.L480
	xorl	%edx, %edx
	xorl	%ecx, %ecx
.L477:
	movq	48(%rdi), %r8
	xchgq	%rcx, %rdx
	movq	%rdi, 8(%rsp)
	call	boids__flocks__steer
	movq	8(%rsp), %rdi
	movq	%rax, %rcx
	movq	%rax, %r9
	movq	%rdx, %r10
	movq	%rdx, %r8
	movq	80(%rdi), %rsi
	imulq	48(%rdi), %rsi
	movabsq	$-6640827866535438581, %rax
	imulq	%rcx, %rcx
	imulq	%r10, %r10
	imulq	%rsi
	addq	%r10, %rcx
	addq	%rsi, %rdx
	sarq	$63, %rsi
	sarq	$6, %rdx
	subq	%rsi, %rdx
	imulq	%rdx, %rdx
	cmpq	%rcx, %rdx
	jl	.L492
	movq	%r9, %rax
	movq	%r8, %rdx
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L490:
	.cfi_restore_state
	testb	%dl, %dl
	jne	.L473
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	.p2align 4
	.p2align 3
.L478:
	movslq	(%r8), %rax
	movq	$-16777216, %r9
	addq	$2, %rax
	salq	$5, %rax
	addq	%rdi, %rax
	addq	8(%rax), %rcx
	cmpq	%r9, %rcx
	cmovl	%r9, %rcx
	movl	$16777216, %r9d
	cmpq	%r9, %rcx
	cmovg	%r9, %rcx
	addq	16(%rax), %rdx
	movq	$-16777216, %rax
	cmpq	%rax, %rdx
	cmovl	%rax, %rdx
	movl	$16777216, %eax
	cmpq	%rax, %rdx
	cmovg	%rax, %rdx
	addq	$4, %r8
	cmpq	%r10, %r8
	jne	.L478
	jmp	.L477
	.p2align 4,,10
	.p2align 3
.L480:
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movq	%r9, %rax
	movq	%r8, %rdx
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L488:
	.cfi_restore_state
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L492:
	leaq	.LC32(%rip), %rdi
	leaq	.LC4(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE23:
	.size	boids__flocks__alignment, .-boids__flocks__alignment
	.section	.rodata.str1.8
	.align 8
.LC33:
	.string	"failed precondition from boids-flocks.ads:105"
	.align 8
.LC34:
	.string	"failed postcondition from boids-flocks.ads:107"
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__cohesion
	.type	boids__flocks__cohesion, @function
boids__flocks__cohesion:
.LFB25:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	(%rdi), %r9d
	cmpl	$2000, %r9d
	ja	.L506
	movq	64(%rdi), %rax
	cmpq	%rax, 72(%rdi)
	movl	%ecx, %r8d
	movq	%rdx, %r15
	setge	%al
	movq	24(%rdi), %rcx
	cmpq	%rcx, 32(%rdi)
	movq	%rdi, %rbx
	setle	%dl
	movl	%esi, %ebp
	andl	%edx, %eax
	movl	%eax, %r10d
	testl	%r9d, %r9d
	je	.L495
	movq	8(%rdi), %rsi
	leal	1(%r9), %r11d
	movq	16(%rdi), %rdi
	movl	$1, %ecx
	jmp	.L497
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L534:
	addq	$1, %rcx
	cmpq	%rcx, %r11
	je	.L495
.L497:
	movq	%rcx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	cmpq	%rsi, 56(%rax)
	setge	%dl
	cmpq	%rdi, 64(%rax)
	setge	%al
	orb	%al, %dl
	je	.L534
	testl	%r8d, %r8d
	jle	.L500
.L517:
	leaq	(%r15,%r8,4), %rax
	movq	%rax, 8(%rsp)
	movq	%r15, %rax
	jmp	.L501
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L536:
	addq	$4, %rax
	cmpq	%rax, 8(%rsp)
	je	.L535
.L501:
	cmpl	%r9d, (%rax)
	jle	.L536
.L500:
	leaq	.LC33(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L495:
	movl	%r10d, %eax
	movl	%r8d, %edx
	xorl	$1, %eax
	cmpl	%r8d, %ebp
	cmovge	%ebp, %edx
	cmpl	%edx, %r9d
	setl	%dl
	orl	%eax, %edx
	testl	%r8d, %r8d
	jg	.L517
	testb	%dl, %dl
	jne	.L500
	testl	%r8d, %r8d
	je	.L518
	xorl	%r13d, %r13d
	xorl	%r14d, %r14d
.L504:
	movq	56(%rbx), %r8
	movq	%r13, %rcx
	movl	%ebp, %esi
	movq	%rbx, %rdi
	movq	%r14, %rdx
	call	boids__flocks__steer
	movq	80(%rbx), %rsi
	imulq	56(%rbx), %rsi
	movq	%rax, %rcx
	movq	%rax, %r8
	movq	%rdx, %r9
	movq	%rdx, %rdi
	movabsq	$-6640827866535438581, %rax
	imulq	%rcx, %rcx
	imulq	%rsi
	imulq	%r9, %r9
	leaq	(%rdx,%rsi), %rax
	sarq	$63, %rsi
	sarq	$6, %rax
	leaq	(%rcx,%r9), %rdx
	subq	%rsi, %rax
	imulq	%rax, %rax
	cmpq	%rdx, %rax
	jl	.L537
.L503:
	movq	%r8, %rax
	movq	%rdi, %rdx
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L535:
	.cfi_restore_state
	testb	%dl, %dl
	jne	.L500
	movslq	%ebp, %rcx
	xorl	%r13d, %r13d
	xorl	%r14d, %r14d
	salq	$5, %rcx
	leaq	(%rbx,%rcx), %r12
	.p2align 4
	.p2align 3
.L505:
	cmpl	$2000, %r9d
	ja	.L506
	testl	%r9d, %r9d
	je	.L507
	movq	8(%rbx), %rsi
	movq	16(%rbx), %rdi
	leal	1(%r9), %r10d
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L509:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r8
	cmpq	%rsi, 56(%rax)
	jge	.L508
	cmpq	%rdi, %r8
	jge	.L508
	addq	$1, %rdx
	cmpq	%r10, %rdx
	jne	.L509
.L507:
	movq	72(%rbx), %rcx
	cmpq	%rcx, 64(%rbx)
	setle	%dl
	movq	24(%rbx), %rcx
	cmpq	%rcx, 32(%rbx)
	setle	%sil
	movslq	(%r15), %rax
	andl	%esi, %edx
	xorl	$1, %edx
	cmpl	%r9d, %ebp
	setg	%sil
	orb	%sil, %dl
	jne	.L508
	cmpl	%r9d, %eax
	jg	.L508
	salq	$5, %rax
	movq	8(%rbx), %rdx
	movq	56(%r12), %rdi
	movq	56(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	movl	(%rbx), %r8d
	movq	%rax, %r10
	cmpl	$2000, %r8d
	ja	.L506
	testl	%r8d, %r8d
	je	.L512
	movq	8(%rbx), %rsi
	movq	16(%rbx), %rdi
	leal	1(%r8), %r9d
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L514:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %r11
	cmpq	%rsi, 56(%rax)
	jge	.L513
	cmpq	%rdi, %r11
	jge	.L513
	addq	$1, %rdx
	cmpq	%rdx, %r9
	jne	.L514
.L512:
	movq	$-16777216, %rax
	addq	%r10, %r14
	movq	72(%rbx), %rcx
	cmpq	%rax, %r14
	cmovl	%rax, %r14
	movl	$16777216, %eax
	cmpq	%rax, %r14
	cmovg	%rax, %r14
	cmpq	%rcx, 64(%rbx)
	movq	24(%rbx), %rcx
	setle	%dl
	cmpq	%rcx, 32(%rbx)
	movslq	(%r15), %rax
	setle	%sil
	andl	%esi, %edx
	xorl	$1, %edx
	cmpl	%r8d, %ebp
	setg	%sil
	orb	%sil, %dl
	jne	.L513
	cmpl	%r8d, %eax
	jg	.L513
	salq	$5, %rax
	movq	16(%rbx), %rdx
	movq	64(%r12), %rdi
	movq	64(%rbx,%rax), %rsi
	call	boids__torus_delta@PLT
	addq	%rax, %r13
	movq	$-16777216, %rax
	cmpq	%rax, %r13
	cmovl	%rax, %r13
	movl	$16777216, %eax
	cmpq	%rax, %r13
	cmovg	%rax, %r13
	addq	$4, %r15
	cmpq	%r15, 8(%rsp)
	je	.L504
	movl	(%rbx), %r9d
	jmp	.L505
.L518:
	xorl	%r8d, %r8d
	xorl	%edi, %edi
	jmp	.L503
.L506:
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.p2align 4,,10
	.p2align 3
.L513:
	leaq	.LC16(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L508:
	leaq	.LC15(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L537:
	leaq	.LC34(%rip), %rdi
	leaq	.LC4(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE25:
	.size	boids__flocks__cohesion, .-boids__flocks__cohesion
	.section	.rodata.str1.8
	.align 8
.LC35:
	.string	"Loop_Invariant failed at boids-flocks.adb:115"
	.align 8
.LC36:
	.string	"Loop_Invariant failed at boids-flocks.adb:118"
	.align 8
.LC37:
	.string	"Loop_Invariant failed at boids-flocks.adb:126"
	.align 8
.LC38:
	.string	"Loop_Invariant failed at boids-flocks.adb:129"
	.align 8
.LC39:
	.string	"Loop_Invariant failed at boids-flocks.adb:132"
	.text
	.align 2
	.p2align 4
	.type	boids__flocks__step___wrapped_statements.5, @function
boids__flocks__step___wrapped_statements.5:
.LFB28:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%r10, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$72120, %rsp
	.cfi_def_cfa_offset 72176
	movq	(%r10), %rbx
	movl	(%rbx), %r10d
	cmpl	$2000, %r10d
	ja	.L585
	testl	%r10d, %r10d
	je	.L538
	movq	8(%rbx), %rax
	leaq	88(%rbx), %rsi
	movl	$64000, %edx
	leaq	8112(%rsp), %rdi
	movl	%r10d, (%rsp)
	movl	$2, %r13d
	movq	%rax, 16(%rsp)
	movq	16(%rbx), %rax
	movq	%rax, 32(%rsp)
	movq	24(%rbx), %rax
	movq	%rax, 40(%rsp)
	movq	32(%rbx), %rax
	movq	%rax, 48(%rsp)
	movq	40(%rbx), %rax
	movq	%rax, 96(%rsp)
	movq	48(%rbx), %rax
	movq	%rax, 88(%rsp)
	movq	56(%rbx), %rax
	movq	%rax, 80(%rsp)
	movq	64(%rbx), %rax
	movq	%rax, 72(%rsp)
	movq	72(%rbx), %rax
	movq	%rax, 64(%rsp)
	movq	80(%rbx), %rax
	movq	%rax, 56(%rsp)
	call	memcpy@PLT
	movl	(%rsp), %r10d
	movq	%rbx, %rdi
	leal	2(%r10), %eax
	movl	%r10d, 108(%rsp)
	movq	%rax, 24(%rsp)
	.p2align 4
	.p2align 3
.L551:
	leal	-1(%r13), %ebp
	leaq	112(%rsp), %rdx
	movl	%ebp, %esi
	call	boids__flocks__find_neighbours
	movq	(%r14), %rdi
	movl	%ebp, %esi
	leaq	112(%rsp), %rdx
	movl	%eax, %ecx
	movl	%eax, %r12d
	call	boids__flocks__separation
	movq	(%r14), %rdi
	movl	%r12d, %ecx
	movl	%ebp, %esi
	movq	%rdx, %r15
	leaq	112(%rsp), %rdx
	movq	%rax, %rbx
	call	boids__flocks__alignment
	movq	(%r14), %rdi
	movl	%r12d, %ecx
	movl	%ebp, %esi
	movq	%rdx, 8(%rsp)
	leaq	112(%rsp), %rdx
	leaq	1(%r13), %rbp
	movq	%rax, (%rsp)
	call	boids__flocks__cohesion
	movq	(%r14), %rcx
	movq	%rax, %r10
	movq	%rbp, %rax
	movq	%rdx, %r9
	movq	(%rsp), %rdx
	salq	$5, %rax
	addq	%rcx, %rax
	addq	8(%rax), %rbx
	addq	%rbx, %rdx
	movq	8(%rsp), %rbx
	addq	%r10, %rdx
	movq	$-16777216, %r10
	cmpq	%r10, %rdx
	cmovl	%r10, %rdx
	movl	$16777216, %r10d
	cmpq	%r10, %rdx
	cmovg	%r10, %rdx
	addq	16(%rax), %r15
	leaq	(%r15,%rbx), %rax
	addq	%r9, %rax
	movq	$-16777216, %r9
	cmpq	%r9, %rax
	cmovl	%r9, %rax
	movl	$16777216, %r9d
	cmpq	%r9, %rax
	cmovg	%r9, %rax
	leaq	4003(%r13), %r9
	salq	$4, %r9
	xchgq	%rdx, %rax
	leaq	(%rcx,%r9), %rbx
	movq	%rdx, %rsi
	movq	64(%rcx), %rdx
	movq	72(%rcx), %rcx
	movq	%rax, %rdi
	call	boids__clamp_speed@PLT
	movq	(%r14), %rdi
	movq	%rax, 8(%rbx)
	movl	(%rdi), %ecx
	movq	8(%rdi), %r12
	movq	%rdx, 16(%rbx)
	cmpq	16(%rsp), %r12
	je	.L586
.L541:
	movl	$1, %esi
.L543:
	movq	8112(%rsp), %rax
	cmpq	%rax, 88(%rdi)
	jne	.L544
	movl	$1, %edx
	xorl	%eax, %eax
	jmp	.L546
	.p2align 4,,10
	.p2align 3
.L587:
	movq	%rdx, %rax
	salq	$5, %rax
	leaq	(%rdi,%rax), %r8
	movq	8096(%rsp,%rax), %rbx
	cmpq	%rbx, 72(%r8)
	jne	.L544
	movq	8104(%rsp,%rax), %rax
	cmpq	%rax, 80(%r8)
	jne	.L544
	cmpq	$2000, %rdx
	je	.L545
	addq	$1, %rdx
	leaq	-1(%rdx), %rax
	movq	%rax, %r8
	salq	$5, %r8
	movq	8112(%rsp,%r8), %rbx
	cmpq	%rbx, 88(%rdi,%r8)
	jne	.L544
.L546:
	salq	$5, %rax
	movq	8120(%rsp,%rax), %rbx
	cmpq	%rbx, 96(%rdi,%rax)
	je	.L587
.L544:
	leaq	.LC35(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L595:
	movq	%rbx, %r13
	cmpq	%rbx, (%rsp)
	jne	.L567
.L538:
	addq	$72120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L545:
	.cfi_restore_state
	testb	%sil, %sil
	jne	.L544
	movq	64(%rdi), %r11
	movq	72(%rdi), %rbx
	movl	$1, %esi
	movq	%r11, %r9
	movq	%rbx, %r10
	imulq	%r11, %r9
	imulq	%rbx, %r10
	jmp	.L549
	.p2align 4,,10
	.p2align 3
.L589:
	cmpq	%rax, %r10
	jl	.L548
	addq	$1, %rsi
	cmpq	%rsi, %r13
	je	.L588
.L549:
	leaq	4004(%rsi), %rdx
	salq	$4, %rdx
	addq	%rdi, %rdx
	movq	8(%rdx), %rax
	movq	16(%rdx), %rdx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rdx, %rax
	cmpq	%rax, %r9
	jle	.L589
.L548:
	leaq	.LC36(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L588:
	movq	%rbp, %r13
	cmpq	%rbp, 24(%rsp)
	jne	.L551
	movq	%rbx, 64(%rsp)
	movq	%rdi, %rbx
	movq	%r11, 56(%rsp)
	cmpl	$2000, %ecx
	ja	.L590
	testl	%ecx, %ecx
	je	.L538
	movq	16(%rdi), %rax
	leaq	64088(%rdi), %rsi
	movl	$32000, %edx
	movl	%ecx, (%rsp)
	movl	$2, %r13d
	movq	%rax, 8(%rsp)
	movq	24(%rdi), %rax
	movq	%rax, 16(%rsp)
	movq	32(%rdi), %rax
	movq	%rax, 24(%rsp)
	movq	40(%rdi), %rax
	movq	%rax, 48(%rsp)
	movq	48(%rdi), %rax
	movq	%rax, 40(%rsp)
	movq	56(%rdi), %rax
	movq	%rax, 32(%rsp)
	movq	80(%rdi), %rax
	leaq	8112(%rsp), %rdi
	movq	%rax, 72(%rsp)
	call	memcpy@PLT
	movl	(%rsp), %ecx
	movq	%r12, %r10
	movq	%rbx, %rsi
	leal	2(%rcx), %eax
	movl	%ecx, 80(%rsp)
	movq	%rax, (%rsp)
	.p2align 4
	.p2align 3
.L567:
	movq	%r13, %rax
	leaq	1(%r13), %rbx
	leaq	-1(%r13), %rbp
	salq	$4, %rax
	movq	%rbx, %r15
	salq	$5, %rbp
	movdqu	64056(%rax,%rsi), %xmm0
	salq	$5, %r15
	movq	%xmm0, %rdi
	movups	%xmm0, 8(%rsi,%r15)
	addq	56(%rsi,%rbp), %rdi
	movq	%r10, %rsi
	call	boids__wrap@PLT
	movq	%rax, %rsi
	movq	(%r14), %rax
	movq	%rsi, 56(%rax,%rbp)
	movq	16(%rax), %rsi
	movq	16(%rax,%r15), %rdi
	addq	64(%rax,%rbp), %rdi
	call	boids__wrap@PLT
	movq	(%r14), %rsi
	movq	8(%rsi), %r10
	movl	(%rsi), %ecx
	movq	%rax, 64(%rsi,%rbp)
	cmpq	%r10, %r12
	je	.L591
.L553:
	movl	$1, %edi
.L555:
	movq	8112(%rsp), %rax
	cmpq	%rax, 64088(%rsi)
	jne	.L556
	movl	$1, %edx
	xorl	%eax, %eax
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L592:
	cmpq	$2000, %rdx
	je	.L557
	addq	$1, %rdx
	leaq	-1(%rdx), %rax
	movq	%rax, %r8
	salq	$4, %r8
	movq	8112(%rsp,%r8), %r15
	cmpq	%r15, 64088(%rsi,%r8)
	jne	.L556
.L558:
	salq	$4, %rax
	movq	8120(%rsp,%rax), %r15
	cmpq	%r15, 64096(%rsi,%rax)
	je	.L592
.L556:
	leaq	.LC37(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L557:
	testb	%dil, %dil
	jne	.L556
	cmpl	$2000, %ecx
	ja	.L593
	testl	%ecx, %ecx
	jne	.L594
.L561:
	movq	64(%rsi), %rdi
	movq	72(%rsi), %r11
	movl	$1, %ecx
	imulq	%rdi, %rdi
	imulq	%r11, %r11
	jmp	.L565
	.p2align 4,,10
	.p2align 3
.L596:
	cmpq	%rax, %r11
	jl	.L564
	addq	$1, %rcx
	cmpq	%rcx, %r13
	je	.L595
.L565:
	leaq	2(%rcx), %rdx
	salq	$5, %rdx
	addq	%rsi, %rdx
	movq	8(%rdx), %rax
	movq	16(%rdx), %rdx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rdx, %rax
	cmpq	%rax, %rdi
	jle	.L596
.L564:
	leaq	.LC39(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L591:
	movq	8(%rsp), %rax
	cmpq	16(%rsi), %rax
	jne	.L553
	movq	16(%rsp), %rax
	cmpq	24(%rsi), %rax
	jne	.L553
	movq	24(%rsp), %rax
	cmpq	32(%rsi), %rax
	jne	.L553
	movq	48(%rsp), %rax
	cmpq	40(%rsi), %rax
	jne	.L553
	movq	40(%rsp), %rax
	cmpq	48(%rsi), %rax
	jne	.L553
	movq	32(%rsp), %rax
	cmpq	56(%rsi), %rax
	jne	.L553
	movq	56(%rsp), %rax
	cmpq	64(%rsi), %rax
	jne	.L553
	movq	64(%rsp), %rax
	cmpq	72(%rsi), %rax
	jne	.L553
	movq	72(%rsp), %rax
	cmpq	%rax, 80(%rsi)
	setne	%dil
	cmpl	%ecx, 80(%rsp)
	setne	%al
	orl	%eax, %edi
	jmp	.L555
	.p2align 4,,10
	.p2align 3
.L594:
	movq	16(%rsi), %rdi
	addl	$1, %ecx
	movl	$1, %edx
	jmp	.L563
	.p2align 4,,10
	.p2align 3
.L597:
	cmpq	%r8, %rdi
	jle	.L562
	addq	$1, %rdx
	cmpq	%rcx, %rdx
	je	.L561
.L563:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rsi, %rax
	movq	64(%rax), %r8
	cmpq	56(%rax), %r10
	jg	.L597
.L562:
	leaq	.LC38(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L586:
	movq	32(%rsp), %rax
	cmpq	%rax, 16(%rdi)
	jne	.L541
	movq	40(%rsp), %rax
	cmpq	%rax, 24(%rdi)
	jne	.L541
	movq	48(%rsp), %rax
	cmpq	%rax, 32(%rdi)
	jne	.L541
	movq	96(%rsp), %rax
	cmpq	%rax, 40(%rdi)
	jne	.L541
	movq	88(%rsp), %rax
	cmpq	%rax, 48(%rdi)
	jne	.L541
	movq	80(%rsp), %rax
	cmpq	%rax, 56(%rdi)
	jne	.L541
	movq	72(%rsp), %rax
	cmpq	%rax, 64(%rdi)
	jne	.L541
	movq	64(%rsp), %rax
	cmpq	%rax, 72(%rdi)
	jne	.L541
	movq	56(%rsp), %rax
	cmpq	%rax, 80(%rdi)
	setne	%sil
	cmpl	108(%rsp), %ecx
	setne	%al
	orl	%eax, %esi
	jmp	.L543
.L585:
	movl	$106, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.p2align 4,,10
	.p2align 3
.L593:
	movl	$129, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L590:
	movl	$122, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.cfi_endproc
.LFE28:
	.size	boids__flocks__step___wrapped_statements.5, .-boids__flocks__step___wrapped_statements.5
	.section	.rodata.str1.8
	.align 8
.LC40:
	.string	"failed precondition from boids-flocks.ads:111"
	.align 8
.LC41:
	.string	"failed postcondition from boids-flocks.ads:112"
	.text
	.align 2
	.p2align 4
	.globl	boids__flocks__step
	.type	boids__flocks__step, @function
boids__flocks__step:
.LFB27:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	movl	(%rdi), %ebp
	leaq	160(%rsp), %rax
	movq	%rdi, 80(%rsp)
	movq	%rax, 88(%rsp)
	cmpl	$2000, %ebp
	ja	.L604
	movq	%rdi, %rbx
	testl	%ebp, %ebp
	je	.L600
	movq	8(%rbx), %rsi
	movq	16(%rbx), %r10
	leal	1(%rbp), %edi
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L602:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rsi, 56(%rax)
	jge	.L601
	cmpq	%r10, %rcx
	jge	.L601
	addq	$1, %rdx
	cmpq	%rdx, %rdi
	jne	.L602
.L600:
	movq	64(%rbx), %rax
	movq	72(%rbx), %r15
	movq	32(%rbx), %rdi
	movq	24(%rbx), %r13
	cmpq	%r15, %rax
	movq	%rax, (%rsp)
	setle	%dl
	cmpq	%r13, %rdi
	movq	%rdi, 8(%rsp)
	setle	%al
	andb	%al, %dl
	movb	%dl, 78(%rsp)
	je	.L601
	movq	8(%rbx), %rax
	leaq	80(%rsp), %r10
	movq	%rax, 16(%rsp)
	movq	16(%rbx), %rax
	movq	%rax, 24(%rsp)
	movq	40(%rbx), %rax
	movq	%rax, 32(%rsp)
	movq	48(%rbx), %rax
	movq	%rax, 40(%rsp)
	movq	56(%rbx), %rax
	movq	%rax, 48(%rsp)
	movq	80(%rbx), %rax
	movq	%rax, 56(%rsp)
	call	boids__flocks__step___wrapped_statements.5
	movl	(%rbx), %r11d
	cmpl	$2000, %r11d
	ja	.L604
	movq	64(%rbx), %r12
	movq	72(%rbx), %rdx
	movq	32(%rbx), %rax
	movq	24(%rbx), %r14
	cmpq	%rdx, %r12
	movq	8(%rbx), %r8
	setle	%sil
	cmpq	%r14, %rax
	setle	%cl
	andl	%ecx, %esi
	testl	%r11d, %r11d
	jne	.L625
	xorl	$1, %esi
	movb	%sil, 78(%rsp)
.L608:
	cmpq	%r8, 16(%rsp)
	jne	.L612
	movq	24(%rsp), %rdi
	cmpq	%rdi, 16(%rbx)
	setne	%cl
	cmpq	%r14, %r13
	setne	%sil
	orb	%cl, %sil
	jne	.L612
	cmpq	%rax, 8(%rsp)
	jne	.L612
	movq	32(%rsp), %rax
	cmpq	%rax, 40(%rbx)
	jne	.L612
	movq	40(%rsp), %rax
	cmpq	%rax, 48(%rbx)
	jne	.L612
	movq	48(%rsp), %rax
	cmpq	%rax, 56(%rbx)
	setne	%al
	cmpq	%r12, (%rsp)
	setne	%cl
	orb	%cl, %al
	jne	.L612
	cmpq	%rdx, %r15
	jne	.L612
	cmpl	%r11d, %ebp
	setne	%al
	orb	78(%rsp), %al
	jne	.L612
	movq	56(%rsp), %rax
	cmpq	%rax, 80(%rbx)
	jne	.L612
	addq	$104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L625:
	.cfi_restore_state
	movb	%sil, 64(%rsp)
	movq	16(%rbx), %r10
	movl	%r11d, %edi
	movl	$1, %r9d
	jmp	.L607
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L627:
	cmpq	%r9, %rdi
	je	.L626
	addq	$1, %r9
.L607:
	movq	%r9, %rsi
	salq	$5, %rsi
	addq	%rbx, %rsi
	cmpq	%r8, 56(%rsi)
	setge	%cl
	cmpq	%r10, 64(%rsi)
	setge	%sil
	orb	%sil, %cl
	je	.L627
.L606:
	movq	%r12, %r9
	movq	%rdx, %r10
	movq	%r15, 64(%rsp)
	movl	$1, %esi
	imulq	%r12, %r9
	movb	%cl, 79(%rsp)
	imulq	%rdx, %r10
	jmp	.L611
	.p2align 4,,10
	.p2align 3
.L629:
	cmpq	%r10, %rcx
	jg	.L623
	cmpq	%rdi, %rsi
	je	.L628
	addq	$1, %rsi
.L611:
	leaq	2(%rsi), %r15
	salq	$5, %r15
	addq	%rbx, %r15
	movq	8(%r15), %rcx
	movq	16(%r15), %r15
	imulq	%rcx, %rcx
	imulq	%r15, %r15
	addq	%r15, %rcx
	cmpq	%r9, %rcx
	jge	.L629
.L623:
	movq	64(%rsp), %r15
	jmp	.L608
	.p2align 4,,10
	.p2align 3
.L626:
	movzbl	64(%rsp), %ecx
	xorl	$1, %ecx
	jmp	.L606
	.p2align 4,,10
	.p2align 3
.L628:
	movzbl	79(%rsp), %ecx
	movq	64(%rsp), %r15
	movb	%cl, 78(%rsp)
	jmp	.L608
.L612:
	leaq	.LC41(%rip), %rdi
	leaq	.LC4(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L604:
	movl	$44, %esi
	leaq	.LC5(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L601:
	leaq	.LC40(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE27:
	.size	boids__flocks__step, .-boids__flocks__step
	.globl	boids__flocks_E
	.data
	.align 2
	.type	boids__flocks_E, @object
	.size	boids__flocks_E, 2
boids__flocks_E:
	.zero	2
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC10:
	.quad	10240
	.quad	4096
	.align 16
.LC12:
	.quad	100
	.quad	512
	.align 16
.LC13:
	.quad	1024
	.quad	32
	.ident	"GCC: (GNAT-FSF-builds) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
