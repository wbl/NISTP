#include<stdio.h>
#include<strings.h>
#include<stdlib.h>
#include "schnorr.h"
int main(){
  unsigned char sk[64];
  unsigned char pk[64];
  unsigned char *m = strdup("Hello World!");
  unsigned char *sm=malloc(strlen(m)+65);
  unsigned long long smlen;
  unsigned long long mlen=strlen(m)+1;
  crypto_sign_keypair_nistp256schnorr(pk, sk);
  crypto_sign_nistp256schnorr(sm, &smlen, m, mlen, sk);
  if(crypto_sign_open_nistp256schnorr(m, &mlen, sm, smlen, pk)){
    printf("Opening failed!\n");
  }else{
    printf("%s\n", m);
  }
  exit(0);
}
