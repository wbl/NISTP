#include<string.h>
#include<stdio.h>
#include "ctr.h"
#include "aes.h"
void incr(unsigned char *block);
void aes256ctr(unsigned char *out, unsigned char *in,
               unsigned long long len, unsigned char *key,
               unsigned char *icb){
  unsigned int state[AES_STATEINTS];
  unsigned char inblock[16];
  unsigned char tempblock[16];
  unsigned long long  place;
  memcpy(inblock, icb, 16);
  aeskey(state, key);
  for(place=0; place+15<len; place+=16){
    aescrypt(tempblock, inblock, state);
    for(int i=0; i<16; i++){
      out[place+i]=in[place+i]^tempblock[i];
    }
    incr(inblock);
  }
  aescrypt(tempblock, inblock, state);
  for(int i=0; i+place<len; i++)/*we might have a spare byte*/
    out[place+i]=in[place+i]^tempblock[i];
  for(int i=0; i<AES_STATEINTS; i++){
    state[i]=0; //zeroize secret data
  }
  bzero(tempblock, 16); //zeroize secret data
}
void incr(unsigned char block[16]){
  /*Can be nonconstant time: attacker knows what we did here.*/
  block[15]++;
  if(block[15]==0){
    block[14]++;
    if(block[14]==0){
      block[13]++;
      if(block[13]==0){
        block[12]++;
      }
    }
  }
}
