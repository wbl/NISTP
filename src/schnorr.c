#include <stdint.h>
#include <strings.h>
#include "fep256.h"
#include "curve.h"
#include "scp256.h"
#include "hash.h"
#include "randombytes.h"
#include "verify.h"

void crypto_sign_keypair_nistp256schnorr(unsigned char *pk, unsigned char *sk){
  point p;
  randombytes(sk, 64); //additional 32 bytes of entropy
  p256scalarmult_base(&p, sk); //first 32 bytes are used only
  p256pack(pk, &p);
}

void crypto_sign_nistp256schnorr(unsigned char *sm,
                                 unsigned long long *smlen,
                                 const unsigned char *m,
                                 unsigned long long mlen,
                                 const unsigned char *sk){
  point r;
  scp256 k;
  scp256 e;
  scp256 x;
  scp256 s;
  scp256 t;
  unsigned char hash[64];
  unsigned char temp[64];
  unsigned char kchar[32];
  *smlen=mlen+64;
  memcpy(sm+32, m, mlen);
  memcpy(sm+mlen+32, sk+32, 32); //copy the tail entropy over
  crypto_hash(hash, sm+32, mlen+32);//hash message plus tail
  scp256_from64bytes(&k, hash);
  scp256_pack(kchar, &k);
  p256scalarmult_base(&r, kchar);
  p256pack(temp, &r); //put r at end of message
  memcpy(sm+mlen+32, temp, 32);
  scp256_unpack(&x, sk);
  crypto_hash(hash, sm+32, mlen+32); //calculate e=h(m, r)
  scp256_unpack(&e, hash); //first 32 bytes as per usual
  scp256_mul(&t, &e, &x);
  scp256_sub(&s, &k, &t);
  scp256_pack(sm, &s); //put s at start of message
}

int crypto_sign_open_nistp256schnorr(unsigned char *m,
                                     unsigned long long *mlen,
                                     const unsigned char *sm,
                                     unsigned long long smlen,
                                     const unsigned char *pk){
  point gs;
  point ye;
  point y;
  point rsig;
  unsigned char hash[64];
  unsigned char rv[64];
  if(smlen<64) return -1;
  *mlen=smlen-64;
  memcpy(m, sm+32, smlen-64); //copy out message
  crypto_hash(hash, sm+32, smlen-32); //H(M||r)
  p256unpack(&y, pk);
  p256scalarmult(&ye, &y, hash); //calculate ye
  p256scalarmult_base(&gs, sm); //calculate gs
  p256add(&rsig, &ye, &gs);
  p256pack(rv, &rsig);
  return verify32(sm+smlen-32, rv);
}
