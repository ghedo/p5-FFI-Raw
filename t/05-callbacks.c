#include <stdio.h>
#include <string.h>

#include "ffi_test.h"

extern EXPORT void take_one_int_callback(void (*cb)(int)) {
	cb(42);

	fflush(stdout);
}

extern EXPORT int return_int_callback(int (*cb)(int)) {
	return cb(42);
}

static char str_value[512] = "";

extern EXPORT void return_str_callback(const char *(*cb)(void)) {
	const char *value = cb();

	if (value == NULL)
		strcpy(str_value, "NULL");
	else
		strcpy(str_value, value);
}

extern EXPORT const char *get_str_value() {
	return str_value;
}

extern EXPORT void reset() {
	str_value[0] = '\0';
}
