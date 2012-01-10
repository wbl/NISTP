#include <strings.h>
#include <string.h>
#include <assert.h>
#include "garith.h"

/*We are using arrays of chars. Each char is either 0 or 1*/
void unpack8(unsigned char *bits, unsigned char *c){
  bits[0]=(*c&0x80)>>7;
  bits[1]=(*c&0x40)>>6;
  bits[2]=(*c&0x20)>>5;
  bits[3]=(*c&0x10)>>4;
  bits[4]=(*c&0x08)>>3;
  bits[5]=(*c&0x04)>>2;
  bits[6]=(*c&0x02)>>1;
  bits[7]=(*c&0x01);
}

void pack8(unsigned char *c, unsigned char *bits){
  *c=(bits[0]<<7)|(bits[1]<<6)|(bits[2]<<5)|(bits[3]<<4)|(bits[4]<<3)|
    (bits[5]<<2)|(bits[6]<<1)|(bits[7]);
}
void gf2128add(gf2128 *c, gf2128 *a, gf2128 *b){
  for(int i=0; i<128; i++){
    c->c[i]=a->c[i]^b->c[i];
    assert(c->c[i]<2);
  }
}
static gf2128 R = { {1,1,1,0,0,0,0,1,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0}};
void gf2128mulx(gf2128 *b, gf2128 *a){ //uniqueness required
  for(int i=0; i<127; i++){
    b->c[i+1]=a->c[i];
    assert(a->c[i]<2);
  }
  b->c[0]=0;
  if(a->c[127]){
    gf2128add(b, b, &R);
  }
}

void gf2128mov(gf2128 *b, gf2128 *a){
  memcpy(b->c, a->c, 128);
}

void gf2128zero(gf2128 *a){
  bzero(a->c, 128);
}
void gf2128mul(gf2128 *c, gf2128 *a, gf2128 *b){
  gf2128 V;
  gf2128 Z;
  gf2128 temp;
  gf2128zero(&V);
  gf2128zero(&Z);
  gf2128zero(&temp);
  gf2128add(&V, &V, b);
  for(int i=0; i<128; i++){
    if(a->c[i]){
      assert(a->c[i]<2);
      gf2128add(&Z,&Z,&V);
    }
    gf2128mulx(&temp,&V);
    gf2128mov(&V, &temp);
  }
  gf2128mov(c, &Z);
}
void gf2128pack(unsigned char *p, gf2128 *x){
  for(int i=0; i<16; i++){
    pack8(p+i, x->c+8*i);
  }
}

void gf2128unpack(gf2128 *x, unsigned char *p){
  for(int i=0; i<16; i++){
    unpack8(x->c+8*i, p+i);
  }
}

void gf2128packcoeffs(unsigned char *dest, gf2128 *x){
  memcpy(dest, x->c, 128);
}

void gf2128unpackcoeffs(gf2128 *x, unsigned char *src){
  memcpy(x->c, src, 128);
}
