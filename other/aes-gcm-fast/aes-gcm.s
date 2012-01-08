################################################################
### AES-128 in CTR mode			       	             ###
### bitsliced implementation for Intel Core 2 processors     ###
### requires support of SSE extensions up to SSSE3           ###
### Author: Emilia Käsper				     ###	
### Date: 2009-03-19					     ###
### Public domain        	             		     ###
################################################################

#.include "common.s"

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

# qhasm: int64 arg1

# qhasm: int64 arg2

# qhasm: input arg1

# qhasm: input arg2

# qhasm: int64 r11_caller

# qhasm: int64 r12_caller

# qhasm: int64 r13_caller

# qhasm: int64 r14_caller

# qhasm: int64 r15_caller

# qhasm: int64 rbx_caller

# qhasm: int64 rbp_caller

# qhasm: caller r11_caller

# qhasm: caller r12_caller

# qhasm: caller r13_caller

# qhasm: caller r14_caller

# qhasm: caller r15_caller

# qhasm: caller rbx_caller

# qhasm: caller rbp_caller

# qhasm: stack64 r11_caller_stack

# qhasm: stack64 r12_caller_stack

# qhasm: int64 sboxp

# qhasm: int64 c

# qhasm: int64 k

# qhasm: int64 x0

# qhasm: int64 x1

# qhasm: int64 x2

# qhasm: int64 x3

# qhasm: int64 e

# qhasm: int64 q0

# qhasm: int64 q1

# qhasm: int64 q2

# qhasm: int64 q3

# qhasm: int6464 xmm0

# qhasm: int6464 xmm1

# qhasm: int6464 xmm2

# qhasm: int6464 xmm3

# qhasm: int6464 xmm4

# qhasm: int6464 xmm5

# qhasm: int6464 xmm6

# qhasm: int6464 xmm7

# qhasm: int6464 t

# qhasm: stack128 key_stack

# qhasm: int64 keyp

# qhasm: enter ECRYPT_keysetup
.text
.p2align 5
.globl _ECRYPT_keysetup
.globl ECRYPT_keysetup
_ECRYPT_keysetup:
ECRYPT_keysetup:
mov %rsp,%r11
and $31,%r11
add $64,%r11
sub %r11,%rsp

# qhasm: r11_caller_stack = r11_caller
# asm 1: movq <r11_caller=int64#9,>r11_caller_stack=stack64#1
# asm 2: movq <r11_caller=%r11,>r11_caller_stack=32(%rsp)
movq %r11,32(%rsp)

# qhasm: c = arg1
# asm 1: mov  <arg1=int64#1,>c=int64#4
# asm 2: mov  <arg1=%rdi,>c=%rcx
mov  %rdi,%rcx

# qhasm: k = arg2
# asm 1: mov  <arg2=int64#2,>k=int64#1
# asm 2: mov  <arg2=%rsi,>k=%rdi
mov  %rsi,%rdi

# qhasm: sboxp = &sbox
# asm 1: lea  sbox(%rip),>sboxp=int64#2
# asm 2: lea  sbox(%rip),>sboxp=%rsi
lea  sbox(%rip),%rsi

# qhasm: keyp = &key_stack
# asm 1: leaq <key_stack=stack128#1,>keyp=int64#5
# asm 2: leaq <key_stack=0(%rsp),>keyp=%r8
leaq 0(%rsp),%r8

# qhasm: x0 = *(uint32 *) (k + 0)
# asm 1: movl   0(<k=int64#1),>x0=int64#6d
# asm 2: movl   0(<k=%rdi),>x0=%r9d
movl   0(%rdi),%r9d

# qhasm: x1 = *(uint32 *) (k + 4)
# asm 1: movl   4(<k=int64#1),>x1=int64#7d
# asm 2: movl   4(<k=%rdi),>x1=%eax
movl   4(%rdi),%eax

# qhasm: x2 = *(uint32 *) (k + 8)
# asm 1: movl   8(<k=int64#1),>x2=int64#8d
# asm 2: movl   8(<k=%rdi),>x2=%r10d
movl   8(%rdi),%r10d

# qhasm: x3 = *(uint32 *) (k + 12)
# asm 1: movl   12(<k=int64#1),>x3=int64#3d
# asm 2: movl   12(<k=%rdi),>x3=%edx
movl   12(%rdi),%edx

# qhasm: *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm: *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm: *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm: *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   *(int128 *) (c + 0) = xmm0
# asm 1: movdqa <xmm0=int6464#1,0(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,0(<c=%rcx)
movdqa %xmm0,0(%rcx)

# qhasm:   *(int128 *) (c + 16) = xmm1
# asm 1: movdqa <xmm1=int6464#2,16(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,16(<c=%rcx)
movdqa %xmm1,16(%rcx)

# qhasm:   *(int128 *) (c + 32) = xmm2
# asm 1: movdqa <xmm2=int6464#3,32(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,32(<c=%rcx)
movdqa %xmm2,32(%rcx)

# qhasm:   *(int128 *) (c + 48) = xmm3
# asm 1: movdqa <xmm3=int6464#4,48(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,48(<c=%rcx)
movdqa %xmm3,48(%rcx)

# qhasm:   *(int128 *) (c + 64) = xmm4
# asm 1: movdqa <xmm4=int6464#5,64(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,64(<c=%rcx)
movdqa %xmm4,64(%rcx)

# qhasm:   *(int128 *) (c + 80) = xmm5
# asm 1: movdqa <xmm5=int6464#6,80(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,80(<c=%rcx)
movdqa %xmm5,80(%rcx)

# qhasm:   *(int128 *) (c + 96) = xmm6
# asm 1: movdqa <xmm6=int6464#7,96(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,96(<c=%rcx)
movdqa %xmm6,96(%rcx)

# qhasm:   *(int128 *) (c + 112) = xmm7
# asm 1: movdqa <xmm7=int6464#8,112(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,112(<c=%rcx)
movdqa %xmm7,112(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 1
# asm 1: xor  $1,<e=int64#9d
# asm 2: xor  $1,<e=%r11d
xor  $1,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 128) = xmm0
# asm 1: movdqa <xmm0=int6464#1,128(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,128(<c=%rcx)
movdqa %xmm0,128(%rcx)

# qhasm:   *(int128 *) (c + 144) = xmm1
# asm 1: movdqa <xmm1=int6464#2,144(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,144(<c=%rcx)
movdqa %xmm1,144(%rcx)

# qhasm:   *(int128 *) (c + 160) = xmm2
# asm 1: movdqa <xmm2=int6464#3,160(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,160(<c=%rcx)
movdqa %xmm2,160(%rcx)

# qhasm:   *(int128 *) (c + 176) = xmm3
# asm 1: movdqa <xmm3=int6464#4,176(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,176(<c=%rcx)
movdqa %xmm3,176(%rcx)

# qhasm:   *(int128 *) (c + 192) = xmm4
# asm 1: movdqa <xmm4=int6464#5,192(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,192(<c=%rcx)
movdqa %xmm4,192(%rcx)

# qhasm:   *(int128 *) (c + 208) = xmm5
# asm 1: movdqa <xmm5=int6464#6,208(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,208(<c=%rcx)
movdqa %xmm5,208(%rcx)

# qhasm:   *(int128 *) (c + 224) = xmm6
# asm 1: movdqa <xmm6=int6464#7,224(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,224(<c=%rcx)
movdqa %xmm6,224(%rcx)

# qhasm:   *(int128 *) (c + 240) = xmm7
# asm 1: movdqa <xmm7=int6464#8,240(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,240(<c=%rcx)
movdqa %xmm7,240(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 2
# asm 1: xor  $2,<e=int64#9d
# asm 2: xor  $2,<e=%r11d
xor  $2,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 256) = xmm0
# asm 1: movdqa <xmm0=int6464#1,256(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,256(<c=%rcx)
movdqa %xmm0,256(%rcx)

# qhasm:   *(int128 *) (c + 272) = xmm1
# asm 1: movdqa <xmm1=int6464#2,272(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,272(<c=%rcx)
movdqa %xmm1,272(%rcx)

# qhasm:   *(int128 *) (c + 288) = xmm2
# asm 1: movdqa <xmm2=int6464#3,288(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,288(<c=%rcx)
movdqa %xmm2,288(%rcx)

# qhasm:   *(int128 *) (c + 304) = xmm3
# asm 1: movdqa <xmm3=int6464#4,304(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,304(<c=%rcx)
movdqa %xmm3,304(%rcx)

# qhasm:   *(int128 *) (c + 320) = xmm4
# asm 1: movdqa <xmm4=int6464#5,320(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,320(<c=%rcx)
movdqa %xmm4,320(%rcx)

# qhasm:   *(int128 *) (c + 336) = xmm5
# asm 1: movdqa <xmm5=int6464#6,336(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,336(<c=%rcx)
movdqa %xmm5,336(%rcx)

# qhasm:   *(int128 *) (c + 352) = xmm6
# asm 1: movdqa <xmm6=int6464#7,352(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,352(<c=%rcx)
movdqa %xmm6,352(%rcx)

# qhasm:   *(int128 *) (c + 368) = xmm7
# asm 1: movdqa <xmm7=int6464#8,368(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,368(<c=%rcx)
movdqa %xmm7,368(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 4
# asm 1: xor  $4,<e=int64#9d
# asm 2: xor  $4,<e=%r11d
xor  $4,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 384) = xmm0
# asm 1: movdqa <xmm0=int6464#1,384(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,384(<c=%rcx)
movdqa %xmm0,384(%rcx)

# qhasm:   *(int128 *) (c + 400) = xmm1
# asm 1: movdqa <xmm1=int6464#2,400(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,400(<c=%rcx)
movdqa %xmm1,400(%rcx)

# qhasm:   *(int128 *) (c + 416) = xmm2
# asm 1: movdqa <xmm2=int6464#3,416(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,416(<c=%rcx)
movdqa %xmm2,416(%rcx)

# qhasm:   *(int128 *) (c + 432) = xmm3
# asm 1: movdqa <xmm3=int6464#4,432(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,432(<c=%rcx)
movdqa %xmm3,432(%rcx)

# qhasm:   *(int128 *) (c + 448) = xmm4
# asm 1: movdqa <xmm4=int6464#5,448(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,448(<c=%rcx)
movdqa %xmm4,448(%rcx)

# qhasm:   *(int128 *) (c + 464) = xmm5
# asm 1: movdqa <xmm5=int6464#6,464(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,464(<c=%rcx)
movdqa %xmm5,464(%rcx)

# qhasm:   *(int128 *) (c + 480) = xmm6
# asm 1: movdqa <xmm6=int6464#7,480(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,480(<c=%rcx)
movdqa %xmm6,480(%rcx)

# qhasm:   *(int128 *) (c + 496) = xmm7
# asm 1: movdqa <xmm7=int6464#8,496(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,496(<c=%rcx)
movdqa %xmm7,496(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 8
# asm 1: xor  $8,<e=int64#9d
# asm 2: xor  $8,<e=%r11d
xor  $8,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 512) = xmm0
# asm 1: movdqa <xmm0=int6464#1,512(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,512(<c=%rcx)
movdqa %xmm0,512(%rcx)

# qhasm:   *(int128 *) (c + 528) = xmm1
# asm 1: movdqa <xmm1=int6464#2,528(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,528(<c=%rcx)
movdqa %xmm1,528(%rcx)

# qhasm:   *(int128 *) (c + 544) = xmm2
# asm 1: movdqa <xmm2=int6464#3,544(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,544(<c=%rcx)
movdqa %xmm2,544(%rcx)

# qhasm:   *(int128 *) (c + 560) = xmm3
# asm 1: movdqa <xmm3=int6464#4,560(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,560(<c=%rcx)
movdqa %xmm3,560(%rcx)

# qhasm:   *(int128 *) (c + 576) = xmm4
# asm 1: movdqa <xmm4=int6464#5,576(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,576(<c=%rcx)
movdqa %xmm4,576(%rcx)

# qhasm:   *(int128 *) (c + 592) = xmm5
# asm 1: movdqa <xmm5=int6464#6,592(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,592(<c=%rcx)
movdqa %xmm5,592(%rcx)

# qhasm:   *(int128 *) (c + 608) = xmm6
# asm 1: movdqa <xmm6=int6464#7,608(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,608(<c=%rcx)
movdqa %xmm6,608(%rcx)

# qhasm:   *(int128 *) (c + 624) = xmm7
# asm 1: movdqa <xmm7=int6464#8,624(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,624(<c=%rcx)
movdqa %xmm7,624(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 16
# asm 1: xor  $16,<e=int64#9d
# asm 2: xor  $16,<e=%r11d
xor  $16,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 640) = xmm0
# asm 1: movdqa <xmm0=int6464#1,640(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,640(<c=%rcx)
movdqa %xmm0,640(%rcx)

# qhasm:   *(int128 *) (c + 656) = xmm1
# asm 1: movdqa <xmm1=int6464#2,656(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,656(<c=%rcx)
movdqa %xmm1,656(%rcx)

# qhasm:   *(int128 *) (c + 672) = xmm2
# asm 1: movdqa <xmm2=int6464#3,672(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,672(<c=%rcx)
movdqa %xmm2,672(%rcx)

# qhasm:   *(int128 *) (c + 688) = xmm3
# asm 1: movdqa <xmm3=int6464#4,688(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,688(<c=%rcx)
movdqa %xmm3,688(%rcx)

# qhasm:   *(int128 *) (c + 704) = xmm4
# asm 1: movdqa <xmm4=int6464#5,704(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,704(<c=%rcx)
movdqa %xmm4,704(%rcx)

# qhasm:   *(int128 *) (c + 720) = xmm5
# asm 1: movdqa <xmm5=int6464#6,720(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,720(<c=%rcx)
movdqa %xmm5,720(%rcx)

# qhasm:   *(int128 *) (c + 736) = xmm6
# asm 1: movdqa <xmm6=int6464#7,736(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,736(<c=%rcx)
movdqa %xmm6,736(%rcx)

# qhasm:   *(int128 *) (c + 752) = xmm7
# asm 1: movdqa <xmm7=int6464#8,752(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,752(<c=%rcx)
movdqa %xmm7,752(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 32
# asm 1: xor  $32,<e=int64#9d
# asm 2: xor  $32,<e=%r11d
xor  $32,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 768) = xmm0
# asm 1: movdqa <xmm0=int6464#1,768(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,768(<c=%rcx)
movdqa %xmm0,768(%rcx)

# qhasm:   *(int128 *) (c + 784) = xmm1
# asm 1: movdqa <xmm1=int6464#2,784(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,784(<c=%rcx)
movdqa %xmm1,784(%rcx)

# qhasm:   *(int128 *) (c + 800) = xmm2
# asm 1: movdqa <xmm2=int6464#3,800(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,800(<c=%rcx)
movdqa %xmm2,800(%rcx)

# qhasm:   *(int128 *) (c + 816) = xmm3
# asm 1: movdqa <xmm3=int6464#4,816(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,816(<c=%rcx)
movdqa %xmm3,816(%rcx)

# qhasm:   *(int128 *) (c + 832) = xmm4
# asm 1: movdqa <xmm4=int6464#5,832(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,832(<c=%rcx)
movdqa %xmm4,832(%rcx)

# qhasm:   *(int128 *) (c + 848) = xmm5
# asm 1: movdqa <xmm5=int6464#6,848(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,848(<c=%rcx)
movdqa %xmm5,848(%rcx)

# qhasm:   *(int128 *) (c + 864) = xmm6
# asm 1: movdqa <xmm6=int6464#7,864(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,864(<c=%rcx)
movdqa %xmm6,864(%rcx)

# qhasm:   *(int128 *) (c + 880) = xmm7
# asm 1: movdqa <xmm7=int6464#8,880(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,880(<c=%rcx)
movdqa %xmm7,880(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 64
# asm 1: xor  $64,<e=int64#9d
# asm 2: xor  $64,<e=%r11d
xor  $64,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 896) = xmm0
# asm 1: movdqa <xmm0=int6464#1,896(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,896(<c=%rcx)
movdqa %xmm0,896(%rcx)

# qhasm:   *(int128 *) (c + 912) = xmm1
# asm 1: movdqa <xmm1=int6464#2,912(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,912(<c=%rcx)
movdqa %xmm1,912(%rcx)

# qhasm:   *(int128 *) (c + 928) = xmm2
# asm 1: movdqa <xmm2=int6464#3,928(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,928(<c=%rcx)
movdqa %xmm2,928(%rcx)

# qhasm:   *(int128 *) (c + 944) = xmm3
# asm 1: movdqa <xmm3=int6464#4,944(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,944(<c=%rcx)
movdqa %xmm3,944(%rcx)

# qhasm:   *(int128 *) (c + 960) = xmm4
# asm 1: movdqa <xmm4=int6464#5,960(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,960(<c=%rcx)
movdqa %xmm4,960(%rcx)

# qhasm:   *(int128 *) (c + 976) = xmm5
# asm 1: movdqa <xmm5=int6464#6,976(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,976(<c=%rcx)
movdqa %xmm5,976(%rcx)

# qhasm:   *(int128 *) (c + 992) = xmm6
# asm 1: movdqa <xmm6=int6464#7,992(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,992(<c=%rcx)
movdqa %xmm6,992(%rcx)

# qhasm:   *(int128 *) (c + 1008) = xmm7
# asm 1: movdqa <xmm7=int6464#8,1008(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,1008(<c=%rcx)
movdqa %xmm7,1008(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 128
# asm 1: xor  $128,<e=int64#9d
# asm 2: xor  $128,<e=%r11d
xor  $128,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 1024) = xmm0
# asm 1: movdqa <xmm0=int6464#1,1024(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,1024(<c=%rcx)
movdqa %xmm0,1024(%rcx)

# qhasm:   *(int128 *) (c + 1040) = xmm1
# asm 1: movdqa <xmm1=int6464#2,1040(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,1040(<c=%rcx)
movdqa %xmm1,1040(%rcx)

# qhasm:   *(int128 *) (c + 1056) = xmm2
# asm 1: movdqa <xmm2=int6464#3,1056(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,1056(<c=%rcx)
movdqa %xmm2,1056(%rcx)

# qhasm:   *(int128 *) (c + 1072) = xmm3
# asm 1: movdqa <xmm3=int6464#4,1072(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,1072(<c=%rcx)
movdqa %xmm3,1072(%rcx)

# qhasm:   *(int128 *) (c + 1088) = xmm4
# asm 1: movdqa <xmm4=int6464#5,1088(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,1088(<c=%rcx)
movdqa %xmm4,1088(%rcx)

# qhasm:   *(int128 *) (c + 1104) = xmm5
# asm 1: movdqa <xmm5=int6464#6,1104(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,1104(<c=%rcx)
movdqa %xmm5,1104(%rcx)

# qhasm:   *(int128 *) (c + 1120) = xmm6
# asm 1: movdqa <xmm6=int6464#7,1120(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,1120(<c=%rcx)
movdqa %xmm6,1120(%rcx)

# qhasm:   *(int128 *) (c + 1136) = xmm7
# asm 1: movdqa <xmm7=int6464#8,1136(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,1136(<c=%rcx)
movdqa %xmm7,1136(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 27
# asm 1: xor  $27,<e=int64#9d
# asm 2: xor  $27,<e=%r11d
xor  $27,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   shuffle bytes of xmm0 by M0
# asm 1: pshufb M0,<xmm0=int6464#1
# asm 2: pshufb M0,<xmm0=%xmm0
pshufb M0,%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 1152) = xmm0
# asm 1: movdqa <xmm0=int6464#1,1152(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,1152(<c=%rcx)
movdqa %xmm0,1152(%rcx)

# qhasm:   *(int128 *) (c + 1168) = xmm1
# asm 1: movdqa <xmm1=int6464#2,1168(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,1168(<c=%rcx)
movdqa %xmm1,1168(%rcx)

# qhasm:   *(int128 *) (c + 1184) = xmm2
# asm 1: movdqa <xmm2=int6464#3,1184(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,1184(<c=%rcx)
movdqa %xmm2,1184(%rcx)

# qhasm:   *(int128 *) (c + 1200) = xmm3
# asm 1: movdqa <xmm3=int6464#4,1200(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,1200(<c=%rcx)
movdqa %xmm3,1200(%rcx)

# qhasm:   *(int128 *) (c + 1216) = xmm4
# asm 1: movdqa <xmm4=int6464#5,1216(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,1216(<c=%rcx)
movdqa %xmm4,1216(%rcx)

# qhasm:   *(int128 *) (c + 1232) = xmm5
# asm 1: movdqa <xmm5=int6464#6,1232(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,1232(<c=%rcx)
movdqa %xmm5,1232(%rcx)

# qhasm:   *(int128 *) (c + 1248) = xmm6
# asm 1: movdqa <xmm6=int6464#7,1248(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,1248(<c=%rcx)
movdqa %xmm6,1248(%rcx)

# qhasm:   *(int128 *) (c + 1264) = xmm7
# asm 1: movdqa <xmm7=int6464#8,1264(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,1264(<c=%rcx)
movdqa %xmm7,1264(%rcx)

# qhasm:   e = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>e=int64#1d
# asm 2: movzbl  <x3=%dh,>e=%edi
movzbl  %dh,%edi

# qhasm:   e = *(uint8 *) (sboxp + e)
# asm 1: movzbq (<sboxp=int64#2,<e=int64#1),>e=int64#9
# asm 2: movzbq (<sboxp=%rsi,<e=%rdi),>e=%r11
movzbq (%rsi,%rdi),%r11

# qhasm:   (uint32) e ^= 54
# asm 1: xor  $54,<e=int64#9d
# asm 2: xor  $54,<e=%r11d
xor  $54,%r11d

# qhasm:   q3 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q3=int64#1d
# asm 2: movzbl  <x3=%dl,>q3=%edi
movzbl  %dl,%edi

# qhasm:   q3 = *(uint8 *) (sboxp + q3)
# asm 1: movzbq (<sboxp=int64#2,<q3=int64#1),>q3=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q3=%rdi),>q3=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q3 <<= 24
# asm 1: shl  $24,<q3=int64#1
# asm 2: shl  $24,<q3=%rdi
shl  $24,%rdi

# qhasm:   e ^= q3
# asm 1: xor  <q3=int64#1,<e=int64#9
# asm 2: xor  <q3=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q2 = (x3 >> 8) & 255
# asm 1: movzbl  <x3=int64#3%next8,>q2=int64#1d
# asm 2: movzbl  <x3=%dh,>q2=%edi
movzbl  %dh,%edi

# qhasm:   q2 = *(uint8 *) (sboxp + q2)
# asm 1: movzbq (<sboxp=int64#2,<q2=int64#1),>q2=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q2=%rdi),>q2=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q2 <<= 16
# asm 1: shl  $16,<q2=int64#1
# asm 2: shl  $16,<q2=%rdi
shl  $16,%rdi

# qhasm:   e ^= q2
# asm 1: xor  <q2=int64#1,<e=int64#9
# asm 2: xor  <q2=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   q1 = x3 & 255
# asm 1: movzbl  <x3=int64#3b,>q1=int64#1d
# asm 2: movzbl  <x3=%dl,>q1=%edi
movzbl  %dl,%edi

# qhasm:   (uint32) x3 <<<= 16
# asm 1: rol  $16,<x3=int64#3d
# asm 2: rol  $16,<x3=%edx
rol  $16,%edx

# qhasm:   q1 = *(uint8 *) (sboxp + q1)
# asm 1: movzbq (<sboxp=int64#2,<q1=int64#1),>q1=int64#1
# asm 2: movzbq (<sboxp=%rsi,<q1=%rdi),>q1=%rdi
movzbq (%rsi,%rdi),%rdi

# qhasm:   q1 <<= 8
# asm 1: shl  $8,<q1=int64#1
# asm 2: shl  $8,<q1=%rdi
shl  $8,%rdi

# qhasm:   e ^= q1
# asm 1: xor  <q1=int64#1,<e=int64#9
# asm 2: xor  <q1=%rdi,<e=%r11
xor  %rdi,%r11

# qhasm:   x0 ^= e
# asm 1: xor  <e=int64#9,<x0=int64#6
# asm 2: xor  <e=%r11,<x0=%r9
xor  %r11,%r9

# qhasm:   *(uint32 *) (keyp + 0) = x0
# asm 1: movl   <x0=int64#6d,0(<keyp=int64#5)
# asm 2: movl   <x0=%r9d,0(<keyp=%r8)
movl   %r9d,0(%r8)

# qhasm:   x1 ^= x0
# asm 1: xor  <x0=int64#6,<x1=int64#7
# asm 2: xor  <x0=%r9,<x1=%rax
xor  %r9,%rax

# qhasm:   *(uint32 *) (keyp + 4) = x1
# asm 1: movl   <x1=int64#7d,4(<keyp=int64#5)
# asm 2: movl   <x1=%eax,4(<keyp=%r8)
movl   %eax,4(%r8)

# qhasm:   x2 ^= x1
# asm 1: xor  <x1=int64#7,<x2=int64#8
# asm 2: xor  <x1=%rax,<x2=%r10
xor  %rax,%r10

# qhasm:   *(uint32 *) (keyp + 8) = x2
# asm 1: movl   <x2=int64#8d,8(<keyp=int64#5)
# asm 2: movl   <x2=%r10d,8(<keyp=%r8)
movl   %r10d,8(%r8)

# qhasm:   x3 ^= x2
# asm 1: xor  <x2=int64#8,<x3=int64#3
# asm 2: xor  <x2=%r10,<x3=%rdx
xor  %r10,%rdx

# qhasm:   *(uint32 *) (keyp + 12) = x3
# asm 1: movl   <x3=int64#3d,12(<keyp=int64#5)
# asm 2: movl   <x3=%edx,12(<keyp=%r8)
movl   %edx,12(%r8)

# qhasm:   xmm0 = *(int128 *) (keyp + 0)
# asm 1: movdqa 0(<keyp=int64#5),>xmm0=int6464#1
# asm 2: movdqa 0(<keyp=%r8),>xmm0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm:   xmm1 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm1=int6464#2
# asm 2: movdqa <xmm0=%xmm0,>xmm1=%xmm1
movdqa %xmm0,%xmm1

# qhasm:   xmm2 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm2=int6464#3
# asm 2: movdqa <xmm0=%xmm0,>xmm2=%xmm2
movdqa %xmm0,%xmm2

# qhasm:   xmm3 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm3=int6464#4
# asm 2: movdqa <xmm0=%xmm0,>xmm3=%xmm3
movdqa %xmm0,%xmm3

# qhasm:   xmm4 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm4=int6464#5
# asm 2: movdqa <xmm0=%xmm0,>xmm4=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   xmm5 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm5=int6464#6
# asm 2: movdqa <xmm0=%xmm0,>xmm5=%xmm5
movdqa %xmm0,%xmm5

# qhasm:   xmm6 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm6=int6464#7
# asm 2: movdqa <xmm0=%xmm0,>xmm6=%xmm6
movdqa %xmm0,%xmm6

# qhasm:   xmm7 = xmm0
# asm 1: movdqa <xmm0=int6464#1,>xmm7=int6464#8
# asm 2: movdqa <xmm0=%xmm0,>xmm7=%xmm7
movdqa %xmm0,%xmm7

# qhasm:       t = xmm6
# asm 1: movdqa <xmm6=int6464#7,>t=int6464#9
# asm 2: movdqa <xmm6=%xmm6,>t=%xmm8
movdqa %xmm6,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 1
# asm 1: psrlq $1,<t=int6464#9
# asm 2: psrlq $1,<t=%xmm8
psrlq $1,%xmm8

# qhasm:       t ^= xmm1
# asm 1: pxor  <xmm1=int6464#2,<t=int6464#9
# asm 2: pxor  <xmm1=%xmm1,<t=%xmm8
pxor  %xmm1,%xmm8

# qhasm:       t &= BS0
# asm 1: pand  BS0,<t=int6464#9
# asm 2: pand  BS0,<t=%xmm8
pand  BS0,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       uint6464 t <<= 1
# asm 1: psllq $1,<t=int6464#9
# asm 2: psllq $1,<t=%xmm8
psllq $1,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm5
# asm 1: movdqa <xmm5=int6464#6,>t=int6464#9
# asm 2: movdqa <xmm5=%xmm5,>t=%xmm8
movdqa %xmm5,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       t = xmm4
# asm 1: movdqa <xmm4=int6464#5,>t=int6464#9
# asm 2: movdqa <xmm4=%xmm4,>t=%xmm8
movdqa %xmm4,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm3
# asm 1: pxor  <xmm3=int6464#4,<t=int6464#9
# asm 2: pxor  <xmm3=%xmm3,<t=%xmm8
pxor  %xmm3,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 2
# asm 1: psrlq $2,<t=int6464#9
# asm 2: psrlq $2,<t=%xmm8
psrlq $2,%xmm8

# qhasm:       t ^= xmm2
# asm 1: pxor  <xmm2=int6464#3,<t=int6464#9
# asm 2: pxor  <xmm2=%xmm2,<t=%xmm8
pxor  %xmm2,%xmm8

# qhasm:       t &= BS1
# asm 1: pand  BS1,<t=int6464#9
# asm 2: pand  BS1,<t=%xmm8
pand  BS1,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       uint6464 t <<= 2
# asm 1: psllq $2,<t=int6464#9
# asm 2: psllq $2,<t=%xmm8
psllq $2,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:       t = xmm3
# asm 1: movdqa <xmm3=int6464#4,>t=int6464#9
# asm 2: movdqa <xmm3=%xmm3,>t=%xmm8
movdqa %xmm3,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm7
# asm 1: pxor  <xmm7=int6464#8,<t=int6464#9
# asm 2: pxor  <xmm7=%xmm7,<t=%xmm8
pxor  %xmm7,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm7 ^= t
# asm 1: pxor  <t=int6464#9,<xmm7=int6464#8
# asm 2: pxor  <t=%xmm8,<xmm7=%xmm7
pxor  %xmm8,%xmm7

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm3 ^= t
# asm 1: pxor  <t=int6464#9,<xmm3=int6464#4
# asm 2: pxor  <t=%xmm8,<xmm3=%xmm3
pxor  %xmm8,%xmm3

# qhasm:       t = xmm2
# asm 1: movdqa <xmm2=int6464#3,>t=int6464#9
# asm 2: movdqa <xmm2=%xmm2,>t=%xmm8
movdqa %xmm2,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm6
# asm 1: pxor  <xmm6=int6464#7,<t=int6464#9
# asm 2: pxor  <xmm6=%xmm6,<t=%xmm8
pxor  %xmm6,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm6 ^= t
# asm 1: pxor  <t=int6464#9,<xmm6=int6464#7
# asm 2: pxor  <t=%xmm8,<xmm6=%xmm6
pxor  %xmm8,%xmm6

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm2 ^= t
# asm 1: pxor  <t=int6464#9,<xmm2=int6464#3
# asm 2: pxor  <t=%xmm8,<xmm2=%xmm2
pxor  %xmm8,%xmm2

# qhasm:       t = xmm1
# asm 1: movdqa <xmm1=int6464#2,>t=int6464#9
# asm 2: movdqa <xmm1=%xmm1,>t=%xmm8
movdqa %xmm1,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm5
# asm 1: pxor  <xmm5=int6464#6,<t=int6464#9
# asm 2: pxor  <xmm5=%xmm5,<t=%xmm8
pxor  %xmm5,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm5 ^= t
# asm 1: pxor  <t=int6464#9,<xmm5=int6464#6
# asm 2: pxor  <t=%xmm8,<xmm5=%xmm5
pxor  %xmm8,%xmm5

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm1 ^= t
# asm 1: pxor  <t=int6464#9,<xmm1=int6464#2
# asm 2: pxor  <t=%xmm8,<xmm1=%xmm1
pxor  %xmm8,%xmm1

# qhasm:       t = xmm0
# asm 1: movdqa <xmm0=int6464#1,>t=int6464#9
# asm 2: movdqa <xmm0=%xmm0,>t=%xmm8
movdqa %xmm0,%xmm8

# qhasm:       uint6464 t >>= 4
# asm 1: psrlq $4,<t=int6464#9
# asm 2: psrlq $4,<t=%xmm8
psrlq $4,%xmm8

# qhasm:       t ^= xmm4
# asm 1: pxor  <xmm4=int6464#5,<t=int6464#9
# asm 2: pxor  <xmm4=%xmm4,<t=%xmm8
pxor  %xmm4,%xmm8

# qhasm:       t &= BS2
# asm 1: pand  BS2,<t=int6464#9
# asm 2: pand  BS2,<t=%xmm8
pand  BS2,%xmm8

# qhasm:       xmm4 ^= t
# asm 1: pxor  <t=int6464#9,<xmm4=int6464#5
# asm 2: pxor  <t=%xmm8,<xmm4=%xmm4
pxor  %xmm8,%xmm4

# qhasm:       uint6464 t <<= 4
# asm 1: psllq $4,<t=int6464#9
# asm 2: psllq $4,<t=%xmm8
psllq $4,%xmm8

# qhasm:       xmm0 ^= t
# asm 1: pxor  <t=int6464#9,<xmm0=int6464#1
# asm 2: pxor  <t=%xmm8,<xmm0=%xmm0
pxor  %xmm8,%xmm0

# qhasm:   xmm6 ^= ONE
# asm 1: pxor  ONE,<xmm6=int6464#7
# asm 2: pxor  ONE,<xmm6=%xmm6
pxor  ONE,%xmm6

# qhasm:   xmm5 ^= ONE
# asm 1: pxor  ONE,<xmm5=int6464#6
# asm 2: pxor  ONE,<xmm5=%xmm5
pxor  ONE,%xmm5

# qhasm:   xmm1 ^= ONE
# asm 1: pxor  ONE,<xmm1=int6464#2
# asm 2: pxor  ONE,<xmm1=%xmm1
pxor  ONE,%xmm1

# qhasm:   xmm0 ^= ONE
# asm 1: pxor  ONE,<xmm0=int6464#1
# asm 2: pxor  ONE,<xmm0=%xmm0
pxor  ONE,%xmm0

# qhasm:   *(int128 *) (c + 1280) = xmm0
# asm 1: movdqa <xmm0=int6464#1,1280(<c=int64#4)
# asm 2: movdqa <xmm0=%xmm0,1280(<c=%rcx)
movdqa %xmm0,1280(%rcx)

# qhasm:   *(int128 *) (c + 1296) = xmm1
# asm 1: movdqa <xmm1=int6464#2,1296(<c=int64#4)
# asm 2: movdqa <xmm1=%xmm1,1296(<c=%rcx)
movdqa %xmm1,1296(%rcx)

# qhasm:   *(int128 *) (c + 1312) = xmm2
# asm 1: movdqa <xmm2=int6464#3,1312(<c=int64#4)
# asm 2: movdqa <xmm2=%xmm2,1312(<c=%rcx)
movdqa %xmm2,1312(%rcx)

# qhasm:   *(int128 *) (c + 1328) = xmm3
# asm 1: movdqa <xmm3=int6464#4,1328(<c=int64#4)
# asm 2: movdqa <xmm3=%xmm3,1328(<c=%rcx)
movdqa %xmm3,1328(%rcx)

# qhasm:   *(int128 *) (c + 1344) = xmm4
# asm 1: movdqa <xmm4=int6464#5,1344(<c=int64#4)
# asm 2: movdqa <xmm4=%xmm4,1344(<c=%rcx)
movdqa %xmm4,1344(%rcx)

# qhasm:   *(int128 *) (c + 1360) = xmm5
# asm 1: movdqa <xmm5=int6464#6,1360(<c=int64#4)
# asm 2: movdqa <xmm5=%xmm5,1360(<c=%rcx)
movdqa %xmm5,1360(%rcx)

# qhasm:   *(int128 *) (c + 1376) = xmm6
# asm 1: movdqa <xmm6=int6464#7,1376(<c=int64#4)
# asm 2: movdqa <xmm6=%xmm6,1376(<c=%rcx)
movdqa %xmm6,1376(%rcx)

# qhasm:   *(int128 *) (c + 1392) = xmm7
# asm 1: movdqa <xmm7=int6464#8,1392(<c=int64#4)
# asm 2: movdqa <xmm7=%xmm7,1392(<c=%rcx)
movdqa %xmm7,1392(%rcx)

# qhasm: r11_caller = r11_caller_stack
# asm 1: movq <r11_caller_stack=stack64#1,>r11_caller=int64#9
# asm 2: movq <r11_caller_stack=32(%rsp),>r11_caller=%r11
movq 32(%rsp),%r11

# qhasm: leave
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
ret
.globl sbox
	.section	.rodata
	.p2align 6
	.type	sbox, @object
	.size	sbox, 256
sbox:
	.byte	99
	.byte	124
	.byte	119
	.byte	123
	.byte	-14
	.byte	107
	.byte	111
	.byte	-59
	.byte	48
	.byte	1
	.byte	103
	.byte	43
	.byte	-2
	.byte	-41
	.byte	-85
	.byte	118
	.byte	-54
	.byte	-126
	.byte	-55
	.byte	125
	.byte	-6
	.byte	89
	.byte	71
	.byte	-16
	.byte	-83
	.byte	-44
	.byte	-94
	.byte	-81
	.byte	-100
	.byte	-92
	.byte	114
	.byte	-64
	.byte	-73
	.byte	-3
	.byte	-109
	.byte	38
	.byte	54
	.byte	63
	.byte	-9
	.byte	-52
	.byte	52
	.byte	-91
	.byte	-27
	.byte	-15
	.byte	113
	.byte	-40
	.byte	49
	.byte	21
	.byte	4
	.byte	-57
	.byte	35
	.byte	-61
	.byte	24
	.byte	-106
	.byte	5
	.byte	-102
	.byte	7
	.byte	18
	.byte	-128
	.byte	-30
	.byte	-21
	.byte	39
	.byte	-78
	.byte	117
	.byte	9
	.byte	-125
	.byte	44
	.byte	26
	.byte	27
	.byte	110
	.byte	90
	.byte	-96
	.byte	82
	.byte	59
	.byte	-42
	.byte	-77
	.byte	41
	.byte	-29
	.byte	47
	.byte	-124
	.byte	83
	.byte	-47
	.byte	0
	.byte	-19
	.byte	32
	.byte	-4
	.byte	-79
	.byte	91
	.byte	106
	.byte	-53
	.byte	-66
	.byte	57
	.byte	74
	.byte	76
	.byte	88
	.byte	-49
	.byte	-48
	.byte	-17
	.byte	-86
	.byte	-5
	.byte	67
	.byte	77
	.byte	51
	.byte	-123
	.byte	69
	.byte	-7
	.byte	2
	.byte	127
	.byte	80
	.byte	60
	.byte	-97
	.byte	-88
	.byte	81
	.byte	-93
	.byte	64
	.byte	-113
	.byte	-110
	.byte	-99
	.byte	56
	.byte	-11
	.byte	-68
	.byte	-74
	.byte	-38
	.byte	33
	.byte	16
	.byte	-1
	.byte	-13
	.byte	-46
	.byte	-51
	.byte	12
	.byte	19
	.byte	-20
	.byte	95
	.byte	-105
	.byte	68
	.byte	23
	.byte	-60
	.byte	-89
	.byte	126
	.byte	61
	.byte	100
	.byte	93
	.byte	25
	.byte	115
	.byte	96
	.byte	-127
	.byte	79
	.byte	-36
	.byte	34
	.byte	42
	.byte	-112
	.byte	-120
	.byte	70
	.byte	-18
	.byte	-72
	.byte	20
	.byte	-34
	.byte	94
	.byte	11
	.byte	-37
	.byte	-32
	.byte	50
	.byte	58
	.byte	10
	.byte	73
	.byte	6
	.byte	36
	.byte	92
	.byte	-62
	.byte	-45
	.byte	-84
	.byte	98
	.byte	-111
	.byte	-107
	.byte	-28
	.byte	121
	.byte	-25
	.byte	-56
	.byte	55
	.byte	109
	.byte	-115
	.byte	-43
	.byte	78
	.byte	-87
	.byte	108
	.byte	86
	.byte	-12
	.byte	-22
	.byte	101
	.byte	122
	.byte	-82
	.byte	8
	.byte	-70
	.byte	120
	.byte	37
	.byte	46
	.byte	28
	.byte	-90
	.byte	-76
	.byte	-58
	.byte	-24
	.byte	-35
	.byte	116
	.byte	31
	.byte	75
	.byte	-67
	.byte	-117
	.byte	-118
	.byte	112
	.byte	62
	.byte	-75
	.byte	102
	.byte	72
	.byte	3
	.byte	-10
	.byte	14
	.byte	97
	.byte	53
	.byte	87
	.byte	-71
	.byte	-122
	.byte	-63
	.byte	29
	.byte	-98
	.byte	-31
	.byte	-8
	.byte	-104
	.byte	17
	.byte	105
	.byte	-39
	.byte	-114
	.byte	-108
	.byte	-101
	.byte	30
	.byte	-121
	.byte	-23
	.byte	-50
	.byte	85
	.byte	40
	.byte	-33
	.byte	-116
	.byte	-95
	.byte	-119
	.byte	13
	.byte	-65
	.byte	-26
	.byte	66
	.byte	104
	.byte	65
	.byte	-103
	.byte	45
	.byte	15
	.byte	-80
	.byte	84
	.byte	-69
	.byte	22
# Author: Emilia Käsper and Peter Schwabe
# Date: 2009-03-19
# Public domain

.data

.globl RCON
.globl ROTB
.globl EXPB0
.globl ONE
.globl BS0
.globl BS1
.globl BS2
.globl CTRINC1
.globl CTRINC2
.globl CTRINC3
.globl CTRINC4
.globl CTRINC5
.globl CTRINC6
.globl CTRINC7
.globl M0
.globl SRM0
.globl SR

.p2align 6
#.align 16

#.section .rodata

RCON: .int 0x00000000, 0x00000000, 0x00000000, 0xffffffff
ROTB: .int 0x0c000000, 0x00000000, 0x04000000, 0x08000000
EXPB0: .int 0x03030303, 0x07070707, 0x0b0b0b0b, 0x0f0f0f0f
CTRINC1: .int 0x00000001, 0x00000000, 0x00000000, 0x00000000
CTRINC2: .int 0x00000002, 0x00000000, 0x00000000, 0x00000000
CTRINC3: .int 0x00000003, 0x00000000, 0x00000000, 0x00000000
CTRINC4: .int 0x00000004, 0x00000000, 0x00000000, 0x00000000
CTRINC5: .int 0x00000005, 0x00000000, 0x00000000, 0x00000000
CTRINC6: .int 0x00000006, 0x00000000, 0x00000000, 0x00000000
CTRINC7: .int 0x00000007, 0x00000000, 0x00000000, 0x00000000

BS0: .quad 0x5555555555555555, 0x5555555555555555
BS1: .quad 0x3333333333333333, 0x3333333333333333
BS2: .quad 0x0f0f0f0f0f0f0f0f, 0x0f0f0f0f0f0f0f0f
ONE: .quad 0xffffffffffffffff, 0xffffffffffffffff
M0:  .quad 0x02060a0e03070b0f, 0x0004080c0105090d
SRM0:	.quad 0x0304090e00050a0f, 0x01060b0c0207080d
SR: .quad 0x0504070600030201, 0x0f0e0d0c0a09080b



# Author: Emilia Käsper and Peter Schwabe
# Date: 2009-03-19
# Public domain

.data

.globl BM31
.globl BM30
.globl BM29
.globl BM28

.globl BM27
.globl BM26
.globl BM25
.globl BM24

.globl BM23
.globl BM22
.globl BM21
.globl BM20

.globl BM19
.globl BM18
.globl BM17
.globl BM16

.globl BM15
.globl BM14
.globl BM13
.globl BM12

.globl BM11
.globl BM10
.globl BM09
.globl BM08

.globl BM07
.globl BM06
.globl BM05
.globl BM04

.globl BM03
.globl BM02
.globl BM01
.globl BM00

.globl REVERS

.globl BIT063
.globl BIT064
.globl BIT127
.globl GCMPOL

.globl SWAP32
.globl M0SWAP

.globl RCTRINC1
.globl RCTRINC2
.globl RCTRINC3
.globl RCTRINC4
.globl RCTRINC5
.globl RCTRINC6
.globl RCTRINC7

.p2align 6
#.align 16

#.section .rodata

SWAP32: .int 0x00010203, 0x04050607, 0x08090a0b, 0x0c0d0e0f
RCTRINC1: .int 0x00000000, 0x00000000, 0x00000000, 0x00000001
RCTRINC2: .int 0x00000000, 0x00000000, 0x00000000, 0x00000002
RCTRINC3: .int 0x00000000, 0x00000000, 0x00000000, 0x00000003
RCTRINC4: .int 0x00000000, 0x00000000, 0x00000000, 0x00000004
RCTRINC5: .int 0x00000000, 0x00000000, 0x00000000, 0x00000005
RCTRINC6: .int 0x00000000, 0x00000000, 0x00000000, 0x00000006
RCTRINC7: .int 0x00000000, 0x00000000, 0x00000000, 0x00000007

REVERS: .quad 0x08090A0B0C0D0E0F, 0x0001020304050607

BIT063: .quad 0x0000000000000000, 0x0000000000000001
BIT064: .quad 0x8000000000000000, 0x0000000000000000
BIT127: .quad 0x0000000000000001, 0x0000000000000000
GCMPOL: .quad 0x0000000000000000, 0xE100000000000000

BM31: .quad 0x0000000100000001, 0x0000000100000001
BM30: .quad 0x0000000200000002, 0x0000000200000002
BM29: .quad 0x0000000400000004, 0x0000000400000004
BM28: .quad 0x0000000800000008, 0x0000000800000008

BM27: .quad 0x0000001000000010, 0x0000001000000010
BM26: .quad 0x0000002000000020, 0x0000002000000020
BM25: .quad 0x0000004000000040, 0x0000004000000040
BM24: .quad 0x0000008000000080, 0x0000008000000080

BM23: .quad 0x0000010000000100, 0x0000010000000100
BM22: .quad 0x0000020000000200, 0x0000020000000200
BM21: .quad 0x0000040000000400, 0x0000040000000400
BM20: .quad 0x0000080000000800, 0x0000080000000800

BM19: .quad 0x0000100000001000, 0x0000100000001000
BM18: .quad 0x0000200000002000, 0x0000200000002000
BM17: .quad 0x0000400000004000, 0x0000400000004000
BM16: .quad 0x0000800000008000, 0x0000800000008000

BM15: .quad 0x0001000000010000, 0x0001000000010000
BM14: .quad 0x0002000000020000, 0x0002000000020000
BM13: .quad 0x0004000000040000, 0x0004000000040000
BM12: .quad 0x0008000000080000, 0x0008000000080000

BM11: .quad 0x0010000000100000, 0x0010000000100000
BM10: .quad 0x0020000000200000, 0x0020000000200000
BM09: .quad 0x0040000000400000, 0x0040000000400000
BM08: .quad 0x0080000000800000, 0x0080000000800000

BM07: .quad 0x0100000001000000, 0x0100000001000000
BM06: .quad 0x0200000002000000, 0x0200000002000000
BM05: .quad 0x0400000004000000, 0x0400000004000000
BM04: .quad 0x0800000008000000, 0x0800000008000000

BM03: .quad 0x1000000010000000, 0x1000000010000000
BM02: .quad 0x2000000020000000, 0x2000000020000000
BM01: .quad 0x4000000040000000, 0x4000000040000000
BM00: .quad 0x8000000080000000, 0x8000000080000000

M0SWAP: .quad 0x0105090d0004080c , 0x03070b0f02060a0e




# qhasm: int64 arg1

# qhasm: int64 arg2

# qhasm: int64 arg3

# qhasm: input arg1

# qhasm: input arg2

# qhasm: input arg3

# qhasm: int64 r11_caller

# qhasm: int64 r12_caller

# qhasm: int64 r13_caller

# qhasm: int64 r14_caller

# qhasm: int64 r15_caller

# qhasm: int64 rbx_caller

# qhasm: int64 rbp_caller

# qhasm: caller r11_caller

# qhasm: caller r12_caller

# qhasm: caller r13_caller

# qhasm: caller r14_caller

# qhasm: caller r15_caller

# qhasm: caller rbx_caller

# qhasm: caller rbp_caller

# qhasm: stack64 r11_stack

# qhasm: stack64 r12_stack

# qhasm: stack64 r13_stack

# qhasm: stack64 r14_stack

# qhasm: stack64 r15_stack

# qhasm: stack64 rbx_stack

# qhasm: stack64 rbp_stack

# qhasm: int64 table

# qhasm: int64 gfmtable

# qhasm: int64 redtable

# qhasm: stack64 gfmtable_stack

# qhasm: int64 check

# qhasm: int64 c

# qhasm: int64 k

# qhasm: int64 iv

# qhasm: int64 tag

# qhasm: int64 outp

# qhasm: int64 x0

# qhasm: int64 x1

# qhasm: int64 x2

# qhasm: int64 x3

# qhasm: int64 e

# qhasm: int64 q0

# qhasm: int64 q1

# qhasm: int64 q2

# qhasm: int64 q3

# qhasm: int64 tmp

# qhasm: int64 mainloopbytes

# qhasm: int64 in

# qhasm: int64 out

# qhasm: int64 len

# qhasm: int64 tmpoutp

# qhasm: stack64 outstack

# qhasm: stack64 argout

# qhasm: stack64 arglen

# qhasm: int64 inv

# qhasm: int64 outv

# qhasm: int64 zero

# qhasm: int64 mask

# qhasm: int6464 n0

# qhasm: int6464 n1

# qhasm: int6464 n2

# qhasm: int6464 n3

# qhasm: int6464 t0dq

# qhasm: int6464 t0dqu

# qhasm: int6464 t0dql

# qhasm: int6464 rh

# qhasm: int6464 rl

# qhasm: int6464 t1dq

# qhasm: int6464 t1dql

# qhasm: int6464 t1dqu

# qhasm: int6464 t2dq

# qhasm: int6464 t2dql

# qhasm: int6464 t2dqu

# qhasm: int6464 t3dq

# qhasm: int6464 t3dql

# qhasm: int6464 t3dqu

# qhasm: int6464 r

# qhasm: int6464 cbyte

# qhasm: int6464 cbyte0

# qhasm: int6464 cbyte1

# qhasm: int6464 cbyte2

# qhasm: int6464 cbyte3

# qhasm: int64 rbyte

# qhasm: int64 rbyte0

# qhasm: int64 rbyte0u

# qhasm: int64 rbyte0l

# qhasm: int64 rbyte1

# qhasm: int64 rbyte1u

# qhasm: int64 rbyte1l

# qhasm: int64 rbyte2

# qhasm: int64 rbyte2u

# qhasm: int64 rbyte2l

# qhasm: int64 rbyte3

# qhasm: int64 rbyte3u

# qhasm: int64 rbyte3l

# qhasm: int64 carry

# qhasm: int64 carry0

# qhasm: int64 carry1

# qhasm: int64 carry2

# qhasm: int64 carry3

# qhasm: int64 t0

# qhasm: int64 t1

# qhasm: int64 red

# qhasm: stack64 pre10

# qhasm: stack64 pre20

# qhasm: stack64 pre21

# qhasm: stack64 pre22

# qhasm: stack64 pre23

# qhasm: int6464 ty0

# qhasm: stack64 r0

# qhasm: stack64 r1

# qhasm: stack64 r2

# qhasm: stack64 r3

# qhasm: stack64 r4

# qhasm: stack64 r5

# qhasm: stack64 r6

# qhasm: stack64 r7

# qhasm: stack64 r8

# qhasm: stack64 r9

# qhasm: stack64 r10

# qhasm: stack64 r11

# qhasm: int3232 r12

# qhasm: int3232 r13

# qhasm: int3232 r14

# qhasm: int3232 r15

# qhasm: int3232 r16

# qhasm: int6464 r20

# qhasm: int6464 r24

# qhasm: int6464 r28

# qhasm: int6464 r32

# qhasm: int6464 r36

# qhasm: int6464 r40

# qhasm: int6464 pr0

# qhasm: int6464 pr1

# qhasm: int6464 pr2

# qhasm: int6464 pr3

# qhasm: int64 y0

# qhasm: int64 y2

# qhasm: int64 y3

# qhasm: int64 ny3

# qhasm: int64 z0

# qhasm: int64 z1u

# qhasm: int64 z1l

# qhasm: int64 z2

# qhasm: int64 z3u

# qhasm: int64 z3l

# qhasm: int64 p00

# qhasm: int64 p01

# qhasm: int64 p02

# qhasm: int64 p03

# qhasm: int64 p10

# qhasm: int64 p11

# qhasm: int64 p12

# qhasm: int64 p13

# qhasm: int64 p20

# qhasm: int64 p21

# qhasm: int64 p22

# qhasm: int64 p23

# qhasm: int64 p30

# qhasm: int64 p31

# qhasm: int64 p32

# qhasm: int64 p33

# qhasm: int64 b0

# qhasm: int64 b1

# qhasm: int64 b2

# qhasm: int64 b3

# qhasm: stack128 tmpout

# qhasm: enter authenticate
.text
.p2align 5
.globl _authenticate
.globl authenticate
_authenticate:
authenticate:
mov %rsp,%r11
and $31,%r11
add $96,%r11
sub %r11,%rsp

# qhasm: r11_stack = r11_caller
# asm 1: movq <r11_caller=int64#9,>r11_stack=stack64#1
# asm 2: movq <r11_caller=%r11,>r11_stack=32(%rsp)
movq %r11,32(%rsp)

# qhasm: r12_stack = r12_caller
# asm 1: movq <r12_caller=int64#10,>r12_stack=stack64#2
# asm 2: movq <r12_caller=%r12,>r12_stack=40(%rsp)
movq %r12,40(%rsp)

# qhasm: r13_stack = r13_caller
# asm 1: movq <r13_caller=int64#11,>r13_stack=stack64#3
# asm 2: movq <r13_caller=%r13,>r13_stack=48(%rsp)
movq %r13,48(%rsp)

# qhasm: r14_stack = r14_caller
# asm 1: movq <r14_caller=int64#12,>r14_stack=stack64#4
# asm 2: movq <r14_caller=%r14,>r14_stack=56(%rsp)
movq %r14,56(%rsp)

# qhasm: r15_stack = r15_caller
# asm 1: movq <r15_caller=int64#13,>r15_stack=stack64#5
# asm 2: movq <r15_caller=%r15,>r15_stack=64(%rsp)
movq %r15,64(%rsp)

# qhasm: rbx_stack = rbx_caller
# asm 1: movq <rbx_caller=int64#14,>rbx_stack=stack64#6
# asm 2: movq <rbx_caller=%rbx,>rbx_stack=72(%rsp)
movq %rbx,72(%rsp)

# qhasm: rbp_stack = rbp_caller
# asm 1: movq <rbp_caller=int64#15,>rbp_stack=stack64#7
# asm 2: movq <rbp_caller=%rbp,>rbp_stack=80(%rsp)
movq %rbp,80(%rsp)

# qhasm: c = arg1
# asm 1: mov  <arg1=int64#1,>c=int64#5
# asm 2: mov  <arg1=%rdi,>c=%r8
mov  %rdi,%r8

# qhasm: outp = arg2
# asm 1: mov  <arg2=int64#2,>outp=int64#2
# asm 2: mov  <arg2=%rsi,>outp=%rsi
mov  %rsi,%rsi

# qhasm: len = arg3
# asm 1: mov  <arg3=int64#3,>len=int64#6
# asm 2: mov  <arg3=%rdx,>len=%r9
mov  %rdx,%r9

# qhasm: tmp = 0xf0f0f0f0
# asm 1: mov  $0xf0f0f0f0,>tmp=int64#1
# asm 2: mov  $0xf0f0f0f0,>tmp=%rdi
mov  $0xf0f0f0f0,%rdi

# qhasm: mask = tmp
# asm 1: mov  <tmp=int64#1,>mask=int64#7
# asm 2: mov  <tmp=%rdi,>mask=%rax
mov  %rdi,%rax

# qhasm: tmp <<= 32
# asm 1: shl  $32,<tmp=int64#1
# asm 2: shl  $32,<tmp=%rdi
shl  $32,%rdi

# qhasm: mask ^= tmp
# asm 1: xor  <tmp=int64#1,<mask=int64#7
# asm 2: xor  <tmp=%rdi,<mask=%rax
xor  %rdi,%rax

# qhasm: z1u = *(uint64 *)(c + 1424)
# asm 1: movq   1424(<c=int64#5),>z1u=int64#4
# asm 2: movq   1424(<c=%r8),>z1u=%rcx
movq   1424(%r8),%rcx

# qhasm: z3u = *(uint64 *)(c + 1432)
# asm 1: movq   1432(<c=int64#5),>z3u=int64#14
# asm 2: movq   1432(<c=%r8),>z3u=%rbx
movq   1432(%r8),%rbx

# qhasm: gfmtable = c + 1456
# asm 1: lea  1456(<c=int64#5),>gfmtable=int64#8
# asm 2: lea  1456(<c=%r8),>gfmtable=%r10
lea  1456(%r8),%r10

# qhasm: redtable = &red_table
# asm 1: lea  red_table(%rip),>redtable=int64#1
# asm 2: lea  red_table(%rip),>redtable=%rdi
lea  red_table(%rip),%rdi

# qhasm: loop:
._loop:

# qhasm: unsigned<? len -=16
# asm 1: sub  $16,<len=int64#6
# asm 2: sub  $16,<len=%r9
sub  $16,%r9
# comment:fp stack unchanged by jump

# qhasm: goto authpartial if unsigned<
jb ._authpartial

# qhasm:   z1u ^= *(uint64 *) (outp + 0)
# asm 1: xorq 0(<outp=int64#2),<z1u=int64#4
# asm 2: xorq 0(<outp=%rsi),<z1u=%rcx
xorq 0(%rsi),%rcx

# qhasm:   z3u ^= *(uint64 *) (outp + 8)
# asm 1: xorq 8(<outp=int64#2),<z3u=int64#14
# asm 2: xorq 8(<outp=%rsi),<z3u=%rbx
xorq 8(%rsi),%rbx

# qhasm:   z3l = z3u
# asm 1: mov  <z3u=int64#14,>z3l=int64#3
# asm 2: mov  <z3u=%rbx,>z3l=%rdx
mov  %rbx,%rdx

# qhasm:   z3u <<= 4
# asm 1: shl  $4,<z3u=int64#14
# asm 2: shl  $4,<z3u=%rbx
shl  $4,%rbx

# qhasm:   z3u &= mask
# asm 1: and  <mask=int64#7,<z3u=int64#14
# asm 2: and  <mask=%rax,<z3u=%rbx
and  %rax,%rbx

# qhasm:   z3l &= mask
# asm 1: and  <mask=int64#7,<z3l=int64#3
# asm 2: and  <mask=%rax,<z3l=%rdx
and  %rax,%rdx

# qhasm:   rbyte0u = z3u & 255
# asm 1: movzbl  <z3u=int64#14b,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%bl,>rbyte0u=%edi
movzbl  %bl,%edi

# qhasm:   rbyte0l = z3l & 255
# asm 1: movzbl  <z3l=int64#3b,>rbyte0l=int64#9d
# asm 2: movzbl  <z3l=%dl,>rbyte0l=%r11d
movzbl  %dl,%r11d

# qhasm:   t0dql = *(int128 *)(gfmtable + 4096 + rbyte0l)
# asm 1: movdqa 4096(<gfmtable=int64#8,<rbyte0l=int64#9,1),>t0dql=int6464#1
# asm 2: movdqa 4096(<gfmtable=%r10,<rbyte0l=%r11,1),>t0dql=%xmm0
movdqa 4096(%r10,%r11,1),%xmm0

# qhasm:   t0dqu = *(int128 *)(gfmtable + 4352 + rbyte0u)
# asm 1: movdqa 4352(<gfmtable=int64#8,<rbyte0u=int64#1,1),>t0dqu=int6464#2
# asm 2: movdqa 4352(<gfmtable=%r10,<rbyte0u=%rdi,1),>t0dqu=%xmm1
movdqa 4352(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z3u >> 8) & 255
# asm 1: movzbl  <z3u=int64#14%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%bh,>rbyte0u=%edi
movzbl  %bh,%edi

# qhasm:   rbyte0l = (z3l >> 8) & 255
# asm 1: movzbl  <z3l=int64#3%next8,>rbyte0l=int64#15d
# asm 2: movzbl  <z3l=%dh,>rbyte0l=%ebp
movzbl  %dh,%ebp

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 4608 + rbyte0l)
# asm 1: pxor 4608(<gfmtable=int64#8,<rbyte0l=int64#15,1),<t0dql=int6464#1
# asm 2: pxor 4608(<gfmtable=%r10,<rbyte0l=%rbp,1),<t0dql=%xmm0
pxor 4608(%r10,%rbp,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 4864 + rbyte0u)
# asm 1: pxor 4864(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 4864(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 4864(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z3u >>= 16
# asm 1: shr  $16,<z3u=int64#14
# asm 2: shr  $16,<z3u=%rbx
shr  $16,%rbx

# qhasm:   (uint64) z3l >>= 16
# asm 1: shr  $16,<z3l=int64#3
# asm 2: shr  $16,<z3l=%rdx
shr  $16,%rdx

# qhasm:   rbyte0u = z3u & 255
# asm 1: movzbl  <z3u=int64#14b,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%bl,>rbyte0u=%edi
movzbl  %bl,%edi

# qhasm:   rbyte0l = z3l & 255
# asm 1: movzbl  <z3l=int64#3b,>rbyte0l=int64#9d
# asm 2: movzbl  <z3l=%dl,>rbyte0l=%r11d
movzbl  %dl,%r11d

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 5120 + rbyte0l)
# asm 1: pxor 5120(<gfmtable=int64#8,<rbyte0l=int64#9,1),<t0dql=int6464#1
# asm 2: pxor 5120(<gfmtable=%r10,<rbyte0l=%r11,1),<t0dql=%xmm0
pxor 5120(%r10,%r11,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 5376 + rbyte0u)
# asm 1: pxor 5376(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 5376(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 5376(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z3u >> 8) & 255
# asm 1: movzbl  <z3u=int64#14%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%bh,>rbyte0u=%edi
movzbl  %bh,%edi

# qhasm:   rbyte0l = (z3l >> 8) & 255
# asm 1: movzbl  <z3l=int64#3%next8,>rbyte0l=int64#15d
# asm 2: movzbl  <z3l=%dh,>rbyte0l=%ebp
movzbl  %dh,%ebp

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 5632 + rbyte0l)
# asm 1: pxor 5632(<gfmtable=int64#8,<rbyte0l=int64#15,1),<t0dql=int6464#1
# asm 2: pxor 5632(<gfmtable=%r10,<rbyte0l=%rbp,1),<t0dql=%xmm0
pxor 5632(%r10,%rbp,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 5888 + rbyte0u)
# asm 1: pxor 5888(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 5888(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 5888(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z3u >>= 16
# asm 1: shr  $16,<z3u=int64#14
# asm 2: shr  $16,<z3u=%rbx
shr  $16,%rbx

# qhasm:   (uint64) z3l >>= 16
# asm 1: shr  $16,<z3l=int64#3
# asm 2: shr  $16,<z3l=%rdx
shr  $16,%rdx

# qhasm:   rbyte0u = z3u & 255
# asm 1: movzbl  <z3u=int64#14b,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%bl,>rbyte0u=%edi
movzbl  %bl,%edi

# qhasm:   rbyte0l = z3l & 255
# asm 1: movzbl  <z3l=int64#3b,>rbyte0l=int64#9d
# asm 2: movzbl  <z3l=%dl,>rbyte0l=%r11d
movzbl  %dl,%r11d

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 6144 + rbyte0l)
# asm 1: pxor 6144(<gfmtable=int64#8,<rbyte0l=int64#9,1),<t0dql=int6464#1
# asm 2: pxor 6144(<gfmtable=%r10,<rbyte0l=%r11,1),<t0dql=%xmm0
pxor 6144(%r10,%r11,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 6400 + rbyte0u)
# asm 1: pxor 6400(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 6400(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 6400(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z3u >> 8) & 255
# asm 1: movzbl  <z3u=int64#14%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%bh,>rbyte0u=%edi
movzbl  %bh,%edi

# qhasm:   rbyte0l = (z3l >> 8) & 255
# asm 1: movzbl  <z3l=int64#3%next8,>rbyte0l=int64#15d
# asm 2: movzbl  <z3l=%dh,>rbyte0l=%ebp
movzbl  %dh,%ebp

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 6656 + rbyte0l)
# asm 1: pxor 6656(<gfmtable=int64#8,<rbyte0l=int64#15,1),<t0dql=int6464#1
# asm 2: pxor 6656(<gfmtable=%r10,<rbyte0l=%rbp,1),<t0dql=%xmm0
pxor 6656(%r10,%rbp,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 6912 + rbyte0u)
# asm 1: pxor 6912(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 6912(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 6912(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z3u >>= 16
# asm 1: shr  $16,<z3u=int64#14
# asm 2: shr  $16,<z3u=%rbx
shr  $16,%rbx

# qhasm:   (uint64) z3l >>= 16
# asm 1: shr  $16,<z3l=int64#3
# asm 2: shr  $16,<z3l=%rdx
shr  $16,%rdx

# qhasm:   rbyte0u = z3u & 255
# asm 1: movzbl  <z3u=int64#14b,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%bl,>rbyte0u=%edi
movzbl  %bl,%edi

# qhasm:   rbyte0l = z3l & 255
# asm 1: movzbl  <z3l=int64#3b,>rbyte0l=int64#9d
# asm 2: movzbl  <z3l=%dl,>rbyte0l=%r11d
movzbl  %dl,%r11d

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 7168 + rbyte0l)
# asm 1: pxor 7168(<gfmtable=int64#8,<rbyte0l=int64#9,1),<t0dql=int6464#1
# asm 2: pxor 7168(<gfmtable=%r10,<rbyte0l=%r11,1),<t0dql=%xmm0
pxor 7168(%r10,%r11,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 7424 + rbyte0u)
# asm 1: pxor 7424(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 7424(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 7424(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z3u >> 8) & 255
# asm 1: movzbl  <z3u=int64#14%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%bh,>rbyte0u=%edi
movzbl  %bh,%edi

# qhasm:   rbyte0l = (z3l >> 8) & 255
# asm 1: movzbl  <z3l=int64#3%next8,>rbyte0l=int64#14d
# asm 2: movzbl  <z3l=%dh,>rbyte0l=%ebx
movzbl  %dh,%ebx

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 7680 + rbyte0l)
# asm 1: pxor 7680(<gfmtable=int64#8,<rbyte0l=int64#14,1),<t0dql=int6464#1
# asm 2: pxor 7680(<gfmtable=%r10,<rbyte0l=%rbx,1),<t0dql=%xmm0
pxor 7680(%r10,%rbx,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 7936 + rbyte0u)
# asm 1: pxor 7936(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 7936(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 7936(%r10,%rdi,1),%xmm1

# qhasm:   z1l = z1u
# asm 1: mov  <z1u=int64#4,>z1l=int64#14
# asm 2: mov  <z1u=%rcx,>z1l=%rbx
mov  %rcx,%rbx

# qhasm:   z1u <<= 4
# asm 1: shl  $4,<z1u=int64#4
# asm 2: shl  $4,<z1u=%rcx
shl  $4,%rcx

# qhasm:   z1u &= mask
# asm 1: and  <mask=int64#7,<z1u=int64#4
# asm 2: and  <mask=%rax,<z1u=%rcx
and  %rax,%rcx

# qhasm:   z1l &= mask
# asm 1: and  <mask=int64#7,<z1l=int64#14
# asm 2: and  <mask=%rax,<z1l=%rbx
and  %rax,%rbx

# qhasm:   rbyte0u = z1u & 255
# asm 1: movzbl  <z1u=int64#4b,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%cl,>rbyte0u=%edi
movzbl  %cl,%edi

# qhasm:   rbyte0l = z1l & 255
# asm 1: movzbl  <z1l=int64#14b,>rbyte0l=int64#3d
# asm 2: movzbl  <z1l=%bl,>rbyte0l=%edx
movzbl  %bl,%edx

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 0 + rbyte0l)
# asm 1: pxor 0(<gfmtable=int64#8,<rbyte0l=int64#3,1),<t0dql=int6464#1
# asm 2: pxor 0(<gfmtable=%r10,<rbyte0l=%rdx,1),<t0dql=%xmm0
pxor 0(%r10,%rdx,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 256 + rbyte0u)
# asm 1: pxor 256(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 256(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 256(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z1u >> 8) & 255
# asm 1: movzbl  <z1u=int64#4%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%ch,>rbyte0u=%edi
movzbl  %ch,%edi

# qhasm:   rbyte0l = (z1l >> 8) & 255
# asm 1: movzbl  <z1l=int64#14%next8,>rbyte0l=int64#15d
# asm 2: movzbl  <z1l=%bh,>rbyte0l=%ebp
movzbl  %bh,%ebp

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 512 + rbyte0l)
# asm 1: pxor 512(<gfmtable=int64#8,<rbyte0l=int64#15,1),<t0dql=int6464#1
# asm 2: pxor 512(<gfmtable=%r10,<rbyte0l=%rbp,1),<t0dql=%xmm0
pxor 512(%r10,%rbp,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 768 + rbyte0u)
# asm 1: pxor 768(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 768(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 768(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z1u >>= 16
# asm 1: shr  $16,<z1u=int64#4
# asm 2: shr  $16,<z1u=%rcx
shr  $16,%rcx

# qhasm:   (uint64) z1l >>= 16
# asm 1: shr  $16,<z1l=int64#14
# asm 2: shr  $16,<z1l=%rbx
shr  $16,%rbx

# qhasm:   rbyte0u = z1u & 255
# asm 1: movzbl  <z1u=int64#4b,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%cl,>rbyte0u=%edi
movzbl  %cl,%edi

# qhasm:   rbyte0l = z1l & 255
# asm 1: movzbl  <z1l=int64#14b,>rbyte0l=int64#3d
# asm 2: movzbl  <z1l=%bl,>rbyte0l=%edx
movzbl  %bl,%edx

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 1024 + rbyte0l)
# asm 1: pxor 1024(<gfmtable=int64#8,<rbyte0l=int64#3,1),<t0dql=int6464#1
# asm 2: pxor 1024(<gfmtable=%r10,<rbyte0l=%rdx,1),<t0dql=%xmm0
pxor 1024(%r10,%rdx,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 1280 + rbyte0u)
# asm 1: pxor 1280(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 1280(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 1280(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z1u >> 8) & 255
# asm 1: movzbl  <z1u=int64#4%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%ch,>rbyte0u=%edi
movzbl  %ch,%edi

# qhasm:   rbyte0l = (z1l >> 8) & 255
# asm 1: movzbl  <z1l=int64#14%next8,>rbyte0l=int64#15d
# asm 2: movzbl  <z1l=%bh,>rbyte0l=%ebp
movzbl  %bh,%ebp

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 1536 + rbyte0l)
# asm 1: pxor 1536(<gfmtable=int64#8,<rbyte0l=int64#15,1),<t0dql=int6464#1
# asm 2: pxor 1536(<gfmtable=%r10,<rbyte0l=%rbp,1),<t0dql=%xmm0
pxor 1536(%r10,%rbp,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 1792 + rbyte0u)
# asm 1: pxor 1792(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 1792(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 1792(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z1u >>= 16
# asm 1: shr  $16,<z1u=int64#4
# asm 2: shr  $16,<z1u=%rcx
shr  $16,%rcx

# qhasm:   (uint64) z1l >>= 16
# asm 1: shr  $16,<z1l=int64#14
# asm 2: shr  $16,<z1l=%rbx
shr  $16,%rbx

# qhasm:   rbyte0u = z1u & 255
# asm 1: movzbl  <z1u=int64#4b,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%cl,>rbyte0u=%edi
movzbl  %cl,%edi

# qhasm:   rbyte0l = z1l & 255
# asm 1: movzbl  <z1l=int64#14b,>rbyte0l=int64#3d
# asm 2: movzbl  <z1l=%bl,>rbyte0l=%edx
movzbl  %bl,%edx

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 2048 + rbyte0l)
# asm 1: pxor 2048(<gfmtable=int64#8,<rbyte0l=int64#3,1),<t0dql=int6464#1
# asm 2: pxor 2048(<gfmtable=%r10,<rbyte0l=%rdx,1),<t0dql=%xmm0
pxor 2048(%r10,%rdx,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 2304 + rbyte0u)
# asm 1: pxor 2304(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 2304(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 2304(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z1u >> 8) & 255
# asm 1: movzbl  <z1u=int64#4%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%ch,>rbyte0u=%edi
movzbl  %ch,%edi

# qhasm:   rbyte0l = (z1l >> 8) & 255
# asm 1: movzbl  <z1l=int64#14%next8,>rbyte0l=int64#15d
# asm 2: movzbl  <z1l=%bh,>rbyte0l=%ebp
movzbl  %bh,%ebp

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 2560 + rbyte0l)
# asm 1: pxor 2560(<gfmtable=int64#8,<rbyte0l=int64#15,1),<t0dql=int6464#1
# asm 2: pxor 2560(<gfmtable=%r10,<rbyte0l=%rbp,1),<t0dql=%xmm0
pxor 2560(%r10,%rbp,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 2816 + rbyte0u)
# asm 1: pxor 2816(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 2816(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 2816(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z1u >>= 16
# asm 1: shr  $16,<z1u=int64#4
# asm 2: shr  $16,<z1u=%rcx
shr  $16,%rcx

# qhasm:   (uint64) z1l >>= 16
# asm 1: shr  $16,<z1l=int64#14
# asm 2: shr  $16,<z1l=%rbx
shr  $16,%rbx

# qhasm:   rbyte0u = z1u & 255
# asm 1: movzbl  <z1u=int64#4b,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%cl,>rbyte0u=%edi
movzbl  %cl,%edi

# qhasm:   rbyte0l = z1l & 255
# asm 1: movzbl  <z1l=int64#14b,>rbyte0l=int64#3d
# asm 2: movzbl  <z1l=%bl,>rbyte0l=%edx
movzbl  %bl,%edx

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 3072 + rbyte0l)
# asm 1: pxor 3072(<gfmtable=int64#8,<rbyte0l=int64#3,1),<t0dql=int6464#1
# asm 2: pxor 3072(<gfmtable=%r10,<rbyte0l=%rdx,1),<t0dql=%xmm0
pxor 3072(%r10,%rdx,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 3328 + rbyte0u)
# asm 1: pxor 3328(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 3328(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 3328(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z1u >> 8) & 255
# asm 1: movzbl  <z1u=int64#4%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%ch,>rbyte0u=%edi
movzbl  %ch,%edi

# qhasm:   rbyte0l = (z1l >> 8) & 255
# asm 1: movzbl  <z1l=int64#14%next8,>rbyte0l=int64#14d
# asm 2: movzbl  <z1l=%bh,>rbyte0l=%ebx
movzbl  %bh,%ebx

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 3584 + rbyte0l)
# asm 1: pxor 3584(<gfmtable=int64#8,<rbyte0l=int64#14,1),<t0dql=int6464#1
# asm 2: pxor 3584(<gfmtable=%r10,<rbyte0l=%rbx,1),<t0dql=%xmm0
pxor 3584(%r10,%rbx,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 3840 + rbyte0u)
# asm 1: pxor 3840(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 3840(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 3840(%r10,%rdi,1),%xmm1

# qhasm:   t0dql ^= t0dqu
# asm 1: pxor  <t0dqu=int6464#2,<t0dql=int6464#1
# asm 2: pxor  <t0dqu=%xmm1,<t0dql=%xmm0
pxor  %xmm1,%xmm0

# qhasm:   z1u = t0dql[0]
# asm 1: movq <t0dql=int6464#1,>z1u=int64#4
# asm 2: movq <t0dql=%xmm0,>z1u=%rcx
movq %xmm0,%rcx

# qhasm:  t0dql >>= 64
# asm 1: psrldq $8,<t0dql=int6464#1
# asm 2: psrldq $8,<t0dql=%xmm0
psrldq $8,%xmm0

# qhasm:  z3u = t0dql[0]
# asm 1: movq <t0dql=int6464#1,>z3u=int64#14
# asm 2: movq <t0dql=%xmm0,>z3u=%rbx
movq %xmm0,%rbx

# qhasm:  outp += 16
# asm 1: add  $16,<outp=int64#2
# asm 2: add  $16,<outp=%rsi
add  $16,%rsi
# comment:fp stack unchanged by jump

# qhasm: goto loop
jmp ._loop

# qhasm: authpartial:
._authpartial:

# qhasm: len += 16
# asm 1: add  $16,<len=int64#6
# asm 2: add  $16,<len=%r9
add  $16,%r9

# qhasm: =? len - 0
# asm 1: cmp  $0,<len=int64#6
# asm 2: cmp  $0,<len=%r9
cmp  $0,%r9
# comment:fp stack unchanged by jump

# qhasm: goto authend if =
je ._authend

# qhasm: zero = 0
# asm 1: mov  $0,>zero=int64#3
# asm 2: mov  $0,>zero=%rdx
mov  $0,%rdx

# qhasm: tmpoutp = &tmpout
# asm 1: leaq <tmpout=stack128#1,>tmpoutp=int64#9
# asm 2: leaq <tmpout=0(%rsp),>tmpoutp=%r11
leaq 0(%rsp),%r11

# qhasm: tmp = tmpoutp
# asm 1: mov  <tmpoutp=int64#9,>tmp=int64#1
# asm 2: mov  <tmpoutp=%r11,>tmp=%rdi
mov  %r11,%rdi

# qhasm: *(int64 *)(tmpoutp + 0) = zero
# asm 1: movq   <zero=int64#3,0(<tmpoutp=int64#9)
# asm 2: movq   <zero=%rdx,0(<tmpoutp=%r11)
movq   %rdx,0(%r11)

# qhasm: *(int64 *)(tmpoutp + 8) = zero
# asm 1: movq   <zero=int64#3,8(<tmpoutp=int64#9)
# asm 2: movq   <zero=%rdx,8(<tmpoutp=%r11)
movq   %rdx,8(%r11)

# qhasm: z1u = z1u
# asm 1: mov  <z1u=int64#4,>z1u=int64#3
# asm 2: mov  <z1u=%rcx,>z1u=%rdx
mov  %rcx,%rdx

# qhasm: assign 4 to len

# qhasm: len = len
# asm 1: mov  <len=int64#6,>len=int64#4
# asm 2: mov  <len=%r9,>len=%rcx
mov  %r9,%rcx

# qhasm: while (len) { *tmp++ = *outp++; --len }
rep movsb

# qhasm: z1u = z1u
# asm 1: mov  <z1u=int64#3,>z1u=int64#4
# asm 2: mov  <z1u=%rdx,>z1u=%rcx
mov  %rdx,%rcx

# qhasm: outp = tmpoutp
# asm 1: mov  <tmpoutp=int64#9,>outp=int64#2
# asm 2: mov  <tmpoutp=%r11,>outp=%rsi
mov  %r11,%rsi

# qhasm: len = 16
# asm 1: mov  $16,>len=int64#6
# asm 2: mov  $16,>len=%r9
mov  $16,%r9
# comment:fp stack unchanged by jump

# qhasm: goto loop
jmp ._loop

# qhasm: authend:
._authend:

# qhasm: *(uint64 *)(c + 1424) = z1u
# asm 1: movq   <z1u=int64#4,1424(<c=int64#5)
# asm 2: movq   <z1u=%rcx,1424(<c=%r8)
movq   %rcx,1424(%r8)

# qhasm: *(uint64 *)(c + 1432) = z3u
# asm 1: movq   <z3u=int64#14,1432(<c=int64#5)
# asm 2: movq   <z3u=%rbx,1432(<c=%r8)
movq   %rbx,1432(%r8)

# qhasm: nothingtodo:
._nothingtodo:

# qhasm: emms
emms

# qhasm: r11_caller = r11_stack
# asm 1: movq <r11_stack=stack64#1,>r11_caller=int64#9
# asm 2: movq <r11_stack=32(%rsp),>r11_caller=%r11
movq 32(%rsp),%r11

# qhasm: r12_caller = r12_stack
# asm 1: movq <r12_stack=stack64#2,>r12_caller=int64#10
# asm 2: movq <r12_stack=40(%rsp),>r12_caller=%r12
movq 40(%rsp),%r12

# qhasm: r13_caller = r13_stack
# asm 1: movq <r13_stack=stack64#3,>r13_caller=int64#11
# asm 2: movq <r13_stack=48(%rsp),>r13_caller=%r13
movq 48(%rsp),%r13

# qhasm: r14_caller = r14_stack
# asm 1: movq <r14_stack=stack64#4,>r14_caller=int64#12
# asm 2: movq <r14_stack=56(%rsp),>r14_caller=%r14
movq 56(%rsp),%r14

# qhasm: r15_caller = r15_stack
# asm 1: movq <r15_stack=stack64#5,>r15_caller=int64#13
# asm 2: movq <r15_stack=64(%rsp),>r15_caller=%r15
movq 64(%rsp),%r15

# qhasm: rbx_caller = rbx_stack
# asm 1: movq <rbx_stack=stack64#6,>rbx_caller=int64#14
# asm 2: movq <rbx_stack=72(%rsp),>rbx_caller=%rbx
movq 72(%rsp),%rbx

# qhasm: rbp_caller = rbp_stack
# asm 1: movq <rbp_stack=stack64#7,>rbp_caller=int64#15
# asm 2: movq <rbp_stack=80(%rsp),>rbp_caller=%rbp
movq 80(%rsp),%rbp

# qhasm: leave
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
ret

# qhasm: int64 c

# qhasm: int64 h

# qhasm: input c

# qhasm: input h

# qhasm: int64 r11_caller

# qhasm: int64 r12_caller

# qhasm: int64 r13_caller

# qhasm: int64 r14_caller

# qhasm: int64 r15_caller

# qhasm: int64 rbx_caller

# qhasm: int64 rbp_caller

# qhasm: caller r11_caller

# qhasm: caller r12_caller

# qhasm: caller r13_caller

# qhasm: caller r14_caller

# qhasm: caller r15_caller

# qhasm: caller rbx_caller

# qhasm: caller rbp_caller

# qhasm: stack64 r11_stack

# qhasm: stack64 r12_stack

# qhasm: stack64 r13_stack

# qhasm: stack64 r14_stack

# qhasm: stack64 r15_stack

# qhasm: stack64 rbx_stack

# qhasm: stack64 rbp_stack

# qhasm: int64 table

# qhasm: int64 gfmtable

# qhasm: int64 redtable

# qhasm: stack64 gfmtable_stack

# qhasm: int64 check

# qhasm: int64 iv

# qhasm: int64 k

# qhasm: int64 x0

# qhasm: int64 x1

# qhasm: int64 x2

# qhasm: int64 x3

# qhasm: int64 e

# qhasm: int64 q0

# qhasm: int64 q1

# qhasm: int64 q2

# qhasm: int64 q3

# qhasm: int64 mainloopbytes

# qhasm: int64 in

# qhasm: int64 out

# qhasm: int64 len

# qhasm: int64 tmpinp

# qhasm: stack64 outstack

# qhasm: stack64 argout

# qhasm: int64 lentmp

# qhasm: stack64 arglen

# qhasm: int64 inv

# qhasm: int64 outv

# qhasm: int6464 n0

# qhasm: int6464 n1

# qhasm: int6464 n2

# qhasm: int6464 n3

# qhasm: int6464 tmp

# qhasm: int6464 zero

# qhasm: int6464 t0dq

# qhasm: int6464 t0dqu

# qhasm: int6464 t0dql

# qhasm: int6464 rh

# qhasm: int6464 rl

# qhasm: int6464 t1dq

# qhasm: int6464 t1dql

# qhasm: int6464 t1dqu

# qhasm: int6464 t2dq

# qhasm: int6464 t2dql

# qhasm: int6464 t2dqu

# qhasm: int6464 t3dq

# qhasm: int6464 t3dql

# qhasm: int6464 t3dqu

# qhasm: int6464 r

# qhasm: int6464 cbyte

# qhasm: int6464 cbyte0

# qhasm: int6464 cbyte1

# qhasm: int6464 cbyte2

# qhasm: int6464 cbyte3

# qhasm: int64 rbyte

# qhasm: int64 rbyte0

# qhasm: int64 rbyte0u

# qhasm: int64 rbyte0l

# qhasm: int64 rbyte1

# qhasm: int64 rbyte1u

# qhasm: int64 rbyte1l

# qhasm: int64 rbyte2

# qhasm: int64 rbyte2u

# qhasm: int64 rbyte2l

# qhasm: int64 rbyte3

# qhasm: int64 rbyte3u

# qhasm: int64 rbyte3l

# qhasm: int64 carry

# qhasm: int64 carry0

# qhasm: int64 carry1

# qhasm: int64 carry2

# qhasm: int64 carry3

# qhasm: int64 t0

# qhasm: int64 t1

# qhasm: int64 red

# qhasm: stack128 xi

# qhasm: int64 xip

# qhasm: stack64 pre10

# qhasm: stack64 pre20

# qhasm: stack64 pre21

# qhasm: stack64 pre22

# qhasm: stack64 pre23

# qhasm: int6464 ty0

# qhasm: stack64 r0

# qhasm: stack64 r1

# qhasm: stack64 r2

# qhasm: stack64 r3

# qhasm: stack64 r4

# qhasm: stack64 r5

# qhasm: stack64 r6

# qhasm: stack64 r7

# qhasm: stack64 r8

# qhasm: stack64 r9

# qhasm: stack64 r10

# qhasm: stack64 r11

# qhasm: int3232 r12

# qhasm: int3232 r13

# qhasm: int3232 r14

# qhasm: int3232 r15

# qhasm: int3232 r16

# qhasm: int6464 r20

# qhasm: int6464 r24

# qhasm: int6464 r28

# qhasm: int6464 r32

# qhasm: int6464 r36

# qhasm: int6464 r40

# qhasm: int6464 pr0

# qhasm: int6464 pr1

# qhasm: int6464 pr2

# qhasm: int6464 pr3

# qhasm: int64 y0

# qhasm: int64 y1

# qhasm: int64 y2

# qhasm: int64 y3

# qhasm: int64 ny3

# qhasm: int64 z0

# qhasm: int64 z1

# qhasm: int64 z2

# qhasm: int64 z3

# qhasm: int64 p00

# qhasm: int64 p01

# qhasm: int64 p02

# qhasm: int64 p03

# qhasm: int64 p10

# qhasm: int64 p11

# qhasm: int64 p12

# qhasm: int64 p13

# qhasm: int64 p20

# qhasm: int64 p21

# qhasm: int64 p22

# qhasm: int64 p23

# qhasm: int64 p30

# qhasm: int64 p31

# qhasm: int64 p32

# qhasm: int64 p33

# qhasm: int64 b0

# qhasm: int64 b1

# qhasm: int64 b2

# qhasm: int64 b3

# qhasm: stack128 tmpin

# qhasm: enter tablesetup
.text
.p2align 5
.globl _tablesetup
.globl tablesetup
_tablesetup:
tablesetup:
mov %rsp,%r11
and $31,%r11
add $64,%r11
sub %r11,%rsp

# qhasm: r11_stack = r11_caller
# asm 1: movq <r11_caller=int64#9,>r11_stack=stack64#1
# asm 2: movq <r11_caller=%r11,>r11_stack=0(%rsp)
movq %r11,0(%rsp)

# qhasm: r12_stack = r12_caller
# asm 1: movq <r12_caller=int64#10,>r12_stack=stack64#2
# asm 2: movq <r12_caller=%r12,>r12_stack=8(%rsp)
movq %r12,8(%rsp)

# qhasm: r13_stack = r13_caller
# asm 1: movq <r13_caller=int64#11,>r13_stack=stack64#3
# asm 2: movq <r13_caller=%r13,>r13_stack=16(%rsp)
movq %r13,16(%rsp)

# qhasm: r14_stack = r14_caller
# asm 1: movq <r14_caller=int64#12,>r14_stack=stack64#4
# asm 2: movq <r14_caller=%r14,>r14_stack=24(%rsp)
movq %r14,24(%rsp)

# qhasm: r15_stack = r15_caller
# asm 1: movq <r15_caller=int64#13,>r15_stack=stack64#5
# asm 2: movq <r15_caller=%r15,>r15_stack=32(%rsp)
movq %r15,32(%rsp)

# qhasm: rbx_stack = rbx_caller
# asm 1: movq <rbx_caller=int64#14,>rbx_stack=stack64#6
# asm 2: movq <rbx_caller=%rbx,>rbx_stack=40(%rsp)
movq %rbx,40(%rsp)

# qhasm: rbp_stack = rbp_caller
# asm 1: movq <rbp_caller=int64#15,>rbp_stack=stack64#7
# asm 2: movq <rbp_caller=%rbp,>rbp_stack=48(%rsp)
movq %rbp,48(%rsp)

# qhasm: gfmtable = c + 1456
# asm 1: lea  1456(<c=int64#1),>gfmtable=int64#1
# asm 2: lea  1456(<c=%rdi),>gfmtable=%rdi
lea  1456(%rdi),%rdi

# qhasm: redtable = &red_table
# asm 1: lea  red_table(%rip),>redtable=int64#3
# asm 2: lea  red_table(%rip),>redtable=%rdx
lea  red_table(%rip),%rdx

# qhasm: red = 0xe1
# asm 1: mov  $0xe1,>red=int64#4
# asm 2: mov  $0xe1,>red=%rcx
mov  $0xe1,%rcx

# qhasm: z1 = *(uint64 *) (h + 0)
# asm 1: movq   0(<h=int64#2),>z1=int64#5
# asm 2: movq   0(<h=%rsi),>z1=%r8
movq   0(%rsi),%r8

# qhasm: z3 = *(uint64 *) (h + 8)
# asm 1: movq   8(<h=int64#2),>z3=int64#2
# asm 2: movq   8(<h=%rsi),>z3=%rsi
movq   8(%rsi),%rsi

# qhasm: zero ^= zero
# asm 1: pxor  <zero=int6464#1,<zero=int6464#1
# asm 2: pxor  <zero=%xmm0,<zero=%xmm0
pxor  %xmm0,%xmm0

# qhasm:   *(int128 *) (gfmtable + 0) = zero
# asm 1: movdqa <zero=int6464#1,0(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,0(<gfmtable=%rdi)
movdqa %xmm0,0(%rdi)

# qhasm:   *(int128 *) (gfmtable + 256) = zero
# asm 1: movdqa <zero=int6464#1,256(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,256(<gfmtable=%rdi)
movdqa %xmm0,256(%rdi)

# qhasm:   *(int128 *) (gfmtable + 512) = zero
# asm 1: movdqa <zero=int6464#1,512(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,512(<gfmtable=%rdi)
movdqa %xmm0,512(%rdi)

# qhasm:   *(int128 *) (gfmtable + 768) = zero
# asm 1: movdqa <zero=int6464#1,768(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,768(<gfmtable=%rdi)
movdqa %xmm0,768(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1024) = zero
# asm 1: movdqa <zero=int6464#1,1024(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,1024(<gfmtable=%rdi)
movdqa %xmm0,1024(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1280) = zero
# asm 1: movdqa <zero=int6464#1,1280(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,1280(<gfmtable=%rdi)
movdqa %xmm0,1280(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1536) = zero
# asm 1: movdqa <zero=int6464#1,1536(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,1536(<gfmtable=%rdi)
movdqa %xmm0,1536(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1792) = zero
# asm 1: movdqa <zero=int6464#1,1792(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,1792(<gfmtable=%rdi)
movdqa %xmm0,1792(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2048) = zero
# asm 1: movdqa <zero=int6464#1,2048(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,2048(<gfmtable=%rdi)
movdqa %xmm0,2048(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2304) = zero
# asm 1: movdqa <zero=int6464#1,2304(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,2304(<gfmtable=%rdi)
movdqa %xmm0,2304(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2560) = zero
# asm 1: movdqa <zero=int6464#1,2560(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,2560(<gfmtable=%rdi)
movdqa %xmm0,2560(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2816) = zero
# asm 1: movdqa <zero=int6464#1,2816(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,2816(<gfmtable=%rdi)
movdqa %xmm0,2816(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3072) = zero
# asm 1: movdqa <zero=int6464#1,3072(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,3072(<gfmtable=%rdi)
movdqa %xmm0,3072(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3328) = zero
# asm 1: movdqa <zero=int6464#1,3328(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,3328(<gfmtable=%rdi)
movdqa %xmm0,3328(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3584) = zero
# asm 1: movdqa <zero=int6464#1,3584(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,3584(<gfmtable=%rdi)
movdqa %xmm0,3584(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3840) = zero
# asm 1: movdqa <zero=int6464#1,3840(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,3840(<gfmtable=%rdi)
movdqa %xmm0,3840(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4096) = zero
# asm 1: movdqa <zero=int6464#1,4096(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,4096(<gfmtable=%rdi)
movdqa %xmm0,4096(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4352) = zero
# asm 1: movdqa <zero=int6464#1,4352(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,4352(<gfmtable=%rdi)
movdqa %xmm0,4352(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4608) = zero
# asm 1: movdqa <zero=int6464#1,4608(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,4608(<gfmtable=%rdi)
movdqa %xmm0,4608(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4864) = zero
# asm 1: movdqa <zero=int6464#1,4864(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,4864(<gfmtable=%rdi)
movdqa %xmm0,4864(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5120) = zero
# asm 1: movdqa <zero=int6464#1,5120(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,5120(<gfmtable=%rdi)
movdqa %xmm0,5120(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5376) = zero
# asm 1: movdqa <zero=int6464#1,5376(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,5376(<gfmtable=%rdi)
movdqa %xmm0,5376(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5632) = zero
# asm 1: movdqa <zero=int6464#1,5632(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,5632(<gfmtable=%rdi)
movdqa %xmm0,5632(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5888) = zero
# asm 1: movdqa <zero=int6464#1,5888(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,5888(<gfmtable=%rdi)
movdqa %xmm0,5888(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6144) = zero
# asm 1: movdqa <zero=int6464#1,6144(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,6144(<gfmtable=%rdi)
movdqa %xmm0,6144(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6400) = zero
# asm 1: movdqa <zero=int6464#1,6400(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,6400(<gfmtable=%rdi)
movdqa %xmm0,6400(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6656) = zero
# asm 1: movdqa <zero=int6464#1,6656(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,6656(<gfmtable=%rdi)
movdqa %xmm0,6656(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6912) = zero
# asm 1: movdqa <zero=int6464#1,6912(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,6912(<gfmtable=%rdi)
movdqa %xmm0,6912(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7168) = zero
# asm 1: movdqa <zero=int6464#1,7168(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,7168(<gfmtable=%rdi)
movdqa %xmm0,7168(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7424) = zero
# asm 1: movdqa <zero=int6464#1,7424(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,7424(<gfmtable=%rdi)
movdqa %xmm0,7424(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7680) = zero
# asm 1: movdqa <zero=int6464#1,7680(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,7680(<gfmtable=%rdi)
movdqa %xmm0,7680(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7936) = zero
# asm 1: movdqa <zero=int6464#1,7936(<gfmtable=int64#1)
# asm 2: movdqa <zero=%xmm0,7936(<gfmtable=%rdi)
movdqa %xmm0,7936(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 128) = z1
# asm 1: movq   <z1=int64#5,128(<gfmtable=int64#1)
# asm 2: movq   <z1=%r8,128(<gfmtable=%rdi)
movq   %r8,128(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 136) = z3
# asm 1: movq   <z3=int64#2,136(<gfmtable=int64#1)
# asm 2: movq   <z3=%rsi,136(<gfmtable=%rdi)
movq   %rsi,136(%rdi)

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 = z1
# asm 1: mov  <z1=int64#5,>carry1=int64#6
# asm 2: mov  <z1=%r8,>carry1=%r9
mov  %r8,%r9

# qhasm:   carry2 = z3
# asm 1: mov  <z3=int64#2,>carry2=int64#7
# asm 2: mov  <z3=%rsi,>carry2=%rax
mov  %rsi,%rax

# qhasm:   (uint32) carry1 &= 1 
# asm 1: and  $1,<carry1=int64#6d
# asm 2: and  $1,<carry1=%r9d
and  $1,%r9d

# qhasm:   (uint32) carry2 &= 1 
# asm 1: and  $1,<carry2=int64#7d
# asm 2: and  $1,<carry2=%eax
and  $1,%eax

# qhasm:   (uint64) z1 >>= 1
# asm 1: shr  $1,<z1=int64#5
# asm 2: shr  $1,<z1=%r8
shr  $1,%r8

# qhasm:   (uint64) z3 >>= 1
# asm 1: shr  $1,<z3=int64#2
# asm 2: shr  $1,<z3=%rsi
shr  $1,%rsi

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 <<= 7
# asm 1: shl  $7,<carry1=int64#6
# asm 2: shl  $7,<carry1=%r9
shl  $7,%r9

# qhasm:   z3 ^= carry1
# asm 1: xor  <carry1=int64#6,<z3=int64#2
# asm 2: xor  <carry1=%r9,<z3=%rsi
xor  %r9,%rsi

# qhasm:   carry2 *= red
# asm 1: imul  <red=int64#4,<carry2=int64#7
# asm 2: imul  <red=%rcx,<carry2=%rax
imul  %rcx,%rax

# qhasm:   z1 ^= carry2
# asm 1: xor  <carry2=int64#7,<z1=int64#5
# asm 2: xor  <carry2=%rax,<z1=%r8
xor  %rax,%r8

# qhasm:   *(uint64 *) (gfmtable + 64) = z1
# asm 1: movq   <z1=int64#5,64(<gfmtable=int64#1)
# asm 2: movq   <z1=%r8,64(<gfmtable=%rdi)
movq   %r8,64(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 72) = z3
# asm 1: movq   <z3=int64#2,72(<gfmtable=int64#1)
# asm 2: movq   <z3=%rsi,72(<gfmtable=%rdi)
movq   %rsi,72(%rdi)

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 = z1
# asm 1: mov  <z1=int64#5,>carry1=int64#6
# asm 2: mov  <z1=%r8,>carry1=%r9
mov  %r8,%r9

# qhasm:   carry2 = z3
# asm 1: mov  <z3=int64#2,>carry2=int64#7
# asm 2: mov  <z3=%rsi,>carry2=%rax
mov  %rsi,%rax

# qhasm:   (uint32) carry1 &= 1 
# asm 1: and  $1,<carry1=int64#6d
# asm 2: and  $1,<carry1=%r9d
and  $1,%r9d

# qhasm:   (uint32) carry2 &= 1 
# asm 1: and  $1,<carry2=int64#7d
# asm 2: and  $1,<carry2=%eax
and  $1,%eax

# qhasm:   (uint64) z1 >>= 1
# asm 1: shr  $1,<z1=int64#5
# asm 2: shr  $1,<z1=%r8
shr  $1,%r8

# qhasm:   (uint64) z3 >>= 1
# asm 1: shr  $1,<z3=int64#2
# asm 2: shr  $1,<z3=%rsi
shr  $1,%rsi

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 <<= 7
# asm 1: shl  $7,<carry1=int64#6
# asm 2: shl  $7,<carry1=%r9
shl  $7,%r9

# qhasm:   z3 ^= carry1
# asm 1: xor  <carry1=int64#6,<z3=int64#2
# asm 2: xor  <carry1=%r9,<z3=%rsi
xor  %r9,%rsi

# qhasm:   carry2 *= red
# asm 1: imul  <red=int64#4,<carry2=int64#7
# asm 2: imul  <red=%rcx,<carry2=%rax
imul  %rcx,%rax

# qhasm:   z1 ^= carry2
# asm 1: xor  <carry2=int64#7,<z1=int64#5
# asm 2: xor  <carry2=%rax,<z1=%r8
xor  %rax,%r8

# qhasm:   *(uint64 *) (gfmtable + 32) = z1
# asm 1: movq   <z1=int64#5,32(<gfmtable=int64#1)
# asm 2: movq   <z1=%r8,32(<gfmtable=%rdi)
movq   %r8,32(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 40) = z3
# asm 1: movq   <z3=int64#2,40(<gfmtable=int64#1)
# asm 2: movq   <z3=%rsi,40(<gfmtable=%rdi)
movq   %rsi,40(%rdi)

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 = z1
# asm 1: mov  <z1=int64#5,>carry1=int64#6
# asm 2: mov  <z1=%r8,>carry1=%r9
mov  %r8,%r9

# qhasm:   carry2 = z3
# asm 1: mov  <z3=int64#2,>carry2=int64#7
# asm 2: mov  <z3=%rsi,>carry2=%rax
mov  %rsi,%rax

# qhasm:   (uint32) carry1 &= 1 
# asm 1: and  $1,<carry1=int64#6d
# asm 2: and  $1,<carry1=%r9d
and  $1,%r9d

# qhasm:   (uint32) carry2 &= 1 
# asm 1: and  $1,<carry2=int64#7d
# asm 2: and  $1,<carry2=%eax
and  $1,%eax

# qhasm:   (uint64) z1 >>= 1
# asm 1: shr  $1,<z1=int64#5
# asm 2: shr  $1,<z1=%r8
shr  $1,%r8

# qhasm:   (uint64) z3 >>= 1
# asm 1: shr  $1,<z3=int64#2
# asm 2: shr  $1,<z3=%rsi
shr  $1,%rsi

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 <<= 7
# asm 1: shl  $7,<carry1=int64#6
# asm 2: shl  $7,<carry1=%r9
shl  $7,%r9

# qhasm:   z3 ^= carry1
# asm 1: xor  <carry1=int64#6,<z3=int64#2
# asm 2: xor  <carry1=%r9,<z3=%rsi
xor  %r9,%rsi

# qhasm:   carry2 *= red
# asm 1: imul  <red=int64#4,<carry2=int64#7
# asm 2: imul  <red=%rcx,<carry2=%rax
imul  %rcx,%rax

# qhasm:   z1 ^= carry2
# asm 1: xor  <carry2=int64#7,<z1=int64#5
# asm 2: xor  <carry2=%rax,<z1=%r8
xor  %rax,%r8

# qhasm:   *(uint64 *) (gfmtable + 16) = z1
# asm 1: movq   <z1=int64#5,16(<gfmtable=int64#1)
# asm 2: movq   <z1=%r8,16(<gfmtable=%rdi)
movq   %r8,16(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 24) = z3
# asm 1: movq   <z3=int64#2,24(<gfmtable=int64#1)
# asm 2: movq   <z3=%rsi,24(<gfmtable=%rdi)
movq   %rsi,24(%rdi)

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 = z1
# asm 1: mov  <z1=int64#5,>carry1=int64#6
# asm 2: mov  <z1=%r8,>carry1=%r9
mov  %r8,%r9

# qhasm:   carry2 = z3
# asm 1: mov  <z3=int64#2,>carry2=int64#7
# asm 2: mov  <z3=%rsi,>carry2=%rax
mov  %rsi,%rax

# qhasm:   (uint32) carry1 &= 1 
# asm 1: and  $1,<carry1=int64#6d
# asm 2: and  $1,<carry1=%r9d
and  $1,%r9d

# qhasm:   (uint32) carry2 &= 1 
# asm 1: and  $1,<carry2=int64#7d
# asm 2: and  $1,<carry2=%eax
and  $1,%eax

# qhasm:   (uint64) z1 >>= 1
# asm 1: shr  $1,<z1=int64#5
# asm 2: shr  $1,<z1=%r8
shr  $1,%r8

# qhasm:   (uint64) z3 >>= 1
# asm 1: shr  $1,<z3=int64#2
# asm 2: shr  $1,<z3=%rsi
shr  $1,%rsi

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 <<= 7
# asm 1: shl  $7,<carry1=int64#6
# asm 2: shl  $7,<carry1=%r9
shl  $7,%r9

# qhasm:   z3 ^= carry1
# asm 1: xor  <carry1=int64#6,<z3=int64#2
# asm 2: xor  <carry1=%r9,<z3=%rsi
xor  %r9,%rsi

# qhasm:   carry2 *= red
# asm 1: imul  <red=int64#4,<carry2=int64#7
# asm 2: imul  <red=%rcx,<carry2=%rax
imul  %rcx,%rax

# qhasm:   z1 ^= carry2
# asm 1: xor  <carry2=int64#7,<z1=int64#5
# asm 2: xor  <carry2=%rax,<z1=%r8
xor  %rax,%r8

# qhasm:   *(uint64 *) (gfmtable + 384) = z1
# asm 1: movq   <z1=int64#5,384(<gfmtable=int64#1)
# asm 2: movq   <z1=%r8,384(<gfmtable=%rdi)
movq   %r8,384(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 392) = z3
# asm 1: movq   <z3=int64#2,392(<gfmtable=int64#1)
# asm 2: movq   <z3=%rsi,392(<gfmtable=%rdi)
movq   %rsi,392(%rdi)

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 = z1
# asm 1: mov  <z1=int64#5,>carry1=int64#6
# asm 2: mov  <z1=%r8,>carry1=%r9
mov  %r8,%r9

# qhasm:   carry2 = z3
# asm 1: mov  <z3=int64#2,>carry2=int64#7
# asm 2: mov  <z3=%rsi,>carry2=%rax
mov  %rsi,%rax

# qhasm:   (uint32) carry1 &= 1 
# asm 1: and  $1,<carry1=int64#6d
# asm 2: and  $1,<carry1=%r9d
and  $1,%r9d

# qhasm:   (uint32) carry2 &= 1 
# asm 1: and  $1,<carry2=int64#7d
# asm 2: and  $1,<carry2=%eax
and  $1,%eax

# qhasm:   (uint64) z1 >>= 1
# asm 1: shr  $1,<z1=int64#5
# asm 2: shr  $1,<z1=%r8
shr  $1,%r8

# qhasm:   (uint64) z3 >>= 1
# asm 1: shr  $1,<z3=int64#2
# asm 2: shr  $1,<z3=%rsi
shr  $1,%rsi

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 <<= 7
# asm 1: shl  $7,<carry1=int64#6
# asm 2: shl  $7,<carry1=%r9
shl  $7,%r9

# qhasm:   z3 ^= carry1
# asm 1: xor  <carry1=int64#6,<z3=int64#2
# asm 2: xor  <carry1=%r9,<z3=%rsi
xor  %r9,%rsi

# qhasm:   carry2 *= red
# asm 1: imul  <red=int64#4,<carry2=int64#7
# asm 2: imul  <red=%rcx,<carry2=%rax
imul  %rcx,%rax

# qhasm:   z1 ^= carry2
# asm 1: xor  <carry2=int64#7,<z1=int64#5
# asm 2: xor  <carry2=%rax,<z1=%r8
xor  %rax,%r8

# qhasm:   *(uint64 *) (gfmtable + 320) = z1
# asm 1: movq   <z1=int64#5,320(<gfmtable=int64#1)
# asm 2: movq   <z1=%r8,320(<gfmtable=%rdi)
movq   %r8,320(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 328) = z3
# asm 1: movq   <z3=int64#2,328(<gfmtable=int64#1)
# asm 2: movq   <z3=%rsi,328(<gfmtable=%rdi)
movq   %rsi,328(%rdi)

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 = z1
# asm 1: mov  <z1=int64#5,>carry1=int64#6
# asm 2: mov  <z1=%r8,>carry1=%r9
mov  %r8,%r9

# qhasm:   carry2 = z3
# asm 1: mov  <z3=int64#2,>carry2=int64#7
# asm 2: mov  <z3=%rsi,>carry2=%rax
mov  %rsi,%rax

# qhasm:   (uint32) carry1 &= 1 
# asm 1: and  $1,<carry1=int64#6d
# asm 2: and  $1,<carry1=%r9d
and  $1,%r9d

# qhasm:   (uint32) carry2 &= 1 
# asm 1: and  $1,<carry2=int64#7d
# asm 2: and  $1,<carry2=%eax
and  $1,%eax

# qhasm:   (uint64) z1 >>= 1
# asm 1: shr  $1,<z1=int64#5
# asm 2: shr  $1,<z1=%r8
shr  $1,%r8

# qhasm:   (uint64) z3 >>= 1
# asm 1: shr  $1,<z3=int64#2
# asm 2: shr  $1,<z3=%rsi
shr  $1,%rsi

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 <<= 7
# asm 1: shl  $7,<carry1=int64#6
# asm 2: shl  $7,<carry1=%r9
shl  $7,%r9

# qhasm:   z3 ^= carry1
# asm 1: xor  <carry1=int64#6,<z3=int64#2
# asm 2: xor  <carry1=%r9,<z3=%rsi
xor  %r9,%rsi

# qhasm:   carry2 *= red
# asm 1: imul  <red=int64#4,<carry2=int64#7
# asm 2: imul  <red=%rcx,<carry2=%rax
imul  %rcx,%rax

# qhasm:   z1 ^= carry2
# asm 1: xor  <carry2=int64#7,<z1=int64#5
# asm 2: xor  <carry2=%rax,<z1=%r8
xor  %rax,%r8

# qhasm:   *(uint64 *) (gfmtable + 288) = z1
# asm 1: movq   <z1=int64#5,288(<gfmtable=int64#1)
# asm 2: movq   <z1=%r8,288(<gfmtable=%rdi)
movq   %r8,288(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 296) = z3
# asm 1: movq   <z3=int64#2,296(<gfmtable=int64#1)
# asm 2: movq   <z3=%rsi,296(<gfmtable=%rdi)
movq   %rsi,296(%rdi)

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 = z1
# asm 1: mov  <z1=int64#5,>carry1=int64#6
# asm 2: mov  <z1=%r8,>carry1=%r9
mov  %r8,%r9

# qhasm:   carry2 = z3
# asm 1: mov  <z3=int64#2,>carry2=int64#7
# asm 2: mov  <z3=%rsi,>carry2=%rax
mov  %rsi,%rax

# qhasm:   (uint32) carry1 &= 1 
# asm 1: and  $1,<carry1=int64#6d
# asm 2: and  $1,<carry1=%r9d
and  $1,%r9d

# qhasm:   (uint32) carry2 &= 1 
# asm 1: and  $1,<carry2=int64#7d
# asm 2: and  $1,<carry2=%eax
and  $1,%eax

# qhasm:   (uint64) z1 >>= 1
# asm 1: shr  $1,<z1=int64#5
# asm 2: shr  $1,<z1=%r8
shr  $1,%r8

# qhasm:   (uint64) z3 >>= 1
# asm 1: shr  $1,<z3=int64#2
# asm 2: shr  $1,<z3=%rsi
shr  $1,%rsi

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 <<= 7
# asm 1: shl  $7,<carry1=int64#6
# asm 2: shl  $7,<carry1=%r9
shl  $7,%r9

# qhasm:   z3 ^= carry1
# asm 1: xor  <carry1=int64#6,<z3=int64#2
# asm 2: xor  <carry1=%r9,<z3=%rsi
xor  %r9,%rsi

# qhasm:   carry2 *= red
# asm 1: imul  <red=int64#4,<carry2=int64#7
# asm 2: imul  <red=%rcx,<carry2=%rax
imul  %rcx,%rax

# qhasm:   z1 ^= carry2
# asm 1: xor  <carry2=int64#7,<z1=int64#5
# asm 2: xor  <carry2=%rax,<z1=%r8
xor  %rax,%r8

# qhasm:   *(uint64 *) (gfmtable + 272) = z1
# asm 1: movq   <z1=int64#5,272(<gfmtable=int64#1)
# asm 2: movq   <z1=%r8,272(<gfmtable=%rdi)
movq   %r8,272(%rdi)

# qhasm:   *(uint64 *) (gfmtable + 280) = z3
# asm 1: movq   <z3=int64#2,280(<gfmtable=int64#1)
# asm 2: movq   <z3=%rsi,280(<gfmtable=%rdi)
movq   %rsi,280(%rdi)

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 = z1
# asm 1: mov  <z1=int64#5,>carry1=int64#6
# asm 2: mov  <z1=%r8,>carry1=%r9
mov  %r8,%r9

# qhasm:   carry2 = z3
# asm 1: mov  <z3=int64#2,>carry2=int64#7
# asm 2: mov  <z3=%rsi,>carry2=%rax
mov  %rsi,%rax

# qhasm:   (uint32) carry1 &= 1 
# asm 1: and  $1,<carry1=int64#6d
# asm 2: and  $1,<carry1=%r9d
and  $1,%r9d

# qhasm:   (uint32) carry2 &= 1 
# asm 1: and  $1,<carry2=int64#7d
# asm 2: and  $1,<carry2=%eax
and  $1,%eax

# qhasm:   (uint64) z1 >>= 1
# asm 1: shr  $1,<z1=int64#5
# asm 2: shr  $1,<z1=%r8
shr  $1,%r8

# qhasm:   (uint64) z3 >>= 1
# asm 1: shr  $1,<z3=int64#2
# asm 2: shr  $1,<z3=%rsi
shr  $1,%rsi

# qhasm:   (uint64) bswap z1
# asm 1: bswap <z1=int64#5
# asm 2: bswap <z1=%r8
bswap %r8

# qhasm:   (uint64) bswap z3
# asm 1: bswap <z3=int64#2
# asm 2: bswap <z3=%rsi
bswap %rsi

# qhasm:   carry1 <<= 7
# asm 1: shl  $7,<carry1=int64#6
# asm 2: shl  $7,<carry1=%r9
shl  $7,%r9

# qhasm:   z3 ^= carry1
# asm 1: xor  <carry1=int64#6,<z3=int64#2
# asm 2: xor  <carry1=%r9,<z3=%rsi
xor  %r9,%rsi

# qhasm:   carry2 *= red
# asm 1: imul  <red=int64#4,<carry2=int64#7
# asm 2: imul  <red=%rcx,<carry2=%rax
imul  %rcx,%rax

# qhasm:   z1 ^= carry2
# asm 1: xor  <carry2=int64#7,<z1=int64#5
# asm 2: xor  <carry2=%rax,<z1=%r8
xor  %rax,%r8

# qhasm:   t0dq = *(int128 *) (gfmtable + 128)
# asm 1: movdqa 128(<gfmtable=int64#1),>t0dq=int6464#1
# asm 2: movdqa 128(<gfmtable=%rdi),>t0dq=%xmm0
movdqa 128(%rdi),%xmm0

# qhasm:   t1dq = *(int128 *) (gfmtable + 64)
# asm 1: movdqa 64(<gfmtable=int64#1),>t1dq=int6464#2
# asm 2: movdqa 64(<gfmtable=%rdi),>t1dq=%xmm1
movdqa 64(%rdi),%xmm1

# qhasm:   t2dq = *(int128 *) (gfmtable + 32)
# asm 1: movdqa 32(<gfmtable=int64#1),>t2dq=int6464#3
# asm 2: movdqa 32(<gfmtable=%rdi),>t2dq=%xmm2
movdqa 32(%rdi),%xmm2

# qhasm:   t3dq = *(int128 *) (gfmtable + 16)
# asm 1: movdqa 16(<gfmtable=int64#1),>t3dq=int6464#4
# asm 2: movdqa 16(<gfmtable=%rdi),>t3dq=%xmm3
movdqa 16(%rdi),%xmm3

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 192) = tmp
# asm 1: movdqa <tmp=int6464#5,192(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,192(<gfmtable=%rdi)
movdqa %xmm4,192(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 224) = tmp
# asm 1: movdqa <tmp=int6464#5,224(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,224(<gfmtable=%rdi)
movdqa %xmm4,224(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 160) = tmp
# asm 1: movdqa <tmp=int6464#5,160(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,160(<gfmtable=%rdi)
movdqa %xmm4,160(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 176) = tmp
# asm 1: movdqa <tmp=int6464#5,176(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,176(<gfmtable=%rdi)
movdqa %xmm4,176(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 144) = tmp
# asm 1: movdqa <tmp=int6464#5,144(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,144(<gfmtable=%rdi)
movdqa %xmm4,144(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 208) = tmp
# asm 1: movdqa <tmp=int6464#5,208(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,208(<gfmtable=%rdi)
movdqa %xmm4,208(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 80) = tmp
# asm 1: movdqa <tmp=int6464#5,80(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,80(<gfmtable=%rdi)
movdqa %xmm4,80(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 112) = tmp
# asm 1: movdqa <tmp=int6464#5,112(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,112(<gfmtable=%rdi)
movdqa %xmm4,112(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 48) = tmp
# asm 1: movdqa <tmp=int6464#5,48(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,48(<gfmtable=%rdi)
movdqa %xmm4,48(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 96) = tmp
# asm 1: movdqa <tmp=int6464#5,96(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,96(<gfmtable=%rdi)
movdqa %xmm4,96(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 240) = tmp
# asm 1: movdqa <tmp=int6464#5,240(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,240(<gfmtable=%rdi)
movdqa %xmm4,240(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 640) = t0dq
# asm 1: movdqa <t0dq=int6464#1,640(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,640(<gfmtable=%rdi)
movdqa %xmm0,640(%rdi)

# qhasm:   *(int128 *) (gfmtable + 576) = t1dq
# asm 1: movdqa <t1dq=int6464#2,576(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,576(<gfmtable=%rdi)
movdqa %xmm1,576(%rdi)

# qhasm:   *(int128 *) (gfmtable + 544) = t2dq
# asm 1: movdqa <t2dq=int6464#3,544(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,544(<gfmtable=%rdi)
movdqa %xmm2,544(%rdi)

# qhasm:   *(int128 *) (gfmtable + 528) = t3dq
# asm 1: movdqa <t3dq=int6464#4,528(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,528(<gfmtable=%rdi)
movdqa %xmm3,528(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 704) = tmp
# asm 1: movdqa <tmp=int6464#5,704(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,704(<gfmtable=%rdi)
movdqa %xmm4,704(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 736) = tmp
# asm 1: movdqa <tmp=int6464#5,736(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,736(<gfmtable=%rdi)
movdqa %xmm4,736(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 672) = tmp
# asm 1: movdqa <tmp=int6464#5,672(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,672(<gfmtable=%rdi)
movdqa %xmm4,672(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 688) = tmp
# asm 1: movdqa <tmp=int6464#5,688(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,688(<gfmtable=%rdi)
movdqa %xmm4,688(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 656) = tmp
# asm 1: movdqa <tmp=int6464#5,656(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,656(<gfmtable=%rdi)
movdqa %xmm4,656(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 720) = tmp
# asm 1: movdqa <tmp=int6464#5,720(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,720(<gfmtable=%rdi)
movdqa %xmm4,720(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 592) = tmp
# asm 1: movdqa <tmp=int6464#5,592(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,592(<gfmtable=%rdi)
movdqa %xmm4,592(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 624) = tmp
# asm 1: movdqa <tmp=int6464#5,624(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,624(<gfmtable=%rdi)
movdqa %xmm4,624(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 560) = tmp
# asm 1: movdqa <tmp=int6464#5,560(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,560(<gfmtable=%rdi)
movdqa %xmm4,560(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 608) = tmp
# asm 1: movdqa <tmp=int6464#5,608(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,608(<gfmtable=%rdi)
movdqa %xmm4,608(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 752) = tmp
# asm 1: movdqa <tmp=int6464#5,752(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,752(<gfmtable=%rdi)
movdqa %xmm4,752(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 1152) = t0dq
# asm 1: movdqa <t0dq=int6464#1,1152(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,1152(<gfmtable=%rdi)
movdqa %xmm0,1152(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1088) = t1dq
# asm 1: movdqa <t1dq=int6464#2,1088(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,1088(<gfmtable=%rdi)
movdqa %xmm1,1088(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1056) = t2dq
# asm 1: movdqa <t2dq=int6464#3,1056(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,1056(<gfmtable=%rdi)
movdqa %xmm2,1056(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1040) = t3dq
# asm 1: movdqa <t3dq=int6464#4,1040(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,1040(<gfmtable=%rdi)
movdqa %xmm3,1040(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1216) = tmp
# asm 1: movdqa <tmp=int6464#5,1216(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1216(<gfmtable=%rdi)
movdqa %xmm4,1216(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1248) = tmp
# asm 1: movdqa <tmp=int6464#5,1248(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1248(<gfmtable=%rdi)
movdqa %xmm4,1248(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1184) = tmp
# asm 1: movdqa <tmp=int6464#5,1184(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1184(<gfmtable=%rdi)
movdqa %xmm4,1184(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1200) = tmp
# asm 1: movdqa <tmp=int6464#5,1200(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1200(<gfmtable=%rdi)
movdqa %xmm4,1200(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1168) = tmp
# asm 1: movdqa <tmp=int6464#5,1168(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1168(<gfmtable=%rdi)
movdqa %xmm4,1168(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1232) = tmp
# asm 1: movdqa <tmp=int6464#5,1232(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1232(<gfmtable=%rdi)
movdqa %xmm4,1232(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1104) = tmp
# asm 1: movdqa <tmp=int6464#5,1104(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1104(<gfmtable=%rdi)
movdqa %xmm4,1104(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1136) = tmp
# asm 1: movdqa <tmp=int6464#5,1136(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1136(<gfmtable=%rdi)
movdqa %xmm4,1136(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1072) = tmp
# asm 1: movdqa <tmp=int6464#5,1072(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1072(<gfmtable=%rdi)
movdqa %xmm4,1072(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1120) = tmp
# asm 1: movdqa <tmp=int6464#5,1120(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1120(<gfmtable=%rdi)
movdqa %xmm4,1120(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1264) = tmp
# asm 1: movdqa <tmp=int6464#5,1264(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1264(<gfmtable=%rdi)
movdqa %xmm4,1264(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 1664) = t0dq
# asm 1: movdqa <t0dq=int6464#1,1664(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,1664(<gfmtable=%rdi)
movdqa %xmm0,1664(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1600) = t1dq
# asm 1: movdqa <t1dq=int6464#2,1600(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,1600(<gfmtable=%rdi)
movdqa %xmm1,1600(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1568) = t2dq
# asm 1: movdqa <t2dq=int6464#3,1568(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,1568(<gfmtable=%rdi)
movdqa %xmm2,1568(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1552) = t3dq
# asm 1: movdqa <t3dq=int6464#4,1552(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,1552(<gfmtable=%rdi)
movdqa %xmm3,1552(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1728) = tmp
# asm 1: movdqa <tmp=int6464#5,1728(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1728(<gfmtable=%rdi)
movdqa %xmm4,1728(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1760) = tmp
# asm 1: movdqa <tmp=int6464#5,1760(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1760(<gfmtable=%rdi)
movdqa %xmm4,1760(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1696) = tmp
# asm 1: movdqa <tmp=int6464#5,1696(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1696(<gfmtable=%rdi)
movdqa %xmm4,1696(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1712) = tmp
# asm 1: movdqa <tmp=int6464#5,1712(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1712(<gfmtable=%rdi)
movdqa %xmm4,1712(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1680) = tmp
# asm 1: movdqa <tmp=int6464#5,1680(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1680(<gfmtable=%rdi)
movdqa %xmm4,1680(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1744) = tmp
# asm 1: movdqa <tmp=int6464#5,1744(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1744(<gfmtable=%rdi)
movdqa %xmm4,1744(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1616) = tmp
# asm 1: movdqa <tmp=int6464#5,1616(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1616(<gfmtable=%rdi)
movdqa %xmm4,1616(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1648) = tmp
# asm 1: movdqa <tmp=int6464#5,1648(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1648(<gfmtable=%rdi)
movdqa %xmm4,1648(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1584) = tmp
# asm 1: movdqa <tmp=int6464#5,1584(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1584(<gfmtable=%rdi)
movdqa %xmm4,1584(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1632) = tmp
# asm 1: movdqa <tmp=int6464#5,1632(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1632(<gfmtable=%rdi)
movdqa %xmm4,1632(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1776) = tmp
# asm 1: movdqa <tmp=int6464#5,1776(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1776(<gfmtable=%rdi)
movdqa %xmm4,1776(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 2176) = t0dq
# asm 1: movdqa <t0dq=int6464#1,2176(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,2176(<gfmtable=%rdi)
movdqa %xmm0,2176(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2112) = t1dq
# asm 1: movdqa <t1dq=int6464#2,2112(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,2112(<gfmtable=%rdi)
movdqa %xmm1,2112(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2080) = t2dq
# asm 1: movdqa <t2dq=int6464#3,2080(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,2080(<gfmtable=%rdi)
movdqa %xmm2,2080(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2064) = t3dq
# asm 1: movdqa <t3dq=int6464#4,2064(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,2064(<gfmtable=%rdi)
movdqa %xmm3,2064(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2240) = tmp
# asm 1: movdqa <tmp=int6464#5,2240(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2240(<gfmtable=%rdi)
movdqa %xmm4,2240(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2272) = tmp
# asm 1: movdqa <tmp=int6464#5,2272(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2272(<gfmtable=%rdi)
movdqa %xmm4,2272(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2208) = tmp
# asm 1: movdqa <tmp=int6464#5,2208(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2208(<gfmtable=%rdi)
movdqa %xmm4,2208(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2224) = tmp
# asm 1: movdqa <tmp=int6464#5,2224(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2224(<gfmtable=%rdi)
movdqa %xmm4,2224(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2192) = tmp
# asm 1: movdqa <tmp=int6464#5,2192(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2192(<gfmtable=%rdi)
movdqa %xmm4,2192(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2256) = tmp
# asm 1: movdqa <tmp=int6464#5,2256(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2256(<gfmtable=%rdi)
movdqa %xmm4,2256(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2128) = tmp
# asm 1: movdqa <tmp=int6464#5,2128(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2128(<gfmtable=%rdi)
movdqa %xmm4,2128(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2160) = tmp
# asm 1: movdqa <tmp=int6464#5,2160(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2160(<gfmtable=%rdi)
movdqa %xmm4,2160(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2096) = tmp
# asm 1: movdqa <tmp=int6464#5,2096(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2096(<gfmtable=%rdi)
movdqa %xmm4,2096(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2144) = tmp
# asm 1: movdqa <tmp=int6464#5,2144(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2144(<gfmtable=%rdi)
movdqa %xmm4,2144(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2288) = tmp
# asm 1: movdqa <tmp=int6464#5,2288(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2288(<gfmtable=%rdi)
movdqa %xmm4,2288(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 2688) = t0dq
# asm 1: movdqa <t0dq=int6464#1,2688(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,2688(<gfmtable=%rdi)
movdqa %xmm0,2688(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2624) = t1dq
# asm 1: movdqa <t1dq=int6464#2,2624(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,2624(<gfmtable=%rdi)
movdqa %xmm1,2624(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2592) = t2dq
# asm 1: movdqa <t2dq=int6464#3,2592(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,2592(<gfmtable=%rdi)
movdqa %xmm2,2592(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2576) = t3dq
# asm 1: movdqa <t3dq=int6464#4,2576(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,2576(<gfmtable=%rdi)
movdqa %xmm3,2576(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2752) = tmp
# asm 1: movdqa <tmp=int6464#5,2752(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2752(<gfmtable=%rdi)
movdqa %xmm4,2752(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2784) = tmp
# asm 1: movdqa <tmp=int6464#5,2784(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2784(<gfmtable=%rdi)
movdqa %xmm4,2784(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2720) = tmp
# asm 1: movdqa <tmp=int6464#5,2720(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2720(<gfmtable=%rdi)
movdqa %xmm4,2720(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2736) = tmp
# asm 1: movdqa <tmp=int6464#5,2736(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2736(<gfmtable=%rdi)
movdqa %xmm4,2736(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2704) = tmp
# asm 1: movdqa <tmp=int6464#5,2704(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2704(<gfmtable=%rdi)
movdqa %xmm4,2704(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2768) = tmp
# asm 1: movdqa <tmp=int6464#5,2768(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2768(<gfmtable=%rdi)
movdqa %xmm4,2768(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2640) = tmp
# asm 1: movdqa <tmp=int6464#5,2640(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2640(<gfmtable=%rdi)
movdqa %xmm4,2640(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2672) = tmp
# asm 1: movdqa <tmp=int6464#5,2672(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2672(<gfmtable=%rdi)
movdqa %xmm4,2672(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2608) = tmp
# asm 1: movdqa <tmp=int6464#5,2608(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2608(<gfmtable=%rdi)
movdqa %xmm4,2608(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2656) = tmp
# asm 1: movdqa <tmp=int6464#5,2656(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2656(<gfmtable=%rdi)
movdqa %xmm4,2656(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2800) = tmp
# asm 1: movdqa <tmp=int6464#5,2800(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2800(<gfmtable=%rdi)
movdqa %xmm4,2800(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 3200) = t0dq
# asm 1: movdqa <t0dq=int6464#1,3200(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,3200(<gfmtable=%rdi)
movdqa %xmm0,3200(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3136) = t1dq
# asm 1: movdqa <t1dq=int6464#2,3136(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,3136(<gfmtable=%rdi)
movdqa %xmm1,3136(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3104) = t2dq
# asm 1: movdqa <t2dq=int6464#3,3104(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,3104(<gfmtable=%rdi)
movdqa %xmm2,3104(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3088) = t3dq
# asm 1: movdqa <t3dq=int6464#4,3088(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,3088(<gfmtable=%rdi)
movdqa %xmm3,3088(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3264) = tmp
# asm 1: movdqa <tmp=int6464#5,3264(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3264(<gfmtable=%rdi)
movdqa %xmm4,3264(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3296) = tmp
# asm 1: movdqa <tmp=int6464#5,3296(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3296(<gfmtable=%rdi)
movdqa %xmm4,3296(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3232) = tmp
# asm 1: movdqa <tmp=int6464#5,3232(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3232(<gfmtable=%rdi)
movdqa %xmm4,3232(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3248) = tmp
# asm 1: movdqa <tmp=int6464#5,3248(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3248(<gfmtable=%rdi)
movdqa %xmm4,3248(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3216) = tmp
# asm 1: movdqa <tmp=int6464#5,3216(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3216(<gfmtable=%rdi)
movdqa %xmm4,3216(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3280) = tmp
# asm 1: movdqa <tmp=int6464#5,3280(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3280(<gfmtable=%rdi)
movdqa %xmm4,3280(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3152) = tmp
# asm 1: movdqa <tmp=int6464#5,3152(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3152(<gfmtable=%rdi)
movdqa %xmm4,3152(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3184) = tmp
# asm 1: movdqa <tmp=int6464#5,3184(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3184(<gfmtable=%rdi)
movdqa %xmm4,3184(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3120) = tmp
# asm 1: movdqa <tmp=int6464#5,3120(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3120(<gfmtable=%rdi)
movdqa %xmm4,3120(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3168) = tmp
# asm 1: movdqa <tmp=int6464#5,3168(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3168(<gfmtable=%rdi)
movdqa %xmm4,3168(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3312) = tmp
# asm 1: movdqa <tmp=int6464#5,3312(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3312(<gfmtable=%rdi)
movdqa %xmm4,3312(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 3712) = t0dq
# asm 1: movdqa <t0dq=int6464#1,3712(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,3712(<gfmtable=%rdi)
movdqa %xmm0,3712(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3648) = t1dq
# asm 1: movdqa <t1dq=int6464#2,3648(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,3648(<gfmtable=%rdi)
movdqa %xmm1,3648(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3616) = t2dq
# asm 1: movdqa <t2dq=int6464#3,3616(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,3616(<gfmtable=%rdi)
movdqa %xmm2,3616(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3600) = t3dq
# asm 1: movdqa <t3dq=int6464#4,3600(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,3600(<gfmtable=%rdi)
movdqa %xmm3,3600(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3776) = tmp
# asm 1: movdqa <tmp=int6464#5,3776(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3776(<gfmtable=%rdi)
movdqa %xmm4,3776(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3808) = tmp
# asm 1: movdqa <tmp=int6464#5,3808(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3808(<gfmtable=%rdi)
movdqa %xmm4,3808(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3744) = tmp
# asm 1: movdqa <tmp=int6464#5,3744(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3744(<gfmtable=%rdi)
movdqa %xmm4,3744(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3760) = tmp
# asm 1: movdqa <tmp=int6464#5,3760(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3760(<gfmtable=%rdi)
movdqa %xmm4,3760(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3728) = tmp
# asm 1: movdqa <tmp=int6464#5,3728(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3728(<gfmtable=%rdi)
movdqa %xmm4,3728(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3792) = tmp
# asm 1: movdqa <tmp=int6464#5,3792(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3792(<gfmtable=%rdi)
movdqa %xmm4,3792(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3664) = tmp
# asm 1: movdqa <tmp=int6464#5,3664(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3664(<gfmtable=%rdi)
movdqa %xmm4,3664(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3696) = tmp
# asm 1: movdqa <tmp=int6464#5,3696(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3696(<gfmtable=%rdi)
movdqa %xmm4,3696(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3632) = tmp
# asm 1: movdqa <tmp=int6464#5,3632(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3632(<gfmtable=%rdi)
movdqa %xmm4,3632(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3680) = tmp
# asm 1: movdqa <tmp=int6464#5,3680(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3680(<gfmtable=%rdi)
movdqa %xmm4,3680(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3824) = tmp
# asm 1: movdqa <tmp=int6464#5,3824(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3824(<gfmtable=%rdi)
movdqa %xmm4,3824(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 4224) = t0dq
# asm 1: movdqa <t0dq=int6464#1,4224(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,4224(<gfmtable=%rdi)
movdqa %xmm0,4224(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4160) = t1dq
# asm 1: movdqa <t1dq=int6464#2,4160(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,4160(<gfmtable=%rdi)
movdqa %xmm1,4160(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4128) = t2dq
# asm 1: movdqa <t2dq=int6464#3,4128(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,4128(<gfmtable=%rdi)
movdqa %xmm2,4128(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4112) = t3dq
# asm 1: movdqa <t3dq=int6464#4,4112(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,4112(<gfmtable=%rdi)
movdqa %xmm3,4112(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4288) = tmp
# asm 1: movdqa <tmp=int6464#5,4288(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4288(<gfmtable=%rdi)
movdqa %xmm4,4288(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4320) = tmp
# asm 1: movdqa <tmp=int6464#5,4320(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4320(<gfmtable=%rdi)
movdqa %xmm4,4320(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4256) = tmp
# asm 1: movdqa <tmp=int6464#5,4256(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4256(<gfmtable=%rdi)
movdqa %xmm4,4256(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4272) = tmp
# asm 1: movdqa <tmp=int6464#5,4272(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4272(<gfmtable=%rdi)
movdqa %xmm4,4272(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4240) = tmp
# asm 1: movdqa <tmp=int6464#5,4240(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4240(<gfmtable=%rdi)
movdqa %xmm4,4240(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4304) = tmp
# asm 1: movdqa <tmp=int6464#5,4304(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4304(<gfmtable=%rdi)
movdqa %xmm4,4304(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4176) = tmp
# asm 1: movdqa <tmp=int6464#5,4176(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4176(<gfmtable=%rdi)
movdqa %xmm4,4176(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4208) = tmp
# asm 1: movdqa <tmp=int6464#5,4208(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4208(<gfmtable=%rdi)
movdqa %xmm4,4208(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4144) = tmp
# asm 1: movdqa <tmp=int6464#5,4144(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4144(<gfmtable=%rdi)
movdqa %xmm4,4144(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4192) = tmp
# asm 1: movdqa <tmp=int6464#5,4192(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4192(<gfmtable=%rdi)
movdqa %xmm4,4192(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4336) = tmp
# asm 1: movdqa <tmp=int6464#5,4336(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4336(<gfmtable=%rdi)
movdqa %xmm4,4336(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 4736) = t0dq
# asm 1: movdqa <t0dq=int6464#1,4736(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,4736(<gfmtable=%rdi)
movdqa %xmm0,4736(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4672) = t1dq
# asm 1: movdqa <t1dq=int6464#2,4672(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,4672(<gfmtable=%rdi)
movdqa %xmm1,4672(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4640) = t2dq
# asm 1: movdqa <t2dq=int6464#3,4640(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,4640(<gfmtable=%rdi)
movdqa %xmm2,4640(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4624) = t3dq
# asm 1: movdqa <t3dq=int6464#4,4624(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,4624(<gfmtable=%rdi)
movdqa %xmm3,4624(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4800) = tmp
# asm 1: movdqa <tmp=int6464#5,4800(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4800(<gfmtable=%rdi)
movdqa %xmm4,4800(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4832) = tmp
# asm 1: movdqa <tmp=int6464#5,4832(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4832(<gfmtable=%rdi)
movdqa %xmm4,4832(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4768) = tmp
# asm 1: movdqa <tmp=int6464#5,4768(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4768(<gfmtable=%rdi)
movdqa %xmm4,4768(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4784) = tmp
# asm 1: movdqa <tmp=int6464#5,4784(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4784(<gfmtable=%rdi)
movdqa %xmm4,4784(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4752) = tmp
# asm 1: movdqa <tmp=int6464#5,4752(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4752(<gfmtable=%rdi)
movdqa %xmm4,4752(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4816) = tmp
# asm 1: movdqa <tmp=int6464#5,4816(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4816(<gfmtable=%rdi)
movdqa %xmm4,4816(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4688) = tmp
# asm 1: movdqa <tmp=int6464#5,4688(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4688(<gfmtable=%rdi)
movdqa %xmm4,4688(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4720) = tmp
# asm 1: movdqa <tmp=int6464#5,4720(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4720(<gfmtable=%rdi)
movdqa %xmm4,4720(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4656) = tmp
# asm 1: movdqa <tmp=int6464#5,4656(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4656(<gfmtable=%rdi)
movdqa %xmm4,4656(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4704) = tmp
# asm 1: movdqa <tmp=int6464#5,4704(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4704(<gfmtable=%rdi)
movdqa %xmm4,4704(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4848) = tmp
# asm 1: movdqa <tmp=int6464#5,4848(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4848(<gfmtable=%rdi)
movdqa %xmm4,4848(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 5248) = t0dq
# asm 1: movdqa <t0dq=int6464#1,5248(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,5248(<gfmtable=%rdi)
movdqa %xmm0,5248(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5184) = t1dq
# asm 1: movdqa <t1dq=int6464#2,5184(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,5184(<gfmtable=%rdi)
movdqa %xmm1,5184(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5152) = t2dq
# asm 1: movdqa <t2dq=int6464#3,5152(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,5152(<gfmtable=%rdi)
movdqa %xmm2,5152(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5136) = t3dq
# asm 1: movdqa <t3dq=int6464#4,5136(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,5136(<gfmtable=%rdi)
movdqa %xmm3,5136(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5312) = tmp
# asm 1: movdqa <tmp=int6464#5,5312(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5312(<gfmtable=%rdi)
movdqa %xmm4,5312(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5344) = tmp
# asm 1: movdqa <tmp=int6464#5,5344(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5344(<gfmtable=%rdi)
movdqa %xmm4,5344(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5280) = tmp
# asm 1: movdqa <tmp=int6464#5,5280(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5280(<gfmtable=%rdi)
movdqa %xmm4,5280(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5296) = tmp
# asm 1: movdqa <tmp=int6464#5,5296(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5296(<gfmtable=%rdi)
movdqa %xmm4,5296(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5264) = tmp
# asm 1: movdqa <tmp=int6464#5,5264(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5264(<gfmtable=%rdi)
movdqa %xmm4,5264(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5328) = tmp
# asm 1: movdqa <tmp=int6464#5,5328(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5328(<gfmtable=%rdi)
movdqa %xmm4,5328(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5200) = tmp
# asm 1: movdqa <tmp=int6464#5,5200(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5200(<gfmtable=%rdi)
movdqa %xmm4,5200(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5232) = tmp
# asm 1: movdqa <tmp=int6464#5,5232(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5232(<gfmtable=%rdi)
movdqa %xmm4,5232(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5168) = tmp
# asm 1: movdqa <tmp=int6464#5,5168(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5168(<gfmtable=%rdi)
movdqa %xmm4,5168(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5216) = tmp
# asm 1: movdqa <tmp=int6464#5,5216(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5216(<gfmtable=%rdi)
movdqa %xmm4,5216(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5360) = tmp
# asm 1: movdqa <tmp=int6464#5,5360(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5360(<gfmtable=%rdi)
movdqa %xmm4,5360(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 5760) = t0dq
# asm 1: movdqa <t0dq=int6464#1,5760(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,5760(<gfmtable=%rdi)
movdqa %xmm0,5760(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5696) = t1dq
# asm 1: movdqa <t1dq=int6464#2,5696(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,5696(<gfmtable=%rdi)
movdqa %xmm1,5696(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5664) = t2dq
# asm 1: movdqa <t2dq=int6464#3,5664(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,5664(<gfmtable=%rdi)
movdqa %xmm2,5664(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5648) = t3dq
# asm 1: movdqa <t3dq=int6464#4,5648(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,5648(<gfmtable=%rdi)
movdqa %xmm3,5648(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5824) = tmp
# asm 1: movdqa <tmp=int6464#5,5824(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5824(<gfmtable=%rdi)
movdqa %xmm4,5824(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5856) = tmp
# asm 1: movdqa <tmp=int6464#5,5856(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5856(<gfmtable=%rdi)
movdqa %xmm4,5856(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5792) = tmp
# asm 1: movdqa <tmp=int6464#5,5792(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5792(<gfmtable=%rdi)
movdqa %xmm4,5792(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5808) = tmp
# asm 1: movdqa <tmp=int6464#5,5808(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5808(<gfmtable=%rdi)
movdqa %xmm4,5808(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5776) = tmp
# asm 1: movdqa <tmp=int6464#5,5776(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5776(<gfmtable=%rdi)
movdqa %xmm4,5776(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5840) = tmp
# asm 1: movdqa <tmp=int6464#5,5840(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5840(<gfmtable=%rdi)
movdqa %xmm4,5840(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5712) = tmp
# asm 1: movdqa <tmp=int6464#5,5712(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5712(<gfmtable=%rdi)
movdqa %xmm4,5712(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5744) = tmp
# asm 1: movdqa <tmp=int6464#5,5744(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5744(<gfmtable=%rdi)
movdqa %xmm4,5744(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5680) = tmp
# asm 1: movdqa <tmp=int6464#5,5680(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5680(<gfmtable=%rdi)
movdqa %xmm4,5680(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5728) = tmp
# asm 1: movdqa <tmp=int6464#5,5728(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5728(<gfmtable=%rdi)
movdqa %xmm4,5728(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5872) = tmp
# asm 1: movdqa <tmp=int6464#5,5872(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5872(<gfmtable=%rdi)
movdqa %xmm4,5872(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 6272) = t0dq
# asm 1: movdqa <t0dq=int6464#1,6272(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,6272(<gfmtable=%rdi)
movdqa %xmm0,6272(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6208) = t1dq
# asm 1: movdqa <t1dq=int6464#2,6208(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,6208(<gfmtable=%rdi)
movdqa %xmm1,6208(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6176) = t2dq
# asm 1: movdqa <t2dq=int6464#3,6176(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,6176(<gfmtable=%rdi)
movdqa %xmm2,6176(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6160) = t3dq
# asm 1: movdqa <t3dq=int6464#4,6160(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,6160(<gfmtable=%rdi)
movdqa %xmm3,6160(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6336) = tmp
# asm 1: movdqa <tmp=int6464#5,6336(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6336(<gfmtable=%rdi)
movdqa %xmm4,6336(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6368) = tmp
# asm 1: movdqa <tmp=int6464#5,6368(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6368(<gfmtable=%rdi)
movdqa %xmm4,6368(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6304) = tmp
# asm 1: movdqa <tmp=int6464#5,6304(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6304(<gfmtable=%rdi)
movdqa %xmm4,6304(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6320) = tmp
# asm 1: movdqa <tmp=int6464#5,6320(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6320(<gfmtable=%rdi)
movdqa %xmm4,6320(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6288) = tmp
# asm 1: movdqa <tmp=int6464#5,6288(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6288(<gfmtable=%rdi)
movdqa %xmm4,6288(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6352) = tmp
# asm 1: movdqa <tmp=int6464#5,6352(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6352(<gfmtable=%rdi)
movdqa %xmm4,6352(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6224) = tmp
# asm 1: movdqa <tmp=int6464#5,6224(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6224(<gfmtable=%rdi)
movdqa %xmm4,6224(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6256) = tmp
# asm 1: movdqa <tmp=int6464#5,6256(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6256(<gfmtable=%rdi)
movdqa %xmm4,6256(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6192) = tmp
# asm 1: movdqa <tmp=int6464#5,6192(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6192(<gfmtable=%rdi)
movdqa %xmm4,6192(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6240) = tmp
# asm 1: movdqa <tmp=int6464#5,6240(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6240(<gfmtable=%rdi)
movdqa %xmm4,6240(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6384) = tmp
# asm 1: movdqa <tmp=int6464#5,6384(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6384(<gfmtable=%rdi)
movdqa %xmm4,6384(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 6784) = t0dq
# asm 1: movdqa <t0dq=int6464#1,6784(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,6784(<gfmtable=%rdi)
movdqa %xmm0,6784(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6720) = t1dq
# asm 1: movdqa <t1dq=int6464#2,6720(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,6720(<gfmtable=%rdi)
movdqa %xmm1,6720(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6688) = t2dq
# asm 1: movdqa <t2dq=int6464#3,6688(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,6688(<gfmtable=%rdi)
movdqa %xmm2,6688(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6672) = t3dq
# asm 1: movdqa <t3dq=int6464#4,6672(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,6672(<gfmtable=%rdi)
movdqa %xmm3,6672(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6848) = tmp
# asm 1: movdqa <tmp=int6464#5,6848(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6848(<gfmtable=%rdi)
movdqa %xmm4,6848(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6880) = tmp
# asm 1: movdqa <tmp=int6464#5,6880(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6880(<gfmtable=%rdi)
movdqa %xmm4,6880(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6816) = tmp
# asm 1: movdqa <tmp=int6464#5,6816(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6816(<gfmtable=%rdi)
movdqa %xmm4,6816(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6832) = tmp
# asm 1: movdqa <tmp=int6464#5,6832(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6832(<gfmtable=%rdi)
movdqa %xmm4,6832(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6800) = tmp
# asm 1: movdqa <tmp=int6464#5,6800(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6800(<gfmtable=%rdi)
movdqa %xmm4,6800(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6864) = tmp
# asm 1: movdqa <tmp=int6464#5,6864(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6864(<gfmtable=%rdi)
movdqa %xmm4,6864(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6736) = tmp
# asm 1: movdqa <tmp=int6464#5,6736(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6736(<gfmtable=%rdi)
movdqa %xmm4,6736(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6768) = tmp
# asm 1: movdqa <tmp=int6464#5,6768(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6768(<gfmtable=%rdi)
movdqa %xmm4,6768(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6704) = tmp
# asm 1: movdqa <tmp=int6464#5,6704(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6704(<gfmtable=%rdi)
movdqa %xmm4,6704(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6752) = tmp
# asm 1: movdqa <tmp=int6464#5,6752(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6752(<gfmtable=%rdi)
movdqa %xmm4,6752(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6896) = tmp
# asm 1: movdqa <tmp=int6464#5,6896(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6896(<gfmtable=%rdi)
movdqa %xmm4,6896(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 7296) = t0dq
# asm 1: movdqa <t0dq=int6464#1,7296(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,7296(<gfmtable=%rdi)
movdqa %xmm0,7296(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7232) = t1dq
# asm 1: movdqa <t1dq=int6464#2,7232(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,7232(<gfmtable=%rdi)
movdqa %xmm1,7232(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7200) = t2dq
# asm 1: movdqa <t2dq=int6464#3,7200(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,7200(<gfmtable=%rdi)
movdqa %xmm2,7200(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7184) = t3dq
# asm 1: movdqa <t3dq=int6464#4,7184(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,7184(<gfmtable=%rdi)
movdqa %xmm3,7184(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7360) = tmp
# asm 1: movdqa <tmp=int6464#5,7360(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7360(<gfmtable=%rdi)
movdqa %xmm4,7360(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7392) = tmp
# asm 1: movdqa <tmp=int6464#5,7392(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7392(<gfmtable=%rdi)
movdqa %xmm4,7392(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7328) = tmp
# asm 1: movdqa <tmp=int6464#5,7328(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7328(<gfmtable=%rdi)
movdqa %xmm4,7328(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7344) = tmp
# asm 1: movdqa <tmp=int6464#5,7344(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7344(<gfmtable=%rdi)
movdqa %xmm4,7344(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7312) = tmp
# asm 1: movdqa <tmp=int6464#5,7312(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7312(<gfmtable=%rdi)
movdqa %xmm4,7312(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7376) = tmp
# asm 1: movdqa <tmp=int6464#5,7376(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7376(<gfmtable=%rdi)
movdqa %xmm4,7376(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7248) = tmp
# asm 1: movdqa <tmp=int6464#5,7248(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7248(<gfmtable=%rdi)
movdqa %xmm4,7248(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7280) = tmp
# asm 1: movdqa <tmp=int6464#5,7280(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7280(<gfmtable=%rdi)
movdqa %xmm4,7280(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7216) = tmp
# asm 1: movdqa <tmp=int6464#5,7216(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7216(<gfmtable=%rdi)
movdqa %xmm4,7216(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7264) = tmp
# asm 1: movdqa <tmp=int6464#5,7264(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7264(<gfmtable=%rdi)
movdqa %xmm4,7264(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7408) = tmp
# asm 1: movdqa <tmp=int6464#5,7408(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7408(<gfmtable=%rdi)
movdqa %xmm4,7408(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 7808) = t0dq
# asm 1: movdqa <t0dq=int6464#1,7808(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,7808(<gfmtable=%rdi)
movdqa %xmm0,7808(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7744) = t1dq
# asm 1: movdqa <t1dq=int6464#2,7744(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,7744(<gfmtable=%rdi)
movdqa %xmm1,7744(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7712) = t2dq
# asm 1: movdqa <t2dq=int6464#3,7712(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,7712(<gfmtable=%rdi)
movdqa %xmm2,7712(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7696) = t3dq
# asm 1: movdqa <t3dq=int6464#4,7696(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,7696(<gfmtable=%rdi)
movdqa %xmm3,7696(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7872) = tmp
# asm 1: movdqa <tmp=int6464#5,7872(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7872(<gfmtable=%rdi)
movdqa %xmm4,7872(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7904) = tmp
# asm 1: movdqa <tmp=int6464#5,7904(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7904(<gfmtable=%rdi)
movdqa %xmm4,7904(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7840) = tmp
# asm 1: movdqa <tmp=int6464#5,7840(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7840(<gfmtable=%rdi)
movdqa %xmm4,7840(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7856) = tmp
# asm 1: movdqa <tmp=int6464#5,7856(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7856(<gfmtable=%rdi)
movdqa %xmm4,7856(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7824) = tmp
# asm 1: movdqa <tmp=int6464#5,7824(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7824(<gfmtable=%rdi)
movdqa %xmm4,7824(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7888) = tmp
# asm 1: movdqa <tmp=int6464#5,7888(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7888(<gfmtable=%rdi)
movdqa %xmm4,7888(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7760) = tmp
# asm 1: movdqa <tmp=int6464#5,7760(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7760(<gfmtable=%rdi)
movdqa %xmm4,7760(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7792) = tmp
# asm 1: movdqa <tmp=int6464#5,7792(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7792(<gfmtable=%rdi)
movdqa %xmm4,7792(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7728) = tmp
# asm 1: movdqa <tmp=int6464#5,7728(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7728(<gfmtable=%rdi)
movdqa %xmm4,7728(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7776) = tmp
# asm 1: movdqa <tmp=int6464#5,7776(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7776(<gfmtable=%rdi)
movdqa %xmm4,7776(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7920) = tmp
# asm 1: movdqa <tmp=int6464#5,7920(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7920(<gfmtable=%rdi)
movdqa %xmm4,7920(%rdi)

# qhasm:   t0dq = *(int128 *) (gfmtable + 384)
# asm 1: movdqa 384(<gfmtable=int64#1),>t0dq=int6464#1
# asm 2: movdqa 384(<gfmtable=%rdi),>t0dq=%xmm0
movdqa 384(%rdi),%xmm0

# qhasm:   t1dq = *(int128 *) (gfmtable + 320)
# asm 1: movdqa 320(<gfmtable=int64#1),>t1dq=int6464#2
# asm 2: movdqa 320(<gfmtable=%rdi),>t1dq=%xmm1
movdqa 320(%rdi),%xmm1

# qhasm:   t2dq = *(int128 *) (gfmtable + 288)
# asm 1: movdqa 288(<gfmtable=int64#1),>t2dq=int6464#3
# asm 2: movdqa 288(<gfmtable=%rdi),>t2dq=%xmm2
movdqa 288(%rdi),%xmm2

# qhasm:   t3dq = *(int128 *) (gfmtable + 272)
# asm 1: movdqa 272(<gfmtable=int64#1),>t3dq=int6464#4
# asm 2: movdqa 272(<gfmtable=%rdi),>t3dq=%xmm3
movdqa 272(%rdi),%xmm3

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 448) = tmp
# asm 1: movdqa <tmp=int6464#5,448(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,448(<gfmtable=%rdi)
movdqa %xmm4,448(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 480) = tmp
# asm 1: movdqa <tmp=int6464#5,480(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,480(<gfmtable=%rdi)
movdqa %xmm4,480(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 416) = tmp
# asm 1: movdqa <tmp=int6464#5,416(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,416(<gfmtable=%rdi)
movdqa %xmm4,416(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 432) = tmp
# asm 1: movdqa <tmp=int6464#5,432(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,432(<gfmtable=%rdi)
movdqa %xmm4,432(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 400) = tmp
# asm 1: movdqa <tmp=int6464#5,400(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,400(<gfmtable=%rdi)
movdqa %xmm4,400(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 464) = tmp
# asm 1: movdqa <tmp=int6464#5,464(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,464(<gfmtable=%rdi)
movdqa %xmm4,464(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 336) = tmp
# asm 1: movdqa <tmp=int6464#5,336(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,336(<gfmtable=%rdi)
movdqa %xmm4,336(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 368) = tmp
# asm 1: movdqa <tmp=int6464#5,368(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,368(<gfmtable=%rdi)
movdqa %xmm4,368(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 304) = tmp
# asm 1: movdqa <tmp=int6464#5,304(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,304(<gfmtable=%rdi)
movdqa %xmm4,304(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 352) = tmp
# asm 1: movdqa <tmp=int6464#5,352(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,352(<gfmtable=%rdi)
movdqa %xmm4,352(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 496) = tmp
# asm 1: movdqa <tmp=int6464#5,496(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,496(<gfmtable=%rdi)
movdqa %xmm4,496(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 896) = t0dq
# asm 1: movdqa <t0dq=int6464#1,896(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,896(<gfmtable=%rdi)
movdqa %xmm0,896(%rdi)

# qhasm:   *(int128 *) (gfmtable + 832) = t1dq
# asm 1: movdqa <t1dq=int6464#2,832(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,832(<gfmtable=%rdi)
movdqa %xmm1,832(%rdi)

# qhasm:   *(int128 *) (gfmtable + 800) = t2dq
# asm 1: movdqa <t2dq=int6464#3,800(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,800(<gfmtable=%rdi)
movdqa %xmm2,800(%rdi)

# qhasm:   *(int128 *) (gfmtable + 784) = t3dq
# asm 1: movdqa <t3dq=int6464#4,784(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,784(<gfmtable=%rdi)
movdqa %xmm3,784(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 960) = tmp
# asm 1: movdqa <tmp=int6464#5,960(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,960(<gfmtable=%rdi)
movdqa %xmm4,960(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 992) = tmp
# asm 1: movdqa <tmp=int6464#5,992(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,992(<gfmtable=%rdi)
movdqa %xmm4,992(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 928) = tmp
# asm 1: movdqa <tmp=int6464#5,928(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,928(<gfmtable=%rdi)
movdqa %xmm4,928(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 944) = tmp
# asm 1: movdqa <tmp=int6464#5,944(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,944(<gfmtable=%rdi)
movdqa %xmm4,944(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 912) = tmp
# asm 1: movdqa <tmp=int6464#5,912(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,912(<gfmtable=%rdi)
movdqa %xmm4,912(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 976) = tmp
# asm 1: movdqa <tmp=int6464#5,976(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,976(<gfmtable=%rdi)
movdqa %xmm4,976(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 848) = tmp
# asm 1: movdqa <tmp=int6464#5,848(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,848(<gfmtable=%rdi)
movdqa %xmm4,848(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 880) = tmp
# asm 1: movdqa <tmp=int6464#5,880(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,880(<gfmtable=%rdi)
movdqa %xmm4,880(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 816) = tmp
# asm 1: movdqa <tmp=int6464#5,816(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,816(<gfmtable=%rdi)
movdqa %xmm4,816(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 864) = tmp
# asm 1: movdqa <tmp=int6464#5,864(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,864(<gfmtable=%rdi)
movdqa %xmm4,864(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1008) = tmp
# asm 1: movdqa <tmp=int6464#5,1008(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1008(<gfmtable=%rdi)
movdqa %xmm4,1008(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 1408) = t0dq
# asm 1: movdqa <t0dq=int6464#1,1408(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,1408(<gfmtable=%rdi)
movdqa %xmm0,1408(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1344) = t1dq
# asm 1: movdqa <t1dq=int6464#2,1344(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,1344(<gfmtable=%rdi)
movdqa %xmm1,1344(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1312) = t2dq
# asm 1: movdqa <t2dq=int6464#3,1312(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,1312(<gfmtable=%rdi)
movdqa %xmm2,1312(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1296) = t3dq
# asm 1: movdqa <t3dq=int6464#4,1296(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,1296(<gfmtable=%rdi)
movdqa %xmm3,1296(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1472) = tmp
# asm 1: movdqa <tmp=int6464#5,1472(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1472(<gfmtable=%rdi)
movdqa %xmm4,1472(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1504) = tmp
# asm 1: movdqa <tmp=int6464#5,1504(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1504(<gfmtable=%rdi)
movdqa %xmm4,1504(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1440) = tmp
# asm 1: movdqa <tmp=int6464#5,1440(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1440(<gfmtable=%rdi)
movdqa %xmm4,1440(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1456) = tmp
# asm 1: movdqa <tmp=int6464#5,1456(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1456(<gfmtable=%rdi)
movdqa %xmm4,1456(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1424) = tmp
# asm 1: movdqa <tmp=int6464#5,1424(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1424(<gfmtable=%rdi)
movdqa %xmm4,1424(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1488) = tmp
# asm 1: movdqa <tmp=int6464#5,1488(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1488(<gfmtable=%rdi)
movdqa %xmm4,1488(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1360) = tmp
# asm 1: movdqa <tmp=int6464#5,1360(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1360(<gfmtable=%rdi)
movdqa %xmm4,1360(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1392) = tmp
# asm 1: movdqa <tmp=int6464#5,1392(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1392(<gfmtable=%rdi)
movdqa %xmm4,1392(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1328) = tmp
# asm 1: movdqa <tmp=int6464#5,1328(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1328(<gfmtable=%rdi)
movdqa %xmm4,1328(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1376) = tmp
# asm 1: movdqa <tmp=int6464#5,1376(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1376(<gfmtable=%rdi)
movdqa %xmm4,1376(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1520) = tmp
# asm 1: movdqa <tmp=int6464#5,1520(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1520(<gfmtable=%rdi)
movdqa %xmm4,1520(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 1920) = t0dq
# asm 1: movdqa <t0dq=int6464#1,1920(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,1920(<gfmtable=%rdi)
movdqa %xmm0,1920(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1856) = t1dq
# asm 1: movdqa <t1dq=int6464#2,1856(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,1856(<gfmtable=%rdi)
movdqa %xmm1,1856(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1824) = t2dq
# asm 1: movdqa <t2dq=int6464#3,1824(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,1824(<gfmtable=%rdi)
movdqa %xmm2,1824(%rdi)

# qhasm:   *(int128 *) (gfmtable + 1808) = t3dq
# asm 1: movdqa <t3dq=int6464#4,1808(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,1808(<gfmtable=%rdi)
movdqa %xmm3,1808(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1984) = tmp
# asm 1: movdqa <tmp=int6464#5,1984(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1984(<gfmtable=%rdi)
movdqa %xmm4,1984(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2016) = tmp
# asm 1: movdqa <tmp=int6464#5,2016(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2016(<gfmtable=%rdi)
movdqa %xmm4,2016(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1952) = tmp
# asm 1: movdqa <tmp=int6464#5,1952(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1952(<gfmtable=%rdi)
movdqa %xmm4,1952(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1968) = tmp
# asm 1: movdqa <tmp=int6464#5,1968(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1968(<gfmtable=%rdi)
movdqa %xmm4,1968(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1936) = tmp
# asm 1: movdqa <tmp=int6464#5,1936(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1936(<gfmtable=%rdi)
movdqa %xmm4,1936(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2000) = tmp
# asm 1: movdqa <tmp=int6464#5,2000(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2000(<gfmtable=%rdi)
movdqa %xmm4,2000(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1872) = tmp
# asm 1: movdqa <tmp=int6464#5,1872(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1872(<gfmtable=%rdi)
movdqa %xmm4,1872(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1904) = tmp
# asm 1: movdqa <tmp=int6464#5,1904(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1904(<gfmtable=%rdi)
movdqa %xmm4,1904(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1840) = tmp
# asm 1: movdqa <tmp=int6464#5,1840(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1840(<gfmtable=%rdi)
movdqa %xmm4,1840(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 1888) = tmp
# asm 1: movdqa <tmp=int6464#5,1888(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,1888(<gfmtable=%rdi)
movdqa %xmm4,1888(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2032) = tmp
# asm 1: movdqa <tmp=int6464#5,2032(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2032(<gfmtable=%rdi)
movdqa %xmm4,2032(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 2432) = t0dq
# asm 1: movdqa <t0dq=int6464#1,2432(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,2432(<gfmtable=%rdi)
movdqa %xmm0,2432(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2368) = t1dq
# asm 1: movdqa <t1dq=int6464#2,2368(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,2368(<gfmtable=%rdi)
movdqa %xmm1,2368(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2336) = t2dq
# asm 1: movdqa <t2dq=int6464#3,2336(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,2336(<gfmtable=%rdi)
movdqa %xmm2,2336(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2320) = t3dq
# asm 1: movdqa <t3dq=int6464#4,2320(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,2320(<gfmtable=%rdi)
movdqa %xmm3,2320(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2496) = tmp
# asm 1: movdqa <tmp=int6464#5,2496(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2496(<gfmtable=%rdi)
movdqa %xmm4,2496(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2528) = tmp
# asm 1: movdqa <tmp=int6464#5,2528(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2528(<gfmtable=%rdi)
movdqa %xmm4,2528(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2464) = tmp
# asm 1: movdqa <tmp=int6464#5,2464(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2464(<gfmtable=%rdi)
movdqa %xmm4,2464(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2480) = tmp
# asm 1: movdqa <tmp=int6464#5,2480(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2480(<gfmtable=%rdi)
movdqa %xmm4,2480(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2448) = tmp
# asm 1: movdqa <tmp=int6464#5,2448(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2448(<gfmtable=%rdi)
movdqa %xmm4,2448(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2512) = tmp
# asm 1: movdqa <tmp=int6464#5,2512(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2512(<gfmtable=%rdi)
movdqa %xmm4,2512(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2384) = tmp
# asm 1: movdqa <tmp=int6464#5,2384(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2384(<gfmtable=%rdi)
movdqa %xmm4,2384(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2416) = tmp
# asm 1: movdqa <tmp=int6464#5,2416(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2416(<gfmtable=%rdi)
movdqa %xmm4,2416(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2352) = tmp
# asm 1: movdqa <tmp=int6464#5,2352(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2352(<gfmtable=%rdi)
movdqa %xmm4,2352(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2400) = tmp
# asm 1: movdqa <tmp=int6464#5,2400(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2400(<gfmtable=%rdi)
movdqa %xmm4,2400(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2544) = tmp
# asm 1: movdqa <tmp=int6464#5,2544(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2544(<gfmtable=%rdi)
movdqa %xmm4,2544(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 2944) = t0dq
# asm 1: movdqa <t0dq=int6464#1,2944(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,2944(<gfmtable=%rdi)
movdqa %xmm0,2944(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2880) = t1dq
# asm 1: movdqa <t1dq=int6464#2,2880(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,2880(<gfmtable=%rdi)
movdqa %xmm1,2880(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2848) = t2dq
# asm 1: movdqa <t2dq=int6464#3,2848(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,2848(<gfmtable=%rdi)
movdqa %xmm2,2848(%rdi)

# qhasm:   *(int128 *) (gfmtable + 2832) = t3dq
# asm 1: movdqa <t3dq=int6464#4,2832(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,2832(<gfmtable=%rdi)
movdqa %xmm3,2832(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3008) = tmp
# asm 1: movdqa <tmp=int6464#5,3008(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3008(<gfmtable=%rdi)
movdqa %xmm4,3008(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3040) = tmp
# asm 1: movdqa <tmp=int6464#5,3040(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3040(<gfmtable=%rdi)
movdqa %xmm4,3040(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2976) = tmp
# asm 1: movdqa <tmp=int6464#5,2976(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2976(<gfmtable=%rdi)
movdqa %xmm4,2976(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2992) = tmp
# asm 1: movdqa <tmp=int6464#5,2992(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2992(<gfmtable=%rdi)
movdqa %xmm4,2992(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2960) = tmp
# asm 1: movdqa <tmp=int6464#5,2960(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2960(<gfmtable=%rdi)
movdqa %xmm4,2960(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3024) = tmp
# asm 1: movdqa <tmp=int6464#5,3024(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3024(<gfmtable=%rdi)
movdqa %xmm4,3024(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2896) = tmp
# asm 1: movdqa <tmp=int6464#5,2896(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2896(<gfmtable=%rdi)
movdqa %xmm4,2896(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2928) = tmp
# asm 1: movdqa <tmp=int6464#5,2928(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2928(<gfmtable=%rdi)
movdqa %xmm4,2928(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2864) = tmp
# asm 1: movdqa <tmp=int6464#5,2864(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2864(<gfmtable=%rdi)
movdqa %xmm4,2864(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 2912) = tmp
# asm 1: movdqa <tmp=int6464#5,2912(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,2912(<gfmtable=%rdi)
movdqa %xmm4,2912(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3056) = tmp
# asm 1: movdqa <tmp=int6464#5,3056(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3056(<gfmtable=%rdi)
movdqa %xmm4,3056(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 3456) = t0dq
# asm 1: movdqa <t0dq=int6464#1,3456(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,3456(<gfmtable=%rdi)
movdqa %xmm0,3456(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3392) = t1dq
# asm 1: movdqa <t1dq=int6464#2,3392(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,3392(<gfmtable=%rdi)
movdqa %xmm1,3392(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3360) = t2dq
# asm 1: movdqa <t2dq=int6464#3,3360(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,3360(<gfmtable=%rdi)
movdqa %xmm2,3360(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3344) = t3dq
# asm 1: movdqa <t3dq=int6464#4,3344(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,3344(<gfmtable=%rdi)
movdqa %xmm3,3344(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3520) = tmp
# asm 1: movdqa <tmp=int6464#5,3520(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3520(<gfmtable=%rdi)
movdqa %xmm4,3520(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3552) = tmp
# asm 1: movdqa <tmp=int6464#5,3552(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3552(<gfmtable=%rdi)
movdqa %xmm4,3552(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3488) = tmp
# asm 1: movdqa <tmp=int6464#5,3488(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3488(<gfmtable=%rdi)
movdqa %xmm4,3488(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3504) = tmp
# asm 1: movdqa <tmp=int6464#5,3504(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3504(<gfmtable=%rdi)
movdqa %xmm4,3504(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3472) = tmp
# asm 1: movdqa <tmp=int6464#5,3472(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3472(<gfmtable=%rdi)
movdqa %xmm4,3472(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3536) = tmp
# asm 1: movdqa <tmp=int6464#5,3536(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3536(<gfmtable=%rdi)
movdqa %xmm4,3536(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3408) = tmp
# asm 1: movdqa <tmp=int6464#5,3408(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3408(<gfmtable=%rdi)
movdqa %xmm4,3408(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3440) = tmp
# asm 1: movdqa <tmp=int6464#5,3440(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3440(<gfmtable=%rdi)
movdqa %xmm4,3440(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3376) = tmp
# asm 1: movdqa <tmp=int6464#5,3376(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3376(<gfmtable=%rdi)
movdqa %xmm4,3376(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3424) = tmp
# asm 1: movdqa <tmp=int6464#5,3424(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3424(<gfmtable=%rdi)
movdqa %xmm4,3424(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3568) = tmp
# asm 1: movdqa <tmp=int6464#5,3568(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3568(<gfmtable=%rdi)
movdqa %xmm4,3568(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 3968) = t0dq
# asm 1: movdqa <t0dq=int6464#1,3968(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,3968(<gfmtable=%rdi)
movdqa %xmm0,3968(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3904) = t1dq
# asm 1: movdqa <t1dq=int6464#2,3904(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,3904(<gfmtable=%rdi)
movdqa %xmm1,3904(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3872) = t2dq
# asm 1: movdqa <t2dq=int6464#3,3872(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,3872(<gfmtable=%rdi)
movdqa %xmm2,3872(%rdi)

# qhasm:   *(int128 *) (gfmtable + 3856) = t3dq
# asm 1: movdqa <t3dq=int6464#4,3856(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,3856(<gfmtable=%rdi)
movdqa %xmm3,3856(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4032) = tmp
# asm 1: movdqa <tmp=int6464#5,4032(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4032(<gfmtable=%rdi)
movdqa %xmm4,4032(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4064) = tmp
# asm 1: movdqa <tmp=int6464#5,4064(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4064(<gfmtable=%rdi)
movdqa %xmm4,4064(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4000) = tmp
# asm 1: movdqa <tmp=int6464#5,4000(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4000(<gfmtable=%rdi)
movdqa %xmm4,4000(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4016) = tmp
# asm 1: movdqa <tmp=int6464#5,4016(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4016(<gfmtable=%rdi)
movdqa %xmm4,4016(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3984) = tmp
# asm 1: movdqa <tmp=int6464#5,3984(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3984(<gfmtable=%rdi)
movdqa %xmm4,3984(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4048) = tmp
# asm 1: movdqa <tmp=int6464#5,4048(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4048(<gfmtable=%rdi)
movdqa %xmm4,4048(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3920) = tmp
# asm 1: movdqa <tmp=int6464#5,3920(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3920(<gfmtable=%rdi)
movdqa %xmm4,3920(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3952) = tmp
# asm 1: movdqa <tmp=int6464#5,3952(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3952(<gfmtable=%rdi)
movdqa %xmm4,3952(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3888) = tmp
# asm 1: movdqa <tmp=int6464#5,3888(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3888(<gfmtable=%rdi)
movdqa %xmm4,3888(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 3936) = tmp
# asm 1: movdqa <tmp=int6464#5,3936(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,3936(<gfmtable=%rdi)
movdqa %xmm4,3936(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4080) = tmp
# asm 1: movdqa <tmp=int6464#5,4080(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4080(<gfmtable=%rdi)
movdqa %xmm4,4080(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 4480) = t0dq
# asm 1: movdqa <t0dq=int6464#1,4480(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,4480(<gfmtable=%rdi)
movdqa %xmm0,4480(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4416) = t1dq
# asm 1: movdqa <t1dq=int6464#2,4416(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,4416(<gfmtable=%rdi)
movdqa %xmm1,4416(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4384) = t2dq
# asm 1: movdqa <t2dq=int6464#3,4384(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,4384(<gfmtable=%rdi)
movdqa %xmm2,4384(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4368) = t3dq
# asm 1: movdqa <t3dq=int6464#4,4368(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,4368(<gfmtable=%rdi)
movdqa %xmm3,4368(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4544) = tmp
# asm 1: movdqa <tmp=int6464#5,4544(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4544(<gfmtable=%rdi)
movdqa %xmm4,4544(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4576) = tmp
# asm 1: movdqa <tmp=int6464#5,4576(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4576(<gfmtable=%rdi)
movdqa %xmm4,4576(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4512) = tmp
# asm 1: movdqa <tmp=int6464#5,4512(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4512(<gfmtable=%rdi)
movdqa %xmm4,4512(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4528) = tmp
# asm 1: movdqa <tmp=int6464#5,4528(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4528(<gfmtable=%rdi)
movdqa %xmm4,4528(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4496) = tmp
# asm 1: movdqa <tmp=int6464#5,4496(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4496(<gfmtable=%rdi)
movdqa %xmm4,4496(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4560) = tmp
# asm 1: movdqa <tmp=int6464#5,4560(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4560(<gfmtable=%rdi)
movdqa %xmm4,4560(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4432) = tmp
# asm 1: movdqa <tmp=int6464#5,4432(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4432(<gfmtable=%rdi)
movdqa %xmm4,4432(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4464) = tmp
# asm 1: movdqa <tmp=int6464#5,4464(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4464(<gfmtable=%rdi)
movdqa %xmm4,4464(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4400) = tmp
# asm 1: movdqa <tmp=int6464#5,4400(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4400(<gfmtable=%rdi)
movdqa %xmm4,4400(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4448) = tmp
# asm 1: movdqa <tmp=int6464#5,4448(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4448(<gfmtable=%rdi)
movdqa %xmm4,4448(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4592) = tmp
# asm 1: movdqa <tmp=int6464#5,4592(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4592(<gfmtable=%rdi)
movdqa %xmm4,4592(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 4992) = t0dq
# asm 1: movdqa <t0dq=int6464#1,4992(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,4992(<gfmtable=%rdi)
movdqa %xmm0,4992(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4928) = t1dq
# asm 1: movdqa <t1dq=int6464#2,4928(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,4928(<gfmtable=%rdi)
movdqa %xmm1,4928(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4896) = t2dq
# asm 1: movdqa <t2dq=int6464#3,4896(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,4896(<gfmtable=%rdi)
movdqa %xmm2,4896(%rdi)

# qhasm:   *(int128 *) (gfmtable + 4880) = t3dq
# asm 1: movdqa <t3dq=int6464#4,4880(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,4880(<gfmtable=%rdi)
movdqa %xmm3,4880(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5056) = tmp
# asm 1: movdqa <tmp=int6464#5,5056(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5056(<gfmtable=%rdi)
movdqa %xmm4,5056(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5088) = tmp
# asm 1: movdqa <tmp=int6464#5,5088(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5088(<gfmtable=%rdi)
movdqa %xmm4,5088(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5024) = tmp
# asm 1: movdqa <tmp=int6464#5,5024(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5024(<gfmtable=%rdi)
movdqa %xmm4,5024(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5040) = tmp
# asm 1: movdqa <tmp=int6464#5,5040(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5040(<gfmtable=%rdi)
movdqa %xmm4,5040(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5008) = tmp
# asm 1: movdqa <tmp=int6464#5,5008(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5008(<gfmtable=%rdi)
movdqa %xmm4,5008(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5072) = tmp
# asm 1: movdqa <tmp=int6464#5,5072(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5072(<gfmtable=%rdi)
movdqa %xmm4,5072(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4944) = tmp
# asm 1: movdqa <tmp=int6464#5,4944(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4944(<gfmtable=%rdi)
movdqa %xmm4,4944(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4976) = tmp
# asm 1: movdqa <tmp=int6464#5,4976(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4976(<gfmtable=%rdi)
movdqa %xmm4,4976(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4912) = tmp
# asm 1: movdqa <tmp=int6464#5,4912(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4912(<gfmtable=%rdi)
movdqa %xmm4,4912(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 4960) = tmp
# asm 1: movdqa <tmp=int6464#5,4960(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,4960(<gfmtable=%rdi)
movdqa %xmm4,4960(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5104) = tmp
# asm 1: movdqa <tmp=int6464#5,5104(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5104(<gfmtable=%rdi)
movdqa %xmm4,5104(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 5504) = t0dq
# asm 1: movdqa <t0dq=int6464#1,5504(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,5504(<gfmtable=%rdi)
movdqa %xmm0,5504(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5440) = t1dq
# asm 1: movdqa <t1dq=int6464#2,5440(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,5440(<gfmtable=%rdi)
movdqa %xmm1,5440(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5408) = t2dq
# asm 1: movdqa <t2dq=int6464#3,5408(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,5408(<gfmtable=%rdi)
movdqa %xmm2,5408(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5392) = t3dq
# asm 1: movdqa <t3dq=int6464#4,5392(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,5392(<gfmtable=%rdi)
movdqa %xmm3,5392(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5568) = tmp
# asm 1: movdqa <tmp=int6464#5,5568(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5568(<gfmtable=%rdi)
movdqa %xmm4,5568(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5600) = tmp
# asm 1: movdqa <tmp=int6464#5,5600(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5600(<gfmtable=%rdi)
movdqa %xmm4,5600(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5536) = tmp
# asm 1: movdqa <tmp=int6464#5,5536(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5536(<gfmtable=%rdi)
movdqa %xmm4,5536(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5552) = tmp
# asm 1: movdqa <tmp=int6464#5,5552(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5552(<gfmtable=%rdi)
movdqa %xmm4,5552(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5520) = tmp
# asm 1: movdqa <tmp=int6464#5,5520(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5520(<gfmtable=%rdi)
movdqa %xmm4,5520(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5584) = tmp
# asm 1: movdqa <tmp=int6464#5,5584(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5584(<gfmtable=%rdi)
movdqa %xmm4,5584(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5456) = tmp
# asm 1: movdqa <tmp=int6464#5,5456(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5456(<gfmtable=%rdi)
movdqa %xmm4,5456(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5488) = tmp
# asm 1: movdqa <tmp=int6464#5,5488(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5488(<gfmtable=%rdi)
movdqa %xmm4,5488(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5424) = tmp
# asm 1: movdqa <tmp=int6464#5,5424(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5424(<gfmtable=%rdi)
movdqa %xmm4,5424(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5472) = tmp
# asm 1: movdqa <tmp=int6464#5,5472(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5472(<gfmtable=%rdi)
movdqa %xmm4,5472(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5616) = tmp
# asm 1: movdqa <tmp=int6464#5,5616(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5616(<gfmtable=%rdi)
movdqa %xmm4,5616(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 6016) = t0dq
# asm 1: movdqa <t0dq=int6464#1,6016(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,6016(<gfmtable=%rdi)
movdqa %xmm0,6016(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5952) = t1dq
# asm 1: movdqa <t1dq=int6464#2,5952(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,5952(<gfmtable=%rdi)
movdqa %xmm1,5952(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5920) = t2dq
# asm 1: movdqa <t2dq=int6464#3,5920(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,5920(<gfmtable=%rdi)
movdqa %xmm2,5920(%rdi)

# qhasm:   *(int128 *) (gfmtable + 5904) = t3dq
# asm 1: movdqa <t3dq=int6464#4,5904(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,5904(<gfmtable=%rdi)
movdqa %xmm3,5904(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6080) = tmp
# asm 1: movdqa <tmp=int6464#5,6080(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6080(<gfmtable=%rdi)
movdqa %xmm4,6080(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6112) = tmp
# asm 1: movdqa <tmp=int6464#5,6112(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6112(<gfmtable=%rdi)
movdqa %xmm4,6112(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6048) = tmp
# asm 1: movdqa <tmp=int6464#5,6048(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6048(<gfmtable=%rdi)
movdqa %xmm4,6048(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6064) = tmp
# asm 1: movdqa <tmp=int6464#5,6064(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6064(<gfmtable=%rdi)
movdqa %xmm4,6064(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6032) = tmp
# asm 1: movdqa <tmp=int6464#5,6032(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6032(<gfmtable=%rdi)
movdqa %xmm4,6032(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6096) = tmp
# asm 1: movdqa <tmp=int6464#5,6096(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6096(<gfmtable=%rdi)
movdqa %xmm4,6096(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5968) = tmp
# asm 1: movdqa <tmp=int6464#5,5968(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5968(<gfmtable=%rdi)
movdqa %xmm4,5968(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6000) = tmp
# asm 1: movdqa <tmp=int6464#5,6000(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6000(<gfmtable=%rdi)
movdqa %xmm4,6000(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5936) = tmp
# asm 1: movdqa <tmp=int6464#5,5936(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5936(<gfmtable=%rdi)
movdqa %xmm4,5936(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 5984) = tmp
# asm 1: movdqa <tmp=int6464#5,5984(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,5984(<gfmtable=%rdi)
movdqa %xmm4,5984(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6128) = tmp
# asm 1: movdqa <tmp=int6464#5,6128(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6128(<gfmtable=%rdi)
movdqa %xmm4,6128(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 6528) = t0dq
# asm 1: movdqa <t0dq=int6464#1,6528(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,6528(<gfmtable=%rdi)
movdqa %xmm0,6528(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6464) = t1dq
# asm 1: movdqa <t1dq=int6464#2,6464(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,6464(<gfmtable=%rdi)
movdqa %xmm1,6464(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6432) = t2dq
# asm 1: movdqa <t2dq=int6464#3,6432(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,6432(<gfmtable=%rdi)
movdqa %xmm2,6432(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6416) = t3dq
# asm 1: movdqa <t3dq=int6464#4,6416(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,6416(<gfmtable=%rdi)
movdqa %xmm3,6416(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6592) = tmp
# asm 1: movdqa <tmp=int6464#5,6592(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6592(<gfmtable=%rdi)
movdqa %xmm4,6592(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6624) = tmp
# asm 1: movdqa <tmp=int6464#5,6624(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6624(<gfmtable=%rdi)
movdqa %xmm4,6624(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6560) = tmp
# asm 1: movdqa <tmp=int6464#5,6560(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6560(<gfmtable=%rdi)
movdqa %xmm4,6560(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6576) = tmp
# asm 1: movdqa <tmp=int6464#5,6576(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6576(<gfmtable=%rdi)
movdqa %xmm4,6576(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6544) = tmp
# asm 1: movdqa <tmp=int6464#5,6544(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6544(<gfmtable=%rdi)
movdqa %xmm4,6544(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6608) = tmp
# asm 1: movdqa <tmp=int6464#5,6608(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6608(<gfmtable=%rdi)
movdqa %xmm4,6608(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6480) = tmp
# asm 1: movdqa <tmp=int6464#5,6480(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6480(<gfmtable=%rdi)
movdqa %xmm4,6480(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6512) = tmp
# asm 1: movdqa <tmp=int6464#5,6512(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6512(<gfmtable=%rdi)
movdqa %xmm4,6512(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6448) = tmp
# asm 1: movdqa <tmp=int6464#5,6448(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6448(<gfmtable=%rdi)
movdqa %xmm4,6448(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6496) = tmp
# asm 1: movdqa <tmp=int6464#5,6496(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6496(<gfmtable=%rdi)
movdqa %xmm4,6496(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6640) = tmp
# asm 1: movdqa <tmp=int6464#5,6640(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6640(<gfmtable=%rdi)
movdqa %xmm4,6640(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 7040) = t0dq
# asm 1: movdqa <t0dq=int6464#1,7040(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,7040(<gfmtable=%rdi)
movdqa %xmm0,7040(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6976) = t1dq
# asm 1: movdqa <t1dq=int6464#2,6976(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,6976(<gfmtable=%rdi)
movdqa %xmm1,6976(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6944) = t2dq
# asm 1: movdqa <t2dq=int6464#3,6944(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,6944(<gfmtable=%rdi)
movdqa %xmm2,6944(%rdi)

# qhasm:   *(int128 *) (gfmtable + 6928) = t3dq
# asm 1: movdqa <t3dq=int6464#4,6928(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,6928(<gfmtable=%rdi)
movdqa %xmm3,6928(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7104) = tmp
# asm 1: movdqa <tmp=int6464#5,7104(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7104(<gfmtable=%rdi)
movdqa %xmm4,7104(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7136) = tmp
# asm 1: movdqa <tmp=int6464#5,7136(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7136(<gfmtable=%rdi)
movdqa %xmm4,7136(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7072) = tmp
# asm 1: movdqa <tmp=int6464#5,7072(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7072(<gfmtable=%rdi)
movdqa %xmm4,7072(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7088) = tmp
# asm 1: movdqa <tmp=int6464#5,7088(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7088(<gfmtable=%rdi)
movdqa %xmm4,7088(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7056) = tmp
# asm 1: movdqa <tmp=int6464#5,7056(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7056(<gfmtable=%rdi)
movdqa %xmm4,7056(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7120) = tmp
# asm 1: movdqa <tmp=int6464#5,7120(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7120(<gfmtable=%rdi)
movdqa %xmm4,7120(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6992) = tmp
# asm 1: movdqa <tmp=int6464#5,6992(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6992(<gfmtable=%rdi)
movdqa %xmm4,6992(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7024) = tmp
# asm 1: movdqa <tmp=int6464#5,7024(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7024(<gfmtable=%rdi)
movdqa %xmm4,7024(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 6960) = tmp
# asm 1: movdqa <tmp=int6464#5,6960(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,6960(<gfmtable=%rdi)
movdqa %xmm4,6960(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7008) = tmp
# asm 1: movdqa <tmp=int6464#5,7008(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7008(<gfmtable=%rdi)
movdqa %xmm4,7008(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7152) = tmp
# asm 1: movdqa <tmp=int6464#5,7152(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7152(<gfmtable=%rdi)
movdqa %xmm4,7152(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 7552) = t0dq
# asm 1: movdqa <t0dq=int6464#1,7552(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,7552(<gfmtable=%rdi)
movdqa %xmm0,7552(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7488) = t1dq
# asm 1: movdqa <t1dq=int6464#2,7488(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,7488(<gfmtable=%rdi)
movdqa %xmm1,7488(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7456) = t2dq
# asm 1: movdqa <t2dq=int6464#3,7456(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,7456(<gfmtable=%rdi)
movdqa %xmm2,7456(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7440) = t3dq
# asm 1: movdqa <t3dq=int6464#4,7440(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,7440(<gfmtable=%rdi)
movdqa %xmm3,7440(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7616) = tmp
# asm 1: movdqa <tmp=int6464#5,7616(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7616(<gfmtable=%rdi)
movdqa %xmm4,7616(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7648) = tmp
# asm 1: movdqa <tmp=int6464#5,7648(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7648(<gfmtable=%rdi)
movdqa %xmm4,7648(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7584) = tmp
# asm 1: movdqa <tmp=int6464#5,7584(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7584(<gfmtable=%rdi)
movdqa %xmm4,7584(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7600) = tmp
# asm 1: movdqa <tmp=int6464#5,7600(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7600(<gfmtable=%rdi)
movdqa %xmm4,7600(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7568) = tmp
# asm 1: movdqa <tmp=int6464#5,7568(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7568(<gfmtable=%rdi)
movdqa %xmm4,7568(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7632) = tmp
# asm 1: movdqa <tmp=int6464#5,7632(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7632(<gfmtable=%rdi)
movdqa %xmm4,7632(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7504) = tmp
# asm 1: movdqa <tmp=int6464#5,7504(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7504(<gfmtable=%rdi)
movdqa %xmm4,7504(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7536) = tmp
# asm 1: movdqa <tmp=int6464#5,7536(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7536(<gfmtable=%rdi)
movdqa %xmm4,7536(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7472) = tmp
# asm 1: movdqa <tmp=int6464#5,7472(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7472(<gfmtable=%rdi)
movdqa %xmm4,7472(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7520) = tmp
# asm 1: movdqa <tmp=int6464#5,7520(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7520(<gfmtable=%rdi)
movdqa %xmm4,7520(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7664) = tmp
# asm 1: movdqa <tmp=int6464#5,7664(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7664(<gfmtable=%rdi)
movdqa %xmm4,7664(%rdi)

# qhasm:   cbyte0 = t0dq
# asm 1: movdqa <t0dq=int6464#1,>cbyte0=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>cbyte0=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   t0dq <<= 8
# asm 1: pslldq $1,<t0dq=int6464#1
# asm 2: pslldq $1,<t0dq=%xmm0
pslldq $1,%xmm0

# qhasm:   cbyte0 >>= 120
# asm 1: psrldq $15,<cbyte0=int6464#5
# asm 2: psrldq $15,<cbyte0=%xmm4
psrldq $15,%xmm4

# qhasm:   carry0 = cbyte0[0]
# asm 1: movq <cbyte0=int6464#5,>carry0=int64#2
# asm 2: movq <cbyte0=%xmm4,>carry0=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte0 = *(uint32 *) (redtable + carry0 * 4)
# asm 1: movd (<redtable=int64#3,<carry0=int64#2,4),>cbyte0=int6464#5
# asm 2: movd (<redtable=%rdx,<carry0=%rsi,4),>cbyte0=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t0dq ^= cbyte0
# asm 1: pxor  <cbyte0=int6464#5,<t0dq=int6464#1
# asm 2: pxor  <cbyte0=%xmm4,<t0dq=%xmm0
pxor  %xmm4,%xmm0

# qhasm:   cbyte1 = t1dq
# asm 1: movdqa <t1dq=int6464#2,>cbyte1=int6464#5
# asm 2: movdqa <t1dq=%xmm1,>cbyte1=%xmm4
movdqa %xmm1,%xmm4

# qhasm:   t1dq <<= 8
# asm 1: pslldq $1,<t1dq=int6464#2
# asm 2: pslldq $1,<t1dq=%xmm1
pslldq $1,%xmm1

# qhasm:   cbyte1 >>= 120
# asm 1: psrldq $15,<cbyte1=int6464#5
# asm 2: psrldq $15,<cbyte1=%xmm4
psrldq $15,%xmm4

# qhasm:   carry1 = cbyte1[0]
# asm 1: movq <cbyte1=int6464#5,>carry1=int64#2
# asm 2: movq <cbyte1=%xmm4,>carry1=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte1 = *(uint32 *) (redtable + carry1 * 4)
# asm 1: movd (<redtable=int64#3,<carry1=int64#2,4),>cbyte1=int6464#5
# asm 2: movd (<redtable=%rdx,<carry1=%rsi,4),>cbyte1=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t1dq ^= cbyte1
# asm 1: pxor  <cbyte1=int6464#5,<t1dq=int6464#2
# asm 2: pxor  <cbyte1=%xmm4,<t1dq=%xmm1
pxor  %xmm4,%xmm1

# qhasm:   cbyte2 = t2dq
# asm 1: movdqa <t2dq=int6464#3,>cbyte2=int6464#5
# asm 2: movdqa <t2dq=%xmm2,>cbyte2=%xmm4
movdqa %xmm2,%xmm4

# qhasm:   t2dq <<= 8
# asm 1: pslldq $1,<t2dq=int6464#3
# asm 2: pslldq $1,<t2dq=%xmm2
pslldq $1,%xmm2

# qhasm:   cbyte2 >>= 120
# asm 1: psrldq $15,<cbyte2=int6464#5
# asm 2: psrldq $15,<cbyte2=%xmm4
psrldq $15,%xmm4

# qhasm:   carry2 = cbyte2[0]
# asm 1: movq <cbyte2=int6464#5,>carry2=int64#2
# asm 2: movq <cbyte2=%xmm4,>carry2=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte2 = *(uint32 *) (redtable + carry2 * 4)
# asm 1: movd (<redtable=int64#3,<carry2=int64#2,4),>cbyte2=int6464#5
# asm 2: movd (<redtable=%rdx,<carry2=%rsi,4),>cbyte2=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t2dq ^= cbyte2
# asm 1: pxor  <cbyte2=int6464#5,<t2dq=int6464#3
# asm 2: pxor  <cbyte2=%xmm4,<t2dq=%xmm2
pxor  %xmm4,%xmm2

# qhasm:   cbyte3 = t3dq
# asm 1: movdqa <t3dq=int6464#4,>cbyte3=int6464#5
# asm 2: movdqa <t3dq=%xmm3,>cbyte3=%xmm4
movdqa %xmm3,%xmm4

# qhasm:   t3dq <<= 8
# asm 1: pslldq $1,<t3dq=int6464#4
# asm 2: pslldq $1,<t3dq=%xmm3
pslldq $1,%xmm3

# qhasm:   cbyte3 >>= 120
# asm 1: psrldq $15,<cbyte3=int6464#5
# asm 2: psrldq $15,<cbyte3=%xmm4
psrldq $15,%xmm4

# qhasm:   carry3 = cbyte3[0]
# asm 1: movq <cbyte3=int6464#5,>carry3=int64#2
# asm 2: movq <cbyte3=%xmm4,>carry3=%rsi
movq %xmm4,%rsi

# qhasm:   cbyte3 = *(uint32 *) (redtable + carry3 * 4)
# asm 1: movd (<redtable=int64#3,<carry3=int64#2,4),>cbyte3=int6464#5
# asm 2: movd (<redtable=%rdx,<carry3=%rsi,4),>cbyte3=%xmm4
movd (%rdx,%rsi,4),%xmm4

# qhasm:   t3dq ^= cbyte3
# asm 1: pxor  <cbyte3=int6464#5,<t3dq=int6464#4
# asm 2: pxor  <cbyte3=%xmm4,<t3dq=%xmm3
pxor  %xmm4,%xmm3

# qhasm:   *(int128 *) (gfmtable + 8064) = t0dq
# asm 1: movdqa <t0dq=int6464#1,8064(<gfmtable=int64#1)
# asm 2: movdqa <t0dq=%xmm0,8064(<gfmtable=%rdi)
movdqa %xmm0,8064(%rdi)

# qhasm:   *(int128 *) (gfmtable + 8000) = t1dq
# asm 1: movdqa <t1dq=int6464#2,8000(<gfmtable=int64#1)
# asm 2: movdqa <t1dq=%xmm1,8000(<gfmtable=%rdi)
movdqa %xmm1,8000(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7968) = t2dq
# asm 1: movdqa <t2dq=int6464#3,7968(<gfmtable=int64#1)
# asm 2: movdqa <t2dq=%xmm2,7968(<gfmtable=%rdi)
movdqa %xmm2,7968(%rdi)

# qhasm:   *(int128 *) (gfmtable + 7952) = t3dq
# asm 1: movdqa <t3dq=int6464#4,7952(<gfmtable=int64#1)
# asm 2: movdqa <t3dq=%xmm3,7952(<gfmtable=%rdi)
movdqa %xmm3,7952(%rdi)

# qhasm:   tmp = t0dq
# asm 1: movdqa <t0dq=int6464#1,>tmp=int6464#5
# asm 2: movdqa <t0dq=%xmm0,>tmp=%xmm4
movdqa %xmm0,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8128) = tmp
# asm 1: movdqa <tmp=int6464#5,8128(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8128(<gfmtable=%rdi)
movdqa %xmm4,8128(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8160) = tmp
# asm 1: movdqa <tmp=int6464#5,8160(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8160(<gfmtable=%rdi)
movdqa %xmm4,8160(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8096) = tmp
# asm 1: movdqa <tmp=int6464#5,8096(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8096(<gfmtable=%rdi)
movdqa %xmm4,8096(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8112) = tmp
# asm 1: movdqa <tmp=int6464#5,8112(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8112(<gfmtable=%rdi)
movdqa %xmm4,8112(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8080) = tmp
# asm 1: movdqa <tmp=int6464#5,8080(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8080(<gfmtable=%rdi)
movdqa %xmm4,8080(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8144) = tmp
# asm 1: movdqa <tmp=int6464#5,8144(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8144(<gfmtable=%rdi)
movdqa %xmm4,8144(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8016) = tmp
# asm 1: movdqa <tmp=int6464#5,8016(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8016(<gfmtable=%rdi)
movdqa %xmm4,8016(%rdi)

# qhasm:   tmp ^= t2dq
# asm 1: pxor  <t2dq=int6464#3,<tmp=int6464#5
# asm 2: pxor  <t2dq=%xmm2,<tmp=%xmm4
pxor  %xmm2,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8048) = tmp
# asm 1: movdqa <tmp=int6464#5,8048(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8048(<gfmtable=%rdi)
movdqa %xmm4,8048(%rdi)

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 7984) = tmp
# asm 1: movdqa <tmp=int6464#5,7984(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,7984(<gfmtable=%rdi)
movdqa %xmm4,7984(%rdi)

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   tmp ^= t1dq
# asm 1: pxor  <t1dq=int6464#2,<tmp=int6464#5
# asm 2: pxor  <t1dq=%xmm1,<tmp=%xmm4
pxor  %xmm1,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8032) = tmp
# asm 1: movdqa <tmp=int6464#5,8032(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8032(<gfmtable=%rdi)
movdqa %xmm4,8032(%rdi)

# qhasm:   tmp ^= t0dq
# asm 1: pxor  <t0dq=int6464#1,<tmp=int6464#5
# asm 2: pxor  <t0dq=%xmm0,<tmp=%xmm4
pxor  %xmm0,%xmm4

# qhasm:   tmp ^= t3dq
# asm 1: pxor  <t3dq=int6464#4,<tmp=int6464#5
# asm 2: pxor  <t3dq=%xmm3,<tmp=%xmm4
pxor  %xmm3,%xmm4

# qhasm:   *(int128 *) (gfmtable + 8176) = tmp
# asm 1: movdqa <tmp=int6464#5,8176(<gfmtable=int64#1)
# asm 2: movdqa <tmp=%xmm4,8176(<gfmtable=%rdi)
movdqa %xmm4,8176(%rdi)

# qhasm: emms
emms

# qhasm: r11_caller = r11_stack
# asm 1: movq <r11_stack=stack64#1,>r11_caller=int64#9
# asm 2: movq <r11_stack=0(%rsp),>r11_caller=%r11
movq 0(%rsp),%r11

# qhasm: r12_caller = r12_stack
# asm 1: movq <r12_stack=stack64#2,>r12_caller=int64#10
# asm 2: movq <r12_stack=8(%rsp),>r12_caller=%r12
movq 8(%rsp),%r12

# qhasm: r13_caller = r13_stack
# asm 1: movq <r13_stack=stack64#3,>r13_caller=int64#11
# asm 2: movq <r13_stack=16(%rsp),>r13_caller=%r13
movq 16(%rsp),%r13

# qhasm: r14_caller = r14_stack
# asm 1: movq <r14_stack=stack64#4,>r14_caller=int64#12
# asm 2: movq <r14_stack=24(%rsp),>r14_caller=%r14
movq 24(%rsp),%r14

# qhasm: r15_caller = r15_stack
# asm 1: movq <r15_stack=stack64#5,>r15_caller=int64#13
# asm 2: movq <r15_stack=32(%rsp),>r15_caller=%r15
movq 32(%rsp),%r15

# qhasm: rbx_caller = rbx_stack
# asm 1: movq <rbx_stack=stack64#6,>rbx_caller=int64#14
# asm 2: movq <rbx_stack=40(%rsp),>rbx_caller=%rbx
movq 40(%rsp),%rbx

# qhasm: rbp_caller = rbp_stack
# asm 1: movq <rbp_stack=stack64#7,>rbp_caller=int64#15
# asm 2: movq <rbp_stack=48(%rsp),>rbp_caller=%rbp
movq 48(%rsp),%rbp

# qhasm: leave
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
ret
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
	.section	__TEXT,__text,regular,pure_instructions
	.section	__TEXT,__const
	.globl	_red_table
	.align	4
_red_table:
	.long	0
	.long	49665
	.long	33795
	.long	17922
	.long	2055
	.long	51718
	.long	35844
	.long	19973
	.long	4110
	.long	53775
	.long	37901
	.long	22028
	.long	6153
	.long	55816
	.long	39946
	.long	24075
	.long	8220
	.long	57885
	.long	42015
	.long	26142
	.long	10267
	.long	59930
	.long	44056
	.long	28185
	.long	12306
	.long	61971
	.long	46097
	.long	30224
	.long	14357
	.long	64020
	.long	48150
	.long	32279
	.long	16440
	.long	33337
	.long	50235
	.long	1594
	.long	18495
	.long	35390
	.long	52284
	.long	3645
	.long	20534
	.long	37431
	.long	54325
	.long	5684
	.long	22577
	.long	39472
	.long	56370
	.long	7731
	.long	24612
	.long	41509
	.long	58407
	.long	9766
	.long	26659
	.long	43554
	.long	60448
	.long	11809
	.long	28714
	.long	45611
	.long	62505
	.long	13864
	.long	30765
	.long	47660
	.long	64558
	.long	15919
	.long	32880
	.long	17009
	.long	1139
	.long	50802
	.long	34935
	.long	19062
	.long	3188
	.long	52853
	.long	36990
	.long	21119
	.long	5245
	.long	54908
	.long	39033
	.long	23160
	.long	7290
	.long	56955
	.long	41068
	.long	25197
	.long	9327
	.long	58990
	.long	43115
	.long	27242
	.long	11368
	.long	61033
	.long	45154
	.long	29283
	.long	13409
	.long	63072
	.long	47205
	.long	31332
	.long	15462
	.long	65127
	.long	49224
	.long	585
	.long	17483
	.long	34378
	.long	51279
	.long	2638
	.long	19532
	.long	36429
	.long	53318
	.long	4679
	.long	21573
	.long	38468
	.long	55361
	.long	6720
	.long	23618
	.long	40515
	.long	57428
	.long	8789
	.long	25687
	.long	42582
	.long	59475
	.long	10834
	.long	27728
	.long	44625
	.long	61530
	.long	12891
	.long	29785
	.long	46680
	.long	63581
	.long	14940
	.long	31838
	.long	48735
	.long	225
	.long	49888
	.long	34018
	.long	18147
	.long	2278
	.long	51943
	.long	36069
	.long	20196
	.long	4335
	.long	53998
	.long	38124
	.long	22253
	.long	6376
	.long	56041
	.long	40171
	.long	24298
	.long	8445
	.long	58108
	.long	42238
	.long	26367
	.long	10490
	.long	60155
	.long	44281
	.long	28408
	.long	12531
	.long	62194
	.long	46320
	.long	30449
	.long	14580
	.long	64245
	.long	48375
	.long	32502
	.long	16601
	.long	33496
	.long	50394
	.long	1755
	.long	18654
	.long	35551
	.long	52445
	.long	3804
	.long	20695
	.long	37590
	.long	54484
	.long	5845
	.long	22736
	.long	39633
	.long	56531
	.long	7890
	.long	24773
	.long	41668
	.long	58566
	.long	9927
	.long	26818
	.long	43715
	.long	60609
	.long	11968
	.long	28875
	.long	45770
	.long	62664
	.long	14025
	.long	30924
	.long	47821
	.long	64719
	.long	16078
	.long	32913
	.long	17040
	.long	1170
	.long	50835
	.long	34966
	.long	19095
	.long	3221
	.long	52884
	.long	37023
	.long	21150
	.long	5276
	.long	54941
	.long	39064
	.long	23193
	.long	7323
	.long	56986
	.long	41101
	.long	25228
	.long	9358
	.long	59023
	.long	43146
	.long	27275
	.long	11401
	.long	61064
	.long	45187
	.long	29314
	.long	13440
	.long	63105
	.long	47236
	.long	31365
	.long	15495
	.long	65158
	.long	49321
	.long	680
	.long	17578
	.long	34475
	.long	51374
	.long	2735
	.long	19629
	.long	36524
	.long	53415
	.long	4774
	.long	21668
	.long	38565
	.long	55456
	.long	6817
	.long	23715
	.long	40610
	.long	57525
	.long	8884
	.long	25782
	.long	42679
	.long	59570
	.long	10931
	.long	27825
	.long	44720
	.long	61627
	.long	12986
	.long	29880
	.long	46777
	.long	63676
	.long	15037
	.long	31935
	.long	48830


.subsections_via_symbols

# qhasm: int64 arg1

# qhasm: int64 arg2

# qhasm: int64 arg3

# qhasm: input arg1

# qhasm: input arg2

# qhasm: input arg3

# qhasm: int64 ctx

# qhasm: int64 mac

# qhasm: int64 ey0

# qhasm: int6464 t0dq

# qhasm: int6464 t0dqu

# qhasm: int6464 t0dql

# qhasm: int6464 rh

# qhasm: int6464 rl

# qhasm: int6464 t1dq

# qhasm: int6464 t1dql

# qhasm: int6464 t1dqu

# qhasm: int6464 t2dq

# qhasm: int6464 t2dql

# qhasm: int6464 t2dqu

# qhasm: int6464 t3dq

# qhasm: int6464 t3dql

# qhasm: int6464 t3dqu

# qhasm: int6464 r

# qhasm: int6464 cbyte

# qhasm: int6464 cbyte0

# qhasm: int6464 cbyte1

# qhasm: int6464 cbyte2

# qhasm: int6464 cbyte3

# qhasm: int64 rbyte

# qhasm: int64 rbyte0

# qhasm: int64 rbyte0u

# qhasm: int64 rbyte0l

# qhasm: int64 rbyte1

# qhasm: int64 rbyte1u

# qhasm: int64 rbyte1l

# qhasm: int64 rbyte2

# qhasm: int64 rbyte2u

# qhasm: int64 rbyte2l

# qhasm: int64 rbyte3

# qhasm: int64 rbyte3u

# qhasm: int64 rbyte3l

# qhasm: int64 carry

# qhasm: int64 carry0

# qhasm: int64 carry1

# qhasm: int64 carry2

# qhasm: int64 carry3

# qhasm: int64 len

# qhasm: int64 gfmtable

# qhasm: int64 r11_caller

# qhasm: int64 r12_caller

# qhasm: int64 r13_caller

# qhasm: int64 r14_caller

# qhasm: int64 r15_caller

# qhasm: int64 rbx_caller

# qhasm: int64 rbp_caller

# qhasm: caller r11_caller

# qhasm: caller r12_caller

# qhasm: caller r13_caller

# qhasm: caller r14_caller

# qhasm: caller r15_caller

# qhasm: caller rbx_caller

# qhasm: caller rbp_caller

# qhasm: stack64 r11_caller_stack

# qhasm: stack64 r12_caller_stack

# qhasm: int64 z1u

# qhasm: int64 z1l

# qhasm: int64 z3u

# qhasm: int64 z3l

# qhasm: int64 tmp

# qhasm: int64 mask

# qhasm: enter finalmul
.text
.p2align 5
.globl _finalmul
.globl finalmul
_finalmul:
finalmul:
mov %rsp,%r11
and $31,%r11
add $32,%r11
sub %r11,%rsp

# qhasm: r11_caller_stack = r11_caller
# asm 1: movq <r11_caller=int64#9,>r11_caller_stack=stack64#1
# asm 2: movq <r11_caller=%r11,>r11_caller_stack=0(%rsp)
movq %r11,0(%rsp)

# qhasm: r12_caller_stack = r12_caller
# asm 1: movq <r12_caller=int64#10,>r12_caller_stack=stack64#2
# asm 2: movq <r12_caller=%r12,>r12_caller_stack=8(%rsp)
movq %r12,8(%rsp)

# qhasm: ctx = arg1
# asm 1: mov  <arg1=int64#1,>ctx=int64#1
# asm 2: mov  <arg1=%rdi,>ctx=%rdi
mov  %rdi,%rdi

# qhasm: mac = arg2
# asm 1: mov  <arg2=int64#2,>mac=int64#5
# asm 2: mov  <arg2=%rsi,>mac=%r8
mov  %rsi,%r8

# qhasm: ey0 = arg3
# asm 1: mov  <arg3=int64#3,>ey0=int64#6
# asm 2: mov  <arg3=%rdx,>ey0=%r9
mov  %rdx,%r9

# qhasm: gfmtable = ctx + 1456
# asm 1: lea  1456(<ctx=int64#1),>gfmtable=int64#8
# asm 2: lea  1456(<ctx=%rdi),>gfmtable=%r10
lea  1456(%rdi),%r10

# qhasm: tmp = 0xf0f0f0f0
# asm 1: mov  $0xf0f0f0f0,>tmp=int64#2
# asm 2: mov  $0xf0f0f0f0,>tmp=%rsi
mov  $0xf0f0f0f0,%rsi

# qhasm: mask = tmp
# asm 1: mov  <tmp=int64#2,>mask=int64#9
# asm 2: mov  <tmp=%rsi,>mask=%r11
mov  %rsi,%r11

# qhasm: tmp <<= 32
# asm 1: shl  $32,<tmp=int64#2
# asm 2: shl  $32,<tmp=%rsi
shl  $32,%rsi

# qhasm: mask ^= tmp
# asm 1: xor  <tmp=int64#2,<mask=int64#9
# asm 2: xor  <tmp=%rsi,<mask=%r11
xor  %rsi,%r11

# qhasm: z1u = *(uint64 *)(ctx + 1424)
# asm 1: movq   1424(<ctx=int64#1),>z1u=int64#7
# asm 2: movq   1424(<ctx=%rdi),>z1u=%rax
movq   1424(%rdi),%rax

# qhasm: z3u = *(uint64 *)(ctx + 1432)
# asm 1: movq   1432(<ctx=int64#1),>z3u=int64#3
# asm 2: movq   1432(<ctx=%rdi),>z3u=%rdx
movq   1432(%rdi),%rdx

# qhasm: len = *(uint64 *)(ctx + 1440)
# asm 1: movq   1440(<ctx=int64#1),>len=int64#1
# asm 2: movq   1440(<ctx=%rdi),>len=%rdi
movq   1440(%rdi),%rdi

# qhasm: len -= 16
# asm 1: sub  $16,<len=int64#1
# asm 2: sub  $16,<len=%rdi
sub  $16,%rdi

# qhasm: len <<= 3
# asm 1: shl  $3,<len=int64#1
# asm 2: shl  $3,<len=%rdi
shl  $3,%rdi

# qhasm: (uint64) bswap len
# asm 1: bswap <len=int64#1
# asm 2: bswap <len=%rdi
bswap %rdi

# qhasm: z3u ^= len
# asm 1: xor  <len=int64#1,<z3u=int64#3
# asm 2: xor  <len=%rdi,<z3u=%rdx
xor  %rdi,%rdx

# qhasm:   z3l = z3u
# asm 1: mov  <z3u=int64#3,>z3l=int64#4
# asm 2: mov  <z3u=%rdx,>z3l=%rcx
mov  %rdx,%rcx

# qhasm:   z3u <<= 4
# asm 1: shl  $4,<z3u=int64#3
# asm 2: shl  $4,<z3u=%rdx
shl  $4,%rdx

# qhasm:   z3u &= mask
# asm 1: and  <mask=int64#9,<z3u=int64#3
# asm 2: and  <mask=%r11,<z3u=%rdx
and  %r11,%rdx

# qhasm:   z3l &= mask
# asm 1: and  <mask=int64#9,<z3l=int64#4
# asm 2: and  <mask=%r11,<z3l=%rcx
and  %r11,%rcx

# qhasm:   rbyte0u = z3u & 255
# asm 1: movzbl  <z3u=int64#3b,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%dl,>rbyte0u=%edi
movzbl  %dl,%edi

# qhasm:   rbyte0l = z3l & 255
# asm 1: movzbl  <z3l=int64#4b,>rbyte0l=int64#2d
# asm 2: movzbl  <z3l=%cl,>rbyte0l=%esi
movzbl  %cl,%esi

# qhasm:   t0dql = *(int128 *)(gfmtable + 4096 + rbyte0l)
# asm 1: movdqa 4096(<gfmtable=int64#8,<rbyte0l=int64#2,1),>t0dql=int6464#1
# asm 2: movdqa 4096(<gfmtable=%r10,<rbyte0l=%rsi,1),>t0dql=%xmm0
movdqa 4096(%r10,%rsi,1),%xmm0

# qhasm:   t0dqu = *(int128 *)(gfmtable + 4352 + rbyte0u)
# asm 1: movdqa 4352(<gfmtable=int64#8,<rbyte0u=int64#1,1),>t0dqu=int6464#2
# asm 2: movdqa 4352(<gfmtable=%r10,<rbyte0u=%rdi,1),>t0dqu=%xmm1
movdqa 4352(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z3u >> 8) & 255
# asm 1: movzbl  <z3u=int64#3%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%dh,>rbyte0u=%edi
movzbl  %dh,%edi

# qhasm:   rbyte0l = (z3l >> 8) & 255
# asm 1: movzbl  <z3l=int64#4%next8,>rbyte0l=int64#2d
# asm 2: movzbl  <z3l=%ch,>rbyte0l=%esi
movzbl  %ch,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 4608 + rbyte0l)
# asm 1: pxor 4608(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 4608(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 4608(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 4864 + rbyte0u)
# asm 1: pxor 4864(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 4864(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 4864(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z3u >>= 16
# asm 1: shr  $16,<z3u=int64#3
# asm 2: shr  $16,<z3u=%rdx
shr  $16,%rdx

# qhasm:   (uint64) z3l >>= 16
# asm 1: shr  $16,<z3l=int64#4
# asm 2: shr  $16,<z3l=%rcx
shr  $16,%rcx

# qhasm:   rbyte0u = z3u & 255
# asm 1: movzbl  <z3u=int64#3b,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%dl,>rbyte0u=%edi
movzbl  %dl,%edi

# qhasm:   rbyte0l = z3l & 255
# asm 1: movzbl  <z3l=int64#4b,>rbyte0l=int64#2d
# asm 2: movzbl  <z3l=%cl,>rbyte0l=%esi
movzbl  %cl,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 5120 + rbyte0l)
# asm 1: pxor 5120(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 5120(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 5120(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 5376 + rbyte0u)
# asm 1: pxor 5376(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 5376(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 5376(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z3u >> 8) & 255
# asm 1: movzbl  <z3u=int64#3%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%dh,>rbyte0u=%edi
movzbl  %dh,%edi

# qhasm:   rbyte0l = (z3l >> 8) & 255
# asm 1: movzbl  <z3l=int64#4%next8,>rbyte0l=int64#2d
# asm 2: movzbl  <z3l=%ch,>rbyte0l=%esi
movzbl  %ch,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 5632 + rbyte0l)
# asm 1: pxor 5632(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 5632(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 5632(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 5888 + rbyte0u)
# asm 1: pxor 5888(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 5888(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 5888(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z3u >>= 16
# asm 1: shr  $16,<z3u=int64#3
# asm 2: shr  $16,<z3u=%rdx
shr  $16,%rdx

# qhasm:   (uint64) z3l >>= 16
# asm 1: shr  $16,<z3l=int64#4
# asm 2: shr  $16,<z3l=%rcx
shr  $16,%rcx

# qhasm:   rbyte0u = z3u & 255
# asm 1: movzbl  <z3u=int64#3b,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%dl,>rbyte0u=%edi
movzbl  %dl,%edi

# qhasm:   rbyte0l = z3l & 255
# asm 1: movzbl  <z3l=int64#4b,>rbyte0l=int64#2d
# asm 2: movzbl  <z3l=%cl,>rbyte0l=%esi
movzbl  %cl,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 6144 + rbyte0l)
# asm 1: pxor 6144(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 6144(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 6144(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 6400 + rbyte0u)
# asm 1: pxor 6400(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 6400(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 6400(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z3u >> 8) & 255
# asm 1: movzbl  <z3u=int64#3%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%dh,>rbyte0u=%edi
movzbl  %dh,%edi

# qhasm:   rbyte0l = (z3l >> 8) & 255
# asm 1: movzbl  <z3l=int64#4%next8,>rbyte0l=int64#2d
# asm 2: movzbl  <z3l=%ch,>rbyte0l=%esi
movzbl  %ch,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 6656 + rbyte0l)
# asm 1: pxor 6656(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 6656(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 6656(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 6912 + rbyte0u)
# asm 1: pxor 6912(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 6912(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 6912(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z3u >>= 16
# asm 1: shr  $16,<z3u=int64#3
# asm 2: shr  $16,<z3u=%rdx
shr  $16,%rdx

# qhasm:   (uint64) z3l >>= 16
# asm 1: shr  $16,<z3l=int64#4
# asm 2: shr  $16,<z3l=%rcx
shr  $16,%rcx

# qhasm:   rbyte0u = z3u & 255
# asm 1: movzbl  <z3u=int64#3b,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%dl,>rbyte0u=%edi
movzbl  %dl,%edi

# qhasm:   rbyte0l = z3l & 255
# asm 1: movzbl  <z3l=int64#4b,>rbyte0l=int64#2d
# asm 2: movzbl  <z3l=%cl,>rbyte0l=%esi
movzbl  %cl,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 7168 + rbyte0l)
# asm 1: pxor 7168(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 7168(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 7168(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 7424 + rbyte0u)
# asm 1: pxor 7424(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 7424(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 7424(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z3u >> 8) & 255
# asm 1: movzbl  <z3u=int64#3%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z3u=%dh,>rbyte0u=%edi
movzbl  %dh,%edi

# qhasm:   rbyte0l = (z3l >> 8) & 255
# asm 1: movzbl  <z3l=int64#4%next8,>rbyte0l=int64#2d
# asm 2: movzbl  <z3l=%ch,>rbyte0l=%esi
movzbl  %ch,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 7680 + rbyte0l)
# asm 1: pxor 7680(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 7680(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 7680(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 7936 + rbyte0u)
# asm 1: pxor 7936(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 7936(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 7936(%r10,%rdi,1),%xmm1

# qhasm:   z1l = z1u
# asm 1: mov  <z1u=int64#7,>z1l=int64#3
# asm 2: mov  <z1u=%rax,>z1l=%rdx
mov  %rax,%rdx

# qhasm:   z1u <<= 4
# asm 1: shl  $4,<z1u=int64#7
# asm 2: shl  $4,<z1u=%rax
shl  $4,%rax

# qhasm:   z1u &= mask
# asm 1: and  <mask=int64#9,<z1u=int64#7
# asm 2: and  <mask=%r11,<z1u=%rax
and  %r11,%rax

# qhasm:   z1l &= mask
# asm 1: and  <mask=int64#9,<z1l=int64#3
# asm 2: and  <mask=%r11,<z1l=%rdx
and  %r11,%rdx

# qhasm:   rbyte0u = z1u & 255
# asm 1: movzbl  <z1u=int64#7b,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%al,>rbyte0u=%edi
movzbl  %al,%edi

# qhasm:   rbyte0l = z1l & 255
# asm 1: movzbl  <z1l=int64#3b,>rbyte0l=int64#2d
# asm 2: movzbl  <z1l=%dl,>rbyte0l=%esi
movzbl  %dl,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 0 + rbyte0l)
# asm 1: pxor 0(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 0(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 0(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 256 + rbyte0u)
# asm 1: pxor 256(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 256(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 256(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z1u >> 8) & 255
# asm 1: movzbl  <z1u=int64#7%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%ah,>rbyte0u=%edi
movzbl  %ah,%edi

# qhasm:   rbyte0l = (z1l >> 8) & 255
# asm 1: movzbl  <z1l=int64#3%next8,>rbyte0l=int64#2d
# asm 2: movzbl  <z1l=%dh,>rbyte0l=%esi
movzbl  %dh,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 512 + rbyte0l)
# asm 1: pxor 512(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 512(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 512(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 768 + rbyte0u)
# asm 1: pxor 768(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 768(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 768(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z1u >>= 16
# asm 1: shr  $16,<z1u=int64#7
# asm 2: shr  $16,<z1u=%rax
shr  $16,%rax

# qhasm:   (uint64) z1l >>= 16
# asm 1: shr  $16,<z1l=int64#3
# asm 2: shr  $16,<z1l=%rdx
shr  $16,%rdx

# qhasm:   rbyte0u = z1u & 255
# asm 1: movzbl  <z1u=int64#7b,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%al,>rbyte0u=%edi
movzbl  %al,%edi

# qhasm:   rbyte0l = z1l & 255
# asm 1: movzbl  <z1l=int64#3b,>rbyte0l=int64#2d
# asm 2: movzbl  <z1l=%dl,>rbyte0l=%esi
movzbl  %dl,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 1024 + rbyte0l)
# asm 1: pxor 1024(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 1024(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 1024(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 1280 + rbyte0u)
# asm 1: pxor 1280(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 1280(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 1280(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z1u >> 8) & 255
# asm 1: movzbl  <z1u=int64#7%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%ah,>rbyte0u=%edi
movzbl  %ah,%edi

# qhasm:   rbyte0l = (z1l >> 8) & 255
# asm 1: movzbl  <z1l=int64#3%next8,>rbyte0l=int64#2d
# asm 2: movzbl  <z1l=%dh,>rbyte0l=%esi
movzbl  %dh,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 1536 + rbyte0l)
# asm 1: pxor 1536(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 1536(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 1536(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 1792 + rbyte0u)
# asm 1: pxor 1792(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 1792(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 1792(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z1u >>= 16
# asm 1: shr  $16,<z1u=int64#7
# asm 2: shr  $16,<z1u=%rax
shr  $16,%rax

# qhasm:   (uint64) z1l >>= 16
# asm 1: shr  $16,<z1l=int64#3
# asm 2: shr  $16,<z1l=%rdx
shr  $16,%rdx

# qhasm:   rbyte0u = z1u & 255
# asm 1: movzbl  <z1u=int64#7b,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%al,>rbyte0u=%edi
movzbl  %al,%edi

# qhasm:   rbyte0l = z1l & 255
# asm 1: movzbl  <z1l=int64#3b,>rbyte0l=int64#2d
# asm 2: movzbl  <z1l=%dl,>rbyte0l=%esi
movzbl  %dl,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 2048 + rbyte0l)
# asm 1: pxor 2048(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 2048(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 2048(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 2304 + rbyte0u)
# asm 1: pxor 2304(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 2304(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 2304(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z1u >> 8) & 255
# asm 1: movzbl  <z1u=int64#7%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%ah,>rbyte0u=%edi
movzbl  %ah,%edi

# qhasm:   rbyte0l = (z1l >> 8) & 255
# asm 1: movzbl  <z1l=int64#3%next8,>rbyte0l=int64#2d
# asm 2: movzbl  <z1l=%dh,>rbyte0l=%esi
movzbl  %dh,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 2560 + rbyte0l)
# asm 1: pxor 2560(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 2560(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 2560(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 2816 + rbyte0u)
# asm 1: pxor 2816(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 2816(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 2816(%r10,%rdi,1),%xmm1

# qhasm:   (uint64) z1u >>= 16
# asm 1: shr  $16,<z1u=int64#7
# asm 2: shr  $16,<z1u=%rax
shr  $16,%rax

# qhasm:   (uint64) z1l >>= 16
# asm 1: shr  $16,<z1l=int64#3
# asm 2: shr  $16,<z1l=%rdx
shr  $16,%rdx

# qhasm:   rbyte0u = z1u & 255
# asm 1: movzbl  <z1u=int64#7b,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%al,>rbyte0u=%edi
movzbl  %al,%edi

# qhasm:   rbyte0l = z1l & 255
# asm 1: movzbl  <z1l=int64#3b,>rbyte0l=int64#2d
# asm 2: movzbl  <z1l=%dl,>rbyte0l=%esi
movzbl  %dl,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 3072 + rbyte0l)
# asm 1: pxor 3072(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 3072(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 3072(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 3328 + rbyte0u)
# asm 1: pxor 3328(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 3328(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 3328(%r10,%rdi,1),%xmm1

# qhasm:   rbyte0u = (z1u >> 8) & 255
# asm 1: movzbl  <z1u=int64#7%next8,>rbyte0u=int64#1d
# asm 2: movzbl  <z1u=%ah,>rbyte0u=%edi
movzbl  %ah,%edi

# qhasm:   rbyte0l = (z1l >> 8) & 255
# asm 1: movzbl  <z1l=int64#3%next8,>rbyte0l=int64#2d
# asm 2: movzbl  <z1l=%dh,>rbyte0l=%esi
movzbl  %dh,%esi

# qhasm:   uint32323232 t0dql ^= *(int128 *)(gfmtable + 3584 + rbyte0l)
# asm 1: pxor 3584(<gfmtable=int64#8,<rbyte0l=int64#2,1),<t0dql=int6464#1
# asm 2: pxor 3584(<gfmtable=%r10,<rbyte0l=%rsi,1),<t0dql=%xmm0
pxor 3584(%r10,%rsi,1),%xmm0

# qhasm:   uint32323232 t0dqu ^= *(int128 *)(gfmtable + 3840 + rbyte0u)
# asm 1: pxor 3840(<gfmtable=int64#8,<rbyte0u=int64#1,1),<t0dqu=int6464#2
# asm 2: pxor 3840(<gfmtable=%r10,<rbyte0u=%rdi,1),<t0dqu=%xmm1
pxor 3840(%r10,%rdi,1),%xmm1

# qhasm:   t0dql ^= t0dqu
# asm 1: pxor  <t0dqu=int6464#2,<t0dql=int6464#1
# asm 2: pxor  <t0dqu=%xmm1,<t0dql=%xmm0
pxor  %xmm1,%xmm0

# qhasm: uint32323232 t0dql ^= *(int128 *) (ey0 + 0)
# asm 1: pxor 0(<ey0=int64#6),<t0dql=int6464#1
# asm 2: pxor 0(<ey0=%r9),<t0dql=%xmm0
pxor 0(%r9),%xmm0

# qhasm: *(int128 *)(mac + 0) = t0dql
# asm 1: movdqa <t0dql=int6464#1,0(<mac=int64#5)
# asm 2: movdqa <t0dql=%xmm0,0(<mac=%r8)
movdqa %xmm0,0(%r8)

# qhasm: r11_caller = r11_caller_stack
# asm 1: movq <r11_caller_stack=stack64#1,>r11_caller=int64#9
# asm 2: movq <r11_caller_stack=0(%rsp),>r11_caller=%r11
movq 0(%rsp),%r11

# qhasm: r12_caller = r12_caller_stack
# asm 1: movq <r12_caller_stack=stack64#2,>r12_caller=int64#10
# asm 2: movq <r12_caller_stack=8(%rsp),>r12_caller=%r12
movq 8(%rsp),%r12

# qhasm: leave
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
ret
