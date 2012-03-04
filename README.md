NISTP
=====

NISTP is an implementation of elliptic curve cryptography designed to be easy
to use. Similar to NaCl, with which I hope to integrate it sometime, it
combines authentication and encryption into a single function, making
cryptography easy to use. NISTP puts together P256, AES256GCM into the
crypto_box_p256aes256gcm function, and includes ECDSA support.

Building requires only a C compiler. To build ./configure.sh && cd bin
&& make Libtomcrypt is required to build tests. PARI is required to
interpret some tests, and there is an awk script for summarizing
tests. There is currently no configure script.