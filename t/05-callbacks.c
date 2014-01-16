#include <stdio.h>

#include "ffi_test.h"

extern EXPORT void take_one_int_callback(void (*cb)(int)) {
	cb(42);

	fflush(stdout);
}

extern EXPORT int return_int_callback(int (*cb)(int)) {
	return cb(42);
}
