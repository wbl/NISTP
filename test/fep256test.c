#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdint.h>
#include "fep256.h"
#include "randombytes.h"
/*This outputs tests for GP. I really should use dc*/
void hexprint( unsigned char *bytes, unsigned int len){
  for(int i=0; i<len; i++){
    printf("%02x", bytes[i]);
  }
}

void modpprint(unsigned char *bytes){
  printf("Mod(hex(\"");
  hexprint(bytes, 32);
  printf("\"),p)");
}


int main(){
  fep256 a;
  fep256 b;
  fep256 c;
  unsigned char achar[32];
  unsigned char bchar[32];
  unsigned char cchar[32];
  unsigned char temp[32];
  printf("print(\"start\")\n");
  printf("p=2^256-2^224+2^192+2^96-1\n");
  printf("hex(s) =\n { local(v=Vec(s), a=10,b=11,c=12,d=13,e=14,f=15,\n \
                      A=10,B=11,C=12,D=13,E=14,F=15, h);\n \
      for(i=1,#v,h = (h<<4) + eval(v[i])); h\n \
    }\n\n");
  /*First let's test import and export */
  printf("print(\"identity assertions\")\n");
  for(int i=0; i<10; i++){
    randombytes(temp, 32);
    fep256unpack(&a, temp);
    printf("print(");
    modpprint(temp);
    printf("==");
    fep256pack(temp, &a);
    modpprint(temp);
    printf(")\n");
  }
  printf("print(\"addition section\")\n");
  for(int i=0; i<10; i++){
    randombytes(achar, 32);
    randombytes(bchar, 32);
    fep256unpack(&a, achar);
    fep256unpack(&b, bchar);
    fep256add(&c, &a, &b);
    fep256pack(cchar, &c);
    printf("print(");
    modpprint(achar);
    printf("+");
    modpprint(bchar);
    printf("==");
    modpprint(cchar);
    printf(")\n");
  }
  printf("print(\"subtraction section\")\n");
  for(int i=0; i<10; i++){
    randombytes(achar, 32);
    randombytes(bchar, 32);
    fep256unpack(&a, achar);
    fep256unpack(&b, bchar);
    fep256sub(&c, &a, &b);
    fep256pack(cchar, &c);
    printf("print(");
    modpprint(achar);
    printf("-");
    modpprint(bchar);
    printf("==");
    modpprint(cchar);
    printf(")\n");
  }
  printf("print(\"multiplication section\")\n");
  for(int i=0; i<10; i++){
    randombytes(achar, 32);
    randombytes(bchar, 32);
    fep256unpack(&a, achar);
    fep256unpack(&b, bchar);
    fep256mul(&c, &a, &b);
    fep256pack(cchar, &c);
    printf("print(");
    modpprint(achar);
    printf("*");
    modpprint(bchar);
    printf("==");
    modpprint(cchar);
    printf(")\n");
  }
  printf("print(\"inversion section\")\n");
  for(int i=0; i<10; i++){//hope we don't get divison by zero. odds small.
    randombytes(achar, 32);
    fep256unpack(&a, achar);
    fep256inv(&b, &a);
    fep256pack(bchar, &b);
    printf("print(");
    modpprint(achar);
    printf("*");
    modpprint(bchar);
    printf("==Mod(1,p))\n");
  }
  /*Still need to test setone setzero iszero*/
  /*I think they will be okay*/
  printf("print(\"cmov section\")\n");
  randombytes(achar, 32);
  fep256unpack(&a, achar);
  fep256cmov(&b, &a, 1);
  fep256pack(bchar, &b);
  fep256pack(achar, &a);
  printf("print(");
  modpprint(achar);
  printf("==");
  modpprint(bchar);
  printf(")\n");
  printf("quit()\n");
  exit(0);
}
