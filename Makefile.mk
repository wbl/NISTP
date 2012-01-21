VPATH = ../test:../src
CC = gcc -g
CCOPTS = -std=c99 -fPIC
IOPTS = -I../src -I../test -I/opt/local/include
LOPTS = -L/opt/local/lib
LINK = -ltomcrypt
%.o: %.c
	$(CC) $(CCOPTS) $(IOPTS)  -c $? -o $@
% : %.o
	$(CC) $(IOPTS) $(LOPTS) $(LINK) $^ -o $@
all: test libnistp.a libnistp.so
test: garithtest ctrtest aestest aes256gcmtest gpacktest fep256test curvetest
aes256gcmtest: aes256gcmtest.o aes256gcm.o aes256gcmtom.o rijndael.o ctr.o ghash.o unload64.o load64.o garith.o verify.o
ctrtest: ctrtest.o ctr.o rijndael.o
aestest: aestest.o rijndael.o
garithtest: garithtest.o garith.o
gpacktest: gpacktest.o garith.o
fep256test: fep256.o fep256test.o randombytes.o
curvetest: curvetest.o randombytes.o curve.o fep256.o
libnistp.a: ctr.o rijndael.o garith.o aes256gcm.o secretbox.o ghash.o unload64.o load64.o verify.o fep256.o
	ar -r $@ $^
libnistp.so: ctr.o rijndael.o garith.o aes256gcm.o secretbox.o ghash.o unload64.o load64.o verify.o fep256.o
	$(CC) -shared $(IOPTS) $(LOPTS) -o $@ $^
.PHONY : all
.PHONY : test