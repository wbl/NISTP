
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
