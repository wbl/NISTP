#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "fep256.h"
void outputpoly (fep256 *t){
  for(int i=0; i<10; i++){
    printf("%lld*2^(24*%d)+", t->c[i], i);
  }
  printf("%lld*2^240", t->c[10], 10);
}

int main(){
  //test fep256.h by creating a script of equations that should hold
  fep256 b;
  fep256 c;
  fep256setzero(&c);
  fep256setone(&b);
  printf("p=2^256-2^224+2^192+2^96-1\n");
  for(int i=1; i<1024; i++){
    printf("print(Mod(%d, p)==Mod(", i);
    fep256add(&c, &c,&b);
    outputpoly(&c);
    printf(",p))\n");
  }
  printf("quit()\n");
  exit(0);
}
    
