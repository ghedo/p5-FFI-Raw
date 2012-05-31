package CompileTest;

use strict;
use warnings;

use Config;

my $cc = $Config{ccname};

sub compile {
	my ($file, $out) = @_;

	system($cc, '-shared', '-fPIC', '-o', $out, $file);
}
