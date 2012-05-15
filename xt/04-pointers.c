#include <stdlib.h>
#include <string.h>

typedef struct POINTER {
	char *string;
	int   number;
} test_ptr_t;

extern void take_one_pointer(test_ptr_t *ptr) {
	char *string = "some string";

	ptr -> string = malloc(strlen(string) + 1);
	ptr -> string = strcpy(ptr -> string, string);

	ptr -> number = 42;
}

extern test_ptr_t *return_pointer() {
	test_ptr_t *ptr = malloc(sizeof(test_ptr_t));

	take_one_pointer(ptr);

	return ptr;
}

extern char *return_str_from_ptr(test_ptr_t *ptr) {
	return ptr -> string;
}

extern int return_int_from_ptr(test_ptr_t *ptr) {
	return ptr -> number;
}

extern int get_test_ptr_size() {
	return sizeof(test_ptr_t);
}
