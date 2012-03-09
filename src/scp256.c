#include "scp256.h"
#include <stdio.h>
/*ripped from nacl, some changes made.*/
/*style issues: not C99, not GNU indented*/
/* arithmetic modulo the group of order
   115792089210356248762697446949407573529996955224135760342422259061068512044369
//we use little endian*/
/*The modulus, base 256*/

const unsigned char m[32]={81,  37,  99,  252,  194,  202,  185,
                           243,  132,  158,  23,  167,  173,
                           250,  230,  188,  255, 
                           255,  255,  255,  255,  
                           255,  255,  255,  0,  0, 
                           0,  0,  255,  255,  255, 255};

/*The constant for barrett reduction*/
/*See HAC 14.42 for details */
const unsigned char mu[33]={ 254,  155,  223,  238,  133,  253,
                             47,  1,  33,  108,  26,  223,  82,  5,  25,  67, 
                             255,  255,  255,  255,  254,  255, 
                             255,  255,  255,  255,  255,  255,
                             0,  0,  0,  0, 1};
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
static inline int min(int a, int b){
  return (a<b)?a:b;
}
static inline int max(int a, int b){
  return (b>a)?b:a;
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
  unsigned char t[33];
  unsigned int carry;
  int b, pb=0;

  for(i=0;i<33;i++)
    for(j=max(31-i,0);j<33;j++)
      q2[i+j] += mu[i]*x[j+31];
  carry = q2[31] >> 8;
  q2[32] += carry;
  carry = q2[32] >> 8;
  q2[33] += carry;
  for(i=0;i<33;i++)r1[i] = x[i];
  for(i=0;i<32;i++)
    for(j=0;j<33-i;j++)
      r2[i+j] += m[i]*q3[j];

  for(i=0;i<32;i++)
  {
    carry = r2[i] >> 8;
    r2[i+1] += carry;
    r2[i] &= 0xff;
  }
  //issue: 3*m overflows a 32 byte word
  //solution is to change reduce
  for(i=0;i<33;i++) 
  {
    b = (r1[i]<pb+r2[i]);
    t[i] = r1[i]-pb-r2[i]+b*256;
    pb = b;
  }
  /*Why this? because t is 33 bytes, not 32.*/
  for(i=0; i<32; i++){
    r->v[i]=t[i];
  }
  r->v[31]+=256*t[32];
  reduce_add_sub(r);
  reduce_add_sub(r);
}


static void scp256_from32bytes(scp256 *r, const unsigned char x[32])
{
  int i;
  unsigned int t[64] = {0};
  for(i=0;i<32;i++) t[i] = x[i];
  barrett_reduce(r, t);
}

static void scp256_from64bytes(scp256 *r, const unsigned char x[64])
{
  int i;
  unsigned int t[64] = {0};
  for(i=0;i<64;i++) t[i] = x[i];
  barrett_reduce(r, t);
}

static void rev32(unsigned char *x, const unsigned char *t){
  for(int i=0; i<32; i++){
    x[31-i]=t[i];
  }
}


static void scp256_to32bytes(unsigned char r[32], const scp256 *x)
{
  int i;
  for(i=0;i<32;i++) r[i] = x->v[i];
}

void scp256_pack(unsigned char x[32], scp256 *r){
  unsigned char t[32];
  scp256_to32bytes(t, r);
  rev32(x, t);
}

void scp256_unpack(scp256 *r, const unsigned char x[32]){
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

  for(int i=0; i<32; i++)
    for(int j=0; j<32; j++)
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

void scp256_sqr(scp256 *r, scp256 *x){
  scp256_mul(r, x, x);
}
/*That was everything originally in the program. It's enough for
  a good signature scheme. But we want ECDSA, and ECDSA requires division and subtraction*/

/*c=a-b*/
void scp256_sub(scp256 *c, scp256 *a, scp256 *b){
  scp256 t;
  unsigned int carry=0;
  unsigned int brw=0;
  unsigned int pbrw=0;
  for(int i=0; i<32; i++){
    brw=(m[i]<b->v[i]+pbrw);
    t.v[i]=m[i]-(b->v[i])-pbrw+256*brw;
    pbrw=brw;
  }
  /*Note that b<m, so pb=0*/
  scp256_add(c, a, &t);
}
void scp256_cmov(scp256 *c, scp256 *b, unsigned int a){
  for(int i=0; i<32; i++){
    c->v[i]=c->v[i]*(1-a)+b->v[i]*a;
  }
}

void scp256_inv(scp256 *c, scp256 *a){
  /*idea: raise a to the m-2 power.*/
  unsigned char msub2[32];
  int index;
  scp256 apows[16]; //use a four bit window: base 16
  for(int i=0; i<32; i++){
    msub2[i]=m[i];
  }
  msub2[0]-=2; //81>2 is used here.
  for(int i=0; i<32; i++){
    c->v[i]=0;
  }
  c->v[0]=1; //set to 1 initially
  scp256_cmov(&apows[0], c, 1);
  for(int i=1; i<16; i++){
    scp256_mul(&apows[i], &apows[i-1], a);
  }
  for(int i=31; i>=0; i--){//big endian right now
    for(int j=4; j>=0; j-=4){ //exponent is public: time can vary!
      index=(msub2[i]>>j)&0x0f;
      scp256_sqr(c, c);
      scp256_sqr(c, c);
      scp256_sqr(c, c);
      scp256_sqr(c, c);
      scp256_mul(c, c, &apows[index]);
      }
  }
}

int scp256_iszero(scp256 *c){
  unsigned int r=0;
  for(int i=0; i<32; i++){
    r|=c->v[i];
  }
  return (r==0);
}
