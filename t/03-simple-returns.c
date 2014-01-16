#include <limits.h>
#include <stdint.h>

#ifdef _MSC_VER
# define EXPORT __declspec(dllexport)
#else
# define EXPORT 
#endif

extern EXPORT long return_long() {
	return LONG_MIN;
}

extern EXPORT unsigned long return_ulong() {
	return ULONG_MAX;
}

extern EXPORT int64_t return_int64() {
	return LLONG_MIN;
}

extern EXPORT uint64_t return_uint64() {
	return ULLONG_MAX;
}

extern EXPORT int return_int() {
	return 101;
}

extern EXPORT short return_short() {
	return 102;
}

extern EXPORT char return_char() {
	return -103;
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
