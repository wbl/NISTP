#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "garith.h"
int main(int argc, char *argv[]){
  gf2128 test;
  unsigned int flag=0;
  unsigned char packvec[16]={0x01,0xf0,0x0f,0xde,
                             0xad,0xbe,0xef,0xde,
                             0xad,0xbe,0xef,0x77,
                             0xab,0xcd,0xef,0x12};
  unsigned char testvec[16];
  gf2128unpack(&test, packvec);
  gf2128pack(testvec, &test);
  for(int i=0; i<16; i++){
    if(packvec[i]!=testvec[i]){
      flag =1;
    }
  }
  if(flag){
    printf("Failure!\n");
  }else {
    printf("Success!\n");
  }
  exit(0);
}
