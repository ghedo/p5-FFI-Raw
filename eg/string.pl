use v5.10;

use strict;
use warnings;

use FFI::Raw;

my $libc = 'libc.so.6';

my $strlen = FFI::Raw -> new(
	$libc, 'strlen',
	FFI::Raw::int,
	FFI::Raw::str
);

say $strlen -> call('somestring');

my $strstr = FFI::Raw -> new(
	$libc, 'strstr',
	FFI::Raw::str,
	FFI::Raw::str,
	FFI::Raw::str
);

say $strstr -> call('somestring', 'string');

my $puts = FFI::Raw -> new(
	$libc, 'puts',
	FFI::Raw::int,
	FFI::Raw::str
);

say $puts -> call("lol");

my $strerror = FFI::Raw -> new(
	$libc, 'strerror',
	FFI::Raw::str,
	FFI::Raw::int
);

say $strerror -> call(2);
