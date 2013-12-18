#include <stdio.h>

void pass_in_undef(const char *value) {
	if (value == NULL)
		printf("ok 1 - value == NULL\n");
	else
		printf("not ok 1 - value == '%s'\n", value);

	fflush(stdout);
}

const char *return_undef(void) {
	return NULL;
}
