#include<stdio.h>
#include<strings.h>
#include<stdlib.h>
#include "aes.h"
int main(int argc, char *argv[]){
  /*
   * Figure out how to read the test vectors and use them
   * to validate AES. For now just a hardcoded one.
   */
  unsigned int space[60];
  unsigned char key[32];
  unsigned char pt[16];
  unsigned char ct[16];
  memset(key, 0x00, 32);
  bzero(space, 60);
  bzero(pt, 16);
  aeskey(space, key);
  aescrypt(ct, pt, space);
  for(int i=0; i<16; i++){
    printf("%02x", ct[i]);
  }
  printf("\n");
  exit(0);
}
