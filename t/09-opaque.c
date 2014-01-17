#include <stdlib.h>

#include "ffi_test.h"

struct foo { int bar; };

struct foo *foo_new()
{
  struct foo *self;
  self = malloc(sizeof(struct foo));
  self->bar = 0;
  return self;
}

int foo_get_bar(struct foo *self)
{
  return self->bar;
}

void foo_set_bar(struct foo *self, int bar)
{
  self->bar = bar;
}

static int free_count = 0;

void foo_free(struct foo *self)
{
  free_count++;
  free(self);
}

int get_free_count(const char *class)
{
  return free_count;
}
