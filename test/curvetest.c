#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "fep256.h"
#include "curve.h"
#include "randombytes.h"

int main(){
  unsigned char exp1[32];
  unsigned char exp2[32];
  point p1;
  point p2;
  unsigned char res1[64];
  unsigned char res2[64];
  printf("start\n"); //use the awk script: makes life easy
  printf("oncurve section\n");
  for(int i=0; i<10; i++){
    randombytes(exp1, 32);
    p256scalarmult_base(&p1, exp1);
    if(!p256oncurvefinite(&p1)){
      printf("0\n");
    }else {
      printf("1\n");
    }
  }
  printf("dh section\n");
  
}
