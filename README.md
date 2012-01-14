NISTP
=====

NISTP is an implementation of elliptic curve cryptography designed to be easy
to use. Similar to NaCl, with which I hope to integrate it sometime, it
combines authentication and encryption into a single function, making
cryptography easy to use. NISTP will put together the elliptic curve P256,
AES256 and the Galois/Counter authenticated encryption mode. So far AES256GCM
is working, but slowly and with leakes, and P256 remains to be implemented.