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
  fep256 a;
  fep256 b;
  fep256 c;
  fep256setzero(&c);
  fep256setone(&b);
  printf("p=2^256-2^224+2^192+2^96-1\n");
  printf("print(\"plus assertions\")");
  printf("/* plus asserts*/\n");
  for(int i=1; i<1024; i++){
    printf("if(Mod(%d, p)<>Mod(", i);
    fep256add(&c, &c,&b);
    outputpoly(&c);
    printf(",p), print(%d))\n",i);
  }
  //now to test subtraction:
  printf("/*sub asserts*/\n");
  printf("print(\"sub assertions\")\n");
  fep256setzero(&c);
  fep256setone(&b);
  fep256setzero(&a);
  for(int i=1; i<1024; i++){
    printf("if(Mod(-%d, p)<>Mod(", i);
    fep256sub(&a, &a, &b);
    outputpoly(&a);
    printf(",p), print(%d))\n", i);
  }
  printf("/*mul2to24 asserts*/");
  printf("print(\"mul2to24 assertions\")\n");
  for(int i=0; i<1024; i++){
    printf("if(Mod(2^(24*%d), p)<>Mod(", i);
    outputpoly(&b);
    printf(",p), print(%d))\n", i);
    fep256mul2to24(&b, &b);
  }

  printf("quit\n");
  exit(0);
}
