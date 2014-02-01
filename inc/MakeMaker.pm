package inc::MakeMaker;

use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template  = <<'TEMPLATE';

use Config;
use Devel::CheckLib;

my $use_system_ffi = check_lib(lib => "ffi", header => "ffi.h");

sub MY::postamble {
  if ($^O eq 'MSWin32') {
    return "\t$^X -MAlien::MSYS=msys_run -Minc::MSYSConfigure -e \"configure(); msys_run 'make'\"\n\n";
  }

  return if $use_system_ffi;

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

my @libs;

if ($^O eq 'MSWin32' && $Config{cc} =~ /cl(\.exe)?$/) {
  for (@WriteMakefileArgs{'MYEXTLIB','OBJECT'}) {
    s/libffi.a/libffi.lib/;
  }

  $WriteMakefileArgs{CCFLAGS}   = "$Config{ccflags} -DFFI_BUILDING",
  $WriteMakefileArgs{LDDLFLAGS} = "$Config{lddlflags} psapi.lib";
  
} elsif ($^O =~ /^(MSWin32|cygwin)$/) {
  if ($^O eq 'cygwin') {
    push @libs, '-L/usr/lib/w32api';
  }
  push @libs, '-lpsapi';
}

if ($^O eq 'openbsd' && !$Config{usethreads}) {
  $WriteMakefileArgs{MYEXTLIB} .= ' /usr/lib/libpthread.a';
}

if ($use_system_ffi) {
  $WriteMakefileArgs{OBJECT} = '$(O_FILES)';
  push @libs, '-lffi';
  delete $WriteMakefileArgs{MYEXTLIB};
}

$WriteMakefileArgs{LIBS} = "@libs" if @libs;

EXTRA
};

my $ccflags = $Config::Config{ccflags} || '';
override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		INC	=> '-I. -Ixs -Ixs/libffi/include',
		OBJECT	=> '$(O_FILES) xs/libffi/.libs/libffi.a',
		MYEXTLIB => 'xs/libffi/.libs/libffi.a',
	}
};

__PACKAGE__ -> meta -> make_immutable;
