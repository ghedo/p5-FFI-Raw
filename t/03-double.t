#!perl -T

use Test::More;

use FFI::Raw;

my $libm = $^O eq 'MSWin32' ? 'msvcrt.dll' : 'libm.so';

my $fmax = FFI::Raw -> new(
	$libm, 'fmax',
	FFI::Raw::double,
	FFI::Raw::double, FFI::Raw::double
);

is($fmax -> call(2.0, 3.0), 3);
is($fmax -> call(2.5, 4.0), 4.0);

done_testing;
