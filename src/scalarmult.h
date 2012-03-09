#define crypto_scalarmult_nistp256BYTES 64
#define crypto_scalarmult_nistp256SCALARBYTES 32
extern void crypto_scalarmult_nistp256(unsigned char *q,
                                       const unsigned char *n,
                                       const unsigned char *p);
extern void crypto_scalarmult_nistp256_base(unsigned char *q,
                                            const unsigned char *n);
