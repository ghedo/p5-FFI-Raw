#include <limits.h>
#include <stdint.h>

#include "ffi_test.h"

extern EXPORT long return_long() {
	return LONG_MIN;
}

extern EXPORT unsigned long return_ulong() {
	return ULONG_MAX;
}

#ifdef LLONG_MIN
extern EXPORT int64_t return_int64() {
	return LLONG_MIN;
}
#endif

#ifdef ULLONG_MAX
extern EXPORT uint64_t return_uint64() {
	return ULLONG_MAX;
}
#endif

extern EXPORT int return_int() {
	return INT_MIN;
}

extern EXPORT unsigned int return_uint() {
	return UINT_MAX;
}

extern EXPORT short return_short() {
	return SHRT_MIN;
}

extern EXPORT unsigned short return_ushort() {
	return USHRT_MAX;
}

extern EXPORT char return_char() {
	return CHAR_MIN;
}

extern EXPORT unsigned char return_uchar() {
	return UCHAR_MAX;
}

extern EXPORT double return_double() {
	return (double) 9.9;
}

extern EXPORT float return_float() {
	return (float) -4.5;
}

extern EXPORT char *return_string() {
	return "epic cuteness";
}
