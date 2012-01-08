	.section	__TEXT,__text,regular,pure_instructions
	.globl	_ECRYPT_init
	.align	4, 0x90
_ECRYPT_init:
Leh_func_begin0:
	pushq	%rbp
Ltmp0:
	movq	%rsp, %rbp
Ltmp1:
	popq	%rbp
	ret
Leh_func_end0:

	.globl	_ECRYPT_AE_ivsetup
	.align	4, 0x90
_ECRYPT_AE_ivsetup:
Leh_func_begin1:
	pushq	%rbp
Ltmp2:
	movq	%rsp, %rbp
Ltmp3:
	subq	$64, %rsp
Ltmp4:
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movabsq	$-1, %rsi
	cmpq	$-1, %rsi
	je	LBB1_2
	movabsq	$12, %rdx
	movq	-8(%rbp), %rax
	movabsq	$1408, %rcx
	addq	%rax, %rcx
	movq	-16(%rbp), %rsi
	movq	%rcx, -24(%rbp)
	movabsq	$-1, %rcx
	movq	-24(%rbp), %rdi
	callq	___memcpy_chk
	movq	%rax, -32(%rbp)
	jmp	LBB1_3
LBB1_2:
	movabsq	$12, %rdx
	movq	-8(%rbp), %rax
	movabsq	$1408, %rcx
	addq	%rax, %rcx
	movq	-16(%rbp), %rsi
	movq	%rcx, %rdi
	callq	___inline_memcpy_chk
	movq	%rax, -40(%rbp)
LBB1_3:
	movq	-8(%rbp), %rax
	movb	$0, 1420(%rax)
	movq	-8(%rbp), %rax
	movb	$0, 1421(%rax)
	movq	-8(%rbp), %rax
	movb	$0, 1422(%rax)
	movq	-8(%rbp), %rax
	movb	$2, 1423(%rax)
	movabsq	$-1, %rax
	cmpq	$-1, %rax
	je	LBB1_5
	movl	$0, %esi
	movabsq	$16, %rdx
	movq	-8(%rbp), %rax
	movabsq	$1424, %rcx
	addq	%rax, %rcx
	movq	%rcx, -48(%rbp)
	movabsq	$-1, %rcx
	movq	-48(%rbp), %rdi
	callq	___memset_chk
	movq	%rax, -56(%rbp)
	jmp	LBB1_6
LBB1_5:
	movl	$0, %esi
	movabsq	$16, %rdx
	movq	-8(%rbp), %rax
	movabsq	$1424, %rcx
	addq	%rax, %rcx
	movq	%rcx, %rdi
	callq	___inline_memset_chk
	movq	%rax, -64(%rbp)
LBB1_6:
	movq	-8(%rbp), %rax
	movq	$0, 1440(%rax)
	addq	$64, %rsp
	popq	%rbp
	ret
Leh_func_end1:

	.align	4, 0x90
___inline_memcpy_chk:
Leh_func_begin2:
	pushq	%rbp
Ltmp5:
	movq	%rsp, %rbp
Ltmp6:
	subq	$32, %rsp
Ltmp7:
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rax
	movabsq	$-1, %rcx
	movq	%rax, -32(%rbp)
	callq	___memcpy_chk
	addq	$32, %rsp
	popq	%rbp
	ret
Leh_func_end2:

	.align	4, 0x90
___inline_memset_chk:
Leh_func_begin3:
	pushq	%rbp
Ltmp8:
	movq	%rsp, %rbp
Ltmp9:
	subq	$32, %rsp
Ltmp10:
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rdi
	movl	-12(%rbp), %esi
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rax
	movabsq	$-1, %rcx
	movq	%rax, -32(%rbp)
	callq	___memset_chk
	addq	$32, %rsp
	popq	%rbp
	ret
Leh_func_end3:

	.globl	_ECRYPT_AE_keysetup
	.align	4, 0x90
_ECRYPT_AE_keysetup:
Leh_func_begin4:
	pushq	%rbp
Ltmp11:
	movq	%rsp, %rbp
Ltmp12:
	subq	$112, %rsp
Ltmp13:
	leaq	-64(%rbp), %rax
	movq	___stack_chk_guard@GOTPCREL(%rip), %r9
	movq	(%r9), %r9
	movq	%r9, -8(%rbp)
	movq	%rdi, -16(%rbp)
	movq	%rsi, -24(%rbp)
	movl	%edx, -28(%rbp)
	movl	%ecx, -32(%rbp)
	movl	%r8d, -36(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, (%rax)
	movabsq	$-1, %rax
	cmpq	$-1, %rax
	je	LBB4_2
	movl	$0, %esi
	movabsq	$16, %rdx
	movq	-16(%rbp), %rax
	movabsq	$1408, %rcx
	addq	%rax, %rcx
	movq	%rcx, -72(%rbp)
	movabsq	$-1, %rcx
	movq	-72(%rbp), %rdi
	callq	___memset_chk
	movq	%rax, -80(%rbp)
	jmp	LBB4_3
LBB4_2:
	movl	$0, %esi
	movabsq	$16, %rdx
	movq	-16(%rbp), %rax
	movabsq	$1408, %rcx
	addq	%rax, %rcx
	movq	%rcx, %rdi
	callq	___inline_memset_chk
	movq	%rax, -88(%rbp)
LBB4_3:
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	leaq	-64(%rbp), %rcx
	movl	$0, %edi
	movl	$16, %edx
	movq	%rcx, -96(%rbp)
	movl	$12, %ecx
	movl	%edi, -100(%rbp)
	movq	-16(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movl	%edx, -104(%rbp)
	movq	%rax, -112(%rbp)
	callq	_ECRYPT_keysetup
	movq	-16(%rbp), %rsi
	movl	-100(%rbp), %edi
	movq	-96(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movl	-104(%rbp), %r8d
	callq	_process_bytes
	movq	-16(%rbp), %rdi
	movq	-96(%rbp), %rsi
	callq	_tablesetup
	movq	-112(%rbp), %rax
	movq	(%rax), %rcx
	movq	-8(%rbp), %rdx
	cmpq	%rdx, %rcx
	jne	LBB4_5
	addq	$112, %rsp
	popq	%rbp
	ret
LBB4_5:
	callq	___stack_chk_fail
Leh_func_end4:

	.globl	_ECRYPT_AE_process_bytes
	.align	4, 0x90
_ECRYPT_AE_process_bytes:
Leh_func_begin5:
	pushq	%rbp
Ltmp14:
	movq	%rsp, %rbp
Ltmp15:
	subq	$48, %rsp
Ltmp16:
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movl	%r8d, -36(%rbp)
	movl	-4(%rbp), %edi
	cmpl	$0, %edi
	jne	LBB5_2
	movl	$0, %edi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rcx
	movl	-36(%rbp), %r8d
	callq	_process_bytes
	movq	-16(%rbp), %rdi
	movq	-32(%rbp), %rsi
	movl	-36(%rbp), %edx
	callq	_authenticate
	jmp	LBB5_3
LBB5_2:
	movl	$0, %edi
	movl	%edi, -40(%rbp)
	movq	-16(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movl	-36(%rbp), %edx
	callq	_authenticate
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rcx
	movl	-36(%rbp), %r8d
	movl	-40(%rbp), %edi
	callq	_process_bytes
LBB5_3:
	addq	$48, %rsp
	popq	%rbp
	ret
Leh_func_end5:

	.globl	_ECRYPT_AE_finalize
	.align	4, 0x90
_ECRYPT_AE_finalize:
Leh_func_begin6:
	pushq	%rbp
Ltmp17:
	movq	%rsp, %rbp
Ltmp18:
	subq	$80, %rsp
Ltmp19:
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	leaq	-48(%rbp), %rcx
	movq	%rdi, -56(%rbp)
	movl	$0, %edi
	movl	$16, %r8d
	movq	(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movq	-56(%rbp), %rdx
	movq	%rdx, -16(%rbp)
	movq	%rsi, -24(%rbp)
	movq	%rcx, -64(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, (%rcx)
	movq	-16(%rbp), %rcx
	movb	$0, 1420(%rcx)
	movq	-16(%rbp), %rcx
	movb	$0, 1421(%rcx)
	movq	-16(%rbp), %rcx
	movb	$0, 1422(%rcx)
	movq	-16(%rbp), %rcx
	movb	$1, 1423(%rcx)
	movq	-16(%rbp), %rsi
	movq	-64(%rbp), %rdx
	movq	-64(%rbp), %rcx
	movq	%rax, -72(%rbp)
	callq	_process_bytes
	movq	-16(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movq	-64(%rbp), %rdx
	callq	_finalmul
	movq	-72(%rbp), %rax
	movq	(%rax), %rcx
	movq	-8(%rbp), %rdx
	cmpq	%rdx, %rcx
	jne	LBB6_2
	addq	$80, %rsp
	popq	%rbp
	ret
LBB6_2:
	callq	___stack_chk_fail
Leh_func_end6:

	.section	__TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame0:
Lsection_eh_frame0:
Leh_frame_common0:
Lset0 = Leh_frame_common_end0-Leh_frame_common_begin0
	.long	Lset0
Leh_frame_common_begin0:
	.long	0
	.byte	1
	.asciz	 "zR"
	.byte	1
	.byte	120
	.byte	16
	.byte	1
	.byte	16
	.byte	12
	.byte	7
	.byte	8
	.byte	144
	.byte	1
	.align	3
Leh_frame_common_end0:
	.globl	_ECRYPT_init.eh
_ECRYPT_init.eh:
Lset1 = Leh_frame_end0-Leh_frame_begin0
	.long	Lset1
Leh_frame_begin0:
Lset2 = Leh_frame_begin0-Leh_frame_common0
	.long	Lset2
Ltmp20:
	.quad	Leh_func_begin0-Ltmp20
Lset3 = Leh_func_end0-Leh_func_begin0
	.quad	Lset3
	.byte	0
	.byte	4
Lset4 = Ltmp0-Leh_func_begin0
	.long	Lset4
	.byte	14
	.byte	16
	.byte	134
	.byte	2
	.byte	4
Lset5 = Ltmp1-Ltmp0
	.long	Lset5
	.byte	13
	.byte	6
	.align	3
Leh_frame_end0:

	.globl	_ECRYPT_AE_ivsetup.eh
_ECRYPT_AE_ivsetup.eh:
Lset6 = Leh_frame_end1-Leh_frame_begin1
	.long	Lset6
Leh_frame_begin1:
Lset7 = Leh_frame_begin1-Leh_frame_common0
	.long	Lset7
Ltmp21:
	.quad	Leh_func_begin1-Ltmp21
Lset8 = Leh_func_end1-Leh_func_begin1
	.quad	Lset8
	.byte	0
	.byte	4
Lset9 = Ltmp2-Leh_func_begin1
	.long	Lset9
	.byte	14
	.byte	16
	.byte	134
	.byte	2
	.byte	4
Lset10 = Ltmp3-Ltmp2
	.long	Lset10
	.byte	13
	.byte	6
	.align	3
Leh_frame_end1:

___inline_memcpy_chk.eh:
Lset11 = Leh_frame_end2-Leh_frame_begin2
	.long	Lset11
Leh_frame_begin2:
Lset12 = Leh_frame_begin2-Leh_frame_common0
	.long	Lset12
Ltmp22:
	.quad	Leh_func_begin2-Ltmp22
Lset13 = Leh_func_end2-Leh_func_begin2
	.quad	Lset13
	.byte	0
	.byte	4
Lset14 = Ltmp5-Leh_func_begin2
	.long	Lset14
	.byte	14
	.byte	16
	.byte	134
	.byte	2
	.byte	4
Lset15 = Ltmp6-Ltmp5
	.long	Lset15
	.byte	13
	.byte	6
	.align	3
Leh_frame_end2:

___inline_memset_chk.eh:
Lset16 = Leh_frame_end3-Leh_frame_begin3
	.long	Lset16
Leh_frame_begin3:
Lset17 = Leh_frame_begin3-Leh_frame_common0
	.long	Lset17
Ltmp23:
	.quad	Leh_func_begin3-Ltmp23
Lset18 = Leh_func_end3-Leh_func_begin3
	.quad	Lset18
	.byte	0
	.byte	4
Lset19 = Ltmp8-Leh_func_begin3
	.long	Lset19
	.byte	14
	.byte	16
	.byte	134
	.byte	2
	.byte	4
Lset20 = Ltmp9-Ltmp8
	.long	Lset20
	.byte	13
	.byte	6
	.align	3
Leh_frame_end3:

	.globl	_ECRYPT_AE_keysetup.eh
_ECRYPT_AE_keysetup.eh:
Lset21 = Leh_frame_end4-Leh_frame_begin4
	.long	Lset21
Leh_frame_begin4:
Lset22 = Leh_frame_begin4-Leh_frame_common0
	.long	Lset22
Ltmp24:
	.quad	Leh_func_begin4-Ltmp24
Lset23 = Leh_func_end4-Leh_func_begin4
	.quad	Lset23
	.byte	0
	.byte	4
Lset24 = Ltmp11-Leh_func_begin4
	.long	Lset24
	.byte	14
	.byte	16
	.byte	134
	.byte	2
	.byte	4
Lset25 = Ltmp12-Ltmp11
	.long	Lset25
	.byte	13
	.byte	6
	.align	3
Leh_frame_end4:

	.globl	_ECRYPT_AE_process_bytes.eh
_ECRYPT_AE_process_bytes.eh:
Lset26 = Leh_frame_end5-Leh_frame_begin5
	.long	Lset26
Leh_frame_begin5:
Lset27 = Leh_frame_begin5-Leh_frame_common0
	.long	Lset27
Ltmp25:
	.quad	Leh_func_begin5-Ltmp25
Lset28 = Leh_func_end5-Leh_func_begin5
	.quad	Lset28
	.byte	0
	.byte	4
Lset29 = Ltmp14-Leh_func_begin5
	.long	Lset29
	.byte	14
	.byte	16
	.byte	134
	.byte	2
	.byte	4
Lset30 = Ltmp15-Ltmp14
	.long	Lset30
	.byte	13
	.byte	6
	.align	3
Leh_frame_end5:

	.globl	_ECRYPT_AE_finalize.eh
_ECRYPT_AE_finalize.eh:
Lset31 = Leh_frame_end6-Leh_frame_begin6
	.long	Lset31
Leh_frame_begin6:
Lset32 = Leh_frame_begin6-Leh_frame_common0
	.long	Lset32
Ltmp26:
	.quad	Leh_func_begin6-Ltmp26
Lset33 = Leh_func_end6-Leh_func_begin6
	.quad	Lset33
	.byte	0
	.byte	4
Lset34 = Ltmp17-Leh_func_begin6
	.long	Lset34
	.byte	14
	.byte	16
	.byte	134
	.byte	2
	.byte	4
Lset35 = Ltmp18-Ltmp17
	.long	Lset35
	.byte	13
	.byte	6
	.align	3
Leh_frame_end6:


.subsections_via_symbols
