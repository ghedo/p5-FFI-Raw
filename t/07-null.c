#include <stdio.h>

#ifdef _MSC_VER
# define EXPORT __declspec(dllexport)
#else
# define EXPORT 
#endif

extern EXPORT void pass_in_undef_str(const char *value) {
	if (value == NULL)
		printf("ok 1 - value == NULL\n");
	else
		printf("not ok 1 - value == '%s'\n", value);

	fflush(stdout);
}

extern EXPORT const char *return_undef_str(void) {
	return NULL;
}

extern EXPORT void pass_in_undef_ptr(const void *value) {
	if (value == NULL)
		printf("ok 3 - value == NULL\n");
	else
		printf("not ok 3 - value != NULL\n");

	fflush(stdout);
}

extern EXPORT const void *return_undef_ptr(void) {
	return NULL;
}
