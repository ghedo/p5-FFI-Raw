#include <stdio.h>
#include <string.h>

struct some_struct {
	int   some_int;
	char *some_str;
};

extern void take_one_struct(struct some_struct *arg) {
	if (arg -> some_int == 42)
		printf("ok - got passed int 42\n");
	else
		printf("not ok - got passed int %d\n", arg -> some_int);

	if (strlen(arg -> some_str) == 5)
		printf("ok - got passed str of right len\n");
	else
		printf("not ok - got passed str of len %d\n", strlen(arg -> some_str));

	if (strcmp(arg -> some_str, "hello") == 0)
		printf("ok - got passed str hello\n");
	else
		printf("not ok - got passed str %s\n", arg -> some_str);

	fflush(stdout);
}

extern void return_one_struct(struct some_struct *arg) {
	arg -> some_int = 42;
	arg -> some_str = strdup("hello");
}
