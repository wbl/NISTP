typedef __uint128_t uint128_t;
typedef struct {
  uint128_t c[4];
} fep256;

extern void fep256add(fep256 *c, fep256 *a, fep256 *b);
extern void fep256sub(fep256 *c, fep256 *a, fep256 *b);
extern void fep256mul(fep256 *c, fep256 *a, fep256 *b);
extern void fep256sqr(fep256 *c, fep256 *a);
extern void fep256inv(fep256 *c, fep256 *a);

extern void fep256setzero(fep256 *r);
extern void fep256setone(fep256 *r);
extern int fep246iszero(fep256 *a);

extern void fep256cmov (fep256 *r, fep256 *x, int b);

extern void fep256pack(unsigned char c[32], fep256 *r);
extern void fep256unpack(fep256 *r, unsigned char c[32]);

