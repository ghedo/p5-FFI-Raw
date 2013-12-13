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
		$name =~ s/\.c$//;
		$name =~ s/^.*(\/|\\)//;
		require Alien::o2dll;
		Alien::o2dll::o2dll(-o => "$name.dll", $obj_file);
		rename "$name.dll", "t/$name.dll";
		rename "$name.dll.a", "t/$name.dll.a";
		"t/$name.dll";
	}
}

1;
