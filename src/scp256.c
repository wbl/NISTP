#include "scp256.h"
/* arithmetic modulo the group of order
   11579208921035624876269744694940757352999695522413576034242225906106851204436 */
//we use little endian*/
/*The modulus*/
const unsigned char m[32]={84, 29, 61, 25, 173, 250, 248, 177, 115, 41, 79,
                           42, 222, 229, 227, 146, 153, 153, 153, 153, 153,
                           153, 153, 25, 128, 153, 153, 153, 25};
/*The constant for barrett reduction*/
/*See HAC 14.42 for details */
const unsigned char mu[33]={74, 24, 188, 84, 59, 231, 223, 11, 74, 57,
                            8, 183, 60, 53, 250, 158, 248, 255, 255, 
                            255, 245, 255, 255, 255, 255, 255, 255, 
                            255, 9, 0, 0, 0, 0};
/*Much of the following code is inspired by the methods of crypto_sign/sc25519*/
/*However, much of that file is unexplained, so I'm not simply going to copy and past
  it. It also lacks some things we need like subtraction. That said, the algorithms
  will look similar*/

void reduce_add_sub(scp256 *c){
  /*assumptions: c->v[i]<256 for all i.*/
  int borrow=0;
  int prev_borrow=0;
  int no_reduce=0;
  unsigned int t[32];
  /*We calculate a subtraction. Borrow indicates whether we need to borrow
    this time or not. prev_borrow indicates whether we had to brorrow.
    If at the last subtraction we needed to borrow, our number was less then the
    modulus, so, we shouldn't have reduced it at all. t stores the difference */
  for(int i=0; i<32; i++){
    borrow=(c->v[i]<prev_borrow+m[i]);
    t[i]=c->v[i]-prev_borrow-m[i]+256*borrow;
    prev_borrow=borrow;
  }
  no_reduce=1-prev_borrow;
  for(int i=0; i<32; i++){ //get used to this idiom.
    c->v[i]=c->v[i]*prev_borrow+t[i]*no_reduce;
  }
}

void barrett_reduce(scp256 *r, unsigned int x[64]){
  /*What follows can be losely described as black magic. HAC doesn't go into the
    explanation, so I will.
    We can easily divide by 256^k for any k. The challenge is to turn this into division
    by m. mu=\floor{\frac{256^64}{m}}. If we divide by 256^64 and multiply by mu, we've
    divided by m.
    HAC 14.42 is Barrett Reduction, an algorithm for modular reduction that uses this
    observation. I don't really want to explain all the details, but I'll be
    a bit more illuminating then sc25519.c is.*/
  int b=0, pb=0; //the borrows for a subtraction.
  unsigned int q1[33]; //k=32. We need to divide by 256^31, leaving 33 words over
  unsigned int q2[66]={0}; //The product of 2 33 word numbers.
  unsigned int q3[33]; //Top 33 words of q2.
  unsigned int r1[33];
  unsigned int r2[33]={0};
  unsigned int carry=0;
  /*Overview of the algorithm: q1<-\floor{x/b^{k-1}}, q_2<-q1*\mu, 
    q_3<-\floor{q_2/b^{k+1}}. q1 isn't explicitly calculated here, and q3
    is just a pointer to the high half of q2.
    
    r_1 <- x mod(b^{k+1}), r_2<-q_3*m mod(b^{k+1}).
    r<-r_1-r_2
    If r<0, add b^{k+1} to it.
    
    This algorithm produces an r that is within [0, 3m). We therefore need to
    do only 2 reduction steps. The proof is omitted, but isn't that hard*/
  for(int i=0; i<33; i++){
    q1[i]=x[i+31]; //copy the high words, dividing by 256^31
  }
  for(int i=0; i<33; i++){
    for(int j=0; j<33; j++){
      q2[i+j] += q1[i]*q2[j];
    }
  }
  for(int i=0; i<65; i++){
    carry=q2[i]>>8;
    q2[i+1]+=carry;
    q2[i] &=0xff;
  }
  //we have now calculated q2, and done the carries.
  for(int i=0; i<33; i++){
    q3[i]=q2[i+33]; //copy the high words, dividing by 256^33
  }
  for(int i=0; i<33; i++){
    r1[i]=x[i];
  }
  for(int i=0; i<33; i++){
    for(int j=0; j<32; j++){
      if(i+j<33){
        r2[i+j] += m[j]*q3[i];
      }
    }
  }
  //we still need to do the carrying on r2 before we subtract.
  carry=0;
  for(int i=0; i<32; i++){
    carry = r2[i]>>8;
    r2[i+1]+=carry;
    r2[i]&=0xff;
  }
  //time to subtract, same as above
  for(int i=0; i<32; i++){
    b=(r1[i]<pb+r2[i]);
    r->v[i]=r1[i]-pb-r2[i]+b*256;
    pb=b;
  }
  //now, what happens if r<0, or in other words pb=1 right now?
  //we need to add b^{k+1}. But we already have by borrowing.
  //at most 2 reductions needed
  reduce_add_sub(r);
  reduce_add_sub(r);
}

//these are big endian input and output
void scp256_unpack(scp256 *r, unsigned char x[32]){
  unsigned int t[64]={0};
  for(int i=0; i<32; i++){
    r->v[31-i]=x[i];
  }
  reduce_add_sub(r);
}

void scp256_pack(unsigned char x[32], scp256 *r){
  for(int i=0; i<32; i++){
    x[i]=r->v[31-i];
  }
}

//now for arithmetic.
void scp256_add(scp256 *c, scp256 *a, scp256 *b){
  int carry=0;
  for(int i=0; i<31; i++){
    c->v[i]=a->v[i]+b->v[i]+carry;
    carry=c->v[i]>>8;
    c->v[i]&=0xff;
  }
  c->v[31]=a->v[31]+b->v[31]+carry;
  reduce_add_sub(c);
}

void scp256_sub(scp256 *c, scp256 *a, scp256 *b){
  int carry=0;
  //recall, already reduced
  for(int i=0; i<32; i++){
    c->v[i]=a->v[i]+(m[i]-b->v[i]);
  }
  for(int i=0; i<31; i++){
    carry=c->v[i] >>8;
    c->v[i+1]+=carry;
    c->v[i] &=0xff;
  }
  //carry=0 as top part is less then 25.
  reduce_add_sub(c);
}


