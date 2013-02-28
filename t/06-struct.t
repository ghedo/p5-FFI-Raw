#!perl

use lib 't';

use FFI::Raw;
use CompileTest;

my $test   = '06-struct';
my $source = "./t/$test.c";
my $shared = "./t/$test.so";

print "1..5\n";

CompileTest::compile($source, $shared);

my $packed = pack('iZ', 42, 'hello');

my $arg = FFI::Raw::MemPtr -> new_from_buf($packed, 10);

my $take_one_struct = FFI::Raw -> new(
	$shared, 'take_one_struct',
	FFI::Raw::void, FFI::Raw::ptr
);

$take_one_struct -> call($arg);

print "ok - survived the call\n";

$arg = FFI::Raw::MemPtr -> new(10);

my $return_one_struct = FFI::Raw -> new(
	$shared, 'return_one_struct',
	FFI::Raw::void, FFI::Raw::ptr
);

$return_one_struct -> call($arg);

print "ok - survived the call\n";

my ($int, $str) = unpack('iZ', $arg -> tostr(10));

print "ok - got passed int 42\n" if $int == 42;
# print "ok - str\n" if $str eq 'hello';
