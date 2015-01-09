use feature 'say';

use strict;
use warnings;

use FFI::Raw;

my $puts = FFI::Raw -> new(
	undef, 'atoi',
	FFI::Raw::int,
	FFI::Raw::str
);

say $puts -> call('56');
