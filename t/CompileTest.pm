package CompileTest;

use strict;
use warnings;

use Config;

my $cc = "$Config{ccname} -Wall -g -std=gnu99 $Config{cccdlflags} $Config{ccdlflags} $Config{lddlflags}";

$cc =~ s/(-Wl,)?-fwhole-archive//;

sub compile {
	my ($file, $out) = @_;

	$cc .= " -o $out $file";

	system $cc;
}

1;
