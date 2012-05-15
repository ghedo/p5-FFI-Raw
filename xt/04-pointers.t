#!perl

use lib 'xt/';

use Test::More tests => 4;

use FFI::Raw;
use CompileTest;

my $test   = '04-pointers';
my $source = "./xt/$test.c";
my $shared = "./xt/$test.so";

CompileTest::compile($source, $shared);

my $get_test_ptr_size = FFI::Raw -> new(
	$shared, 'get_test_ptr_size', FFI::Raw::int
);

my $take_one_pointer = FFI::Raw -> new(
	$shared, 'take_one_pointer',
	FFI::Raw::void, FFI::Raw::ptr
);

my $return_pointer = FFI::Raw -> new($shared, 'return_pointer', FFI::Raw::ptr);

my $ptr1 = FFI::Raw::memptr($get_test_ptr_size -> call);
$take_one_pointer -> call($ptr1);

my $ptr2 = $return_pointer -> call;

my $return_str_from_ptr = FFI::Raw -> new(
	$shared, 'return_str_from_ptr',
	FFI::Raw::str, FFI::Raw::ptr
);

my $return_int_from_ptr = FFI::Raw -> new(
	$shared, 'return_int_from_ptr',
	FFI::Raw::int, FFI::Raw::ptr
);

my $test_str = 'some string';
my $test_int = 42;

is($return_str_from_ptr -> call($ptr1), $test_str);
is($return_int_from_ptr -> call($ptr1), $test_int);

is($return_str_from_ptr -> call($ptr2), $test_str);
is($return_int_from_ptr -> call($ptr2), $test_int);
