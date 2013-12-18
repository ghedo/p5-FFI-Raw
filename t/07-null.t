#!perl

use lib 't';

use FFI::Raw;
use CompileTest;

my $test   = '07-null';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

my $return_undef  = FFI::Raw -> new($shared, 'return_undef', FFI::Raw::str);
my $pass_in_undef = FFI::Raw -> new($shared, 'pass_in_undef', FFI::Raw::void, FFI::Raw::str);

$pass_in_undef -> call(undef);

unless (defined $return_undef -> call) {
	print "ok 2 - returned undef\n";
} else {
	print "not ok 2 - returned undef\n";
}

print "1..2\n";
