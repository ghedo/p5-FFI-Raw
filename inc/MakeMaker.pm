package inc::MakeMaker;

use Moose;
use Devel::CheckLib;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;
	my $template  = "use Devel::CheckLib;\n";
	$template .= "check_lib_or_exit(lib => 'dl');\n";
	$template .= "check_lib_or_exit(lib => 'ffi');\n";

	return $template.super();
};

override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		LIBS	=> ['-ldl -lffi'],
		INC	=> '-I.',
		OBJECT	=> '$(O_FILES)',
	}
};

__PACKAGE__ -> meta -> make_immutable;
