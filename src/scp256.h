typedef struct {
  unsigned int v[32];
} scp256;

void scp256_unpack(scp256 *r, const unsigned char x[32]);
void scp256_pack(unsigned char x[32], scp256 *r);
void scp256_from64bytes(scp256 *r, const unsigned char x[64]);
void scp256_cmov(scp256 *c, scp256 *a, unsigned int b);
void scp256_add(scp256 *c, scp256 *a, scp256 *b);
void scp256_mul(scp256 *c, scp256 *a, scp256 *b);
void scp256_sub(scp256 *c, scp256 *a, scp256 *b);
void scp256_inv(scp256 *c, scp256 *a);
int scp256_iszero(scp256 *c);
