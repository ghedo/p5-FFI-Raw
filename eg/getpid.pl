use feature 'say';

use strict;
use warnings;

use FFI::Raw;

my $libc = 'libc.so.6';

my $getpid = FFI::Raw -> new(
	$libc, 'getpid',
	FFI::Raw::int,
);

say $getpid -> call();
