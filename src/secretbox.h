#define crypto_secretbox_aes256gcm_KEYBYTES 32
#define crypto_secretbox_aes256gcm_NONCEBYTES 8
#define crypto_secretbox_aes256gcm_ZEROBYTES 16
#define crypto_secretbox_aes256gcm_BOXZEROBYTES 0
extern void crypto_secretbox_aes256gcm(unsigned char *c, 
                                       unsigned char *m, 
                                       unsigned long long mlen, 
                                       unsigned char *n, 
                                       unsigned char *k);
extern int crypto_secretbox_aes256gcm_open(unsigned char *m, 
                                           unsigned char *c, 
                                           unsigned long long clen, 
                                           unsigned char *n,
                                           unsigned char *k);
