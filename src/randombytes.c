#include "randombytes.h"
#include <fcntl.h>
void randombytes(unsigned char *bytes, unsigned int len){
  /*Assuming no errors*/
  int fd;
  int temp;
  fd=open("/dev/random", O_RDONLY);
  while(len){
    temp=read(fd, bytes, len);
    fd += temp;
    len -= temp;
  }
}
