#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <ffi.h>

#ifdef _WIN32
# include <windows.h>
#else
# include <dlfcn.h>
#endif

typedef struct FFI_RAW {
	void *fn;
	void *handle;

	ffi_cif cif;
	ffi_type *ret;
	char ret_type;
	ffi_type **args;
	char *args_types;
	unsigned int argc;
} FFI_Raw_t;

typedef void FFI_Raw_MemPtr_t;

void *_ffi_raw_get_type(char type) {
	switch (type) {
		case 'v': return &ffi_type_void;
		case 'i': return &ffi_type_sint32;
		case 'I': return &ffi_type_uint32;
		case 'c': return &ffi_type_sint8;
		case 'C': return &ffi_type_uint8;
		case 'f': return &ffi_type_float;
		case 'd': return &ffi_type_double;
		case 's':
		case 'p': return &ffi_type_pointer;
		default: Perl_croak(aTHX_ "Invalid type '%c'", type);
	}
}

#define PTR_TO_INT(ARG)				\
	newSViv(PTR2IV(ARG))

#define INT_TO_PTR(ARG)				\
	INT2PTR(void *, SvIV(ARG))

MODULE = FFI::Raw				PACKAGE = FFI::Raw

FFI_Raw_t *
new(class, library, function, ret_type, ...)
	SV *class
	SV *library
	SV *function
	SV *ret_type

	INIT:
		int i;
		char *error;
		ffi_status status;

		STRLEN library_len;
		const char *library_name;

		STRLEN function_len;
		const char *function_name;

		FFI_Raw_t *ffi_raw;
	CODE:
		Newx(ffi_raw, 1, FFI_Raw_t);

		SvGETMAGIC(library);
		library_name = SvPV(library, library_len);

		SvGETMAGIC(function);
		function_name = SvPV(function, function_len);
#ifdef _WIN32
		GetLastError();

		ffi_raw -> handle = LoadLibrary(library_name);

		/*if ((error = GetLastError()) != NULL)
			Perl_croak(aTHX_ error);*/

		ffi_raw -> fn = GetProcAddress(
			ffi_raw -> handle, function_name
		);

		/*if ((error = GetLastError()) != NULL)
			Perl_croak(aTHX_ error);*/
#else
		dlerror();

		ffi_raw -> handle = dlopen(library_name, RTLD_LAZY);

		if ((error = dlerror()) != NULL)
			Perl_croak(aTHX_ error);

		ffi_raw -> fn   = dlsym(ffi_raw -> handle, function_name);

		if ((error = dlerror()) != NULL)
			Perl_croak(aTHX_ error);
#endif
		ffi_raw -> ret  = _ffi_raw_get_type(SvIV(ret_type));
		ffi_raw -> ret_type = SvIV(ret_type);
		ffi_raw -> argc = items - 4;

		Newx(ffi_raw -> args, ffi_raw -> argc, ffi_type *);
		Newx(ffi_raw -> args_types, ffi_raw -> argc, char);

		for (i = 4; i < items; i++) {
			char type = SvIV(ST(i));

			ffi_raw -> args_types[i - 4] = type;
			ffi_raw -> args[i - 4] = _ffi_raw_get_type(type);
		}

		status = ffi_prep_cif(
			&ffi_raw -> cif, FFI_DEFAULT_ABI, ffi_raw -> argc,
			ffi_raw -> ret, ffi_raw -> args
		);

		if (status != FFI_OK)
			Perl_croak(aTHX_ "Error creating calling interface");

		RETVAL = ffi_raw;
	OUTPUT:
		RETVAL

FFI_Raw_t *
new_from_ptr(class, function, ret_type, ...)
	SV *class
	SV *function
	SV *ret_type

	INIT:
		int i;
		char *error;
		ffi_status status;

		FFI_Raw_t *ffi_raw;
	CODE:
		Newx(ffi_raw, 1, FFI_Raw_t);

		ffi_raw -> handle = NULL;
		ffi_raw -> fn   = INT_TO_PTR(function);

		ffi_raw -> ret  = _ffi_raw_get_type(SvIV(ret_type));
		ffi_raw -> ret_type = SvIV(ret_type);
		ffi_raw -> argc = items - 3;

		Newx(ffi_raw -> args, ffi_raw -> argc, ffi_type *);
		Newx(ffi_raw -> args_types, ffi_raw -> argc, char);

		for (i = 3; i < items; i++) {
			char type = SvIV(ST(i));

			ffi_raw -> args_types[i - 3] = type;
			ffi_raw -> args[i - 3] = _ffi_raw_get_type(type);
		}

		status = ffi_prep_cif(
			&ffi_raw -> cif, FFI_DEFAULT_ABI, ffi_raw -> argc,
			ffi_raw -> ret, ffi_raw -> args
		);

		if (status != FFI_OK)
			Perl_croak(aTHX_ "Error creating calling interface");

		RETVAL = ffi_raw;
	OUTPUT:
		RETVAL

void
DESTROY(self)
	FFI_Raw_t *self

	CODE:
		if (self -> handle)
#ifdef _WIN32
		FreeLibrary(self -> handle);
#else
		dlclose(self -> handle);
#endif
		Safefree(self -> args_types);
		Safefree(self -> args);
		Safefree(self);

#define FFI_SET_ARG(TYPE, FN) {			\
	TYPE *val;				\
	Newx(val, 1, TYPE);			\
	*val = FN(arg);				\
	values[i] = val;			\
	break;					\
}

#define FFI_CALL(TYPE, FN) {			\
	TYPE result;				\
	ffi_call(&self -> cif, self -> fn, &result, values);	\
	output = FN(result);			\
	break;					\
}

SV *
call(self, ...)
	FFI_Raw_t *self

	INIT:
		int i;
		SV *output;
		void **values;
	CODE:
		if (self -> argc != (items - 1))
			Perl_croak(aTHX_ "Wrong number of arguments");

		Newx(values, self -> argc, void *);

		for (i = 0; i < self -> argc; i++) {
			STRLEN l;
			SV *arg = ST(i + 1);

			switch (self -> args_types[i]) {
				case 'v': break;
				case 'i': FFI_SET_ARG(int, SvIV)
				case 'I': FFI_SET_ARG(int, SvUV)
				case 'c': FFI_SET_ARG(char, SvIV)
				case 'C': FFI_SET_ARG(int, SvUV)
				case 'f': FFI_SET_ARG(float, SvNV)
				case 'd': FFI_SET_ARG(double, SvNV)
				case 's': {
					char **val; Newx(val, 1, char *);
					*val = SvPV(arg, l);
					values[i] = val;
					break;
				}
				case 'p': {
					if (sv_isobject(arg) && sv_derived_from(
						      arg, "FFI::Raw::MemPtr"))
						arg = SvRV(arg);

					FFI_SET_ARG(void *, INT_TO_PTR)
				}
			}
		}

		switch (self -> ret_type) {
			case 'v': {
				ffi_call(
					&self -> cif, self -> fn,
					NULL, values
				);

				output = newSV(0);
				break;
			}
			case 'i': FFI_CALL(int, newSViv)
			case 'I': FFI_CALL(int, newSVuv)
			case 'c': FFI_CALL(char, newSViv)
			case 'C': FFI_CALL(char, newSVuv)
			case 'f': FFI_CALL(float, newSVnv)
			case 'd': FFI_CALL(double, newSVnv)
			case 's': {
				char *result;

				ffi_call(
					&self -> cif, self -> fn,
					&result, values
				);

				output = newSVpv(result, 0);
				break;
			}
			case 'p': FFI_CALL(void *, PTR_TO_INT)
		}

		for (i = 0; i < self -> argc; i++)
			Safefree(values[i]);

		Safefree(values);

		RETVAL = output;
	OUTPUT:
		RETVAL

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
	OUTPUT:
		RETVAL

void
DESTROY(self)
	FFI_Raw_MemPtr_t *self

	CODE:
		void **ptr = self;
		Safefree(ptr);
