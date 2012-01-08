#include "ghash.h"
#include "load64.h"
#include "unload64.h"
void ginit(ghash_ctx *ctx, unsigned char *h){
  unsigned long long hhi=load64(h);
  unsigned long long hlo=load64(h+8);
  for(int i=0; i<128; i++){
    ctx->hplo[i]=hlo;
    ctx->hphi[i]=hhi;
    unsigned long long carry= hhi & 0x0000000000000001ULL;
    carry = carry<<63;
    hhi=hhi>>1;
    unsigned long long lowbit = hlo & 0x0000000000000001ULL;
    hlo=carry|(hlo>>1);
    /*now to do the reduction*/
    unsigned long R = 0xe100000000000000ULL;
    hhi ^= lowbit*R;
  }
  ctx->xlo=0;
  ctx->xhi=0;
  return;
}

void gupdate(ghash_ctx *ctx, unsigned char *block){
  unsigned long long blo=load64(block);
  unsigned long long bhi=load64(block);
  unsigned long long mask = 1;
  for(int i=0; i<64; i++){ /*The low half*/
    ctx->xlo ^=(mask&blo)*ctx->hplo[i];
    ctx->xhi ^= (mask&blo)*ctx->hphi[i];
    blo = blo >>2;
  }
  for(int i=64; i<128; i++){ /*The high half*/
    ctx->xlo ^=(mask&bhi)*ctx->hplo[i];
    ctx->xhi ^= (mask&bhi)*ctx->hphi[i];
    bhi = bhi >>2;
  }
  /*No need to reduce: why not? Because reduction is GF(2) linear*/
  return;
}

void gfinal(unsigned char *tag, ghash_ctx *ctx){
  unload64(tag,ctx->xhi);
  unload64(tag+8,ctx->xlo);
  return;
}
