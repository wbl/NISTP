
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
