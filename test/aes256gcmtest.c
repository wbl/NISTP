#include<stdio.h>
#include<strings.h>
#include "aes256gcm.h"
#include "aes256gcmtom.h"
int main(int argc, char *argv[]){
  /*The idea is simple: take sample messages, keys and nonces and see
    if we get the same answers.*/
  unsigned char key[16]={0x00, 0x00, 0x00, 0x00,
                         0x00, 0x00, 0x00, 0x00,
                         0x00, 0x00, 0x00, 0x00,
                         0x00, 0x00, 0x00, 0x00};
  unsigned char m[32];
  bzero(m, 32);
  m[16]=1;
  unsigned char mlen=32;
  unsigned char c1[32];
  unsigned char c2[32];
  unsigned char nonce[12]={0x00, 0x00, 0x00, 0x00,
                           0x00, 0x00, 0x00, 0x00,
                           0x00, 0x00, 0x00, 0x00};
  int failure;
  aes256gcmcrypt(c1, m, mlen, nonce, key);
  aes256gcmtomcrypt(c2, m, mlen, nonce, key);
  failure=memcmp(c1,c2,32);
  if(failure){
    printf("failure!\n");
    for(int i=0; i<32; i++)
      printf("%02x ", c1[i]);
    printf("\n");
    for(int i=0; i<32; i++)
      printf("%02x ", c2[i]);
    printf("\n");
  }else {
    printf("success!\n");
  }
  exit(0);
}
