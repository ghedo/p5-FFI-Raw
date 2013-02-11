#!perl

use lib 't';

use FFI::Raw;
use CompileTest;

my $test   = '06-struct';
my $source = "./t/$test.c";
my $shared = "./t/$test.so";

print "1..3\n";

CompileTest::compile($source, $shared);

my $packed = pack('iZ', 42, 'hello');

my $arg = FFI::Raw::MemPtr -> new_from_buf($packed, 13);

my $take_one_struct = FFI::Raw -> new(
	$shared, 'take_one_struct',
	FFI::Raw::void, FFI::Raw::ptr
);

$take_one_struct -> call($arg);

print "ok - survived the call\n";
