#!perl

use lib 't';

use FFI::Raw;
use CompileTest;

my $test   = '05-callbacks';
my $source = "./t/$test.c";
my $shared = "./t/$test.so";

print "1..3\n";

CompileTest::compile($source, $shared);

my $take_one_int_callback = FFI::Raw -> new(
	$shared, 'take_one_int_callback',
	FFI::Raw::void, FFI::Raw::ptr
);

my $return_int_callback = FFI::Raw -> new(
	$shared, 'return_int_callback',
	FFI::Raw::int, FFI::Raw::ptr
);

my $func1 = sub {
	my $num = shift;

	print ($num == 42 ? "ok 1\n" : "not ok 1\n");
};

my $func2 = sub {
	my $num = shift;

	return $num + 15;
};

my $cb1 = FFI::Raw::callback($func1, FFI::Raw::void, FFI::Raw::int);
my $cb2 = FFI::Raw::callback($func2, FFI::Raw::int, FFI::Raw::int);

$take_one_int_callback -> call($cb1);

print "ok 2 - survived the call\n";

my $check = $return_int_callback -> call($cb2);

print ($check == (42 + 15) ? "ok 3\n" : "not ok 3 - returned $check\n");
