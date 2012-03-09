#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "fep256.h"
#include "curve.h"
#include "scp256.h"
int main(){
  point p;
  unsigned char exp[32]={0, 211, 216, 143, 5, 130, 69, 158, 239,
                         207, 161, 203, 214, 71, 167, 161, 224, 34,
                         186, 100, 243, 209, 97, 245, 169, 119, 162, 
                         242, 166, 27, 103, 98};
   unsigned char out[64];
  p256scalarmult_base(&p, exp);
  printf("exp=0x");
  for(int i=0; i<32; i++){
    printf("%02x", exp[i]);
  }
  printf("\n");
  p256pack(out, &p);
  printf("x=0x");
  for(int i=0; i<32; i++){
    printf("%02x", out[i]);
  }
  printf("\n");
  printf("y=0x");
  for(int i=32; i<64; i++){
    printf("%02x", out[i]);
  }
  printf("\n");
  exit(0);
}
