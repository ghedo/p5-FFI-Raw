package inc::MakeMaker;

use Moose;
use Devel::CheckLib;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template  = <<'TEMPLATE';
use Devel::CheckLib;

check_lib_or_exit(lib => 'dl') if $^O ne 'MSWin32';
check_lib_or_exit(lib => 'ffi');

TEMPLATE

	return $template.super();
};

override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		LIBS	=> ['-lffi'],
		INC	=> '-I.',
		OBJECT	=> '$(O_FILES)',
	}
};

__PACKAGE__ -> meta -> make_immutable;
