use v5.10;

use strict;
use warnings;

use FFI::Raw;

my $puts = FFI::Raw -> new(
	'libc.so', 'puts',
	FFI::Raw::integer,
	FFI::Raw::string
);

say $puts -> call("lol");

my $strerror = FFI::Raw -> new(
	'libc.so', 'strerror',
	FFI::Raw::string,
	FFI::Raw::integer
);

say $strerror -> call(2);
