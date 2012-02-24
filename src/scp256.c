#include "scp256.h"
/*ripped from nacl, constants changed.*/
/*style issues: not C99, not GNU indented*/
/* arithmetic modulo the group of order
   115792089210356248762697446949407573529996955224135760342422259061068512044369
//we use little endian*/
/*The modulus, base 256*/
const unsigned char m[32]={81,  37,  99,  252,  194,  202,  185,  243,  132,  158,  23,  167,  173,
                           250,  230,  188,  255,  255,  255,  255,  255,  255,  255,  255,  0,  0, 
                           0,  0,  255,  255,  255, 255};
/*The constant for barrett reduction*/
/*See HAC 14.42 for details */
  const unsigned char mu[33]={ 254,  155,  223,  238,  133,  253,  47,  1,  33,  108,  26,  223,  82,  5,  25,  67, 
                               255,  255,  255,  255,  254,  255,  255,  255,  255,  255,  255,  255,  0,  0,  0,  0, 1};
/* Reduce coefficients of r before calling reduce_add_sub */
static void reduce_add_sub(scp256 *r)
{
  int i, b, pb=0, nb;
  unsigned char t[32];

  for(i=0;i<32;i++) 
  {
    b = (r->v[i]<pb+m[i]);
    t[i] = r->v[i]-pb-m[i]+b*256;
    pb = b;
  }
  nb = 1-b;
  for(i=0;i<32;i++) 
    r->v[i] = r->v[i]*b + t[i]*nb;
}

/* Reduce coefficients of x before calling barrett_reduce */
static void barrett_reduce(scp256 *r, const unsigned int x[64])
{
  /* See HAC, Alg. 14.42 */
  int i,j;
  unsigned int q2[66] = {0};
  unsigned int *q3 = q2 + 33;
  unsigned int r1[33];
  unsigned int r2[33] = {0};
  unsigned int carry;
  int b, pb=0;

  for(i=0;i<33;i++)
    for(j=0;j<33;j++)
      if(i+j >= 31) q2[i+j] += mu[i]*x[j+31];
  carry = q2[31] >> 8;
  q2[32] += carry;
  carry = q2[32] >> 8;
  q2[33] += carry;

  for(i=0;i<33;i++)r1[i] = x[i];
  for(i=0;i<32;i++)
    for(j=0;j<33;j++)
      if(i+j < 33) r2[i+j] += m[i]*q3[j];

  for(i=0;i<32;i++)
  {
    carry = r2[i] >> 8;
    r2[i+1] += carry;
    r2[i] &= 0xff;
  }

  for(i=0;i<32;i++) 
  {
    b = (r1[i]<pb+r2[i]);
    r->v[i] = r1[i]-pb-r2[i]+b*256;
    pb = b;
  }

  /* XXX: Can it really happen that r<0?, See HAC, Alg 14.42, Step 3 
   * If so: Handle  it here!
   */

  reduce_add_sub(r);
  reduce_add_sub(r);
}

/*
static int iszero(const scp256 *x)
{
  // Implement
  return 0;
}
*/

void scp256_from32bytes(scp256 *r, const unsigned char x[32])
{
  int i;
  unsigned int t[64] = {0};
  for(i=0;i<32;i++) t[i] = x[i];
  barrett_reduce(r, t);
}

void scp256_from64bytes(scp256 *r, const unsigned char x[64])
{
  int i;
  unsigned int t[64] = {0};
  for(i=0;i<64;i++) t[i] = x[i];
  barrett_reduce(r, t);
}

void rev32(unsigned char *x, unsigned char *t){
  for(int i=0; i<32; i++){
    x[31-i]=t[i];
  }
}


/* XXX: What we actually want for crypto_group is probably just something like
 * void scp256_frombytes(scp256 *r, const unsigned char *x, size_t xlen)
 */

void scp256_to32bytes(unsigned char r[32], const scp256 *x)
{
  int i;
  for(i=0;i<32;i++) r[i] = x->v[i];
}

void scp256_pack(unsigned char x[32], scp256 *r){
  unsigned char t[32];
  scp256_to32bytes(t, r);
  rev32(x, t);
}

void scp256_unpack(scp256 *r, unsigned char x[32]){
  unsigned char t[32];
  rev32(t, x);
  scp256_from32bytes(r, t);
}

void scp256_add(scp256 *r,  scp256 *x,  scp256 *y)
{
  int i, carry;
  for(i=0;i<32;i++) r->v[i] = x->v[i] + y->v[i];
  for(i=0;i<31;i++)
  {
    carry = r->v[i] >> 8;
    r->v[i+1] += carry;
    r->v[i] &= 0xff;
  }
  reduce_add_sub(r);
}

void scp256_mul(scp256 *r, scp256 *x, scp256 *y)
{
  int i,j,carry;
  unsigned int t[64];
  for(i=0;i<64;i++)t[i] = 0;

  for(i=0;i<32;i++)
    for(j=0;j<32;j++)
      t[i+j] += x->v[i] * y->v[j];

  /* Reduce coefficients */
  for(i=0;i<63;i++)
  {
    carry = t[i] >> 8;
    t[i+1] += carry;
    t[i] &= 0xff;
  }

  barrett_reduce(r, t);
}

void scp256_square(scp256 *r, scp256 *x)
{
  scp256_mul(r, x, x);
}
