typedef struct { /*Right first, fast later*/
  unsigned char h[128];
  unsigned char x[128];
} ghash_ctx;
extern void ginit(ghash_ctx *ctx, unsigned char *h);
extern void gupdate(ghash_ctx *ctx, unsigned char *block);
extern void gfinal(unsigned char *tag, ghash_ctx *ctx);
