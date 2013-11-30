package CompileTest;

use strict;
use warnings;

use Test::More;

use Config;

my $cc = "$Config{ccname}  -Wall -g -std=gnu99  $Config{cccdlflags}  $Config{lddlflags}";

sub compile {
	my ($file, $out) = @_;

	$cc .= "  -o $out $file";

	diag $cc;
	system $cc;
}

1;
