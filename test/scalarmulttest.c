#include "scalarmult.h"
#include "randombytes.h"
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
int main(){
  unsigned char alicesk[32];
  unsigned char alicepk[64];
  unsigned char bobsk[32];
  unsigned char bobpk[64];
  unsigned char bobsec[64];
  unsigned char alicesec[64];
  printf("start\n");
  printf("DH section\n");
  for(int i=0; i<10; i++){
    randombytes(alicesk, 32);
    randombytes(bobsk, 32);
    crypto_scalarmult_nistp256_base(alicepk, alicesk);
    crypto_scalarmult_nistp256_base(bobpk, bobsk);
    crypto_scalarmult_nistp256(bobsec, bobsk, alicepk);
    crypto_scalarmult_nistp256(alicesec, alicesk, bobpk);
    if(memcmp(bobsec, alicesec, 64)){
      printf("0\n");
    }else {
      printf("1\n");
    }
  }
}
