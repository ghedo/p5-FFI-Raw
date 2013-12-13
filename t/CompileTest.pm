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
	
	if($^O ne 'MSWin32') {
		my $lib_file = $b -> link(objects => $obj_file);
		return $lib_file;
	} else {
		my $name = $src_file;
		$name =~ s/-/_/g;
		$name =~ s/\.c$//;
		$name =~ s/^.*(\/|\\)//;
		print "# name = $name\n";
		my $lib_file = $b -> link(objects => $obj_file, module_name => $name);
		return $lib_file;
	}
}

1;
