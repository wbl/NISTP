void unload64(unsigned char *y, unsigned long long x){
  *y++=x;
  x>>=8;
  *y++=x;
  x>>=8;
  *y++=x;
  x>>=8;
  *y++=x;
  x>>=8;
  *y++=x;
  x>>=8;
  *y++=x;
  x>>=8;
  *y++=x;
  x>>=8;
  *y++=x;
}
