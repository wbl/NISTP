#include <stdint.h>
#include <assert.h>
#include "fep256.h"
/*arithmetic mod p=2^256-2^224+2^192+2^96-1*/
/*We use 11 64 bit limbs, with values mostly capped at 2^24.
This arrangement lets us multiply and accumulate safely with very small
number arithmetic. It also makes the awkward placements a bit better, while
still permitting us to use 64 bit arithemetic.*/
