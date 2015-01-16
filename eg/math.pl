use feature 'say';

use strict;
use warnings;

use FFI::Raw;

my $libm = 'libm.so';

my $fdim = FFI::Raw -> new(
	$libm, 'fdim',
	FFI::Raw::double, # return value
	FFI::Raw::double, # arg #1
	FFI::Raw::double  # arg #2
);

say $fdim -> call(7.0, 2.0);

my $cos = FFI::Raw -> new(
	$libm, 'cos',
	FFI::Raw::double, # return value
	FFI::Raw::double  # arg #1
);

say $cos -> call(2.0);

my $fmax = FFI::Raw -> new(
	$libm, 'fmax',
	FFI::Raw::double, # return value
	FFI::Raw::double, # arg #1
	FFI::Raw::double  # arg #2
);

say $fmax -> call(2.0, 3.0);
