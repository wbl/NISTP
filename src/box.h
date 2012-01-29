extern void crypto_box_nistp256aes256gcm(unsigned char *c, unsigned char *m,
                                unsigned long long mlen, unsigned char *n,
                                unsigned char *pk, unsigned char *sk);

extern int crypto_box_nistp256aes256gcm_open(unsigned char *m,
                                              unsigned char *c,
                                              unsigned long long mlen,
                                              unsigned char *n,
                                     unsigned char *pk, unsigned char *sk);

extern void crypto_box_nistp256aes256gcm_befornm(unsigned char *k,
                                                 unsigned char *pk,
                                                 unsigned char *sk);

extern void crypto_box_nistp256aes256gcm_afternm(unsigned char *c,
                                                 unsigned char *m,
                                                 unsigned long long mlen,
                                                 unsigned char *n,
                                                 unsigned char *k);

extern int crypto_box_nistp256aes256gcm_open_afternm(unsigned char *m,
                                                     unsigned char *c,
                                                     unsigned long long clen,
                                                     unsigned char *n,
                                                     unsigned char *k);

extern void crypto_box_nistp256aes256gcm_keypair(unsigned char *pk,
                                                 unsigned char *sk);

#define crypto_box_nistp256aes256gcm_BEFORENMBYTES 32
#define crypto_box_nistp256aes256gcm_NONCEBYTES 8
#define crypto_box_nistp256aes256gcm_PUBLICKEYBYTES 64
#define crypto_box_nistp256aes256gcm_SECRETKEYBYTES 32
#define crypto_box_nistp256aes256gcm_ZEROBYTES 16
#define crypto_box_nistp256aes256gcm_BOXZEROBYTES 0
