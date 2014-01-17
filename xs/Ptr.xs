MODULE = FFI::Raw				PACKAGE = FFI::Raw::Ptr

FFI_Raw_MemPtr_t *
new(class, pointer)
	SV *class
	SV *pointer

	PREINIT:
		void *ptr;

	CODE:
		if (sv_isobject(pointer) && sv_derived_from(pointer, "FFI::Raw::Ptr"))
			ptr = INT2PTR(void *, SvIV((SV *) SvRV(pointer)));
		else
			ptr = SvRV(pointer);

		Newx(RETVAL, sizeof(ptr), char);
		Copy(&ptr, RETVAL, sizeof(ptr), char);

	OUTPUT: RETVAL
