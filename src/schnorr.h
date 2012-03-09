extern void crypto_sign_keypair_nistp256schnorr(unsigned char *pk,
                                                 unsigned char *sk);
extern void crypto_sign_nistp256schnorr(unsigned char *sm,
                                         unsigned long long *smlen,
                                         const unsigned char *m,
                                         unsigned long long mlen,
                                         const unsigned char *sk);
extern int crypto_sign_open_nistp256schnorr(unsigned char *m,
                                             unsigned long long *mlen,
                                             const unsigned char *sm,
                                             unsigned long long smlen,
                                             const unsigned char *pk);
#define crypto_sign_nistp256schnorr_BYTES 64
#define crypto_sign_nistp256schnorr_PUBLICKEYBYTES 64
#define crypto_sign_nistp256schnorr_SECRETKEYBYTES 64
