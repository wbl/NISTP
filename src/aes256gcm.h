extern void crypto_secretbox_aes256gcm(unsigned char *c, unsigned char *m,
                                       unsigned long long mlen, unsigned char
                                       *nonce, unsigned char *key);
extern int crypto_secretbox_open(unsigned char *m, unsigned char *c,
                                 unsigned long long clen, unsigned char *nonce,
                                 unsigned char *key);
#define crypto_secretbox_aes256gcmBOXZEROBYTES 0
#define crypto_secretbox_aes256gcmZEROBYTES 16
