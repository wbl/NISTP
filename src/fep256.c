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
  uint64_t sub=0;
  for(unsigned int i=0; i<11; i++){
    c->c[i] +=carry;
    carry=c->c[i]&(~(twoto24-1));//bitmasking trick
    c->c[i]-=carry;
    carry >>=24;
  }
  //now if carry is zero we like to think we are done. But we are working
  //with unsigned limbs and may have to subtract carry. To do that we have
  //to do some borrowing, potentially making c[9] negative.
  //but the borrwing will be undone by the same loop as before: the top part
  //won't go back to needing correction.
  for(int i=4; i<10; i++){
    c->c[i]+=(twoto24-sub);
    sub=1;
  }
  carry *=256; //this is to correct for the limb ending.
  c->c[0]+=carry;
  c->c[4]-=carry;
  c->c[8]-=carry;
  c->c[9]+=256*carry;
  //now undo the results by doing some more carrying
  carry=0;
  for(unsigned int i=0; i<10; i++){
    c->c[i] +=carry;
    carry=c->c[i]&(~(twoto24-1));//bitmasking trick
    c->c[i]-=carry;
    carry >>=24;
  }
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
  //we overborrow by a factor of 256 to be safe.
  for(int i=0; i<11; i++){
    c->c[i]+=256*twoto24-sub;
    sub=256;
  }
  //now we need to do the carry corrections:
  carry=-256;
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
  return;
}

void fep256sub(fep256 *c, fep256 *a, fep256 *b){
  fep256 t;
  fep256neg(&t, b);
  fep256add(c, a, &t);
  return;
}

void fep256setzero(fep256 *a){
  for(int i=0; i<11; i++){
    a->c[i]=0;
  }
  return;
}

void fep256setone(fep256 *b){
  fep256setzero(b);
  b->c[0]=1;
  return;
}

void fep256cmov(fep256 *c, fep256 *a, unsigned char b){
  //b either 0 or 1.
  for(int i=0; i<11; i++){
    c->c[i]=(b-1)*(c->c[i])+b*(a->c[i]);
  }
  return;
}
void fep256mul2to24(fep256 *c, fep256 *a){
  //if a is reduced, c is a*2^24 mod prime
  //current method is doing it in 24 2^1 chuncks.
  fep256cmov(c, a, 1);
  reduce(c);
  for(int i=0; i<24; i++){
    for(int j=0; j<11; j++){
      c->c[i]*=2;
    }
    reduce(c);
  }
  reduce(c);
  return;
}
void fep256mul(fep256 *c, fep256 *a, fep256 *b){
  uint64_t twoto24 = 1<<24;
  uint64_t prod[22]; //product will fit in here
  uint64_t carry;
  for(int i=0; i<22; i++){
    prod[i]=0;
  }

  for(int i=0; i<11; i++){
    for(int j=0; j<11; j++){
      prod[i+j]+=(a->c[i])*(b->c[j]);
    }
  }
  //That was easy: but we still have to do reductions mod p and carries.
  //the low 11 limbs are good, but the top 10 need to be brought down
  //but first let's do some carrying to make them reasonable size.
  //(for speed can omit this sometimes, but 2^224 makes that a bit tough here)
  carry=0;
  for(int i=0; i<22; i++){
    prod[i]+=carry;
    carry = prod[i]&(twoto24-1);
    carry >>=24;
  }
  //carry is now 0: the top limb was zero before we carried into it.
  //at this point we multiply and add. this is a slow method, but it works.
  fep256setzero(c);
  for(int i=0; i<22; i++){
    fep256mul2to24(c, c);
    c->c[0]+=prod[21-i];
  }
  return;
}
