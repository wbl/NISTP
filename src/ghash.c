#include "garith.h"
#include "ghash.h"
void ginit(ghash_ctx *ctx, unsigned char *h){
  gf2128unpack(&ctx->h, h);
  gf2128zero(&ctx->x);
}

void gupdate(ghash_ctx *ctx, unsigned char *block){
  gf2128 temp;
  gf2128unpack(&temp, block);
  gf2128add(&ctx->x,&ctx->x, &temp);
  gf2128mul(&ctx->x, &ctx->x, &ctx->h);
}

void gfinal(unsigned char *tag, ghash_ctx *ctx){
  gf2128pack(tag, &ctx->x);
}
