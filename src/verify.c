/*return nonzero when twh things nonequal*/
int verify16(const char *y, const char *x){
  int res =0;
  for(int i=0; i<16; i++)
    res |= (y[i]^x[i]);
  return res;
}
int verify32(const char *y, const char *x){
  int res=0;
  for(int i=0; i<32; i++){
    res |=(y[i]^x[i]);
  }
  return res;
}
