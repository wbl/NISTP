VPATH = ../test:../src
CC = gcc -ggdb
CCOPTS = -std=c99 -fPIC -O3 -funroll-loops -m64
IOPTS = -I../src -I../test -I/opt/local/include
LOPTS = -L/opt/local/lib
LINK = -ltomcrypt
%.o: %.c
	$(CC) $(CCOPTS) $(IOPTS)  -c $? -o $@
% : %.o
	$(CC) $(CCOPTS) $(IOPTS) $(LOPTS) $(LINK) $^ -o $@
all: test libnistp.a
test: garithtest ctrtest aestest aes256gcmtest gpacktest fep256test curvetest scalarmulttest boxtest scp256test
aes256gcmtest: aes256gcmtest.o aes256gcm.o aes256gcmtom.o rijndael.o ctr.o ghash.o unload64.o load64.o garith.o verify.o
ctrtest: ctrtest.o ctr.o rijndael.o
aestest: aestest.o rijndael.o
garithtest: garithtest.o garith.o
gpacktest: gpacktest.o garith.o
fep256test: fep256.o fep256test.o randombytes.o
curvetest: curvetest.o randombytes.o curve.o fep256.o
scalarmulttest: scalarmult.o curve.o randombytes.o scalarmulttest.o fep256.o
boxtest: boxtest.o box.o scalarmult.o curve.o secretbox.o ghash.o garith.o aes256gcm.o unload64.o load64.o verify.o rijndael.o ctr.o fep256.o randombytes.o
scp256test: scp256.o scp256test.o randombytes.o
libnistp.a: ctr.o rijndael.o garith.o aes256gcm.o secretbox.o ghash.o unload64.o load64.o verify.o fep256.o scalarmult.o curve.o box.o
	ar -r $@ $^
.PHONY : all
.PHONY : test