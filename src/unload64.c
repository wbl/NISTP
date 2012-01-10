void unload64(unsigned char *y, unsigned long long x){
  y[7]=x;
  x>>=8;
  y[6]=x;
  x>>=8;
  y[5]=x;
  x>>=8;
  y[4]=x;
  x>>=8;
  y[3]=x;
  x>>=8;
  y[2]=x;
  x>>=8;
  y[1]=x;
  x>>=8;
  y[0]=x;
}
