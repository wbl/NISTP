unsigned long long load64(const char *y){
  unsigned long long r=0;
  r = y[7];
  r <<=8;
  r |= y[6];
  r <<=8;
  r |= y[5];
  r <<=8;
  r |= y[4];
  r <<=8;
  r |= y[3];
  r <<=8;
  r |= y[2];
  r<<=8;
  r |=y[1];
  r<<=8;
  r |=y[0];
  return r;
}
