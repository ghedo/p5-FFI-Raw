package inc::MakeMaker;

use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template  = <<'TEMPLATE';

use Config;

sub MY::postamble {
  if ($^O eq 'MSWin32') {
    return "\t$^X -MAlien::MSYS=msys_run -Minc::MSYSConfigure -e \"configure(); msys_run 'make'\"\n\n";
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

override _build_WriteMakefile_dump => sub {
	my ($self) = @_;
	
	return super() . <<'EXTRA';

if($^O eq 'MSWin32' && $Config{cc} =~ /cl(\.exe)?$/) {
  for(@WriteMakefileArgs{'MYEXTLIB','OBJECT'}) {
    s/libffi.a/libffi.lib/;
  }
  $WriteMakefileArgs{CCFLAGS} = "$Config::Config{ccflags} -DFFI_BUILDING",
}

EXTRA
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
