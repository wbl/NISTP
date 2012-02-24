NISTP
=====

NISTP is an implementation of elliptic curve cryptography designed to be easy
to use. Similar to NaCl, with which I hope to integrate it sometime, it
combines authentication and encryption into a single function, making
cryptography easy to use. NISTP will put together the elliptic curve P256,
AES256 and the Galois/Counter authenticated encryption mode. AES256GCMP256 is implemented,
and ECDSA is coming.

Building requires only a C compiler. To build ./configure.sh && cd bin && make
Libtomcrypt is required to build tests. PARI is required to interpret some tests, and there
is an awk script for summarizing tests.