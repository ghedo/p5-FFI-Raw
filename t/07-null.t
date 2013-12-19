#!perl

use lib 't';

use FFI::Raw;
use CompileTest;

my $test   = '07-null';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

$| = 1;

my $return_undef_str  = FFI::Raw -> new(
	$shared, 'return_undef_str', FFI::Raw::str
);

my $pass_in_undef_str = FFI::Raw -> new(
	$shared, 'pass_in_undef_str', FFI::Raw::void, FFI::Raw::str
);

$pass_in_undef_str -> call(undef);

unless (defined $return_undef_str -> call) {
	print "ok 2 - returned undef\n";
} else {
	print "not ok 2 - returned undef\n";
}

my $return_undef_ptr  = FFI::Raw -> new(
	$shared, 'return_undef_ptr', FFI::Raw::ptr
);

my $pass_in_undef_ptr = FFI::Raw -> new(
	$shared, 'pass_in_undef_ptr', FFI::Raw::void, FFI::Raw::ptr
);

$pass_in_undef_ptr -> call(undef);

unless (defined $return_undef_ptr -> call) {
	print "ok 4 - returned undef\n";
} else {
	print "not ok 4 - returned undef\n";
}

print "1..4\n";
