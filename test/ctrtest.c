#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "ctr.h"

int main(int argc, char *argv[]){
  /* Similar situation as before,
     only the test vector is more complex.*/
  unsigned char key[32]={0x60, 0x3d, 0xeb, 0x10,
                         0x15, 0xca, 0x71, 0xbe,
                         0x2b, 0x73, 0xae, 0xf0,
                         0x85, 0x7d, 0x77, 0x81,
                         0x1f, 0x35, 0x2c, 0x07,
                         0x3b, 0x61, 0x08, 0xd7,
                         0x2d,  0x98, 0x10, 0xa3,
                         0x09, 0x14, 0xdf, 0xf4
  };
  
  unsigned char initcount[16]={0xf0, 0xf1, 0xf2, 0xf3,
                               0xf4, 0xf5, 0xf6, 0xf7,
                               0xf8, 0xf9, 0xfa, 0xfb,
                               0xfc, 0xfd, 0xfe, 0xff
  };
  unsigned char input[32*4];
  bzero(input, 32*4);
  unsigned char output[32*4]; //counter mode: assume xor works
  aes256ctr(output, input, 32*4, key, initcount);
  for(int i=0; i<32*4; i++){printf("%02x", output[i]);
  }
  exit(0);
}
