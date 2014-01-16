#include <stdio.h>

#include "ffi_test.h"

extern EXPORT void argless() {
	printf("ok - argless\n");
	fflush(stdout);
}
