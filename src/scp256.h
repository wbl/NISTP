typedef struct {
  unsigned int v[32];
} scp256;
void scp256_unpack(scp256 *r, unsigned char x[32]);
void scp256_pack(unsigned char x[32], scp256 *r);

void scp256_add(scp256 *c, scp256 *a, scp256 *b);
void scp256_mul(scp256 *c, scp256 *a, scp256 *b);
void scp256_sub(scp256 *c, scp256 *a, scp256 *b);
void scp256_inv(scp256 *c, scp256 *a);
