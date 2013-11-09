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
		INC	=> '-I. -Ixs/p5-Math-Int64/ -Ixs/p5-Math-Int64/c_api_client -Ixs/libffi/include',
		DIR => ['xs/p5-Math-Int64'],
		OBJECT	=> '$(O_FILES) perl_math_int64.o xs/libffi/.libs/libffi.a',
		CCFLAGS => "$ccflags xs/p5-Math-Int64/c_api_client/perl_math_int64.c",
		MYEXTLIB => 'xs/libffi/.libs/libffi.a',
	}
};

__PACKAGE__ -> meta -> make_immutable;
