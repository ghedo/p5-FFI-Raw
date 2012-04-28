#!perl -T

use Test::More;

use FFI::Raw;

my $libc = $^O eq 'MSWin32' ? 'msvcrt.dll' : 'libc.so.6';

my $abs = FFI::Raw -> new(
	$libc, 'abs',
	FFI::Raw::int,
	FFI::Raw::int
);

is($abs -> call(5), 5);
is($abs -> call(10), 10);

is($abs -> call(-5), 5);
is($abs -> call(-10), 10);

my $atoi = FFI::Raw -> new(
	$libc, 'atoi',
	FFI::Raw::int,
	FFI::Raw::str
);

is($atoi -> call('56'), 56);
is($atoi -> call('100'), 100);
is($atoi -> call('-75'), -75);

done_testing;
