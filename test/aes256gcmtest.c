#include<stdio.h>
#include<strings.h>
#include<stdlib.h>
#include "aes256gcm.h"
#include "aes256gcmtom.h"
int main(int argc, char *argv[]){
  /*The idea is simple: take sample messages, keys and nonces and see
    if we get the same answers.*/
  unsigned char key[16]={0x00, 0x00, 0x00, 0x00,
                         0x00, 0x00, 0x00, 0x00,
                         0x00, 0x00, 0x00, 0x00,
                         0x00, 0x00, 0x00, 0x00};
  unsigned char m[256];
  bzero(m, 32);
  unsigned char mlen=200; //test overflow
  unsigned char c1[256];
  unsigned char c2[256];
  bzero(c1, 32);
  bzero(c2, 32);
  unsigned char nonce[12]={0x00, 0x00, 0x00, 0x00,
                           0x00, 0x00, 0x00, 0x00,
                           0x00, 0x00, 0x00, 0x00};
  int failure;
  aes256gcmcrypt(c1, m, mlen, nonce, key);
  aes256gcmtomcrypt(c2, m, mlen, nonce, key);
  printf("start\n");
  printf("section box");
  failure=memcmp(c1,c2,32);
  if(failure){
    printf("0\n");
  }else {
    printf("1\n");
  }
  if(aes256gcmdecrypt(m, c2, mlen, nonce, key)){ /*someone else made it*/
    printf("0\n");
  }else {
    printf("1\n");
  }
  c2[1]^=1; /*Screw stuff*/
  if(! aes256gcmdecrypt(m, c2, mlen, nonce, key)){
    printf("0\n");
  }else {
    printf("1\n");
  }
  exit(0);
}
