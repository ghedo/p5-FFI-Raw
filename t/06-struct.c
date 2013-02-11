#include <stdio.h>

struct some_struct {
	int some_int;
	char some_str[];
};

extern void take_one_struct(struct some_struct *arg) {
	if (arg -> some_int == 42)
		printf("ok - got passed int 42\n");
	else
		printf("not ok - got passed int 42\n");

	if (strcmp(arg -> some_str, "hello"))
		printf("ok - got passed str hello\n");
	else
		printf("not ok - got passed str hello\n");

	fflush(stdout);
}
