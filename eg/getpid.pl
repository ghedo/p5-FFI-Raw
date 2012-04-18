use v5.10;

use strict;
use warnings;

use FFI::Raw;

my $getpid = FFI::Raw -> new(
	'libc.so', 'getpid',
	FFI::Raw::int,
	FFI::Raw::void
);

say $getpid -> call();
