#include <stdio.h>

extern void argless() {
	printf("ok - argless\n");
	fflush(stdout);
}

void boot_01_argless() {}
