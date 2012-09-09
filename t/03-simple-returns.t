#!perl

use lib 't';

use Test::More;

use FFI::Raw;
use CompileTest;

my $test   = '03-simple-returns';
my $source = "./t/$test.c";
my $shared = "./t/$test.so";

CompileTest::compile($source, $shared);

my $return_int = FFI::Raw -> new($shared, 'return_int', FFI::Raw::int);
is $return_int -> call, 101;

my $return_short = FFI::Raw -> new($shared, 'return_short', FFI::Raw::short);
is $return_short -> call, 102;

my $return_char = FFI::Raw -> new($shared, 'return_char', FFI::Raw::char);
is $return_char -> call, -103;

my $return_double = FFI::Raw -> new($shared, 'return_double', FFI::Raw::double);
is $return_double -> call, 99.9e0;

my $return_float = FFI::Raw -> new($shared, 'return_float', FFI::Raw::float);
is $return_float -> call, -4.5e0;

my $return_string = FFI::Raw -> new($shared, 'return_string', FFI::Raw::str);
is $return_string -> call, 'epic cuteness';

done_testing;
