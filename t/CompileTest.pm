package CompileTest;

use strict;
use warnings;

use Config;
use FindBin ();
use ExtUtils::CBuilder;
use Text::ParseWords qw(shellwords);

sub compile {
	my ($src_file) = @_;

	my $b = ExtUtils::CBuilder -> new;

	my $obj_file = $b -> compile(
		source => $src_file,
		include_dirs => [$FindBin::Bin],
	);

	return $b -> link(objects => $obj_file)
		unless ($^O eq 'MSWin32');

	$src_file =~ s/\.c$//;
	$src_file =~ s/^.*(\/|\\)//;

	if ($Config{cc} !~ /cl(\.exe)?$/) {
		my $lddlflags = $Config{lddlflags};
		$lddlflags =~ s{\\}{/}g;

		system $Config{cc}, shellwords($lddlflags), -o => "t/$src_file.dll", "-Wl,--export-all-symbols", $obj_file;
	} else {
		my @cmd = ($Config{cc}, $obj_file, "/link", "/dll", "/out:t/$src_file.dll");

		system @cmd;
	}

	return "t/$src_file.dll";
}

1;
