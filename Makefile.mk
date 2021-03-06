VPATH = ../test:../src
CC = clang-mp-3.5 -ggdb
CCOPTS = -std=c99 -fPIC -O3 -funroll-loops -m64
IOPTS = -I../src -I../test -I/opt/local/include
LOPTS = -L/opt/local/lib
LINK = -ltomcrypt
TESTS=garithtest ctrtest aestest aes256gcmtest gpacktest fep256test curvetest scalarmulttest boxtest scp256test hashtest ecdsatest curveknown schnorrtest
SPEED=ecdsaspeed ecdsaverifyspeed scalarmultspeed schnorrsignspeed schnorrverifyspeed
%.o: %.c
	$(CC) $(CCOPTS) $(IOPTS)  -c $^ -o $@
% : %.o
	$(CC) $(CCOPTS) $(IOPTS) $(LOPTS) $(LINK) $^ -o $@
all: test libnistp.a speed
test: $(TESTS)
speed:$(SPEED)
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
hashtest: hash.o blocks.o hashtest.o
ecdsatest: ecdsa.o randombytes.o scp256.o curve.o fep256.o ecdsatest.o hash.o verify.o blocks.o
ecdsaspeed: ecdsaspeed.o scp256.o curve.o fep256.o hash.o verify.o blocks.o ecdsa.o randombytes.o
ecdsaverifyspeed: ecdsaverifyspeed.o scp256.o curve.o fep256.o hash.o verify.o blocks.o ecdsa.o randombytes.o
curveknown: curveknown.o fep256.o curve.o scp256.o
scalarmultspeed: curve.o fep256.o randombytes.o scalarmultspeed.o scalarmult.o
schnorrtest: curve.o fep256.o scp256.o verify.o blocks.o hash.o schnorrtest.o schnorr.o randombytes.o
schnorrsignspeed: schnorrsignspeed.o curve.o fep256.o scp256.o verify.o blocks.o hash.o schnorr.o randombytes.o
schnorrverifyspeed:schnorrverifyspeed.o curve.o fep256.o scp256.o verify.o blocks.o hash.o schnorr.o randombytes.o
libnistp.a: ctr.o rijndael.o garith.o aes256gcm.o secretbox.o ghash.o unload64.o load64.o verify.o fep256.o scalarmult.o curve.o box.o scp256.o ecdsa.o schnorr.o
	ar -r $@ $^
.PHONY : all
.PHONY : test
.PHONY : speed
.PHONY : clean
clean:
	rm *.o *.a $(TESTS) $(SPEED)