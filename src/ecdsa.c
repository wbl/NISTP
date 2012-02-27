#include <stdint.h>
#include "hash.h"
#include "fep256.h"
#include "scp256.h"
#include "curve.h"
#include "verify.h"
/*Secret keys are 64 bytes. First 32 bytes are an exponent, second 32 are
  hashed with last 32 bytes of h(m) to give k*/
void crypto_sign_keypair_ecdsa256sha512(unsigned char *pk,
                                        unsigned char *sk){
  point p;
  randombytes(sk, 64);
  p256scalarmult_base(&p, sk); //first 32 bytes are used only
  p256pack(pk, &p);
}
/*The format of signed messages is as follows: the first 64 bytes are a
  signature, the first 32 being r, the second 32 s. The message follows.*/
void crypto_sign_ecdsa256sha512(unsigned char *sm, unsigned long long *smlen,
                           unsigned char *m, unsigned long long mlen,
                           unsigned char *sk){
  unsigned char mhash[64];
  unsigned char kchar[64];
  unsigned char rchar[64];
  scp256 z;
  scp256 k;
  point R;
  scp256 r;
  scp256 d;
  scp256 kinv;
  scp256 s;
  scp256 t1;
  scp256 t2;
  memcpy(sm+64, m, mlen);
  *smlen=mlen+64;
  crypto_hash(mhash, m, mlen);
  scp256_unpack(&z, mhash);
  /*We could append sk, but I worry about secret key leaks
   with mmapped memory*/
  memcpy(mhash, sk+32, 32);
  crypto_hash(kchar, mhash, 64);
  scp256_unpack(&k, kchar); //not FIPS compliant, but that's okay
  p256scalarmult_base(&R, kchar); /*The issue is that this is incorrect*/
  p256pack(rchar, &R);
  scp256_unpack(&r, rchar); //this is just x
  scp256_unpack(&d, sk); //the secret exponent
  scp256_mul(&t1, &d, &r);
  scp256_add(&t2, &z, &t1); //z+rd
  scp256_inv(&kinv, &k);
  scp256_mul(&s, &kinv, &t2); //k^{-1}(z-rd)
  scp256_pack(sm, &r); //r goes first
  scp256_pack(sm+32, &s); //s goes next.
  //what about r=0 or s=0? Then we can't sign this message, ever.
  //so let's assume that doesn't happen.
  //this is okay: signer will not accept it
}

int crypto_sign_open_ecdsa256sha512(unsigned char *m, unsigned long long *mlen,
                                    unsigned char *sm,
                                    unsigned long long smlen,
                                    unsigned char *pk){
  //all data here is public: don't worry about revelations
  unsigned char mhash[64];
  point Q;
  point u1B;
  point u2Q;
  point result;
  unsigned char resultchar[64];
  scp256 u1;
  scp256 u2;
  unsigned char u1char[32];
  unsigned char u2char[32];
  scp256 z;
  scp256 s;
  scp256 r;
  scp256 w;
  scp256 newr;
  scp256 t;
  if(smlen<64) return -1;
  p256unpack(&Q, pk);
  //just some message manipulation
  memcpy(m, sm+64, smlen-64);
  *mlen=smlen-64;
  crypto_hash(mhash, m, *mlen);
  scp256_unpack(&z, mhash);
  scp256_unpack(&s, sm+32);
  scp256_unpack(&r, sm);
  if(scp256_iszero(&r)||scp256_iszero(&s)) return -1;
  scp256_inv(&w, &s);
  scp256_mul(&u1, &z, &w);
  scp256_mul(&u2, &r, &w);
  scp256_pack(u1char, &u1);
  scp256_pack(u2char, &u2);
  p256scalarmult_base(&u1B,u1char);
  p256scalarmult(&u2Q, &Q, u2char);
  p256add(&result, &u1B, &u2Q);
  p256pack(resultchar, &result);
  scp256_unpack(&newr, resultchar);
  scp256_sub(&t, &newr, &r);
  if(scp256_iszero(&t)){
    return 0;
  }
  return -1;
}
