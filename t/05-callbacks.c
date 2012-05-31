#include <stdio.h>

extern void take_one_int_callback(void (*cb)(int)) {
	cb(42);

	fflush(stdout);
}

extern int return_int_callback(int (*cb)(int)) {
	return cb(42);
}
