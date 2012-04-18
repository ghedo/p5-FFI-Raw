use v5.10;

use strict;
use warnings;

use FFI::Raw;

my $puts = FFI::Raw -> new(
	'libc.so', 'atoi',
	FFI::Raw::int,
	FFI::Raw::str
);

say $puts -> call('56');
