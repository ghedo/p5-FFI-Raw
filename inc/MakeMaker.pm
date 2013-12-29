package inc::MakeMaker;

use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template  = <<'TEMPLATE';

use Config;

sub MY::postamble {
  if ($^O eq 'MSWin32') {
    my $configure_args = 'MAKEILFO=true --disable-builddir --with-pic';

    $configure_args .= ' --build=x86_64-pc-mingw64'
      if $Config{archname} =~ /^MSWin32-x64/;

    return "\t$^X -MAlien::MSYS=msys_run -e \"chdir 'xs/libffi'; msys_run 'sh configure $configure_args'; msys_run 'make'\"\n\n";
  }

  return <<'MAKE_LIBFFI';
$(MYEXTLIB):
	cd xs/libffi && ./configure MAKEINFO=true --disable-builddir --with-pic && $(MAKE)

.NOTPARALLEL:

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
		LIBS	=> '-lpthread',
		OBJECT	=> '$(O_FILES) xs/libffi/.libs/libffi.a',
		MYEXTLIB => 'xs/libffi/.libs/libffi.a',
	}
};

__PACKAGE__ -> meta -> make_immutable;
