#include <stdio.h>
#include <strings.h>
#include "garith.h"
#include "ghash.h"
#include "unload64.h"
typedef struct { /*Right first, fast later*/
  gf2128 h;
  gf2128 x;
} ghash_ctx;

static void ginit(ghash_ctx *ctx, unsigned char *h){
  gf2128unpack(&ctx->h, h);
  gf2128zero(&ctx->x);
}

static void gupdate(ghash_ctx *ctx, unsigned char *block){
  gf2128 temp;
  gf2128unpack(&temp, block);
  gf2128add(&ctx->x,&ctx->x, &temp);
  gf2128mul(&ctx->x, &ctx->x, &ctx->h);
}

static void gfinal(unsigned char *tag, ghash_ctx *ctx){
  gf2128pack(tag, &ctx->x);
  gf2128zero(&ctx->h); //remove secret data from memory.
}
void crypto_ghash(unsigned char *tag, unsigned char *m, unsigned long
           long mlen, unsigned char *h, unsigned char *otk){
  ghash_ctx ctx;
  unsigned long long place;
  unsigned char lastblock[16];
  unsigned char lenblock[16];
  bzero(lastblock, 16);
  ginit(&ctx, h);
  /*Now the loop: feed in the ciphertext*/
  for(place=0; place+15<mlen; place+=16){
    gupdate(&ctx, m+place);
  }
  if(place<mlen){
    for(unsigned long long i=place; i<mlen; i++) //only up to 16
      lastblock[i-place]=m[i];
    gupdate(&ctx, lastblock);
  }
  unload64(lenblock, 0);
  unload64(lenblock+8, 8*mlen); //no associated data
  gupdate(&ctx, lenblock);
  gfinal(tag, &ctx);
  /*encrypt tag*/
  for(int i=0; i<16; i++){
    tag[i]^=otk[i];
  }
  return;
}
