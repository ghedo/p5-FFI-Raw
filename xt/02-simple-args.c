#include <stdio.h>

extern void take_one_int(int x) {
	if (x == 42)
		printf("ok 1 - got passed int 42\n", x);
	else
		printf("not ok 1 - got passed int 42\n", x);

	fflush(stdout);
}

extern void take_two_shorts(short x, short y) {
	if (x == 10)
		printf("ok 2 - got passed short 10\n", x);
	else
		printf("not ok 2 - got passed short 10\n", x);

	if (y == 20)
		printf("ok 3 - got passed short 20\n", x);
	else
		printf("not ok 3 - got passed short 20\n", x);

	fflush(stdout);
}

extern void take_misc_ints(int x, short y, char z) {
	if (x == 101)
		printf("ok 4 - got passed int 101\n", x);
	else
		printf("not ok 4 - got passed int 101\n", x);

	if (y == 102)
		printf("ok 5 - got passed short 102\n", x);
	else
		printf("not ok 5 - got passed short 102\n", x);

	if (z == 103)
		printf("ok 6 - got passed char 103\n", x);
	else
		printf("not ok 6 - got passed char 103\n", x);

	fflush(stdout);
}

extern void take_one_double(double x) {
	if (-6.9 - x < 0.001)
		printf("ok 7 - got passed double -6.9\n", x);
	else
		printf("not ok 7 - got passed double -6.9\n", x);
}

extern void take_one_float(float x) {
	if (4.2 - x < 0.001)
		printf("ok 8 - got passed float 4.2\n", x);
	else
		printf("not ok 8 - got passed float 4.2\n", x);
}

extern void take_one_string(char *pass_msg) {
	printf("%s\n", pass_msg);
}

static char *cached_str = NULL;
extern void set_cached_string(char *str) {
    cached_str = str;
}

extern void print_cached_string() {
	printf("%s\n", cached_str);
}
