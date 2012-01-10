#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "garith.h"
int main(int argc, char *argv[]){
  gf2128 test;
  unsigned int flag=0;
  unsigned char coeffs[128];
  unsigned char packvec[16]={0x01,0x02,0x03,0x04,
                             0x05,0x06,0x07,0x08,
                             0x09,0x0a,0x0b,0x0c,
                             0x0d,0x0e,0x0f,0x10};
  unsigned char testvec[16];
  gf2128unpack(&test, packvec);
  gf2128pack(testvec, &test);
  gf2128packcoeffs(coeffs, &test);
  for(int i=0; i<16; i++){
    if(packvec[i]!=testvec[i]){
      flag =1;
    }
  }
  if(flag){
    printf("Identity Failure!\n");
  }else {
    printf("Identity Success!\n");
  }
  for(int i=0; i<127; i++){
    printf("%01x*x^%d+", coeffs[i], i);
  }
  printf("%01x*x^127\n", coeffs[127]);
  exit(0);
}
