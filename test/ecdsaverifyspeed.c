#include<stdio.h>
#include<strings.h>
#include<stdlib.h>
#include "ecdsa.h"
int main(){
  unsigned char sk[64];
  unsigned char pk[64];
  unsigned char *m = strdup("Hello World!");
  unsigned char *sm=malloc(strlen(m)+65);
  unsigned long long smlen;
  unsigned long long mlen=strlen(m)+1;
  crypto_sign_keypair_ecdsa256sha512(pk, sk);
  crypto_sign_ecdsa256sha512(sm, &smlen, m, mlen, sk);
  for(int i=0; i<10000; i++)
    crypto_sign_open_ecdsa256sha512(m, &mlen, sm, smlen, pk);
  printf("10000 verifications complete\n");
  exit(0);
}
