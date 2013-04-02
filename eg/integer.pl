use feature 'say';

use strict;
use warnings;

use FFI::Raw;

my $libc = 'libc.so.6';

my $puts = FFI::Raw -> new(
	$libc, 'atoi',
	FFI::Raw::int,
	FFI::Raw::str
);

say $puts -> call('56');
