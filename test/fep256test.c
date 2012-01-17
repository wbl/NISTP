#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "fep256.h"
void outputpoly (fep256 *t){
  for(int i=0; i<10; i++){
    printf("%lld*2^(24*%d)+", t->c[i], i);
  }
  printf("%lld*2^240\n", t->c[10], 10);
}

int main(){
  //test fep256.h
  fep256 a;
  fep256 b;
  fep256 c;
  fep256setzero(&a);
  fep256setone(&b);
  fep256add(&c, &a,&b);
  outputpoly(&c);
  exit(0);
}
    
