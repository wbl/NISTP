.ifndef COMMON_GCM_S
COMMON_GCM_S:

.macro setH i, a, t0, t1, m, o

movdqa 	\i, \t0
pand	\m, \t0
pcmpeqd	\m, \t0

# bit b
pshufd $0xff, \t0, \t1
pand   (\a), \t1
pxor	\t1, \o		 

#bit b+32
pshufd $0xaa, \t0, \t1
pand   512(\a), \t1
pxor	\t1, \o	

#bit b+64
pshufd $0x55, \t0, \t1
pand   1024(\a), \t1
pxor	\t1, \o	

#bit b+96
pshufd $0x00, \t0, \t1
pand   1536(\a), \t1
pxor	\t1, \o	
.endm

.macro Mul_X x, t0, t1

# painful shift right by 1 bit

movdqa 	\x, \t0
movdqa	\x, \t1
pand	BIT063, \t0
pand	BIT127, \t1
psrlq	$1, \x
pcmpeqd	BIT063, \t0
pcmpeqd	BIT127, \t1
pshufd	$0xaa, \t0, \t0
pshufd	$0x00, \t1, \t1
pand	BIT064, \t0
pand	GCMPOL, \t1
pxor	\t0, \x 
pxor	\t1, \x

.endm

.macro Mul_H i, a, t0, t1, o

setH	\i, \a, \t0, \t1, BM00, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM01, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM02, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM03, \o
addq	$16, \a

setH	\i, \a, \t0, \t1, BM04, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM05, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM06, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM07, \o
addq	$16, \a

setH	\i, \a, \t0, \t1, BM08, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM09, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM10, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM11, \o
addq	$16, \a

setH	\i, \a, \t0, \t1, BM12, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM13, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM14, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM15, \o
addq	$16, \a

setH	\i, \a, \t0, \t1, BM16, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM17, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM18, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM19, \o
addq	$16, \a

setH	\i, \a, \t0, \t1, BM20, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM21, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM22, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM23, \o
addq	$16, \a

setH	\i, \a, \t0, \t1, BM24, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM25, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM26, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM27, \o
addq	$16, \a

setH	\i, \a, \t0, \t1, BM28, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM29, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM30, \o
addq	$16, \a
setH	\i, \a, \t0, \t1, BM31, \o

.endm

.endif


