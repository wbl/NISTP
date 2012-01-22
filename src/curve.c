#include <strings.h>
#include <stdint.h>
#include <stdio.h> //debugging
#include <assert.h>
#include "fep256.h"
#include "curve.h"
/*Using Jacobian coordinates*/
unsigned char basep[64]={0x6b,  0x17,  0xd1,  0xf2,  0xe1,  0x2c,  0x42,
                         0x47,  0xf8,  0xbc,  0xe6,  0xe5,  0x63,  0xa4, 
                         0x40,  0xf2,  0x77,  0x03,  0x7d,  0x81,  0x2d,  
                         0xeb,  0x33,  0xa0,  0xf4,  0xa1,  0x39,  0x45,  
                         0xd8,  0x98,  0xc2,  0x96,  0x4f,  0xe3,  0x42,  
                         0xe2,  0xfe,  0x1a,  0x7f,  0x9b,  0x8e,  0xe7, 
                         0xeb,  0x4a,  0x7c,  0x0f,  0x9e,  0x16,  0x2b, 
                         0xce,  0x33,  0x57,  0x6b,  0x31,  0x5e,  0xce,
                         0xcb,  0xb6,  0x40,  0x68,  0x37,  0xbf,  0x51,  
                         0xf5};

unsigned char paramb[32]={0x5a, 0xc6, 0x35, 0xd8, 0xaa, 0x3a, 0x93, 0xe7,
                          0xb3, 0xeb, 0xbd, 0x55, 0x76, 0x98, 0x86, 0xbc,
                          0x65, 0x1d, 0x06, 0xb0, 0xcc, 0x53, 0xb0, 0xf6,
                          0x3b, 0xce, 0x3c, 0x3e, 0x27, 0xd2, 0x60,  0x4b};
void printpt(point *c){
  unsigned char xchar[32];
  unsigned char ychar[32];
  unsigned char zchar[32];
  fep256pack(xchar, &c->x);
  fep256pack(ychar, &c->y);
  fep256pack(zchar, &c->z);
  printf("x: ");
  for(int i=0; i<32; i++){
    printf("%02x", xchar[i]);
  }
  printf("\n");
  printf("y: ");
  for(int i=0; i<32; i++){
    printf("%02x", ychar[i]);
  }
  printf("\n");
  printf("z: ");
  for(int i=0; i<32; i++){
    printf("%02x", zchar[i]);
  }
  printf("\n");
}
void p256add(point *c, point *a, point *b){
  /*EFD/g1p/auto-code/shortw/jacobian-3/additon/add-2007-bl.op3*/
  fep256 z1z1, z2z2, u1, u2, t0, s1, t1, s2, h, t2, i, j, t3, r, v, t4,
    t5, t6, t7, t8, t9, t10, t11, t12, t13, t14;
  fep256sqr(&z1z1, &a->z);
  fep256sqr(&z2z2, &b->z);
  fep256mul(&u1, &a->x, &z2z2);
  fep256mul(&u2, &b->x, &z1z1);
  fep256mul(&t0, &b->z, &z2z2);
  fep256mul(&s1, &a->y, &t0);
  fep256mul(&t1, &a->z, &z1z1);
  fep256mul(&s2, &b->y, &t1);
  fep256sub(&h, &u2, &u1);
  fep256scalar(&t2, &h, 2);
  fep256sqr(&i, &t2);
  fep256mul(&j, &h, &i);
  fep256sub(&t3, &s2, &s1);
  fep256scalar(&r, &t3, 2);
  fep256mul(&v, &u1, &i);
  fep256sqr(&t4, &r);
  fep256scalar(&t5, &v, 2);
  fep256sub(&t6, &t4, &j);
  fep256sub(&c->x, &t6, &t5);
  fep256sub(&t7, &v, &c->x);
  fep256sub(&t8, &s1, &j);
  fep256scalar(&t9, &t8, 2);
  fep256mul(&t10, &r, &t7);
  fep256sub(&c->y, &t10, &t9);
  fep256add(&t11, &a->z, &b->z);
  fep256sqr(&t12, &t11);
  fep256sub(&t13, &t12, &z1z1);
  fep256sub(&t14, &t13, &z2z2);
  fep256mul(&c->z, &t14, &h);
}

void p256dbl(point *c, point *a){
  /*EFD/g1p/auto-code/shortw/jacaobian-3/doubling/dbl-2001-b.op3*/
  fep256 delta, gamma, beta, t0, t1, t2, alpha, t3, t4, t5, t6, t7, t8, t9,
    t10, t11, t12;
  fep256sqr(&delta, &a->z);
  fep256sqr(&gamma, &a->y);
  fep256mul(&beta, &a->x, &gamma);
  fep256sub(&t0, &a->x, &delta);
  fep256add(&t1, &a->x, &delta);
  fep256mul(&t2, &t0, &t1);
  fep256scalar(&alpha, &t2, 3);
  fep256sqr(&t3, &alpha);
  fep256scalar(&t4, &beta, 8);
  fep256sub(&c->x, &t3, &t4);
  fep256add(&t5, &a->y, &a->z);
  fep256sqr(&t6, &t5);
  fep256sub(&t7, &t6, &gamma);
  fep256sub(&c->z, &t7, &delta);
  fep256scalar(&t8, &beta, 4);
  fep256sub(&t9, &t8, &c->x);
  fep256sqr(&t10, &gamma);
  fep256scalar(&t11, &t10, 8);
  fep256mul(&t12, &alpha, &t9);
  fep256sub(&c->y, &t12, &t11);
}

void p256cmov(point *c, point *b, unsigned int a){
  fep256cmov(&c->x, &b->x, a);
  fep256cmov(&c->y, &b->y, a);
  fep256cmov(&c->z, &b->z, a);
}

void p256scalarmult(point *c, point *a, unsigned char e[32]){
  /*For now double and add*/
  unsigned int bit;
  point R0;
  point R1;
  point temp;
  p256cmov(&R1, a, 1);
  for(int i=0; i<32; i++){
    for(int j=7; j>=0; j--){ //iterate from top down
      bit=(e[i]>>j)&0x1;
      printf("i %d j %d bit %d\n", i, j, bit);
      printf("R0:");
      printpt(&R0);
      printf("R1:");
      printpt(&R1);
      p256dbl(&R0, &R0);
      if(bit){p256add(&R0, &R1, &R0);} //Fix when working
    }
  }
  p256cmov(c, &R0,1);
}

void p256pack(unsigned char out[64], point *c){
  /*Using Jacobian coordinates*/
  fep256 a, aa, x3, y3, t0;
  fep256inv(&a, &c->z);
  fep256sqr(&aa, &a);
  fep256mul(&x3, &c->x, &aa);
  fep256mul(&t0, &a, &aa);
  fep256mul(&y3, &t0, &c->y);
  fep256pack(out, &x3);
  fep256pack(out+32, &y3);
}

void p256unpack(point *c, unsigned char out[64]){
  fep256unpack(&c->x, out);
  fep256unpack(&c->y, out+32);
  fep256setone(&c->z);
}

void p256scalarmult_base(point *c, unsigned char e[32]){
  point a;
  p256unpack(&a, basep);
  assert(p256oncurvefinite(&a));
  p256scalarmult(c, &a, e);
}

void p256xpack(unsigned char c[32], point *a){
  unsigned char temp[64];
  p256pack(temp, a);
  memcpy(c, temp, 32);
}

unsigned int p256oncurvefinite(point *c){
  /*Jacobianize me*/
  fep256 a, aa, x, y, t0, t1, t2,t3, t4, t5, t6, t7, b;
  if(fep256iszero(&c->z)) return 0;
  fep256inv(&a, &c->z);
  fep256sqr(&aa, &a);
  fep256mul(&x, &c->x, &aa);
  fep256mul(&t0, &a, &aa);
  fep256mul(&y, &t0, &c->y);
  /*we now have &x and &y as our coordinates*/
  fep256sqr(&t1, &x);
  fep256mul(&t2, &t1, &x);
  fep256scalar(&t3, &x, 3);//3x
  fep256sub(&t4, &t2, &t3); //x^3-3x
  fep256unpack(&b, paramb);
  fep256add(&t5, &t4, &b);
  fep256sqr(&t6, &y);
  fep256sub(&t7, &t5, &t6);
  return fep256iszero(&t7);
}