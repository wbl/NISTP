extern void aes256gcmcrypt(unsigned char *c, unsigned char *m,
                                       unsigned long long mlen, unsigned char
                                       *nonce, unsigned char *key);
extern int aes256gcmdecrypt(unsigned char *m, unsigned char *c,
                                 unsigned long long clen, unsigned char *nonce,
                                 unsigned char *key);
#define aes256gcmBOXZEROBYTES 0
#define aes256gcmZEROBYTES 16
#define aes256gcmNONCEBYTES 12
#define aes256gcmKEYBYTES 32
