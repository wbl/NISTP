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

Using NISTP
===

To learn how to use NISTP take a look at the examples in ./tests. The
API follows the principles of the NaCl API at http://nacl.cr.yp.to:
functions should combine multiple cryptographic operations and make all
decisions for the user, as well as require no initialization or cleanup.

Zeroization is not done, but all data is on the stack. The primatives used
in NISTP are secure and mostly standard, aside from the Schnorr signature which
is here used an equivelent form. NISTP is fast, but cannot compete with
Curve25519. It is much simpler then OpenSSL.