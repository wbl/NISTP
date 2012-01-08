################################################################
### AES-128 in CTR mode			       	             ###
### bitsliced implementation for Intel Core 2 processors     ###
### requires support of SSE extensions up to SSSE3           ###
### Author: Emilia Käsper				     ###	
### Date: 2009-03-19					     ###
### Public domain        	             		     ###
################################################################

.include "common.s"

#####################
#int action in %edi
#ECRYPT_ctx* ctx in %rsi
#const u8* input in %rdx
#u8* output in %rcx
#u32 msglen in %r8d
#####################
.globl _process_bytes
.globl process_bytes
_process_bytes:
process_bytes:
cmpl	$0, %r8d
jne	.START
ret
.START:
# bitsliced key
leaq (%rsi), %rax

pushq	%rbx
pushq	%rbp
pushq	%r12
pushq	%r13
pushq   %r14
pushq	%r15

#increment total length
movq   1440(%rsi),%r12
add    %r8, %r12
movq	%r12, 1440(%rsi)

#msglen
movl	%r8d, %r12d
#input
movq	%rdx, %rbx
#output
movq	%rcx, %rbp

.ENC_BLOCK:
	movdqa 1408(%rsi), %xmm0
	movdqa %xmm0, %xmm1
	pshufb SWAP32,%xmm1
	movdqa %xmm1, %xmm2
	movdqa %xmm1, %xmm3
	movdqa %xmm1, %xmm4
	movdqa %xmm1, %xmm5
	movdqa %xmm1, %xmm6
	movdqa %xmm1, %xmm7

	paddd RCTRINC1, %xmm1
	paddd RCTRINC2, %xmm2
	paddd RCTRINC3, %xmm3
	paddd RCTRINC4, %xmm4
	paddd RCTRINC5, %xmm5
	paddd RCTRINC6, %xmm6
	paddd RCTRINC7, %xmm7

	pshufb M0,     %xmm0
	pshufb M0SWAP, %xmm1
	pshufb M0SWAP, %xmm2
	pshufb M0SWAP, %xmm3
	pshufb M0SWAP, %xmm4
	pshufb M0SWAP, %xmm5
	pshufb M0SWAP, %xmm6
	pshufb M0SWAP, %xmm7

aes128 %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm15, %rax


# output in first block > [xmm8, xmm9, xmm12, xmm14, xmm11, xmm15, xmm10, xmm13] < last block

	cmpl  	$128, %r12d
	jb	.PARTIAL
	je	.FULL

	movl	1420(%rsi), %r14d
	bswap	%r14d
	addl 	$8, %r14d
	bswap	%r14d
	movl	%r14d, 1420(%rsi)
	
	pxor	(%rbx), %xmm8
	pxor	16(%rbx), %xmm9
	pxor	32(%rbx), %xmm12
	pxor	48(%rbx), %xmm14
	pxor	64(%rbx), %xmm11
	pxor	80(%rbx), %xmm15
	pxor	96(%rbx), %xmm10
	pxor	112(%rbx), %xmm13
	movdqa	%xmm8,	(%rbp)
	movdqa	%xmm9,	16(%rbp)
	movdqa	%xmm12,	32(%rbp)
	movdqa	%xmm14,	48(%rbp)
	movdqa	%xmm11,	64(%rbp)
	movdqa	%xmm15,	80(%rbp)
	movdqa	%xmm10,	96(%rbp)
	movdqa	%xmm13,	112(%rbp)
	subl	$128, %r12d
	addq	$128, %rbx
	addq	$128, %rbp
	jmp	.ENC_BLOCK	
	
.PARTIAL:
	# add partial bytes #
	movl	%r12d,	%r13d
	shr	$4, 	%r12d

	movl	1420(%rsi), %r14d
	bswap	%r14d
	addl 	%r12d, %r14d
	bswap	%r14d
	movl	%r14d, 1420(%rsi)

	movq	%rsp,	%r15
	subq	$128, %rsp
	and $0xFFFFFFFFFFFFFF00, %rsp
	movdqa	%xmm8, (%rsp)	
	movdqa	%xmm9, 16(%rsp)
	movdqa	%xmm12, 32(%rsp)
	movdqa	%xmm14, 48(%rsp)
	movdqa	%xmm11, 64(%rsp)
	movdqa	%xmm15, 80(%rsp)
	movdqa	%xmm10, 96(%rsp)
	movdqa	%xmm13, 112(%rsp)
.BYTES:
	movb	(%rbx), %al
	xorb	(%rsp), %al
	movb	%al,	(%rbp)
	addq	$1,	%rbx
	addq	$1,	%rbp
	addq	$1,	%rsp
	subl	$1,	%r13d
	cmp	$0, 	%r13d
	jne	.BYTES	
	movq	%r15, %rsp
	jmp	.END
	
.FULL:
	movl	1420(%rsi), %r14d
	bswap	%r14d
	addl 	$8, %r14d
	bswap	%r14d
	movl	%r14d, 1420(%rsi)

	pxor	(%rbx), %xmm8
	pxor	16(%rbx), %xmm9
	pxor	32(%rbx), %xmm12
	pxor	48(%rbx), %xmm14
	pxor	64(%rbx), %xmm11
	pxor	80(%rbx), %xmm15
	pxor	96(%rbx), %xmm10
	pxor	112(%rbx), %xmm13
	movdqa	%xmm8,	(%rbp)
	movdqa	%xmm9,	16(%rbp)
	movdqa	%xmm12,	32(%rbp)
	movdqa	%xmm14,	48(%rbp)
	movdqa	%xmm11,	64(%rbp)
	movdqa	%xmm15,	80(%rbp)
	movdqa	%xmm10,	96(%rbp)
	movdqa	%xmm13,	112(%rbp)


.END:
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbp
	popq	%rbx
	ret
