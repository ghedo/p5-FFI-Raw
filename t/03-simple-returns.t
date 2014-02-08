#!perl

use lib 't';

use Test::More;

use POSIX;

use FFI::Raw;
use CompileTest;

use Math::BigInt;

my $test   = '03-simple-returns';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

my $min_int64  = Math::BigInt -> new('-9223372036854775808');
my $max_uint64 = Math::BigInt -> new('18446744073709551615');

SKIP: {
eval "use Math::Int64";

skip 'Math::Int64 required for int64 tests', 4 if $@;

my $return_int64 = eval { FFI::Raw -> new($shared, 'return_int64', FFI::Raw::int64) };

skip 'LLONG_MIN and ULLONG_MAX required for int64 tests', 4 if $@;

is $return_int64 -> call, $min_int64->bstr();
is $return_int64 -> (), $min_int64->bstr();

my $return_uint64 = FFI::Raw -> new($shared, 'return_uint64', FFI::Raw::uint64);
is $return_uint64 -> call, $max_uint64->bstr();
is $return_uint64 -> (), $max_uint64->bstr();
};

my $return_long = FFI::Raw -> new($shared, 'return_long', FFI::Raw::long);
is $return_long -> call, LONG_MIN;
is $return_long -> (), LONG_MIN;

my $return_ulong = FFI::Raw -> new($shared, 'return_ulong', FFI::Raw::ulong);
is $return_ulong -> call, ULONG_MAX;
is $return_ulong -> (), ULONG_MAX;

my $return_int = FFI::Raw -> new($shared, 'return_int', FFI::Raw::int);
is $return_int -> call, INT_MIN;
is $return_int -> (), INT_MIN;

my $return_uint = FFI::Raw -> new($shared, 'return_uint', FFI::Raw::uint);
is $return_uint -> call, UINT_MAX;
is $return_uint -> (), UINT_MAX;

my $return_short = FFI::Raw -> new($shared, 'return_short', FFI::Raw::short);
is $return_short -> call, SHRT_MIN;
is $return_short -> (), SHRT_MIN;

my $return_ushort = FFI::Raw -> new($shared, 'return_ushort', FFI::Raw::ushort);
is $return_ushort -> call, USHRT_MAX;
is $return_ushort -> (), USHRT_MAX;

my $return_char = FFI::Raw -> new($shared, 'return_char', FFI::Raw::char);
is $return_char -> call, CHAR_MIN;
is $return_char -> (), CHAR_MIN;

my $return_uchar = FFI::Raw -> new($shared, 'return_uchar', FFI::Raw::uchar);
is $return_uchar -> call, UCHAR_MAX;
is $return_uchar -> (), UCHAR_MAX;

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
