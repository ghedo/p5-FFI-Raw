#!perl

use lib 't';

use Config;

use FFI::Raw;
use CompileTest;

my $test   = '06-struct';
my $source = "./t/$test.c";
my $shared = "./t/$test.$Config{dlext}";

print "1..7\n";

CompileTest::compile($source, $shared);

my $int_arg = 42;
my $str_arg = "hello";

my $packed = pack('ix![p]p', 42, $str_arg);

my $arg = FFI::Raw::MemPtr -> new_from_buf($packed, length $packed);

my $take_one_struct = FFI::Raw -> new(
	$shared, 'take_one_struct',
	FFI::Raw::void, FFI::Raw::ptr
);

$take_one_struct -> call($arg);

print "ok - survived the call\n";

$arg = FFI::Raw::MemPtr -> new(length $packed);

my $return_one_struct = FFI::Raw -> new(
	$shared, 'return_one_struct',
	FFI::Raw::void, FFI::Raw::ptr
);

$return_one_struct -> call($arg);

print "ok - survived the call\n";

my ($int, $str) = unpack('ix![p]p', $arg -> tostr(length $packed));

print "ok - got passed int 42\n" if $int == 42;
print "ok - str\n" if $str eq 'hello';
