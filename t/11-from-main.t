use strict;
use warnings;
use Test::More;
use FFI::Raw;

my $isalpha = FFI::Raw->new(undef, 'isalpha', FFI::Raw::int, FFI::Raw::int);
isa_ok $isalpha, 'FFI::Raw';

ok  $isalpha->(ord 'a');
ok !$isalpha->(ord '0');

done_testing;
