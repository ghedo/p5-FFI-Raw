#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <ffi.h>

#ifdef __MINGW32__
# include <stdint.h>
#endif

#ifdef _MSC_VER
#include <stdlib.h>
typedef __int64 int64_t;
typedef unsigned __int64 uint64_t;
#endif

#include "perl_math_int64.h"
#include "perl_math_int64.c"

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

typedef struct FFI_RAW_CALLBACK {
	void *fn;
	SV *coderef;
	ffi_closure *closure;

	ffi_cif cif;
	ffi_type *ret;
	char ret_type;
	ffi_type **args;
	char *args_types;
	unsigned int argc;
} FFI_Raw_Callback_t;

void *_ffi_raw_get_type(char type) {
	switch (type) {
		case 'v': return &ffi_type_void;
		case 'l': return &ffi_type_slong;
		case 'L': return &ffi_type_ulong;
		case 'x': return &ffi_type_sint64;
		case 'X': return &ffi_type_uint64;
		case 'i': return &ffi_type_sint32;
		case 'I': return &ffi_type_uint32;
		case 'z': return &ffi_type_sint16;
		case 'Z': return &ffi_type_uint16;
		case 'c': return &ffi_type_sint8;
		case 'C': return &ffi_type_uint8;
		case 'f': return &ffi_type_float;
		case 'd': return &ffi_type_double;
		case 's':
		case 'p': return &ffi_type_pointer;
		default: Perl_croak(aTHX_ "Invalid type '%c'", type);
	}
}

#define PTR_TO_INT(ARG)							\
	newSViv(PTR2IV(ARG))

#define INT_TO_PTR(ARG)							\
	INT2PTR(void *, SvIV(ARG))

#define INIT_FFI_CIF(ARG, ARGC)						\
	int i;								\
	ARG -> ret	= _ffi_raw_get_type(SvIV(ret_type));		\
	ARG -> ret_type	= SvIV(ret_type);				\
	ARG -> argc	= items - ARGC;					\
									\
	Newx(ARG -> args, ARG -> argc, ffi_type *);			\
	Newx(ARG -> args_types, ARG -> argc, char);			\
									\
	for (i = ARGC; i < items; i++) {				\
		char type = SvIV(ST(i));				\
									\
		ARG -> args_types[i - ARGC] = type;			\
		ARG -> args[i - ARGC] = _ffi_raw_get_type(type);	\
	}								\
									\
	status = ffi_prep_cif(						\
		&ARG -> cif, FFI_DEFAULT_ABI, ARG -> argc,		\
		ARG -> ret, ARG -> args					\
	);								\
									\
	if (status != FFI_OK)						\
		Perl_croak(aTHX_ "Error creating calling interface");

#define FFI_PUSH_PARAM(TYPE, FN) {					\
	SV *arg = FN(*(TYPE *) args[i]);				\
	XPUSHs(sv_2mortal(arg));					\
	break;								\
}

void _ffi_raw_cb_wrap(ffi_cif *cif, void *ret, void *args[], void *argp) {
	dSP;

	int i, retc;
	FFI_Raw_Callback_t *self = argp;

	ENTER;
	SAVETMPS;

	PUSHMARK(SP);
	for (i = 0; i < self -> argc; i++) {
		switch (self -> args_types[i]) {
			case 'v': break;
			case 'l': FFI_PUSH_PARAM(long, newSViv)
			case 'L': FFI_PUSH_PARAM(unsigned long, newSViv)
			case 'x': FFI_PUSH_PARAM(long long int, newSVi64)
			case 'X': FFI_PUSH_PARAM(unsigned long long int, newSVu64)
			case 'i': FFI_PUSH_PARAM(int, newSViv)
			case 'I': FFI_PUSH_PARAM(unsigned int, newSViv)
			case 'c': FFI_PUSH_PARAM(char, newSViv)
			case 'C': FFI_PUSH_PARAM(unsigned char, newSViv)
			case 'f': FFI_PUSH_PARAM(float, newSVuv)
			case 'd': FFI_PUSH_PARAM(double, newSVuv)
			case 's': {
				SV *arg = newSVpv(*(char **) args[i], 0);
				XPUSHs(sv_2mortal(arg));
				break;
			}
			case 'p': FFI_PUSH_PARAM(void *, PTR_TO_INT)
		}
	}
	PUTBACK;

	retc = call_sv(self -> coderef, G_SCALAR);

	SPAGAIN;

	switch (self -> ret_type) {
		case 'v': break;
		case 'l': *(long *) ret = POPi; break;
		case 'L': *(unsigned long *) ret = POPi; break;
		case 'x': *(long long int *) ret = POPi; break;
		case 'X': *(unsigned long long int *) ret = POPi; break;
		case 'i': *(int *) ret = POPi; break;
		case 'I': *(unsigned int *) ret = POPi; break;
		case 'z': *(short *) ret = POPi; break;
		case 'Z': *(unsigned short *) ret = POPi; break;
		case 'c': *(char *) ret = POPi; break;
		case 'C': *(unsigned char *) ret = POPi; break;
		case 'f': *(float *) ret = POPn; break;
		case 'd': *(double *) ret = POPn; break;
		case 's': Perl_croak(aTHX_ "Not supported");
		case 'p': Perl_croak(aTHX_ "Not supported");
	}

	PUTBACK;
	FREETMPS;
	LEAVE;
}

MODULE = FFI::Raw				PACKAGE = FFI::Raw

BOOT:
	PERL_MATH_INT64_LOAD;

FFI_Raw_t *
new(class, library, function, ret_type, ...)
	SV *class
	SV *library
	SV *function
	SV *ret_type

	PREINIT:
		char *error;
		ffi_status status;

		FFI_Raw_t *ffi_raw;

		const char *library_name, *function_name;

	CODE:
		Newx(ffi_raw, 1, FFI_Raw_t);

		library_name  = SvPV_nolen(library);
		function_name = SvPV_nolen(function);
#ifdef _WIN32
		GetLastError();

		ffi_raw -> handle = LoadLibrary(library_name);

		if (ffi_raw->handle == NULL)
			Perl_croak(aTHX_ "library not found");

		/*if ((error = GetLastError()) != NULL)
			Perl_croak(aTHX_ error);*/

		ffi_raw -> fn = GetProcAddress(
			ffi_raw -> handle, function_name
		);

		if (ffi_raw -> fn == NULL)
			Perl_croak(aTHX_ "function not found");

		/*if ((error = GetLastError()) != NULL)
			Perl_croak(aTHX_ error);*/
#else
		dlerror();

		ffi_raw -> handle = dlopen(library_name, RTLD_LAZY);

		if ((error = dlerror()) != NULL)
			Perl_croak(aTHX_ "%s", error);

		ffi_raw -> fn = dlsym(ffi_raw -> handle, function_name);

		if ((error = dlerror()) != NULL)
			Perl_croak(aTHX_ "%s", error);
#endif
		INIT_FFI_CIF(ffi_raw, 4)

		RETVAL = ffi_raw;

	OUTPUT: RETVAL

FFI_Raw_t *
new_from_ptr(class, function, ret_type, ...)
	SV *class
	SV *function
	SV *ret_type

	PREINIT:
		char *error;
		ffi_status status;

		FFI_Raw_t *ffi_raw;

	CODE:
		Newx(ffi_raw, 1, FFI_Raw_t);

		ffi_raw -> handle = NULL;
		ffi_raw -> fn     = INT_TO_PTR(function);

		INIT_FFI_CIF(ffi_raw, 3)

		RETVAL = ffi_raw;

	OUTPUT: RETVAL

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

	PREINIT:
		int i;

		SV *output;
		void **values;

	CODE:
		if (self -> argc != (items - 1))
			Perl_croak(aTHX_ "Wrong number of arguments");

		Newx(values, self -> argc, void *);

		for (i = 0; i < self -> argc; i++) {
			SV *arg = ST(i + 1);

			switch (self -> args_types[i]) {
				case 'v': break;
				case 'l': FFI_SET_ARG(long, SvIV)
				case 'L': FFI_SET_ARG(unsigned long, SvUV)
				case 'x': FFI_SET_ARG(long long int, SvI64)
				case 'X': FFI_SET_ARG(unsigned long long int, SvU64)
				case 'i': FFI_SET_ARG(int, SvIV)
				case 'I': FFI_SET_ARG(int, SvUV)
				case 'z': FFI_SET_ARG(short, SvIV)
				case 'Z': FFI_SET_ARG(short, SvUV)
				case 'c': FFI_SET_ARG(char, SvIV)
				case 'C': FFI_SET_ARG(int, SvUV)
				case 'f': FFI_SET_ARG(float, SvNV)
				case 'd': FFI_SET_ARG(double, SvNV)
				case 's': {
					STRLEN l;
					char **val;

					Newx(val, 1, char *);

					if (SvOK(arg))
						*val = SvPV(arg, l);
					else
						*val = NULL;

					values[i] = val;
					break;
				}

				case 'p': {
					void **val;

					Newx(val, 1, void *);

					if (sv_derived_from(
						arg, "FFI::Raw::Ptr"
					)) {
						arg = SvRV(arg);
					}

					if (sv_derived_from(
						arg, "FFI::Raw::Callback"
					)) {
						FFI_Raw_Callback_t *cb =
							INT_TO_PTR(SvRV(arg));
						*val = cb -> fn;
					} else if (SvOK(arg))
						*val = INT_TO_PTR(arg);
					else
						*val = NULL;

					values[i] = val;
					break;
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

			case 'l': FFI_CALL(long, newSViv)
			case 'L': FFI_CALL(unsigned long, newSVuv)
			case 'x': FFI_CALL(long long int, newSVi64)
			case 'X': FFI_CALL(unsigned long long int, newSVu64)
			case 'i': FFI_CALL(int, newSViv)
			case 'I': FFI_CALL(int, newSVuv)
			case 'z': FFI_CALL(short, newSViv)
			case 'Z': FFI_CALL(short, newSVuv)
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

			case 'p': {
				void *result;

				ffi_call(
					&self -> cif, self -> fn,
					&result, values
				);

				if (result == NULL)
					output = &PL_sv_undef;
				else
					output = PTR_TO_INT(result);
				break;
			}
		}

		for (i = 0; i < self -> argc; i++)
			Safefree(values[i]);

		Safefree(values);

		RETVAL = output;

	OUTPUT: RETVAL

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

INCLUDE: xs/MemPtr.xs
INCLUDE: xs/Callback.xs
