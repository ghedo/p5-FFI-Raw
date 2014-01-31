#!perl

use lib 't';

use Test::More;

use FFI::Raw;
use CompileTest;

my $ffi;
eval {
    $ffi = FFI::Raw -> new('libfoo.X', 'foo', FFI::Raw::void);
};

ok !$ffi;

my $test   = '10-overload';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

$ffi = FFI::Raw -> new($shared, 'foo', FFI::Raw::void);

ok $ffi;

done_testing;
