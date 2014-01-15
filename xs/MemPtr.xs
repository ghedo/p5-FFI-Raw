MODULE = FFI::Raw				PACKAGE = FFI::Raw::MemPtr

FFI_Raw_MemPtr_t *
new(class, length)
	SV *class
	unsigned int length

	CODE:
		Newx(RETVAL, length, char);

	OUTPUT: RETVAL

FFI_Raw_MemPtr_t *
new_from_buf(class, buffer, length)
	SV *class
	SV *buffer
	unsigned int length

	CODE:
		Newx(RETVAL, length, char);
		Copy(SvPVX(buffer), RETVAL, length, char);

	OUTPUT: RETVAL

FFI_Raw_MemPtr_t *
new_from_ptr(class, pointer)
	SV *class
	SV *pointer

	CODE:
		void *ptr;

		if (sv_isobject(pointer) && sv_derived_from(pointer, "FFI::Raw::MemPtr"))
			ptr = INT2PTR(void *, SvIV((SV *) SvRV(pointer)));
		else
			ptr = SvRV(pointer);

		Newx(RETVAL, sizeof(ptr), char);
		Copy(&ptr, RETVAL, sizeof(ptr), char);

	OUTPUT: RETVAL

SV *
tostr(self, ...)
	FFI_Raw_MemPtr_t *self

	PROTOTYPE: $;$
	CODE:
		switch (items) {
			case 1:
				RETVAL = newSVpv(self, 0);
				break;

			case 2:
				RETVAL = newSVpvn(self, SvUV(ST(1)));
				break;

			default: Perl_croak(aTHX_ "Wrong number of arguments");
		}

	OUTPUT: RETVAL

void
DESTROY(self)
	FFI_Raw_MemPtr_t *self

	CODE:
		void *ptr = self;
		Safefree(ptr);
