package inc::MakeMaker;

use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template  = <<'TEMPLATE';
chdir('xs/libffi');
system('./configure --disable-builddir --with-pic');
system('make');
chdir('../..');

TEMPLATE

	return $template.super();
};

override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		INC	=> '-I. -Ixs/libffi/include',
		LIBS	=> ['-pthread'],
		OBJECT	=> '$(O_FILES) xs/libffi/.libs/libffi.a',
	}
};

__PACKAGE__ -> meta -> make_immutable;
