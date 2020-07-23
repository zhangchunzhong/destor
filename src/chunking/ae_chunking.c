/*
 * Author: Yucheng Zhang
 * See his INFOCOM paper for more details.
 */

//#include "destor.h"
#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>

#define my_memcmp(x, y) \
     ({ \
        int __ret; \
        uint64_t __a = __builtin_bswap64(*((uint64_t *) x)); \
        uint64_t __b = __builtin_bswap64(*((uint64_t *) y)); \
        if (__a > __b) \
              __ret = 1; \
        else \
              __ret = -1; \
        __ret;\
      })

static int window_size = 0;
static int chunk_max = 0;
static int chunk_min = 0;

/*
 * Calculating the window size
 */

void __ae_init(int min, int max, int avg){
	double e = 2.718281828;
	window_size = avg/(e-1);
	chunk_max = max;
	chunk_min = min;
}


/*
 * 	n is the size of string p.
 */

int __ae_chunk_data(unsigned char *p, int n) {
	unsigned char *curr = p+1, *max = p, *end = p+n-8;

	if (n <= window_size + 8)
		return n;

	for (; curr <= end; curr++) {
		int comp_res = my_memcmp(curr, max);
		if (comp_res < 0) {
			max = curr;
			continue;
		}
		if (curr == max + window_size || curr == p + chunk_max)
			return curr - p;
	}
	return n;
}

