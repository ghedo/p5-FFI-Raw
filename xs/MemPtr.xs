MODULE = FFI::Raw				PACKAGE = FFI::Raw::MemPtr

FFI_Raw_MemPtr_t *
new(class, number)
	SV *class
	unsigned int number

	INIT:
		void *temp;

	CODE:
		Newx(temp, number, char);

		RETVAL = temp;

	OUTPUT: RETVAL

FFI_Raw_MemPtr_t *
new_from_buf(class, buffer, number)
	SV *class
	SV *buffer
	unsigned int number

	INIT:
		void *temp;

	CODE:
		Newx(temp, number, char);
		Copy(SvPVX(buffer), temp, number, char);

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