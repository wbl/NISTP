extern void crypto_sign_ecdsa256sha512(unsigned char *sm,
                                       unsigned long long *smlen,
                                       const unsigned char *m,
                                       unsigned long long mlen,
                                       const unsigned char *sk);
extern int crypto_sign_open_ecdsa256sha512(unsigned char *m,
                                           unsigned long long *mlen,
                                           const unsigned char *sm,
                                           unsigned long long smlen,
                                           const unsigned char *pk);
extern void crypto_sign_keypair_ecdsa256sha512(unsigned char *pk,
                                               unsigned char *sk);

#define crypto_sign_ecdsa256sha512_BYTES 64
#define crypto_sign_ecdsa256sha512_PUBLICKEYBYTES 64
#define crypto_sign_ecdsa256sha512_SECRETKEYBYTES 64
