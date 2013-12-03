package CompileTest;

use strict;
use warnings;

use ExtUtils::CBuilder;

sub compile {
	my ($src_file) = @_;

	my $b = ExtUtils::CBuilder -> new;

	my $obj_file = $b -> compile(
		source => $src_file,
		extra_compiler_flags => '-std=gnu99'
	);
	my $lib_file = $b -> link(objects => $obj_file);

	return $lib_file;
}

1;
