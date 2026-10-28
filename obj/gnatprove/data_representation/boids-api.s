	.file	"boids-api.adb"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC5:
	.string	"failed precondition from boids-api.adb:8"
	.align 8
.LC6:
	.string	"failed postcondition from boids-api.adb:9"
	.section	.rodata
	.align 8
.LC2:
	.long	1
	.long	40
	.align 8
.LC0:
	.long	1
	.long	41
	.text
	.align 2
	.p2align 4
	.type	boids__api__next_random, @function
boids__api__next_random:
.LFB2:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	testq	%rdi, %rdi
	jle	.L9
	imull	$1664525, boids__api__rng(%rip), %eax
	xorl	%edx, %edx
	addl	$1013904223, %eax
	movl	%eax, boids__api__rng(%rip)
	shrl	$8, %eax
	divq	%rdi
	cmpq	%rdx, %rdi
	jle	.L10
	movq	%rdx, %rax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L9:
	.cfi_restore_state
	leaq	.LC5(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L10:
	leaq	.LC6(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE2:
	.size	boids__api__next_random, .-boids__api__next_random
	.section	.rodata
.LC7:
	.ascii	"boids-flocks.ads"
	.zero	1
	.section	.rodata.str1.8
	.align 8
.LC8:
	.string	"failed precondition from boids-api.adb:19"
	.section	.rodata
.LC9:
	.ascii	"boids-api.adb"
	.zero	1
	.section	.rodata.str1.8
	.align 8
.LC10:
	.string	"failed postcondition from boids-api.adb:20"
	.section	.rodata
	.align 8
.LC1:
	.long	1
	.long	42
	.text
	.align 2
	.p2align 4
	.type	boids__api__new_bird, @function
boids__api__new_bird:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$120, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	boids__api__the_flock(%rip), %eax
	movl	%eax, -68(%rbp)
	cmpl	$2000, %eax
	ja	.L30
	movl	-68(%rbp), %eax
	movl	%edi, %r13d
	leaq	boids__api__the_flock(%rip), %rbx
	testl	%eax, %eax
	jne	.L52
.L13:
	movq	64+boids__api__the_flock(%rip), %rax
	movq	72+boids__api__the_flock(%rip), %r14
	movq	32+boids__api__the_flock(%rip), %rsi
	movq	24+boids__api__the_flock(%rip), %rdi
	cmpq	%r14, %rax
	movq	%rax, -152(%rbp)
	setle	%dl
	cmpq	%rdi, %rsi
	movq	%rsi, -104(%rbp)
	setle	%al
	movq	%rdi, -112(%rbp)
	andb	%al, %dl
	movb	%dl, -69(%rbp)
	je	.L14
	movq	16+boids__api__the_flock(%rip), %rax
	subq	$64000, %rsp
	movq	8+boids__api__the_flock(%rip), %r15
	movl	$64000, %edx
	leaq	88+boids__api__the_flock(%rip), %rsi
	movq	%rsp, %rdi
	movq	%rsp, %r12
	movq	%rax, -96(%rbp)
	movq	40+boids__api__the_flock(%rip), %rax
	movq	%r15, -80(%rbp)
	movq	%rax, -128(%rbp)
	movq	48+boids__api__the_flock(%rip), %rax
	movq	%rax, -120(%rbp)
	movq	56+boids__api__the_flock(%rip), %rax
	movq	%rax, -144(%rbp)
	movq	80+boids__api__the_flock(%rip), %rax
	movq	%rax, -136(%rbp)
	call	memcpy@PLT
	movq	%r15, %rdi
	call	boids__api__next_random
	movq	16+boids__api__the_flock(%rip), %rdi
	movq	%rax, -56(%rbp)
	call	boids__api__next_random
	movq	%rax, -64(%rbp)
	movabsq	$4611686018427387904, %rax
	addq	%r14, %rax
	js	.L53
	movabsq	$4611686018427387905, %rax
	leaq	(%r14,%r14), %rdi
	addq	%rdi, %rax
	js	.L54
	addq	$1, %rdi
	movq	%rdi, -88(%rbp)
	call	boids__api__next_random
	movq	-88(%rbp), %rdi
	movq	%rax, %r15
	call	boids__api__next_random
	movq	%rax, %rdx
	leal	-1(%r13), %eax
	cmpl	$1999, %eax
	ja	.L55
	cmpq	$1048575, -56(%rbp)
	jg	.L56
	movl	%r13d, %eax
	movq	-56(%rbp), %rsi
	movq	%rax, %rcx
	salq	$5, %rcx
	movq	%rsi, 56(%rbx,%rcx)
	cmpq	$1048575, -64(%rbp)
	jg	.L57
	movq	-64(%rbp), %rsi
	subq	%r14, %r15
	movq	%rsi, 64(%rbx,%rcx)
	jo	.L28
	leaq	16777216(%r15), %rcx
	cmpq	$33554432, %rcx
	ja	.L29
	subq	%r14, %rdx
	jo	.L28
	leaq	16777216(%rdx), %rcx
	cmpq	$33554432, %rcx
	ja	.L29
	addq	$2, %rax
	movl	boids__api__the_flock(%rip), %r9d
	salq	$5, %rax
	movq	%r15, 8(%rbx,%rax)
	movq	%rdx, 16(%rbx,%rax)
	cmpl	$2000, %r9d
	ja	.L30
	movq	64+boids__api__the_flock(%rip), %rsi
	movq	72+boids__api__the_flock(%rip), %r15
	movq	32+boids__api__the_flock(%rip), %r11
	movq	24+boids__api__the_flock(%rip), %rax
	cmpq	%r15, %rsi
	movq	%rsi, -88(%rbp)
	movq	16+boids__api__the_flock(%rip), %rdi
	setle	%r10b
	cmpq	%rax, %r11
	movq	8+boids__api__the_flock(%rip), %rsi
	setle	%dl
	andl	%edx, %r10d
	movl	%r10d, %edx
	xorl	$1, %edx
	testl	%r9d, %r9d
	jne	.L58
.L32:
	cmpq	%rsi, -80(%rbp)
	je	.L59
.L35:
	movl	$1, %eax
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L61:
	movq	8(%rcx), %rcx
	cmpq	%rcx, 64(%r10)
	jne	.L38
	leaq	2(%rax), %rcx
	addq	%r12, %r8
	salq	$5, %rcx
	movq	-16(%r8), %r14
	addq	%rbx, %rcx
	cmpq	%r14, 8(%rcx)
	jne	.L38
	movq	-8(%r8), %r15
	cmpq	%r15, 16(%rcx)
	jne	.L38
.L37:
	addq	$1, %rax
	cmpq	$2001, %rax
	je	.L60
.L39:
	cmpl	%eax, %r13d
	je	.L37
	movq	%rax, %r8
	leaq	-1(%rax), %rcx
	salq	$5, %r8
	salq	$5, %rcx
	addq	%r12, %rcx
	leaq	(%rbx,%r8), %r10
	movq	(%rcx), %r11
	cmpq	%r11, 56(%r10)
	je	.L61
.L38:
	leaq	.LC10(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L60:
	cmpq	%rsi, -56(%rbp)
	setge	%al
	cmpq	%rdi, -64(%rbp)
	setge	%cl
	orl	%ecx, %eax
	cmpl	%r9d, -68(%rbp)
	setne	%cl
	orl	%ecx, %eax
	orb	%dl, %al
	jne	.L38
	cmpb	$0, -69(%rbp)
	jne	.L38
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L58:
	.cfi_restore_state
	movb	%r10b, -70(%rbp)
	leal	1(%r9), %r8d
	movl	$1, %ecx
	jmp	.L33
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L63:
	addq	$1, %rcx
	cmpq	%rcx, %r8
	je	.L62
.L33:
	movq	%rcx, %r10
	salq	$5, %r10
	addq	%rbx, %r10
	cmpq	%rsi, 56(%r10)
	setge	%dl
	cmpq	%rdi, 64(%r10)
	setge	%r10b
	orb	%r10b, %dl
	je	.L63
	jmp	.L32
	.p2align 4,,10
	.p2align 3
.L52:
	movl	-68(%rbp), %eax
	movq	8+boids__api__the_flock(%rip), %rsi
	movl	$1, %edx
	leaq	boids__api__the_flock(%rip), %rbx
	movq	16+boids__api__the_flock(%rip), %rdi
	leal	1(%rax), %r8d
	.p2align 4
	.p2align 3
.L15:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rsi, 56(%rax)
	jge	.L14
	cmpq	%rdi, %rcx
	jge	.L14
	addq	$1, %rdx
	cmpq	%r8, %rdx
	jne	.L15
	jmp	.L13
	.p2align 4,,10
	.p2align 3
.L59:
	cmpq	%rax, -112(%rbp)
	setne	%cl
	cmpq	%rdi, -96(%rbp)
	setne	%al
	orl	%ecx, %eax
	cmpq	%r11, -104(%rbp)
	setne	%cl
	orb	%cl, %al
	je	.L64
	movb	%al, -69(%rbp)
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L62:
	movzbl	-70(%rbp), %edx
	xorl	$1, %edx
	jmp	.L32
.L64:
	movq	-128(%rbp), %rax
	cmpq	%rax, 40+boids__api__the_flock(%rip)
	jne	.L35
	movq	-120(%rbp), %rax
	cmpq	48+boids__api__the_flock(%rip), %rax
	jne	.L35
	movq	-144(%rbp), %rax
	cmpq	%rax, 56+boids__api__the_flock(%rip)
	setne	%al
	movq	-88(%rbp), %r11
	cmpq	%r11, -152(%rbp)
	setne	%cl
	orl	%eax, %ecx
	cmpq	%r15, %r14
	setne	%al
	orb	%al, %cl
	movb	%cl, -69(%rbp)
	jne	.L35
	movq	-136(%rbp), %rax
	cmpq	%rax, 80+boids__api__the_flock(%rip)
	setne	-69(%rbp)
	jmp	.L35
.L30:
	movl	$44, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L29:
	movl	$37, %esi
	leaq	.LC9(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L28:
	movl	$37, %esi
	leaq	.LC9(%rip), %rdi
	call	__gnat_rcheck_CE_Overflow_Check@PLT
.L57:
	movl	$36, %esi
	leaq	.LC9(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L56:
	movl	$35, %esi
	leaq	.LC9(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L55:
	movl	$35, %esi
	leaq	.LC9(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L54:
	movl	$33, %esi
	leaq	.LC9(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L53:
	movl	$33, %esi
	leaq	.LC9(%rip), %rdi
	call	__gnat_rcheck_CE_Overflow_Check@PLT
.L14:
	leaq	.LC8(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE4:
	.size	boids__api__new_bird, .-boids__api__new_bird
	.section	.rodata.str1.8
	.align 8
.LC11:
	.string	"failed precondition from boids-api.ads:16"
	.align 8
.LC12:
	.string	"Loop_Invariant failed at boids-api.adb:76"
	.align 8
.LC13:
	.string	"Loop_Invariant failed at boids-api.adb:78"
	.align 8
.LC14:
	.string	"Loop_Invariant failed at boids-api.adb:89"
	.align 8
.LC15:
	.string	"Loop_Invariant failed at boids-api.adb:92"
	.align 8
.LC16:
	.string	"failed postcondition from boids-api.ads:17"
	.text
	.align 2
	.p2align 4
	.globl	mf_set_param
	.type	mf_set_param, @function
mf_set_param:
.LFB6:
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
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	movl	boids__api__the_flock(%rip), %eax
	movl	%eax, 80(%rsp)
	cmpl	$2000, %eax
	ja	.L91
	movl	80(%rsp), %eax
	movl	%esi, %r15d
	testl	%eax, %eax
	je	.L67
	movq	8+boids__api__the_flock(%rip), %rsi
	movq	16+boids__api__the_flock(%rip), %r8
	leal	1(%rax), %r9d
	movl	$1, %edx
	leaq	boids__api__the_flock(%rip), %rbx
	.p2align 4
	.p2align 3
.L69:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rsi, 56(%rax)
	jge	.L68
	cmpq	%r8, %rcx
	jge	.L68
	addq	$1, %rdx
	cmpq	%rdx, %r9
	jne	.L69
.L67:
	movq	64+boids__api__the_flock(%rip), %rsi
	movq	72+boids__api__the_flock(%rip), %rbx
	movq	24+boids__api__the_flock(%rip), %rdx
	movq	32+boids__api__the_flock(%rip), %rax
	cmpq	%rbx, %rsi
	movq	%rsi, 32(%rsp)
	setle	%cl
	cmpq	%rdx, %rax
	movq	%rdx, 16(%rsp)
	setle	%dl
	movq	%rbx, 24(%rsp)
	testb	%dl, %cl
	je	.L68
	movq	40+boids__api__the_flock(%rip), %rsi
	movq	8+boids__api__the_flock(%rip), %r12
	movq	16+boids__api__the_flock(%rip), %rbp
	movq	%rsi, 72(%rsp)
	movq	48+boids__api__the_flock(%rip), %rsi
	movq	%rsi, 64(%rsp)
	movq	56+boids__api__the_flock(%rip), %rsi
	movq	%rsi, 56(%rsp)
	movq	80+boids__api__the_flock(%rip), %rsi
	movq	%rsi, 48(%rsp)
	cmpl	$10, %edi
	ja	.L71
	leaq	.L73(%rip), %rcx
	movl	%edi, %edx
	movslq	(%rcx,%rdx,4), %rdx
	addq	%rcx, %rdx
	jmp	*%rdx
	.section	.rodata
	.align 4
	.align 4
.L73:
	.long	.L71-.L73
	.long	.L82-.L73
	.long	.L81-.L73
	.long	.L80-.L73
	.long	.L79-.L73
	.long	.L78-.L73
	.long	.L77-.L73
	.long	.L76-.L73
	.long	.L75-.L73
	.long	.L74-.L73
	.long	.L72-.L73
	.text
.L72:
	movslq	%r15d, %rbx
	movl	$1024, %esi
	movl	$1, %edx
	cmpq	$1024, %rbx
	cmovle	%rbx, %rsi
	testq	%rsi, %rsi
	cmovg	%rsi, %rdx
	movq	16(%rsp), %rsi
	cmpq	%rsi, %rax
	movq	%rdx, 48(%rsp)
	cmovg	%rsi, %rax
	movq	%rax, 40(%rsp)
.L84:
	cmpl	$2000, 80(%rsp)
	ja	.L130
.L83:
	movl	80(%rsp), %eax
	testl	%eax, %eax
	je	.L85
	leal	2(%rax), %r13d
	movl	%edi, 84(%rsp)
	movq	%rbp, %r14
	movl	%eax, %ebx
	movq	%r13, 8(%rsp)
	movl	$2, %ebp
	movl	%r15d, 88(%rsp)
	movq	%r12, %r15
	leaq	boids__api__the_flock(%rip), %r12
	.p2align 4
	.p2align 3
.L89:
	leaq	-1(%rbp), %rdx
	movq	%r15, %rsi
	salq	$5, %rdx
	leaq	(%r12,%rdx), %r13
	movq	56(%r13), %rdi
	call	boids__wrap@PLT
	movq	64(%r13), %rdi
	movq	%r14, %rsi
	movq	%rax, 56(%r13)
	call	boids__wrap@PLT
	movq	%rax, 64(%r13)
	cmpl	(%r12), %ebx
	jne	.L131
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L86:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%r12, %rax
	movq	64(%rax), %rcx
	cmpq	%r15, 56(%rax)
	jge	.L87
	cmpq	%r14, %rcx
	jge	.L87
	addq	$1, %rdx
	cmpq	%rdx, %rbp
	jne	.L86
	addq	$1, %rbp
	cmpq	%rbp, 8(%rsp)
	jne	.L89
	movq	%r15, %r12
	movl	84(%rsp), %edi
	movl	88(%rsp), %r15d
	movq	%r14, %rbp
.L85:
	movq	72(%rsp), %rbx
	movq	16(%rsp), %rax
	movq	%r12, 8+boids__api__the_flock(%rip)
	movq	40(%rsp), %rsi
	movq	24(%rsp), %rcx
	movq	%rbp, 16+boids__api__the_flock(%rip)
	movq	%rbx, 40+boids__api__the_flock(%rip)
	movq	64(%rsp), %rbx
	movq	48(%rsp), %rdx
	movq	%rax, 24+boids__api__the_flock(%rip)
	movq	%rbx, 48+boids__api__the_flock(%rip)
	movq	56(%rsp), %rbx
	movq	%rsi, 32+boids__api__the_flock(%rip)
	movq	%rbx, 56+boids__api__the_flock(%rip)
	movq	32(%rsp), %rbx
	movq	%rcx, 72+boids__api__the_flock(%rip)
	movq	%rbx, 64+boids__api__the_flock(%rip)
	movq	%rdx, 80+boids__api__the_flock(%rip)
	cmpl	$11, %edi
	je	.L90
	movl	boids__api__the_flock(%rip), %r14d
	cmpl	$2000, %r14d
	ja	.L91
	cmpq	%rax, %rsi
	setle	%dl
	cmpq	%rcx, %rbx
	setle	%al
	andl	%eax, %edx
	movl	%edx, %r10d
.L92:
	testl	%r14d, %r14d
	jne	.L132
.L105:
	testb	%r10b, %r10b
	je	.L106
	addq	$120, %rsp
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
.L82:
	.cfi_restore_state
	movl	$4096, %edx
	movslq	%r15d, %r12
	movq	16(%rsp), %rsi
	cmpq	%rdx, %r12
	cmovg	%rdx, %r12
	movl	$64, %edx
	cmpq	%rdx, %r12
	cmovl	%rdx, %r12
	salq	$8, %r12
	cmpq	%rsi, %rax
	cmovg	%rsi, %rax
	movq	%rax, 40(%rsp)
	jmp	.L84
.L81:
	movl	$4096, %edx
	movslq	%r15d, %rbp
	movq	16(%rsp), %rsi
	cmpq	%rdx, %rbp
	cmovg	%rdx, %rbp
	movl	$64, %edx
	cmpq	%rdx, %rbp
	cmovl	%rdx, %rbp
	salq	$8, %rbp
	cmpq	%rsi, %rax
	cmovg	%rsi, %rax
	movq	%rax, 40(%rsp)
	jmp	.L84
.L80:
	movl	$400, %ecx
	movslq	%r15d, %rdx
	cmpq	%rcx, %rdx
	cmovg	%rcx, %rdx
	movl	$1, %ecx
	testq	%rdx, %rdx
	cmovle	%rcx, %rdx
	movq	%rdx, %rsi
	salq	$8, %rsi
	cmpq	%rsi, %rax
	movq	%rsi, 16(%rsp)
	cmovg	%rsi, %rax
	movq	%rax, 40(%rsp)
	jmp	.L84
.L79:
	movl	$400, %edx
	movslq	%r15d, %rax
	movq	16(%rsp), %rsi
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
	movl	$1, %edx
	testq	%rax, %rax
	cmovle	%rdx, %rax
	salq	$8, %rax
	cmpq	%rax, %rsi
	movq	%rax, 40(%rsp)
	cmovl	%rax, %rsi
	movq	%rsi, 16(%rsp)
	jmp	.L84
.L78:
	movslq	%r15d, %rbx
	movl	$400, %esi
	cmpq	$400, %rbx
	cmovle	%rbx, %rsi
	xorl	%edx, %edx
	testq	%rsi, %rsi
	cmovns	%rsi, %rdx
	movq	16(%rsp), %rsi
	cmpq	%rsi, %rax
	movq	%rdx, 72(%rsp)
	cmovg	%rsi, %rax
	movq	%rax, 40(%rsp)
	jmp	.L84
.L77:
	movslq	%r15d, %rbx
	movl	$400, %esi
	cmpq	$400, %rbx
	cmovle	%rbx, %rsi
	xorl	%edx, %edx
	testq	%rsi, %rsi
	cmovns	%rsi, %rdx
	movq	16(%rsp), %rsi
	cmpq	%rsi, %rax
	movq	%rdx, 64(%rsp)
	cmovg	%rsi, %rax
	movq	%rax, 40(%rsp)
	jmp	.L84
.L76:
	movslq	%r15d, %rbx
	movl	$400, %esi
	cmpq	$400, %rbx
	cmovle	%rbx, %rsi
	xorl	%edx, %edx
	testq	%rsi, %rsi
	cmovns	%rsi, %rdx
	movq	16(%rsp), %rsi
	cmpq	%rsi, %rax
	movq	%rdx, 56(%rsp)
	cmovg	%rsi, %rax
	movq	%rax, 40(%rsp)
	jmp	.L84
.L75:
	movslq	%r15d, %rsi
	movl	$4096, %ebx
	cmpq	$4096, %rsi
	cmovle	%rsi, %rbx
	movl	$1, %esi
	testq	%rbx, %rbx
	cmovg	%rbx, %rsi
	movq	16(%rsp), %rbx
	cmpq	%rbx, %rax
	movq	%rsi, 32(%rsp)
	cmovg	%rbx, %rax
	movq	%rax, 40(%rsp)
	movq	24(%rsp), %rax
	cmpq	%rsi, %rax
	cmovl	%rsi, %rax
	movq	%rax, 24(%rsp)
	jmp	.L84
.L74:
	movslq	%r15d, %rsi
	movl	$4096, %ebx
	cmpq	$4096, %rsi
	cmovle	%rsi, %rbx
	movl	$1, %esi
	testq	%rbx, %rbx
	cmovg	%rbx, %rsi
	movq	16(%rsp), %rbx
	cmpq	%rbx, %rax
	movq	%rsi, 24(%rsp)
	cmovg	%rbx, %rax
	movq	%rax, 40(%rsp)
	movq	32(%rsp), %rax
	cmpq	%rsi, %rax
	cmovg	%rsi, %rax
	movq	%rax, 32(%rsp)
	jmp	.L84
.L132:
	leaq	boids__api__the_flock(%rip), %rbx
.L104:
	movq	8+boids__api__the_flock(%rip), %rsi
	movq	16+boids__api__the_flock(%rip), %rdi
	leal	1(%r14), %r8d
	movl	$1, %edx
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L133:
	cmpq	%rdi, %rcx
	jge	.L106
	addq	$1, %rdx
	cmpq	%rdx, %r8
	je	.L105
.L107:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rsi, 56(%rax)
	jl	.L133
.L106:
	leaq	.LC16(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L90:
	movl	$2000, %eax
	movslq	%r15d, %rdi
	cmpq	%rax, %rdi
	cmovg	%rax, %rdi
	xorl	%eax, %eax
	testq	%rdi, %rdi
	cmovns	%rdi, %rax
	movl	80(%rsp), %edi
	addl	$1, %edi
	movq	%rax, 8(%rsp)
	movl	%eax, %r14d
	movl	%edi, 84(%rsp)
	cmpl	%edi, %eax
	jl	.L93
	movl	%edi, %eax
	movl	%r14d, 108(%rsp)
	leaq	boids__api__the_flock(%rip), %rbx
	leaq	-1(%rax), %rdi
	movq	%r12, 88(%rsp)
	movq	%rax, %r13
	movq	%rdi, 96(%rsp)
	.p2align 4
	.p2align 3
.L103:
	movl	%r13d, %r12d
	movl	%r12d, %edi
	call	boids__api__new_bird
	movl	(%rbx), %r9d
	cmpl	$2000, %r9d
	ja	.L91
	movq	64(%rbx), %r11
	movq	72(%rbx), %r10
	movq	32(%rbx), %r14
	movq	24(%rbx), %r15
	cmpq	%r10, %r11
	movq	8(%rbx), %rdi
	setle	%dl
	cmpq	%r15, %r14
	setle	%al
	andl	%eax, %edx
	movl	%edx, %ecx
	xorl	$1, %ecx
	testl	%r9d, %r9d
	je	.L95
	movb	%dl, 107(%rsp)
	movq	16(%rbx), %r8
	leal	1(%r9), %eax
	movl	$1, %esi
	jmp	.L96
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L135:
	addq	$1, %rsi
	cmpq	%rax, %rsi
	je	.L134
.L96:
	movq	%rsi, %rdx
	salq	$5, %rdx
	addq	%rbx, %rdx
	cmpq	%rdi, 56(%rdx)
	setge	%cl
	cmpq	%r8, 64(%rdx)
	setge	%dl
	orb	%dl, %cl
	je	.L135
	movzbl	107(%rsp), %edx
.L95:
	cmpq	%rdi, 88(%rsp)
	jne	.L97
	cmpq	%rbp, 16(%rbx)
	jne	.L97
	cmpq	16(%rsp), %r15
	jne	.L97
	cmpq	40(%rsp), %r14
	jne	.L97
	movq	72(%rsp), %rax
	cmpq	%rax, 40(%rbx)
	jne	.L97
	movq	64(%rsp), %rax
	cmpq	%rax, 48(%rbx)
	jne	.L97
	movq	56(%rsp), %rax
	cmpq	%rax, 56(%rbx)
	jne	.L97
	cmpq	%r11, 32(%rsp)
	jne	.L97
	cmpq	24(%rsp), %r10
	jne	.L97
	movq	48(%rsp), %rax
	cmpq	80(%rbx), %rax
	jne	.L97
	cmpl	%r9d, 80(%rsp)
	jne	.L97
	testb	%cl, %cl
	jne	.L97
	cmpl	%r13d, 84(%rsp)
	jle	.L136
.L100:
	cmpq	%r13, 8(%rsp)
	je	.L137
	addq	$1, %r13
	jmp	.L103
	.p2align 4,,10
	.p2align 3
.L136:
	movq	96(%rsp), %rcx
	jmp	.L102
	.p2align 4,,10
	.p2align 3
.L138:
	cmpq	%rbp, %rsi
	jge	.L101
	cmpq	%r12, %rcx
	je	.L100
.L102:
	addq	$1, %rcx
	leaq	-1(%rcx), %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	96(%rax), %rsi
	cmpq	%rdi, 88(%rax)
	jl	.L138
.L101:
	leaq	.LC15(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L134:
	movzbl	107(%rsp), %edx
	movl	%edx, %ecx
	xorl	$1, %ecx
	jmp	.L95
.L93:
	movq	16(%rsp), %rax
	cmpq	32+boids__api__the_flock(%rip), %rax
	setge	%dl
	movq	24(%rsp), %rax
	cmpq	64+boids__api__the_flock(%rip), %rax
	setge	%al
	andl	%eax, %edx
	movl	8(%rsp), %eax
	movl	%edx, %r10d
	movl	%eax, boids__api__the_flock(%rip)
	jmp	.L92
.L137:
	movl	108(%rsp), %r14d
	movl	%edx, %r10d
	movl	%r14d, boids__api__the_flock(%rip)
	jmp	.L104
.L71:
	movq	16(%rsp), %rsi
	cmpq	%rsi, %rax
	cmovg	%rsi, %rax
	movq	%rax, 40(%rsp)
	jmp	.L83
.L97:
	leaq	.LC14(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L68:
	leaq	.LC11(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L87:
	leaq	.LC13(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L131:
	leaq	.LC12(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L130:
	movl	$73, %esi
	leaq	.LC9(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L91:
	movl	$44, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.cfi_endproc
.LFE6:
	.size	mf_set_param, .-mf_set_param
	.section	.rodata.str1.8
	.align 8
.LC17:
	.string	"failed precondition from boids-api.ads:21"
	.align 8
.LC18:
	.string	"Loop_Invariant failed at boids-api.adb:105"
	.align 8
.LC19:
	.string	"failed postcondition from boids-api.ads:22"
	.text
	.align 2
	.p2align 4
	.globl	mf_start
	.type	mf_start, @function
mf_start:
.LFB8:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movl	boids__api__the_flock(%rip), %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	cmpl	$2000, %ebp
	ja	.L147
	movq	72+boids__api__the_flock(%rip), %rax
	cmpq	%rax, 64+boids__api__the_flock(%rip)
	movl	%edi, %r10d
	movq	24+boids__api__the_flock(%rip), %rax
	setle	%r9b
	cmpq	%rax, 32+boids__api__the_flock(%rip)
	setle	%al
	andl	%eax, %r9d
	testl	%ebp, %ebp
	je	.L141
	movq	8+boids__api__the_flock(%rip), %rsi
	movq	16+boids__api__the_flock(%rip), %rdi
	leal	1(%rbp), %r8d
	movl	$1, %edx
	leaq	boids__api__the_flock(%rip), %rbx
	.p2align 4
	.p2align 3
.L143:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rsi, 56(%rax)
	jge	.L142
	cmpq	%rdi, %rcx
	jge	.L142
	addq	$1, %rdx
	cmpq	%rdx, %r8
	jne	.L143
	testb	%r9b, %r9b
	je	.L142
	movl	%r10d, boids__api__rng(%rip)
	xorl	%r12d, %r12d
	.p2align 4
	.p2align 3
.L152:
	addl	$1, %r12d
	movl	%r12d, %edi
	call	boids__api__new_bird
	movl	(%rbx), %r9d
	cmpl	$2000, %r9d
	ja	.L147
	testl	%r9d, %r9d
	je	.L148
	movq	8(%rbx), %rsi
	movq	16(%rbx), %rdi
	leal	1(%r9), %r8d
	movl	$1, %edx
	.p2align 4
	.p2align 3
.L150:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rsi, 56(%rax)
	jge	.L149
	cmpq	%rdi, %rcx
	jge	.L149
	addq	$1, %rdx
	cmpq	%rdx, %r8
	jne	.L150
.L148:
	movq	72(%rbx), %rax
	cmpq	%rax, 64(%rbx)
	setle	%dl
	movq	24(%rbx), %rax
	cmpq	%rax, 32(%rbx)
	setle	%al
	testb	%al, %dl
	je	.L149
	cmpl	%r12d, %ebp
	jne	.L152
	testl	%r9d, %r9d
	je	.L139
	movq	8+boids__api__the_flock(%rip), %rsi
	movq	16+boids__api__the_flock(%rip), %rdi
	leal	1(%r9), %r8d
	movl	$1, %edx
	jmp	.L154
	.p2align 4,,10
	.p2align 3
.L170:
	cmpq	%rdi, %rcx
	jge	.L153
	addq	$1, %rdx
	cmpq	%rdx, %r8
	je	.L139
.L154:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rsi, 56(%rax)
	jl	.L170
.L153:
	leaq	.LC19(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L141:
	testb	%r9b, %r9b
	je	.L142
	movl	%edi, boids__api__rng(%rip)
.L139:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L147:
	.cfi_restore_state
	movl	$44, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
	.p2align 4,,10
	.p2align 3
.L149:
	leaq	.LC18(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L142:
	leaq	.LC17(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE8:
	.size	mf_start, .-mf_start
	.section	.rodata.str1.8
	.align 8
.LC20:
	.string	"failed precondition from boids-api.ads:26"
	.align 8
.LC21:
	.string	"failed postcondition from boids-api.ads:27"
	.text
	.align 2
	.p2align 4
	.globl	mf_tick
	.type	mf_tick, @function
mf_tick:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movl	boids__api__the_flock(%rip), %eax
	cmpl	$2000, %eax
	ja	.L177
	leaq	boids__api__the_flock(%rip), %rbx
	testl	%eax, %eax
	je	.L173
	movq	8+boids__api__the_flock(%rip), %rsi
	movq	16+boids__api__the_flock(%rip), %rdi
	leal	1(%rax), %r8d
	movl	$1, %edx
	leaq	boids__api__the_flock(%rip), %rbx
	.p2align 4
	.p2align 3
.L175:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	movq	64(%rax), %rcx
	cmpq	%rsi, 56(%rax)
	jge	.L174
	cmpq	%rdi, %rcx
	jge	.L174
	addq	$1, %rdx
	cmpq	%rdx, %r8
	jne	.L175
.L173:
	movq	72+boids__api__the_flock(%rip), %rax
	cmpq	%rax, 64+boids__api__the_flock(%rip)
	setle	%dl
	movq	24+boids__api__the_flock(%rip), %rax
	cmpq	%rax, 32+boids__api__the_flock(%rip)
	setle	%al
	testb	%al, %dl
	je	.L174
	movq	%rbx, %rdi
	call	boids__flocks__step@PLT
	movl	boids__api__the_flock(%rip), %esi
	cmpl	$2000, %esi
	ja	.L177
	movq	64+boids__api__the_flock(%rip), %r8
	movq	72+boids__api__the_flock(%rip), %r9
	movq	24+boids__api__the_flock(%rip), %rax
	cmpq	%rax, 32+boids__api__the_flock(%rip)
	setle	%al
	cmpq	%r9, %r8
	setle	%dl
	andl	%edx, %eax
	movl	%eax, %ebp
	testl	%esi, %esi
	je	.L178
	movq	8+boids__api__the_flock(%rip), %r11
	movq	16+boids__api__the_flock(%rip), %r10
	movl	$1, %edx
	jmp	.L180
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L193:
	cmpq	%rsi, %rdx
	je	.L192
	addq	$1, %rdx
.L180:
	movq	%rdx, %rax
	salq	$5, %rax
	addq	%rbx, %rax
	cmpq	%r11, 56(%rax)
	setge	%dil
	cmpq	%r10, 64(%rax)
	setge	%al
	orb	%al, %dil
	je	.L193
.L179:
	imulq	%r8, %r8
	movl	$1, %ecx
	imulq	%r9, %r9
	jmp	.L183
	.p2align 4,,10
	.p2align 3
.L194:
	cmpq	%r9, %rax
	jg	.L182
	cmpq	%rsi, %rcx
	je	.L181
	addq	$1, %rcx
.L183:
	leaq	2(%rcx), %rdx
	salq	$5, %rdx
	addq	%rbx, %rdx
	movq	8(%rdx), %rax
	movq	16(%rdx), %rdx
	imulq	%rax, %rax
	imulq	%rdx, %rdx
	addq	%rdx, %rax
	cmpq	%r8, %rax
	jge	.L194
.L182:
	leaq	.LC21(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.p2align 4,,10
	.p2align 3
.L178:
	movl	%eax, %edi
	xorl	$1, %edi
.L181:
	testb	%dil, %dil
	jne	.L182
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L192:
	.cfi_restore_state
	movl	%ebp, %edi
	xorl	$1, %edi
	jmp	.L179
.L177:
	movl	$44, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Invalid_Data@PLT
.L174:
	leaq	.LC20(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE10:
	.size	mf_tick, .-mf_tick
	.align 2
	.p2align 4
	.globl	mf_count
	.type	mf_count, @function
mf_count:
.LFB12:
	.cfi_startproc
	movl	boids__api__the_flock(%rip), %eax
	ret
	.cfi_endproc
.LFE12:
	.size	mf_count, .-mf_count
	.align 2
	.p2align 4
	.globl	mf_x
	.type	mf_x, @function
mf_x:
.LFB13:
	.cfi_startproc
	leal	-1(%rdi), %edx
	xorl	%eax, %eax
	cmpl	$1999, %edx
	ja	.L196
	movl	%edi, %edi
	leaq	boids__api__the_flock(%rip), %rax
	salq	$5, %rdi
	movl	56(%rax,%rdi), %eax
.L196:
	ret
	.cfi_endproc
.LFE13:
	.size	mf_x, .-mf_x
	.align 2
	.p2align 4
	.globl	mf_y
	.type	mf_y, @function
mf_y:
.LFB14:
	.cfi_startproc
	leal	-1(%rdi), %edx
	xorl	%eax, %eax
	cmpl	$1999, %edx
	ja	.L199
	movl	%edi, %edi
	leaq	boids__api__the_flock(%rip), %rax
	salq	$5, %rdi
	movl	64(%rax,%rdi), %eax
.L199:
	ret
	.cfi_endproc
.LFE14:
	.size	mf_y, .-mf_y
	.align 2
	.p2align 4
	.globl	mf_vx
	.type	mf_vx, @function
mf_vx:
.LFB15:
	.cfi_startproc
	leal	-1(%rdi), %edx
	xorl	%eax, %eax
	cmpl	$1999, %edx
	ja	.L202
	movl	%edi, %edi
	leaq	boids__api__the_flock(%rip), %rax
	salq	$5, %rdi
	movl	72(%rax,%rdi), %eax
.L202:
	ret
	.cfi_endproc
.LFE15:
	.size	mf_vx, .-mf_vx
	.align 2
	.p2align 4
	.globl	mf_vy
	.type	mf_vy, @function
mf_vy:
.LFB16:
	.cfi_startproc
	leal	-1(%rdi), %edx
	xorl	%eax, %eax
	cmpl	$1999, %edx
	ja	.L205
	movl	%edi, %edi
	leaq	boids__api__the_flock(%rip), %rax
	salq	$5, %rdi
	movl	80(%rax,%rdi), %eax
.L205:
	ret
	.cfi_endproc
.LFE16:
	.size	mf_vy, .-mf_vy
	.align 2
	.p2align 4
	.globl	boids__api___elabs
	.type	boids__api___elabs, @function
boids__api___elabs:
.LFB1:
	.cfi_startproc
	movl	$0, boids__api__the_flock(%rip)
	movl	$262144, %eax
	movq	%rax, %xmm0
	movl	$100, %eax
	punpcklqdq	%xmm0, %xmm0
	movups	%xmm0, 8+boids__api__the_flock(%rip)
	movdqa	.LC23(%rip), %xmm0
	movups	%xmm0, 24+boids__api__the_flock(%rip)
	movq	%rax, %xmm0
	leaq	88+boids__api__the_flock(%rip), %rax
	punpcklqdq	%xmm0, %xmm0
	leaq	64000(%rax), %rdx
	movups	%xmm0, 40+boids__api__the_flock(%rip)
	movdqa	.LC25(%rip), %xmm0
	movups	%xmm0, 56+boids__api__the_flock(%rip)
	movdqa	.LC26(%rip), %xmm0
	movups	%xmm0, 72+boids__api__the_flock(%rip)
	pxor	%xmm0, %xmm0
	.p2align 4
	.p2align 4
	.p2align 3
.L209:
	movups	%xmm0, (%rax)
	addq	$32, %rax
	movups	%xmm0, -16(%rax)
	cmpq	%rdx, %rax
	jne	.L209
	leaq	96088+boids__api__the_flock(%rip), %rax
	pxor	%xmm0, %xmm0
	movq	%rax, %rcx
	subq	%rdx, %rcx
	andl	$16, %ecx
	je	.L210
	movups	%xmm0, (%rdx)
	addq	$16, %rdx
	cmpq	%rdx, %rax
	je	.L218
	.p2align 4
	.p2align 4
	.p2align 3
.L210:
	movups	%xmm0, (%rdx)
	addq	$32, %rdx
	movups	%xmm0, -16(%rdx)
	cmpq	%rdx, %rax
	jne	.L210
.L218:
	ret
	.cfi_endproc
.LFE1:
	.size	boids__api___elabs, .-boids__api___elabs
	.globl	boids__api__the_flock
	.bss
	.align 32
	.type	boids__api__the_flock, @object
	.size	boids__api__the_flock, 96088
boids__api__the_flock:
	.zero	96088
	.globl	boids__api__rng
	.data
	.align 4
	.type	boids__api__rng, @object
	.size	boids__api__rng, 4
boids__api__rng:
	.long	1
	.globl	boids__api_E
	.align 2
	.type	boids__api_E, @object
	.size	boids__api_E, 2
boids__api_E:
	.zero	2
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC23:
	.quad	10240
	.quad	4096
	.align 16
.LC25:
	.quad	100
	.quad	512
	.align 16
.LC26:
	.quad	1024
	.quad	32
	.ident	"GCC: (GNAT-FSF-builds) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
