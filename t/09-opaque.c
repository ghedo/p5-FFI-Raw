#include <stdlib.h>

#include "ffi_test.h"

struct foo { int bar; };

EXPORT struct foo *foo_new() {
	struct foo *self;
	self = malloc(sizeof(struct foo));
	self->bar = 0;
	return self;
}

EXPORT int foo_get_bar(struct foo *self) {
	return self->bar;
}

EXPORT void foo_set_bar(struct foo *self, int bar) {
	self->bar = bar;
}

static int free_count = 0;

EXPORT void foo_free(struct foo *self) {
	free_count++;
	free(self);
}

EXPORT int get_free_count(const char *class) {
	return free_count;
}
