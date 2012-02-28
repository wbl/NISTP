#include<strings.h>
#include <stdio.h> //debugging
#include "ctr.h"
#include "aes.h"
#include "garith.h"
#include "ghash.h"
#include "aes256gcm.h"
#include "unload64.h"
#include "load64.h"
#include "verify.h"
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
  unsigned char tag[16];
  bzero(zeros, 16);
  memcpy(j0, nonce, 12);
  j0[12]=0;
  j0[13]=0;
  j0[14]=0;
  j0[15]=1;  
  /*A cheap trick: encrypting the first all zero block of m gives us the
    AES(j0) value we need. This is worth it a lot of the time due to counter
    mode potentially being very fast. But first we need H*/
  aeskey(space, key);
  aescrypt(h, zeros, space);
  for(int i=0; i<AES_STATEINTS; i++){
    space[i]=0; //zeroize secret data.
  }
  /*I ought to have aes_ctr take space: no point in redundent scheduling*/
  aes256ctr(c,m,mlen, key, j0);
  /*At this point the first 16 bytes of c are AES(k, j0). The rest are
    the ciphertext.*/
  crypto_ghash(tag,c+16,mlen-16,h,c);
  memcpy(c, tag, 16);
  for(int i=0; i<16; i++){
    h[i]=0; //zeroizing secret data
  }
  return;
}

extern int aes256gcmdecrypt(unsigned char *m, unsigned char *c,
                            unsigned long long clen, unsigned char *nonce,
                            unsigned char *key){
  //We are permitted to branch on success, but that must take constant time.
  //Much of this code similar to above. TODO: factor out similar code. 
  unsigned char zeros[16];
  unsigned char h[16];
  unsigned int  space[AES_STATEINTS];
  unsigned char j0[16];
  unsigned char tagkey[16];
  unsigned char tag[16];
  if(clen<16) return -1;
  bzero(zeros, 16);
  memcpy(j0, nonce, 12);
  j0[12]=0;
  j0[13]=0;
  j0[14]=0;
  j0[15]=1;
  aeskey(space, key);
  aescrypt(h, zeros, space);
  aescrypt(tagkey, j0, space);
  crypto_ghash(tag, c+16, clen-16, h, tagkey);
  if(verify16(tag, c)){
    bzero(h, 16);
    for(int i=0; i<AES_STATEINTS; i++){
      space[i]=0;
    }
    return -1;
  }
  aes256ctr(m, c, clen, key, j0);
  bzero(m, 16); //cleanup;
  bzero(h, 16); //zeroizing secret data;
  for(int i=0; i<AES_STATEINTS; i++){
    space[i]=0;
  }
  return 0;
}
