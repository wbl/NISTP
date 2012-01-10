#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "garith.h"

int main(int argc, int argv[]){
  /*Plan: test multiplication by creating table of powers of some element.*/
  /*Have sage verify the correctness*/
  gf2128 elt;
  gf2128 pow;
  unsigned char coeffs[128];
  bzero(coeffs,128);
  coeffs[1]=1;
  gf2128loadcoeffs(&elt, coeffs);
  gf2128zero(&pow);
  gf2128add(&pow, &pow, &elt);
  printf("xpows=[");
  for(int i=1; i<1024; i++){
    gf2128packcoeffs(coeffs, &pow);
    for(int j=0; j<127; j++){
      printf("%01x*x^%d+", coeffs[j], j);
    }
    printf("%01x*x^127,\n", coeffs[127]);
    gf2128mul(&pow, &pow, &elt);
  }
  printf("]");
  exit(0);
}
