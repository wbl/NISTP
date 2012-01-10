VPATH = ../test:../src
CC = gcc -g
CCOPTS = -std=c99
IOPTS = -I../src -I../test -I/opt/local/include
LOPTS = -L/opt/local/lib
LINK = -ltomcrypt
%.o: %.c
	$(CC) $(CCOPTS) $(IOPTS)  -c $? -o $@
% : %.o
	$(CC) $(IOPTS) $(LOPTS) $(LINK) $^ -o $@
all: test
test: garithtest ctrtest aestest aes256gcmtest
aes256gcmtest: aes256gcmtest.o aes256gcm.o aes256gcmtom.o rijndael.o ctr.o ghash.o unload64.o load64.o garith.o
ctrtest: ctrtest.o ctr.o rijndael.o
aestest: aestest.o rijndael.o
garithtest: garithtest.o garith.o
.PHONY : all
.PHONY : test