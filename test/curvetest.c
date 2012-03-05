#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "fep256.h"
#include "curve.h"
#include "randombytes.h"

int main(){
  unsigned char exp[32];
  point temp;
  unsigned char otherexp[32];
  point b;
  point basepoint;
  printf("start\n");
  printf("exp section\n");
  for(int i=0; i<10; i++){
    //note that in future this will be wrapped up as scalarmult
    randombytes(exp, 32);
    p256scalarmult_base(&temp, exp);
    if(p256oncurvefinite(&temp)){
      printf("1\n");
    }else{
      printf("0\n");
    }
  }
  exit(0);
}
