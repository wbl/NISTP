#include <stdint.h>
#include "fep256.h"
/*arithmetic mod p=2^256-2^224+2^192+2^96-1*/
/*We use 11 64 bit limbs, with values mostly capped at 2^24.
This arrangement lets us multiply and accumulate safely with very small
number arithmetic. It also makes the awkward placements a bit better, while
still permitting us to use 64 bit arithemetic.*/
void reduce(fep256 *c){ //some people say this shouldn't try that hard
  uint64_t twoto24 = 1<<24;
  uint64_t carry =0;
  for(unsigned int i=0; i<11; i++){
    c->c[i] +=carry;
    carry=c->c[i]&(!(twoto24-1));
    carry >>=24;
  }
  //what happens next is to clear the ground for subtractions
  uint64_t sub = 0;
  for(int i=0; i<11; i++){
    c->c[i]+=(twoto24-sub);
    sub=1;
  }
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
  //Not worried about c[9] overflow: <2^27 is OK
  return;
}

void fep256add(fep256 *c, fep256 *a, fep256 *b){
  for(unsigned int i=0; i<11; i++){
    c->c[i]=a->c[i]+b->c[i];
  }
  reduce(c);
  return;
}

void fep256neg(fep256 *c, fep256 *a){
  uint64_t twoto24 = 1<<24;
  uint64_t sub=0;
  uint64_t carry =0;
  //two approaches: one is to precompute zero. But this involves magic
  //numbers not easily groked. So we make zero
  for(int i=0; i<11; i++){
    c->c[i]=0;
  }
  //but that's not enough: we need to borrow to enable subtraction.
  //we overborrow by a factor of 8 to be safe.
  for(int i=0; i<11; i++){
    c->c[i]+=8*twoto24-sub;
    sub=8;
  }
  //now we need to do the carry corrections:
  carry=-8;
  carry *=256; //Adjustment for 2^264 vs. 2^256
  c->c[0]+=carry; //Carry is negative.
  c->c[4]-=carry;
  c->c[8]-=carry;
  c->c[9]+=256*carry;
  //at this point we are ready to actually subtract
  for(int i=0; i<11; i++){
    c->c[i]-=a->c[i];
  }
  reduce(c); //could possibly be omitted.
}

void fep256sub(fep256 *c, fep256 *a, fep256 *b){
  fep256 t;
  fep256neg(&t, b);
  fep256add(c, a, &t);
}

void fep256setzero(fep256 *a){
  for(int i=0; i<11; i++){
    a->c[i]=0;
  }
}

void fep256setone(fep256 *b){
  fep256setzero(b);
  b->c[0]=1;
}
