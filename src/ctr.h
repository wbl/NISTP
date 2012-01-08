extern void aes256ctr(unsigned char *out, unsigned char *in,
                      unsigned long long len, unsigned char *key,
                      unsigned char *block);
#define CTRBLOCKBYTES 16
#define CTRKEYBTYES 32
