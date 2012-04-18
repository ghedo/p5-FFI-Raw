use v5.10;

use strict;
use warnings;

use FFI::Raw;

my $strlen = FFI::Raw -> new(
	'libc.so', 'strlen',
	FFI::Raw::int,
	FFI::Raw::str
);

say $strlen -> call('somestring');

my $strstr = FFI::Raw -> new(
	'libc.so', 'strstr',
	FFI::Raw::str,
	FFI::Raw::str,
	FFI::Raw::str
);

say $strstr -> call('somestring', 'string');

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
