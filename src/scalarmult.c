#include <stdint.h>
#include "fep256.h"
#include "curve.h"
#include "scalarmult.h"

void crypto_scalarmult_nistp256_base(unsigned char *q, const unsigned char *n){
  point temp;
  p256scalarmult_base(&temp, n);
  p256pack(q, &temp);
  return;
}

void crypto_scalarmult_nistp256(unsigned char *q, const unsigned char *n,
                                const unsigned char *p){
  point temp;
  p256unpack(&temp, p);
  if(!p256oncurvefinite(&temp)){ //we don't have a good point
    crypto_scalarmult_nistp256_base(q, n); //use the basepoint instead
    return;
  }
  p256scalarmult(&temp, &temp, n);
  p256pack(q, &temp);
  return;
}
