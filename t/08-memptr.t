#!perl

use Test::More;
use FFI::Raw;

my $greeting = "Hello\0World";

my $buf = FFI::Raw::MemPtr -> new_from_buf($greeting, length $greeting);

my $got = $buf -> tostr;

is $got, "Hello", "Without arguments, tostr uses strlen() to determine the length";

$got = $buf -> tostr(length $greeting);

is $got, $greeting, "A length to tostr() is honoured, and binary data is retrieved correctly";

$got = $buf -> tostr(0);

is $got, '', "A length of 0 tostr() is handled correctly, returning an empty string";

done_testing;
