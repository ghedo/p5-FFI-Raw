#!perl

use lib 't';

use FFI::Raw;
use CompileTest;

my $test   = '02-simple-args';
my $source = "./t/$test.c";
my $shared = "./t/$test.so";

CompileTest::compile($source, $shared);

# integers
my $take_one_int = FFI::Raw -> new(
	$shared, 'take_one_int',
	FFI::Raw::void, FFI::Raw::int
);

$take_one_int -> call(42);

my $take_two_shorts = FFI::Raw -> new(
	$shared, 'take_two_shorts',
	FFI::Raw::void, FFI::Raw::short, FFI::Raw::short
);

$take_two_shorts -> call(10, 20);

my $take_misc_ints = FFI::Raw -> new(
	$shared, 'take_misc_ints',
	FFI::Raw::void, FFI::Raw::int, FFI::Raw::short, FFI::Raw::char
);

$take_misc_ints -> call(101, 102, 103);
$take_misc_ints -> (101, 102, 103);

# floats
my $take_one_double = FFI::Raw -> new(
	$shared, 'take_one_double',
	FFI::Raw::void, FFI::Raw::double
);

$take_one_double -> call(-6.9e0);
$take_one_double -> (-6.9e0);

my $take_one_float = FFI::Raw -> new(
	$shared, 'take_one_float',
	FFI::Raw::void, FFI::Raw::float
);

$take_one_float -> call(4.2e0);
$take_one_float -> (4.2e0);

# strings
my $take_one_string = FFI::Raw -> new(
	$shared, 'take_one_string',
	FFI::Raw::void, FFI::Raw::str
);

$take_one_string -> call('ok - passed a string');
$take_one_string -> ('ok - passed a string');

print "1..15\n";
