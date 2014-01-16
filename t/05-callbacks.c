#include <stdio.h>

#ifdef _MSC_VER
# define EXPORT __declspec(dllexport)
#else
# define EXPORT 
#endif

extern EXPORT void take_one_int_callback(void (*cb)(int)) {
	cb(42);

	fflush(stdout);
}

extern EXPORT int return_int_callback(int (*cb)(int)) {
	return cb(42);
}
