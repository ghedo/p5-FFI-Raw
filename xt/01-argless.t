#!perl

use lib 'xt/';

use FFI::Raw;
use CompileTest;

my $test   = '01-argless';
my $source = "./xt/$test.c";
my $shared = "./xt/$test.so";

print "1..2\n";

CompileTest::compile($source, $shared);

my $argless = FFI::Raw -> new($shared, 'argless', FFI::Raw::void);

$argless -> call;

print "ok 2 - survived the call\n";
