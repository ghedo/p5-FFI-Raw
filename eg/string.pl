use v5.10;

use strict;
use warnings;

use FFI::Raw;

my $puts = FFI::Raw -> new(
	'libc.so', 'puts',
	FFI::Raw::int,
	FFI::Raw::str
);

say $puts -> call("lol");

my $strerror = FFI::Raw -> new(
	'libc.so', 'strerror',
	FFI::Raw::str,
	FFI::Raw::int
);

say $strerror -> call(2);
