#include <strings.h>
#include <stdint.h>
#include <stdio.h> //debugging
#include <assert.h>
#include "fep256.h"
#include "curve.h"

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

void p256add(point *c, point *a, point *b){
  /*Strongly unified projective coordinates */
  /*EFD: add-2007-bl.op3*/
  fep256 minus3;
  fep256 u1;
  fep256 u2;
  fep256 s1;
  fep256 s2;
  fep256 zz;
  fep256 t;
  fep256 tt;
  fep256 m;
  fep256 t0;
  fep256 t1;
  fep256 t2;
  fep256 t3;
  fep256 r;
  fep256 f;
  fep256 l;
  fep256 ll;
  fep256 t4;
  fep256 t5;
  fep256 t6;
  fep256 g;
  fep256 t7;
  fep256 t8;
  fep256 w;
  fep256 t9;
  fep256 t10;
  fep256 t11;
  fep256 t12;
  fep256 t13;
  fep256 t14;
  fep256 t15;
  /*Okay, lots of code. Additional multiply is worth strong unification.
    Lack of strong unification:
    Not problem for our application, but signing might be issue*/
  fep256setone(&minus3);
  fep256scalar(&minus3, &minus3, 3);
  fep256setzero(&t15);
  fep256sub(&minus3, &t15, &minus3);
  /*now minus3 is -3. We don't need b here*/
  fep256mul(&u1, &a->x, &b->z);/*U1 = X1*Z2*/
  fep256mul(&u2, &b->x, &a->z);/*U2 = X2*Z1*/
  fep256mul(&s1, &a->y, &b->z);/*S1 = Y1*Z2*/
  fep256mul(&s2, &b->y, &a->z);/*S2 = Y2*Z1*/
  fep256mul(&zz, &a->z, &b->z); /*ZZ = Z1*Z2*/
  fep256add(&t, &u1, &u2); /*T = U1+U2*/
  fep256sqr(&tt, &t);/*TT = T^2*/
  fep256add(&m, &s1, &s2); /*M = S1+S2*/
  fep256sqr(&t0, &zz);/*t0 = ZZ^2*/
  fep256mul(&t1, &minus3, &t0);/*t1 = a*t0*/
  fep256mul(&t2, &u1, &u2);/*t2 = U1*U2*/
  fep256sub(&t3, &tt, &t2);/*t3 = TT-t2*/
  fep256add(&r, &t3, &t1);/*R = t3+t1*/
  fep256mul(&f, &zz, &m);/*F = ZZ*M*/
  fep256mul(&l, &m, &f);/*L = M*F*/
  fep256sqr(&ll, &l);/*LL = L^2*/
  fep256add(&t4, &t, &l);/*t4 = T+L*/
  fep256sqr(&t5, &t4);/*t5 = t4^2*/
  fep256sub(&t6, &t5, &tt);/*t6 = t5-TT*/
  fep256sub(&g, &t6, &ll);/*G = t6-LL*/
  fep256sqr(&t7, &r);/*t7 = R^2*/
  fep256scalar(&t8, &t7, 2);/*t8 = 2*t7*/
  fep256sub(&w, &t8,&g);/*W = t8-G*/
  fep256mul(&t9, &f, &w);/*t9= F*W*/
  fep256scalar(&c->x, &t9, 2);/*X3 = 2*t9*/
  fep256scalar(&t10, &w, 2);/*t10 = 2*W*/
  fep256sub(&t11, &g, &t10);/*t11=G-t0*/
  fep256scalar(&t12, &ll, 2);/*t12 = 2*LL*/
  fep256mul(&t13, &r, &t11);/*t13 = R*t11*/
  fep256sub(&c->y, &t13, &t12);/*Y3 = t13-t12*/
  fep256sqr(&t14, &f);/*t14 = F^2*/
  fep256mul(&t15, &f, &t14);/*t15 = F*t14*/
  fep256scalar(&c->z, &t15, 4);/*Z3 = 4*t15*/
}

void p256dbl(point *c, point *a){
  /*TODO: use something other then above for speed*/
  /*I ought to have written that automatic translator*/
  p256add(c, a, a);
}

void p256cmov(point *c, point *b, unsigned int a){
  fep256cmov(&c->x, &b->x, a);
  fep256cmov(&c->y, &b->y, a);
  fep256cmov(&c->z, &b->z, a);
}

void p256scalarmult(point *c, point *a, unsigned char e[32]){
  /*For now double and add*/
  /*except double and add is broken with above formulas*/
  unsigned int bit;
  point R0;
  point R1;
  point ident;
  point temp;
  p256cmov(&R1, a, 1);
  assert(p256oncurve(&R1));
  fep256setzero(&ident.x);
  fep256setone(&ident.y);
  fep256setzero(&ident.z); //make R0, ident identity
  p256cmov(&R0, &ident, 1);
  for(int i=0; i<32; i++){
    for(int j=7; j>=0; j--){ //iterate from top bit down
      bit=(e[i]>>j)&0x1;
      p256cmov(&temp, &ident, 1);
      p256cmov(&temp, &R1, bit);
      p256dbl(&R0, &R0);
      p256add(&R0, &R0, &temp);
      assert(p256oncurve(&R0));
      assert(p256oncurve(&R1));
    }
  }
  p256cmov(c, &R0,1);
}

void p256pack(unsigned char out[64], point *c){ //changes c, but in ok way
  fep256 zinv;
  fep256inv(&zinv, &c->z);
  fep256mul(&c->x, &c->x, &zinv);
  fep256mul(&c->y, &c->y, &zinv);
  fep256setone(&c->z);
  fep256pack(out, &c->x);
  fep256pack(out+32, &c->y);
}

void p256unpack(point *c, unsigned char out[64]){
  fep256unpack(&c->x, out);
  fep256unpack(&c->y, out+32);
  fep256setone(&c->z);
}

void p256scalarmult_base(point *c, unsigned char e[32]){
  point a;
  p256unpack(&a, basep);
  assert(p256oncurve(&a));
  p256scalarmult(c, &a, e);
}

void p256xpack(unsigned char c[32], point *a){
  unsigned char temp[64];
  p256pack(temp, a);
  memcpy(c, temp, 32);
}

unsigned int p256oncurve(point *a){
  unsigned char temp[64];
  fep256 t, yy;
  if(fep256iszero(&a->z)){
    return fep256iszero(&a->x)&&(!fep256iszero(&a->y));
  }
  p256pack(temp, a); //as side effect make z=1;
  fep256cmov(&t, &a->x, 1);
  fep256sqr(&t, &t); //x^2
  fep256mul(&t, &t, &a->x); //x^3
  fep256sub(&t, &t, &a->x);
  fep256sub(&t, &t, &a->x);
  fep256sub(&t, &t, &a->x); //x^3-3x
  fep256unpack(&yy, paramb);
  fep256add(&t, &t,  &yy); //x^3-3x+b
  fep256sqr(&yy, &a->y);
  fep256sub(&t, &t, &yy);//x^3-3x+b-y^2==0;
  return fep256iszero(&t);
}
