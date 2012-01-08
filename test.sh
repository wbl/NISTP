gcc -c ../src/rijndael.c -I../src -o rijndael.o
gcc -std=c99 -c ../test/aestest.c -I../src -o aestest.o
gcc rijndael.o aestest.o -o aestest
gcc -std=c99 -c -I../src ../src/ctr.c -o ctr.o
gcc -std=c99 -c -I../src ../test/ctrtest.c -o ctrtest.o
gcc ctrtest.o rijndael.o ctr.o -o ctrtest
gcc -std=c99 -c -I../src ../src/ghash.c -o ghash.o
