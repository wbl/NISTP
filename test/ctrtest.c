#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<tomcrypt.h>
#include "ctr.h"

int main(int argc, char *argv[]){
  /* Similar situation as before,
     only the test vector is more complex.*/
  unsigned char key[32];
  bzero(key, 32);
  unsigned char initcount[16];
  bzero(initcount,16);
  initcount[15]=1; //For test usage
  unsigned char input[32];
  bzero(input, 32);
  unsigned char output[32]; //counter mode: assume xor works
  bzero(output, 32);
  aes256ctr(output, input, 32, key, initcount);
  for(int i=0; i<32; i++) printf("%02x ", output[i]);
  printf("\n");
  symmetric_CTR ctr;
  bzero(output, 32);
  register_cipher(&aes_desc);
  ctr_start(find_cipher("aes"), initcount, key, 32, 0, CTR_COUNTER_BIG_ENDIAN,
            &ctr);
  ctr_encrypt(input, output, 32, &ctr);
  ctr_done(&ctr);
  for(int i=0; i<32; i++) printf("%02x ", output[i]);
  printf("\n");
  exit(0);
}
