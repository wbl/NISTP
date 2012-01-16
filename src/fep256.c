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
    carry=c->c[i]&twoto24;
    carry >>=24;
  }
  /*now we have a high carry: add to various places and subtract*/
  /*instead of subtraction, add 0 mod p. Figure this out */
}

void fep256add(fep256 *c, fep256 *a, fep256 *b){
  for(unsigned int i=0; i<11; i++){
    c->c[i]=a->c[i]+b->c[i];
  }
  reduce(c);
}


