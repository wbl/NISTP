#include<stdio.h>
#include<stdlib.h>
#include "hash.h"
int main(){
  /*Test vector from wikipedia entry on SHA-2*/
  unsigned char h[64];
  crypto_hash(h, "The quick brown fox jumps over the lazy dog.",44 );
  for(int i=0; i<64; i++){
    printf("%02x", h[i]);
  }
  exit(0);
}
