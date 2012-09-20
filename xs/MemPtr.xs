MODULE = FFI::Raw				PACKAGE = FFI::Raw::MemPtr

FFI_Raw_MemPtr_t *
new(class, number)
	SV *class
	unsigned int number

	INIT:
		void *temp;
		SV *output;

	CODE:
		Newx(temp, number, char);

		RETVAL = temp;

	OUTPUT: RETVAL

SV *
tostr(self)
	FFI_Raw_MemPtr_t *self

	CODE:
		RETVAL = newSVpv(self, 0);

	OUTPUT: RETVAL

void
DESTROY(self)
	FFI_Raw_MemPtr_t *self

	CODE:
		void **ptr = self;
		Safefree(ptr);
