#include <stdint.h>
#include "fep256.h"
/*arithmetic mod p=2^256-2^224+2^192+2^96-1*/
/*We use 11 64 bit limbs, with values mostly caped at 2^25.
This arrangement lets us multiply and accumulate safely with very small
number arithmetic.*/
