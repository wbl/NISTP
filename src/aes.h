extern void aeskey(unsigned int *space, unsigned char *key);
extern void aescrypt(unsigned char *blockout, unsigned char *blockin,
                     unsigned int *space);
#define AES_STATEINTS 60
#define AES_BLOCKBYTES 16
