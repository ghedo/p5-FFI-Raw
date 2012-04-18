#!perl -T

use Test::More;

use FFI::Raw;

my $strstr = FFI::Raw -> new(
	'libc.so', 'strstr',
	FFI::Raw::str,
	FFI::Raw::str,
	FFI::Raw::str
);

is($strstr -> call('somestring', 'string'), 'string');

done_testing;
