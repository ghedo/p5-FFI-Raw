#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdlib.h>

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

#define NEW_BASIC_ITEMS 3

MODULE = FFI::Raw					PACKAGE = FFI::Raw

SV *
_ffi_raw_new(class, library, function, ret_type, ...)
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

		SV *self = newSV(1);
		FFI_Raw_t *ffi_raw = malloc(sizeof(FFI_Raw_t));
	CODE:
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
		ffi_raw -> args = malloc(sizeof(ffi_type *) * ffi_raw -> argc);
		ffi_raw -> args_types = malloc(ffi_raw -> argc);

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


		RETVAL = sv_setref_pv(self, "FFI::Raw", ffi_raw);
	OUTPUT:
		RETVAL

void
_ffi_raw_destroy(self)
	SV *self

	INIT:
		FFI_Raw_t *ffi_raw;
	CODE:
		if (sv_isobject(self) && sv_derived_from(self, "FFI::Raw"))
			ffi_raw = INT2PTR(FFI_Raw_t *, SvIV((SV *) SvRV(self)));
		else
			Perl_croak(aTHX_ "$var is not of type FFI::Raw");
#ifdef _WIN32
		/*FreeLibrary(ffi_raw -> handle);*/
#else
		/*dlclose(ffi_raw -> handle);*/
#endif
		free(ffi_raw -> args_types);
		free(ffi_raw -> args);
		free(ffi_raw);

#define PTR_TO_INT(ARG)				\
	newSViv(PTR2IV(ARG))


#define FFI_SET_ARG(TYPE, FN) {			\
	TYPE *val = malloc(sizeof(TYPE));	\
	*val = FN(arg);				\
	values[i] = val;			\
	break;					\
}

#define FFI_CALL(TYPE, FN) {			\
	TYPE result;				\
	ffi_call(&ffi_raw -> cif, ffi_raw -> fn, &result, values);	\
	output = FN(result);			\
	break;					\
}

SV *
_ffi_raw_call(self, ...)
	SV *self

	INIT:
		int i;
		SV *output;
		void **values;
		FFI_Raw_t *ffi_raw;
	CODE:
		if (sv_isobject(self) && sv_derived_from(self, "FFI::Raw"))
			ffi_raw = INT2PTR(FFI_Raw_t *, SvIV((SV *) SvRV(self)));
		else
			Perl_croak(aTHX_ "$var is not of type FFI::Raw");

		if (ffi_raw -> argc != (items - i))
			Perl_croak(aTHX_ "Wrong number of arguments");

		values = malloc(sizeof(void *) * ffi_raw -> argc);

		for (i = 0; i < ffi_raw -> argc; i++) {
			STRLEN l;
			SV *arg = ST(i + 1);

			switch (ffi_raw -> args_types[i]) {
				case 'v': break;
				case 'i': FFI_SET_ARG(int, SvIV)
				case 'I': FFI_SET_ARG(int, SvUV)
				case 'c': FFI_SET_ARG(char, SvIV)
				case 'C': FFI_SET_ARG(int, SvUV)
				case 'f': FFI_SET_ARG(float, SvNV)
				case 'd': FFI_SET_ARG(double, SvNV)
				case 's': {
					char **val = malloc(sizeof(char *));
					*val = SvPV(arg, l);
					values[i] = val;
					break;
				}
				case 'p': {
					long int val = SvIV(arg);
					void **ptr = malloc(sizeof(void *));
					*ptr = INT2PTR(void *, val);
					values[i] = ptr;
					break;
				}
			}
		}

		switch (ffi_raw -> ret_type) {
			case 'v': {
				ffi_call(
					&ffi_raw -> cif, ffi_raw -> fn,
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
					&ffi_raw -> cif, ffi_raw -> fn,
					&result, values
				);

				output = newSVpv(result, 0);
				break;
			}
			case 'p': FFI_CALL(void *, PTR_TO_INT)
		}

		free(values);

		RETVAL = output;
	OUTPUT:
		RETVAL
