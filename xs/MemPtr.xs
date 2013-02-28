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
				RETVAL = newSVpv(self, SvUV(ST(1)));
				break;

			default: Perl_croak(aTHX_ "Wrong number of arguments");
		}

	OUTPUT: RETVAL

void
DESTROY(self)
	FFI_Raw_MemPtr_t *self

	CODE:
		void **ptr = self;
		Safefree(ptr);
