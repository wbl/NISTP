#include "scalarmult.h"
#include "randombytes.h"
#include <stdio.h>
#include <stdlib.h>
int main(){
  unsigned char alicesk[32];
  unsigned char alicepk[64];
  unsigned char bobsk[32];
  unsigned char bobpk[64];
  unsigned char bobsec[64];
  unsigned char alicesec[64];
  randombytes(alicesk, 32);
  randombytes(bobsk, 32);
  for(int i=0; i<5000; i++){
    crypto_scalarmult_nistp256_base(alicepk, alicesk);
    crypto_scalarmult_nistp256_base(bobpk, bobsk);
    crypto_scalarmult_nistp256(bobsec, bobsk, alicepk);
    crypto_scalarmult_nistp256(alicesec, alicesk, bobpk);
  }
  printf("20000 DH operations\n");
}
