/*In plan-9 style .h never has inclusions in it */
extern void ghash(unsigned char *tag, unsigned char *m,
                  unsigned long long mlen, unsigned char *h,
                  unsigned char *otk);
