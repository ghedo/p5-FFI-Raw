package CompileTest;

use strict;
use warnings;

use ExtUtils::CBuilder;
use Config;
use Text::ParseWords qw( shellwords );

sub compile {
	my ($src_file) = @_;

	my $b = ExtUtils::CBuilder -> new;

	my $obj_file = $b -> compile(
		source => $src_file,
		extra_compiler_flags => '-std=gnu99'
	);

	if ($^O ne 'MSWin32') {
		my $lib_file = $b -> link(objects => $obj_file);
		return $lib_file;
	} else {
		my $name = $src_file;
		$name =~ s/\.c$//;
		$name =~ s/^.*(\/|\\)//;

		my $lddlflags = $Config{lddlflags};
		$lddlflags =~ s{\\}{/}g;
		system $Config{cc}, shellwords($lddlflags), -o => "t/$name.dll", "-Wl,--export-all-symbols", $obj_file;

		return "t/$name.dll";
	}
}

1;
