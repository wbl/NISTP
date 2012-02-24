#include<stdio.h>
#include "scp256.h"
#include "randombytes.h"
void hexprint(unsigned char a[32]){
  for(int i=0; i<32; i++){
    printf("%02x", a[i]);
  }
}

void modmprint(unsigned char a[32]){
  printf("Mod(hex(\"");
  hexprint(a);
  printf("\"),m)");
}

int main(){
  scp256 a;
  scp256 b;
  scp256 c;
  unsigned char abytes[32];
  unsigned char bbytes[32];
  unsigned char cbytes[32];
  printf("m=115792089210356248762697446949407573529996955224135760342422259061068512044369\n");
  printf("hex(s) =\n { local(v=Vec(s), a=10,b=11,c=12,d=13,e=14,f=15,\n \
                      A=10,B=11,C=12,D=13,E=14,F=15, h);\n              \
      for(i=1,#v,h = (h<<4) + eval(v[i])); h\n \
    }\n\n");
  printf("print(\"start\")\n");
  printf("print(\"identity section\")\n");
  for(int i=0; i<10; i++){
    randombytes(abytes, 32);
    scp256_unpack(&a, abytes);
    printf("print(");
    modmprint(abytes);
    printf("==");
    scp256_pack(abytes, &a);
    modmprint(abytes);
    printf(")\n");
  }
}
