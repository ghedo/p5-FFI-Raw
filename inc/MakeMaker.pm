package inc::MakeMaker;

use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template  = <<'TEMPLATE';
sub MY::postamble {
  return <<'MAKE_LIBFFI';
$(MYEXTLIB):
	cd xs/libffi && ./configure --disable-builddir --with-pic && $(MAKE)

MAKE_LIBFFI
}

TEMPLATE

	return $template.super();
};

my $ccflags = $Config::Config{ccflags} || '';
override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		INC	=> '-I. -Ixs -Ixs/libffi/include',
		LIBS	=> '-pthread',
		OBJECT	=> '$(O_FILES) xs/libffi/.libs/libffi.a',
		MYEXTLIB => 'xs/libffi/.libs/libffi.a',
	}
};

__PACKAGE__ -> meta -> make_immutable;
