#include <strings.h>
#include "box.h"
#include "scalarmult.h"
#include "secretbox.h"
#include "randombytes.h"

void crypto_box_nistp256aes256gcm_keypair(unsigned char *pk, unsigned char
                                          *sk){
  randombytes(sk, 32); //provided by client.
  crypto_scalarmult_nistp256_base(pk, sk);
  return;
}

void crypto_box_nistp256aes256gcm_beforenm(unsigned char *k, unsigned char *pk,
                                          unsigned char *sk){
  unsigned char temp[64];
  crypto_scalarmult_nistp256(temp, sk, pk);
  memcpy(k, temp, 32); //Magic: copies just x coordinate
}

void crypto_box_nistp256aes256gcm_afternm(unsigned char *c, unsigned char *m,
                                          unsigned long long mlen, unsigned
                                          char *n, unsigned char *k){
  crypto_secretbox_aes256gcm(c, m, mlen, n, k);
}

int crypto_box_nistp256aes256gcm_open_afternm(unsigned char *m,
                                              unsigned char *c,
                                              unsigned long long clen,
                                              unsigned char *n,
                                              unsigned char *k){
  return crypto_secretbox_aes256gcm_open(m, c, clen, n, k);
}

void crypto_box_nistp256aes256gcm(unsigned char *c, unsigned char *m,
                                  unsigned long long mlen, unsigned char *n,
                                  unsigned char *pk, unsigned char *sk){
  unsigned char k[32];
  crypto_box_nistp256aes256gcm_beforenm(k, pk, sk);
  crypto_box_nistp256aes256gcm_afternm(c, m, mlen, n, k);
}

int crypto_box_nistp256aes256gcm_open(unsigned char *m, unsigned char *c,
                                      unsigned long long clen,
                                      unsigned char *n,
                                      unsigned char *pk, unsigned char *sk){
  unsigned char k[32];
  crypto_box_nistp256aes256gcm_beforenm(k, pk, sk);
  return crypto_box_nistp256aes256gcm_open_afternm(m, c, clen, n, k);
}
