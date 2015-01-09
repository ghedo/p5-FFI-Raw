use feature 'say';

use strict;
use warnings;

use FFI::Raw;

my $strlen = FFI::Raw -> new(
	undef, 'strlen',
	FFI::Raw::int,
	FFI::Raw::str
);

say $strlen -> call('somestring');

my $strstr = FFI::Raw -> new(
	undef, 'strstr',
	FFI::Raw::str,
	FFI::Raw::str,
	FFI::Raw::str
);

say $strstr -> call('somestring', 'string');

my $puts = FFI::Raw -> new(
	undef, 'puts',
	FFI::Raw::int,
	FFI::Raw::str
);

say $puts -> call("lol");

my $strerror = FFI::Raw -> new(
	undef, 'strerror',
	FFI::Raw::str,
	FFI::Raw::int
);

say $strerror -> call(2);
