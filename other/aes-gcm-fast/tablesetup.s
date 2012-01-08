
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
