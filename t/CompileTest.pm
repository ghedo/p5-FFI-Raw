package CompileTest;

use strict;
use warnings;

use Config;

my $cc = $Config{ccname}.' '.$Config{lddlflags}.' -Wall -g '.$Config{cccdlflags};

sub compile {
	my ($file, $out) = @_;

	$cc .= " -o $out $file";

	system $cc;
}
