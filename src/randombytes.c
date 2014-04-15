#include "randombytes.h"
#include <fcntl.h>
#include <unistd.h>
void randombytes(unsigned char *bytes, unsigned int len){
  int fd=-1;
  int temp;
  while(fd==-1){
    fd=open("/dev/random", O_RDONLY);
  }
  while(len){
    temp=read(fd, bytes, len);
    bytes += temp;
    len -= temp;
  }
  close(fd);
}
