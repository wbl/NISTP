#include <tomcrypt.h>
#include <strings.h>
#include "aes256gcmtom.h"
#include "ctr.h"
void aes256gcmtomcrypt(unsigned char *c, unsigned char *m,
                    unsigned long long mlen, unsigned char *nonce,
                    unsigned char *key){
  /*Using libtomcrypt as alternative gives us way to check implementation*/
  register_cipher(&aes_desc);
  unsigned char tag[16];
  unsigned long taglen=16;
  unsigned char decryptag[16];
  unsigned char j0[16];
  memcpy(j0, nonce, 12);
  j0[12]=0;
  j0[13]=0;
  j0[14]=0;
  j0[15]=1;
  gcm_memory(find_cipher("aes"), key, 32, nonce, 12, 0, 0, m+16, mlen-16,
             c+16, tag, &taglen ,GCM_ENCRYPT);
  memcpy(c, tag, 16);
}
