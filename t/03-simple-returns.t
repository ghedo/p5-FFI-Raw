#!perl

use lib 't';

use Test::More;

use FFI::Raw;
use CompileTest;
use POSIX;

my $test   = '03-simple-returns';
my $source = "./t/$test.c";
my $shared = "./t/$test.so";

CompileTest::compile($source, $shared);

my $return_long = FFI::Raw -> new($shared, 'return_long', FFI::Raw::long);
is $return_long -> call, LONG_MIN;
is $return_long -> (), LONG_MIN;

my $return_ulong = FFI::Raw -> new($shared, 'return_ulong', FFI::Raw::ulong);
is $return_ulong -> call, ULONG_MAX;
is $return_ulong -> (), ULONG_MAX;

my $return_int = FFI::Raw -> new($shared, 'return_int', FFI::Raw::int);
is $return_int -> call, 101;
is $return_int -> (), 101;

my $return_short = FFI::Raw -> new($shared, 'return_short', FFI::Raw::short);
is $return_short -> call, 102;
is $return_short -> (), 102;

my $return_char = FFI::Raw -> new($shared, 'return_char', FFI::Raw::char);
is $return_char -> call, -103;
is $return_char -> (), -103;

my $return_double = FFI::Raw -> new($shared, 'return_double', FFI::Raw::double);

TODO: {
	local $TODO = 'failing';
	is $return_double -> call, 9.9e0;
	is $return_double -> (), 9.9e0;
};

my $return_float = FFI::Raw -> new($shared, 'return_float', FFI::Raw::float);
is $return_float -> call, -4.5e0;
is $return_float -> (), -4.5e0;

my $return_string = FFI::Raw -> new($shared, 'return_string', FFI::Raw::str);
is $return_string -> call, 'epic cuteness';
is $return_string -> (), 'epic cuteness';

done_testing;
