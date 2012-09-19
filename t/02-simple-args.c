#include <stdio.h>

extern void take_one_int(int x) {
	if (x == 42)
		printf("ok - got passed int 42\n", x);
	else
		printf("not ok - got passed int 42\n", x);

	fflush(stdout);
}

extern void take_two_shorts(short x, short y) {
	if (x == 10)
		printf("ok - got passed short 10\n", x);
	else
		printf("not ok - got passed short 10\n", x);

	if (y == 20)
		printf("ok - got passed short 20\n", x);
	else
		printf("not ok - got passed short 20\n", x);

	fflush(stdout);
}

extern void take_misc_ints(int x, short y, char z) {
	if (x == 101)
		printf("ok - got passed int 101\n", x);
	else
		printf("not ok - got passed int 101\n", x);

	if (y == 102)
		printf("ok - got passed short 102\n", x);
	else
		printf("not ok - got passed short 102\n", x);

	if (z == 103)
		printf("ok - got passed char 103\n", x);
	else
		printf("not ok - got passed char 103\n", x);

	fflush(stdout);
}

extern void take_one_double(double x) {
	if (-6.9 - x < 0.001)
		printf("ok - got passed double -6.9\n", x);
	else
		printf("not ok - got passed double -6.9\n", x);

	fflush(stdout);
}

extern void take_one_float(float x) {
	if (4.2 - x < 0.001)
		printf("ok - got passed float 4.2\n", x);
	else
		printf("not ok - got passed float 4.2\n", x);

	fflush(stdout);
}

extern void take_one_string(char *pass_msg) {
	printf("%s\n", pass_msg);

	fflush(stdout);
}

static char *cached_str = NULL;
extern void set_cached_string(char *str) {
	cached_str = str;
}

extern void print_cached_string() {
	printf("%s\n", cached_str);

	fflush(stdout);
}
