/*In plan-9 style .h never has inclusions in it */
typedef struct { /*Right first, fast later*/
  gf2128 h;
  gf2128 x;
} ghash_ctx;
extern void ginit(ghash_ctx *ctx, unsigned char *h);
extern void gupdate(ghash_ctx *ctx, unsigned char *block);
extern void gfinal(unsigned char *tag, ghash_ctx *ctx);
