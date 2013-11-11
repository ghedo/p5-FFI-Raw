#include <stdio.h>
#include <limits.h>
#include <stdint.h>

extern void take_one_long(long x) {
	if (x == LONG_MIN)
		printf("ok - got passed long %ld\n", x);
	else
		printf("not ok - got passed long %ld\n", x);

	fflush(stdout);
}

extern void take_one_ulong(unsigned long x) {
	if (x == ULONG_MAX)
		printf("ok - got passed ulong %lu\n", x);
	else
		printf("not ok - got passed ulong %lu\n", x);

	fflush(stdout);
}

extern void take_one_int64(int64_t x) {
	if (x == LLONG_MIN)
		printf("ok - got passed int64 %lld\n", x);
	else
		printf("not ok - got passed int64 %lld\n", x);

	fflush(stdout);
}

extern void take_one_uint64(uint64_t x) {
	if (x == ULLONG_MAX)
		printf("ok - got passed uint64 %llu\n", x);
	else
		printf("not ok - got passed uint64 %llu\n", x);

	fflush(stdout);
}

extern void take_one_int(int x) {
	if (x == 42)
		printf("ok - got passed int 42\n");
	else
		printf("not ok - got passed int 42\n");

	fflush(stdout);
}

extern void take_two_shorts(short x, short y) {
	if (x == 10)
		printf("ok - got passed short 10\n");
	else
		printf("not ok - got passed short 10\n");

	if (y == 20)
		printf("ok - got passed short 20\n");
	else
		printf("not ok - got passed short 20\n");

	fflush(stdout);
}

extern void take_misc_ints(int x, short y, char z) {
	if (x == 101)
		printf("ok - got passed int 101\n");
	else
		printf("not ok - got passed int 101\n");

	if (y == 102)
		printf("ok - got passed short 102\n");
	else
		printf("not ok - got passed short 102\n");

	if (z == 103)
		printf("ok - got passed char 103\n");
	else
		printf("not ok - got passed char 103\n");

	fflush(stdout);
}

extern void take_one_double(double x) {
	if (-6.9 - x < 0.001)
		printf("ok - got passed double -6.9\n");
	else
		printf("not ok - got passed double -6.9\n");

	fflush(stdout);
}

extern void take_one_float(float x) {
	if (4.2 - x < 0.001)
		printf("ok - got passed float 4.2\n");
	else
		printf("not ok - got passed float 4.2\n");

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
