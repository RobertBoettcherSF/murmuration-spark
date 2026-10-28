	.file	"boids.adb"
	.text
	.align 2
	.p2align 4
	.globl	boids__vecIP
	.type	boids__vecIP, @function
boids__vecIP:
.LFB2:
	.cfi_startproc
	xorl	%eax, %eax
	xorl	%edx, %edx
	ret
	.cfi_endproc
.LFE2:
	.size	boids__vecIP, .-boids__vecIP
	.align 2
	.p2align 4
	.globl	boids__norm2
	.type	boids__norm2, @function
boids__norm2:
.LFB3:
	.cfi_startproc
	imulq	%rdi, %rdi
	imulq	%rsi, %rsi
	leaq	(%rdi,%rsi), %rax
	ret
	.cfi_endproc
.LFE3:
	.size	boids__norm2, .-boids__norm2
	.align 2
	.p2align 4
	.globl	boids__sat
	.type	boids__sat, @function
boids__sat:
.LFB4:
	.cfi_startproc
	movq	$-16777216, %rax
	movl	$16777216, %edx
	cmpq	%rax, %rdi
	cmovge	%rdi, %rax
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
	ret
	.cfi_endproc
.LFE4:
	.size	boids__sat, .-boids__sat
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"failed precondition from boids.ads:37"
	.align 8
.LC5:
	.string	"Loop_Invariant failed at boids.adb:9"
	.align 8
.LC6:
	.string	"Loop_Variant failed at boids.adb:10"
	.section	.rodata
.LC7:
	.ascii	"boids.adb"
	.zero	1
	.section	.rodata.str1.8
	.align 8
.LC8:
	.string	"failed postcondition from boids.ads:38"
	.section	.rodata
	.align 8
.LC2:
	.long	1
	.long	36
	.align 8
.LC3:
	.long	1
	.long	35
	.align 8
.LC0:
	.long	1
	.long	37
	.align 8
.LC1:
	.long	1
	.long	38
	.text
	.align 2
	.p2align 4
	.globl	boids__isqrt
	.type	boids__isqrt, @function
boids__isqrt:
.LFB5:
	.cfi_startproc
	movabsq	$1125899906842624, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	cmpq	%rdi, %rax
	jb	.L19
	xorl	%ecx, %ecx
	movl	$67108864, %r8d
	movl	$67108864, %edx
	movl	$33554432, %eax
	.p2align 4
	.p2align 3
.L6:
	movq	%rax, %rsi
	imulq	%rax, %rsi
	cmpq	%rsi, %rdi
	cmovl	%rax, %rdx
	cmovge	%rax, %rcx
	movq	%rdx, %rsi
	subq	%rcx, %rsi
	cmpq	$1, %rsi
	jle	.L20
	cmpq	%rcx, %rdx
	jle	.L16
	cmpq	$67108864, %rdx
	jg	.L16
	cmpq	%rsi, %r8
	jle	.L21
	movq	%rsi, %rax
	movq	%rsi, %r8
	sarq	%rax
	addq	%rcx, %rax
	jmp	.L6
	.p2align 4,,10
	.p2align 3
.L20:
	cmpq	$67108864, %rcx
	jg	.L22
	movq	%rcx, %rax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L16:
	.cfi_restore_state
	leaq	.LC5(%rip), %rdi
	leaq	.LC2(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L21:
	leaq	.LC6(%rip), %rdi
	leaq	.LC3(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L19:
	leaq	.LC4(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L22:
	leaq	.LC8(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE5:
	.size	boids__isqrt, .-boids__isqrt
	.section	.rodata.str1.8
	.align 8
.LC9:
	.string	"failed precondition from boids.adb:22"
	.text
	.align 2
	.p2align 4
	.globl	boids__limit
	.type	boids__limit, @function
boids__limit:
.LFB8:
	.cfi_startproc
	movq	%rdi, %r8
	imulq	%rdi, %rdi
	movq	%rsi, %r9
	movq	%rdx, %r10
	imulq	%rsi, %rsi
	imulq	%rdx, %r10
	addq	%rsi, %rdi
	cmpq	%r10, %rdi
	jg	.L38
	movq	%r8, %rax
	movq	%r9, %rdx
	ret
	.p2align 4,,10
	.p2align 3
.L38:
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%r8, 8(%rsp)
	movq	%r9, 16(%rsp)
	movq	%rdx, (%rsp)
	movq	%r10, 24(%rsp)
	call	boids__isqrt
	movq	(%rsp), %rcx
	movq	8(%rsp), %r8
	cmpq	$1048578, %rcx
	ja	.L39
	imulq	%rcx, %r8
	jo	.L32
	movabsq	$4611686018427387904, %rdi
	leaq	1(%rax), %rsi
	movq	%r8, %rax
	cqto
	idivq	%rsi
	movq	%rax, %r8
	addq	%rdi, %rax
	js	.L33
	movq	16(%rsp), %rax
	imulq	%rcx, %rax
	jo	.L32
	cqto
	idivq	%rsi
	addq	%rax, %rdi
	js	.L33
	movq	$-16777216, %rdx
	movq	$-16777216, %r9
	cmpq	%rdx, %r8
	cmovl	%rdx, %r8
	movl	$16777216, %edx
	cmpq	%rdx, %r8
	cmovg	%rdx, %r8
	cmpq	%r9, %rax
	cmovge	%rax, %r9
	movl	$16777216, %eax
	cmpq	%rax, %r9
	cmovg	%rax, %r9
	movq	%r8, %rax
	imulq	%r8, %rax
	movq	%r9, %rdx
	imulq	%r9, %rdx
	addq	%rdx, %rax
	cmpq	%rax, 24(%rsp)
	movl	$0, %eax
	cmovl	%rax, %r9
	cmovl	%rax, %r8
	movq	%r9, %rdx
	movq	%r8, %rax
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L32:
	.cfi_restore_state
	movl	$25, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Overflow_Check@PLT
.L33:
	movl	$25, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L39:
	leaq	.LC9(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE8:
	.size	boids__limit, .-boids__limit
	.section	.rodata.str1.8
	.align 8
.LC10:
	.string	"failed precondition from boids.ads:49"
	.align 8
.LC11:
	.string	"failed postcondition from boids.ads:50"
	.text
	.align 2
	.p2align 4
	.globl	boids__clamp_speed
	.type	boids__clamp_speed, @function
boids__clamp_speed:
.LFB10:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %r9
	movq	%rdx, %rsi
	subq	$48, %rsp
	.cfi_def_cfa_offset 64
	testq	%rdx, %rdx
	jle	.L66
	cmpq	%rcx, %rdx
	jg	.L66
	movq	%r9, %rax
	movq	%rdi, %r8
	movq	%rsi, %r10
	movq	%rcx, %r11
	imulq	%rdi, %rdi
	movq	%r9, %rdx
	imulq	%r9, %rax
	imulq	%rsi, %r10
	imulq	%rcx, %r11
	addq	%rax, %rdi
	cmpq	%r10, %rdi
	jl	.L43
	cmpq	%r11, %rdi
	jle	.L65
.L45:
	movq	%rcx, 40(%rsp)
	movq	%r8, 24(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%r11, 8(%rsp)
	movq	%r10, (%rsp)
	movq	%r9, 32(%rsp)
	call	boids__isqrt
	movq	40(%rsp), %rcx
	movq	(%rsp), %r10
	movq	8(%rsp), %r11
	movq	16(%rsp), %rsi
	cmpq	$1048578, %rcx
	movq	24(%rsp), %r8
	ja	.L73
	imulq	%rcx, %r8
	jo	.L55
	movabsq	$4611686018427387904, %rdi
	leaq	1(%rax), %rbx
	movq	%r8, %rax
	cqto
	idivq	%rbx
	movq	%rax, %r8
	addq	%rdi, %rax
	js	.L56
	movq	32(%rsp), %rax
	imulq	%rcx, %rax
	jo	.L55
	cqto
	idivq	%rbx
	addq	%rax, %rdi
	js	.L56
.L72:
	movq	$-16777216, %rdx
	cmpq	%rdx, %r8
	cmovl	%rdx, %r8
	movl	$16777216, %edx
	cmpq	%rdx, %r8
	cmovg	%rdx, %r8
	movq	$-16777216, %rdx
	cmpq	%rdx, %rax
	cmovge	%rax, %rdx
	movl	$16777216, %eax
	cmpq	%rax, %rdx
	cmovg	%rax, %rdx
	movq	%r8, %rax
	imulq	%r8, %rax
	movq	%rdx, %rcx
	imulq	%rdx, %rcx
	addq	%rcx, %rax
	cmpq	%r11, %rax
	setle	%cl
	cmpq	%rax, %r10
	setle	%al
	testb	%al, %cl
	je	.L46
.L65:
	movq	%r8, %rsi
	movq	%rsi, %rax
	addq	$48, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L43:
	.cfi_restore_state
	testq	%rdi, %rdi
	jne	.L74
.L46:
	cmpq	%r11, %r10
	jg	.L63
	xorl	%edx, %edx
	movq	%rsi, %rax
	addq	$48, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L74:
	.cfi_restore_state
	cmpq	%r11, %rdi
	jg	.L45
	movq	%r8, 24(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%r11, 8(%rsp)
	movq	%r10, (%rsp)
	movq	%r9, 32(%rsp)
	call	boids__isqrt
	movq	16(%rsp), %rsi
	movq	(%rsp), %r10
	movq	8(%rsp), %r11
	movq	24(%rsp), %r8
	leaq	2(%rsi), %rdi
	cmpq	$1048578, %rdi
	jg	.L73
	imulq	%rdi, %r8
	jo	.L55
	testq	%rax, %rax
	movl	$1, %ebx
	movabsq	$4611686018427387904, %rcx
	cmovg	%rax, %rbx
	movq	%r8, %rax
	cqto
	idivq	%rbx
	movq	%rax, %r8
	addq	%rcx, %rax
	js	.L56
	movq	32(%rsp), %rax
	imulq	%rdi, %rax
	jo	.L55
	cqto
	idivq	%rbx
	addq	%rax, %rcx
	jns	.L72
.L56:
	movl	$25, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L63:
	leaq	.LC11(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L66:
	leaq	.LC10(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L55:
	movl	$25, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Overflow_Check@PLT
.L73:
	leaq	.LC9(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE10:
	.size	boids__clamp_speed, .-boids__clamp_speed
	.section	.rodata.str1.8
	.align 8
.LC12:
	.string	"failed precondition from boids.ads:54"
	.align 8
.LC13:
	.string	"failed postcondition from boids.ads:55"
	.align 8
.LC14:
	.string	"failed postcondition from boids.ads:56"
	.text
	.align 2
	.p2align 4
	.globl	boids__torus_delta
	.type	boids__torus_delta, @function
boids__torus_delta:
.LFB12:
	.cfi_startproc
	movq	%rsi, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdx, %rsi
	cmpq	%rax, %rdi
	movq	%rax, %rdx
	cmovge	%rdi, %rdx
	cmpq	%rdx, %rsi
	jle	.L88
	movq	%rsi, %rdx
	subq	%rdi, %rax
	shrq	$63, %rdx
	addq	%rsi, %rdx
	sarq	%rdx
	cmpq	%rdx, %rax
	jg	.L89
	movq	%rdx, %rcx
	negq	%rcx
	cmpq	%rcx, %rax
	jge	.L79
	leaq	(%rsi,%rax), %rcx
	leaq	524288(%rcx), %rdi
	cmpq	$1048576, %rdi
	ja	.L90
.L78:
	movq	%rcx, %rdi
	negq	%rdi
	cmovs	%rcx, %rdi
	cmpq	%rdx, %rdi
	jg	.L81
	movq	%rcx, %rdi
	subq	%rax, %rdi
	movq	%rdi, %rdx
	addq	%rsi, %rdx
	setne	%dl
	cmpq	%rsi, %rdi
	setne	%sil
	andl	%esi, %edx
	cmpq	%rcx, %rax
	setne	%al
	testb	%al, %dl
	jne	.L91
	movq	%rcx, %rax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L89:
	.cfi_restore_state
	movq	%rax, %rcx
	subq	%rsi, %rcx
	leaq	524288(%rcx), %rdi
	cmpq	$1048576, %rdi
	jbe	.L78
	movl	$64, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
	.p2align 4,,10
	.p2align 3
.L79:
	leaq	524288(%rax), %rcx
	cmpq	$1048576, %rcx
	ja	.L92
	movq	%rax, %rcx
	negq	%rcx
	cmovs	%rax, %rcx
	cmpq	%rdx, %rcx
	jg	.L81
	movq	%rax, %rcx
	movq	%rcx, %rax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L88:
	.cfi_restore_state
	leaq	.LC12(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L81:
	leaq	.LC13(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L91:
	leaq	.LC14(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L90:
	movl	$66, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
.L92:
	movl	$68, %esi
	leaq	.LC7(%rip), %rdi
	call	__gnat_rcheck_CE_Range_Check@PLT
	.cfi_endproc
.LFE12:
	.size	boids__torus_delta, .-boids__torus_delta
	.section	.rodata.str1.8
	.align 8
.LC15:
	.string	"failed precondition from boids.ads:60"
	.align 8
.LC16:
	.string	"failed postcondition from boids.ads:61"
	.text
	.align 2
	.p2align 4
	.globl	boids__wrap
	.type	boids__wrap, @function
boids__wrap:
.LFB14:
	.cfi_startproc
	movabsq	$1099511627776, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movabsq	$2199023255552, %rdx
	addq	%rdi, %rax
	cmpq	%rax, %rdx
	jb	.L107
	movq	%rdi, %rax
	movq	%rsi, %rcx
	cqto
	idivq	%rsi
	movq	%rdx, %rsi
	testq	%rdx, %rdx
	jne	.L108
.L95:
	cmpq	%rsi, %rcx
	jle	.L98
	movq	%rsi, %r8
	subq	%rdi, %r8
	movq	%r8, %rax
	cqto
	idivq	%rcx
	testq	%rdx, %rdx
	jne	.L109
.L99:
	movq	%rsi, %rax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L108:
	.cfi_restore_state
	movq	%rdi, %rax
	xorq	%rcx, %rax
	movl	$0, %eax
	cmovs	%rcx, %rax
	addq	%rax, %rsi
	jmp	.L95
	.p2align 4,,10
	.p2align 3
.L109:
	xorq	%rcx, %r8
	movl	$0, %eax
	cmovns	%rax, %rcx
	addq	%rcx, %rdx
	je	.L99
.L98:
	leaq	.LC16(%rip), %rdi
	leaq	.LC1(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
.L107:
	leaq	.LC15(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	system__assertions__raise_assert_failure@PLT
	.cfi_endproc
.LFE14:
	.size	boids__wrap, .-boids__wrap
	.globl	boids__zero
	.section	.rodata
	.align 16
	.type	boids__zero, @object
	.size	boids__zero, 16
boids__zero:
	.zero	16
	.globl	boids_E
	.data
	.align 2
	.type	boids_E, @object
	.size	boids_E, 2
boids_E:
	.zero	2
	.ident	"GCC: (GNAT-FSF-builds) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
