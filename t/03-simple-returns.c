#include <limits.h>

extern long return_long() {
    return LONG_MIN;
}

extern unsigned long return_ulong() {
    return ULONG_MAX;
}

extern int return_int() {
	return 101;
}

extern short return_short() {
	return 102;
}

extern char return_char() {
	return -103;
}

extern double return_double() {
	return (double) 9.9;
}

extern float return_float() {
	return (float) -4.5;
}

extern char *return_string() {
	return "epic cuteness";
}
