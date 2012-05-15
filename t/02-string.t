#!perl -T

use Test::More;

use FFI::Raw;

my $libc = 'libc.so.6';

my $strstr = FFI::Raw -> new(
	$libc, 'strstr',
	FFI::Raw::str,
	FFI::Raw::str, FFI::Raw::str
);

is($strstr -> call('somestring', 'string'), 'string');

done_testing;
