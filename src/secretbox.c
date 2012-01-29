#include "secretbox.h"
#include "aes256gcm.h"
#include <strings.h>
void crypto_secretbox_aes256gcm (unsigned char *c, unsigned char *m,
                                 unsigned long long mlen, unsigned char *n,
                                 unsigned char *k){
  unsigned char j0[16];
  j0[0]='U';
  j0[1]='o';
  j0[2]='f';
  j0[3]='C';
  memcpy(j0+4, n,12);
  aes256gcmcrypt(c, m, mlen, n, k);
}

int crypto_secretbox_aes256gcm_open(unsigned char *m, unsigned char *c,
                                     unsigned long long clen,
                                     unsigned char *n,
                                     unsigned char *k){
  unsigned char j0[16];
  j0[0]='U';
  j0[1]='o';
  j0[2]='f';
  j0[3]='C';
  memcpy(j0+4, n,12);
  return aes256gcmdecrypt(m,c, clen, n, k);
}
