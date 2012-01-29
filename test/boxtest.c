#include <stdio.h>
#include <string.h>
#include "box.h"
#include "randombytes.h"
int main(){
  char message[] = "Hello World!\n";
  char *mtext = malloc(sizeof(message)+16);
  char *ctext = malloc(sizeof(message)+16);
  unsigned long long mlen = sizeof(message)+16;
  char pk[64];
  char sk[32];
  char nonce[8];
  bzero(nonce, 8);
  crypto_box_nistp256aes256gcm_keypair(pk, sk);
  memcpy(mtext+16, message, sizeof(message));
  crypto_box_nistp256aes256gcm(ctext, mtext, mlen, nonce, pk, sk);
  if(crypto_box_nistp256aes256gcm_open(mtext, ctext, mlen, nonce, pk, sk)){
    printf("Failed!\n");
  }else{
    printf("%s", mtext+16);
  }
  return 0;
}
