#include <stdint.h>
#include "fep256.h"
/*arithmetic mod p=2^256-2^224+2^192+2^96-1*/
/*We use 11 64 bit limbs, with values mostly caped at 2^24.
This arrangement lets us multiply and accumulate safely with very small
number arithmetic. It also makes the awkward placements a bit better, while
still permitting us to use 64 bit arithemetic.*/
void reduce(fep256 *c){
  uint64_t twoto24 = 1<<24;
  uint64_t carry =0;
  for(unsigned int i=0; i<11; i++){
    c->c[i] +=carry;
    carry=c->c[i]&(!(twoto24-1));
    carry >>=24;
  }
  //what happens next is to clear the ground for subtractions
  c->c[0]+=twoto24;
  c->c[1]+=(twoto24-1);
  c->c[2]+=(twoto24-1);
  c->c[3]+=(twoto24-1);
  c->c[4]+=(twoto24-1);
  c->c[5]+=(twoto24-1);
  c->c[6]+=(twoto24-1);
  c->c[7]+=(twoto24-1);
  c->c[8]+=(twoto24-1);
  c->c[9]+=(twoto24-1);
  c->c[10]+=(twoto24-1);
  carry -=1; //we've borrowed back.
  carry *=256; //2^264=2^8*2^256. We aren't taking the high 16: no need.
  /*What happens next is okay: the branches will not underflow because of the
    previous lines. Now, c[9] could definitely overflow, but on an addition of
    something at most 2^24 (by conditions on c[10]) this makes it at most 2^25.
  */
  c->c[0]+=carry; //Note that carry is negative.
  c->c[4]-=carry;
  c->c[8]-=carry;
  c->c[9]+=256*carry;
  return;
}

void fep256add(fep256 *c, fep256 *a, fep256 *b){
  for(unsigned int i=0; i<11; i++){
    c->c[i]=a->c[i]+b->c[i];
  }
  reduce(c);
  return;
}
/*
void fep256neg(fep256 *c, fep256 *a); //TODO
void fep256sub(fep256 *c, fep256 *a, fep256 *b){
  fep256 t;
  fep256neg(&t, b);
  fep256add(c, a, &t);
}
*/
void fep256setzero(fep256 *a){
  for(int i=0; i<11; i++){
    a->c[i]=0;
  }
}

void fep256setone(fep256 *b){
  fep256setzero(b);
  b->c[0]=1;
}
