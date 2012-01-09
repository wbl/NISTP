#include<strings.h>
#include "ctr.h"
#include "aes.h"
#include "ghash.h"
#include "aes256gcm.h"
#include "unload64.h"
#include "load64.h"
/*This function uses 12 byte nonces. This is for validation: the real
  functions have yet to be written*/
void aes256gcmcrypt(unsigned char *c, unsigned char *m,
                                unsigned long long mlen,
                                unsigned char *nonce,
                                unsigned char *key){
  unsigned char zeros[16];
  unsigned char h[16];
  unsigned int  space[AES_STATEINTS];
  unsigned char j0[16];
  ghash_ctx ctx;
  unsigned long long place;
  unsigned char lastblock[16];
  unsigned char lenblock[16];
  unsigned char tag[16];
  memcpy(j0, nonce, 12);
  j0[12]=0;
  j0[13]=0;
  j0[14]=0;
  j0[15]=1;
  for(int i=0; i<16; i++){
    zeros[i]=0;
  }
  /*A cheap trick: encrypting the first all zero block of m gives us the
    AES(j0) value we need. This is worth it a lot of the time due to counter
    mode potentially being very fast. But first we need H*/
  aeskey(space, key);
  aescrypt(h, zeros, space);
  /*I ought to have aes_ctr take space: no point in redundent scheduling*/
  aes256ctr(c,m,mlen, key, j0);
  /*At this point the first 16 bytes of c are AES(k, j0). The rest are
    the ciphertext.*/
  for(int i=0; i<16; i++)
    lastblock[i]=0;
  ginit(&ctx, h);
  /*Now the loop: feed in the ciphertext*/
  for(place=16; place<mlen; place+=16)
    gupdate(&ctx, c+place);
  if(place<mlen){
    for(int i=place; i<mlen; i++) //only up to 16
      lastblock[i]=c[i];
    gupdate(&ctx, lastblock);
  }
  unload64(lenblock, 0);
  unload64(lenblock+8, mlen-16); //no associated data
  gupdate(&ctx, lenblock);
  gfinal(tag, &ctx);
  /*add encrypted tag to message*/
  for(int i=0; i<16; i++){
    c[i]^=tag[i];
  }
  return;
}
