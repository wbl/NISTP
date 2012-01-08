typedef struct { /*Our strategy is to use precomputed tables*/
  unsigned long long hplo[128];
  unsigned long long hphi[128];
  unsigned long long xlo;
  unsigned long long xhi;
} ghash_ctx;
extern void ginit(ghash_ctx *ctx, unsigned char *h);
extern void gupdate(ghash_ctx *ctx, unsigned char *block);
extern void gfinal(unsigned char *tag, ghash_ctx *ctx);
