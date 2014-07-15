#!perl

use Test::More;
use FFI::Raw;

my $greeting = "Hello\0World";

my $buf = FFI::Raw::MemPtr -> new_from_buf($greeting, length $greeting);

my $got = $buf -> to_perl_str;

is $got, "Hello", "Without arguments, to_perl_str uses strlen() to determine the length";

$got = $buf -> to_perl_str(length $greeting);

is $got, $greeting, "A length to to_perl_str() is honoured, and binary data is retrieved correctly";

$got = $buf -> to_perl_str(0);

is $got, '', "A length of 0 to_perl_str() is handled correctly, returning an empty string";

done_testing;
