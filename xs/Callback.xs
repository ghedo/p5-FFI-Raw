MODULE = FFI::Raw				PACKAGE = FFI::Raw::Callback

FFI_Raw_Callback_t *
new(class, coderef, ret_type, ...)
	SV *class
	SV *coderef
	SV *ret_type

	PREINIT:
		int status;

		FFI_Raw_Callback_t *ffi_raw_cb;

	CODE:
		Newx(ffi_raw_cb, 1, FFI_Raw_Callback_t);

		ffi_raw_cb -> coderef = SvREFCNT_inc(coderef);
		ffi_raw_cb -> string_value = NULL;

		ffi_raw_cb -> closure = ffi_closure_alloc(
			sizeof(ffi_closure),
			&ffi_raw_cb -> fn
		);

		INIT_FFI_CIF(ffi_raw_cb, 3)

		status = ffi_prep_closure_loc(
			ffi_raw_cb -> closure, &ffi_raw_cb -> cif,
			_ffi_raw_cb_wrap, ffi_raw_cb,
			ffi_raw_cb -> fn
		);

		RETVAL = ffi_raw_cb;

	OUTPUT: RETVAL

void
DESTROY(self)
	FFI_Raw_Callback_t *self

	CODE:
		SvREFCNT_dec(self -> coderef);

		if (self -> string_value != NULL)
			Safefree(self -> string_value);
		Safefree(self -> args_types);
		Safefree(self -> args);
		Safefree(self);
