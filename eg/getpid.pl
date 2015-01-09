use feature 'say';

use strict;
use warnings;

use FFI::Raw;

my $getpid = FFI::Raw -> new(
	undef, 'getpid',
	FFI::Raw::int,
);

say $getpid -> call();
