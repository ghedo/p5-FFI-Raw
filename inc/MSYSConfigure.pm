package inc::MSYSConfigure;

use strict;
use warnings;

use Config;

use File::Copy qw(copy);
use File::Temp qw(tempdir);
use Alien::MSYS qw(msys_run);

sub main::configure {
	chdir 'xs/libffi';

	my $configure_args = 'MAKEILFO=true --disable-builddir --with-pic';

	if ($Config{archname} =~ /^MSWin32-x64/) {
		$configure_args .= ' --build=x86_64-pc-mingw64';
	}

	if ($Config{cc} =~ /cl(\.exe)?$/) {
		my $dir = tempdir( CLEANUP => 1 );

		copy('msvcc.sh', "$dir/msvcc.sh");
		$ENV{PATH} = join($Config{path_sep}, $dir, $ENV{PATH});

		$configure_args .= ' --enable-static --disable-shared';

		if ($Config{archname} =~ /^MSWin32-x64/) {
			$configure_args .= ' CC="msvcc.sh -m64"';
		} else {
			$configure_args .= ' CC=msvcc.sh';
		}

		$configure_args .= ' LD=link';
	}

	print "sh configure $configure_args\n";
	msys_run "sh configure $configure_args"
}

1;
