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
    carry=c->c[i]&(!twoto24);
    carry >>=24;
  }
  c->c[10]-=carry*twoto24; //clear the part we are done with
  /*now we have a high carry: add to various places and subtract*/
  /*instead of subtraction, add 0 mod p. Figure this out */
  c->c[0]+=carry;
  c->c[4]+=(twoto24-carry);
  c->c[8]+=(twoto24-carry);
  c->c[9]+=256*carry;
  //now, how to deal with the necessary borrowing to keep limbs unsigned?
  //hard part is borrowing from c[10]: carry will only be 1.
  c->c[5]+=(twoto24-1);
  c->c[6]+=(twoto24-1);
  c->c[7]+=(twoto24-1);
  c->c[8]+=(twoto24-1);
  c->c[9]+=(twoto24-2);
  c->c[10]+=(twoto24-1);
  //now, at this point only have to deal with 2^264 (potentially)
  //2^264=2^9*2^256. I might have picked bad limbs...
  return;
}

void fep256add(fep256 *c, fep256 *a, fep256 *b){
  for(unsigned int i=0; i<11; i++){
    c->c[i]=a->c[i]+b->c[i];
  }
  reduce(c);
  return;
}

void fep256sub(fep256 *c, fep256 *a, fep256 *b){
  

