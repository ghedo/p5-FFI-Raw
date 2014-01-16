#include <stdio.h>

#ifdef _MSC_VER
# define EXPORT __declspec(dllexport)
#else
# define EXPORT 
#endif

extern EXPORT void argless() {
	printf("ok - argless\n");
	fflush(stdout);
}
