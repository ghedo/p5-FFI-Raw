use strict;
use warnings;
use Test::More;
use FFI::Raw;
use File::Spec;
use lib 't';
use CompileTest;
use File::Basename qw( basename dirname );
use Env qw( @PATH );
use File::Temp qw( tempdir );
use File::Copy qw( cp );

my $test     = '12-absolute-path';
my $source   = "./t/$test.c";
my $shared   = CompileTest::compile($source);
my $absolute = File::Spec->rel2abs($shared);

my $one = FFI::Raw->new($absolute, 'one', FFI::Raw::int);
is $one->(), 1, "absolute $absolute";

SKIP: {
  skip 'requires cygwin or MSWin32', 1
    unless $^O =~ /^(cygwin|MSWin32)$/;
  
  my $tmp = tempdir( CLEANUP => 1 );
  cp($absolute, File::Spec->catfile($tmp, 'foo.dll'));

  push @PATH, $tmp;
  my $one = FFI::Raw->new('foo.dll', 'one', FFI::Raw::int);

  is $one->(), 1, "path $tmp/foo.dll";
}

done_testing;
