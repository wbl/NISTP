extern void crypto_sign_ecdsa256sha512(unsigned char *sm,
                                       unsigned long long *smlen,
                                       unsigned char *m,
                                       unsigned long long mlen,
                                       unsigned char *sk);
extern int crypto_sign_open_ecdsa256sha512(unsigned char *m,
                                           unsigned long long *mlen,
                                           unsigned char *sm,
                                           unsigned long long smlen,
                                           unsigned char *pk);
extern void crypto_sign_keypair(unsigned char *pk, unsigned char *sk);

#define crypto_sign_BYTES 64
#define crypto_sign_PUBLICKEYBYTES 64
#define crypto_sign_SECRETKEYBYTES 64
