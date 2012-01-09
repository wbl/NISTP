typedef struct {
  unsigned char c[128];
} gf2128;
extern void gf2128add(gf2128 *c, gf2128 *a, gf2128 *b);
extern void gf2128mul(gf2128 *c, gf2128 *a, gf2128 *b);
extern void gf2128unpack(gf2128 *c, unsigned char *block);
extern void gf2128pack(unsigned char *dest, gf2128 *c);
extern void gf2128packcoeffs(unsigned char *dest, gf2128 *c);
extern void gf2128loadcoeffs(gf2128 *c, unsigned char *src);
extern void gf2128zero(gf2128 *c);
