package inc::MakeMaker;

use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template  = <<'TEMPLATE';

use Config;
use Devel::CheckLib;

my $use_system_ffi = check_lib(lib => "ffi", header => "ffi.h");
my $pkg_config;

if (!$use_system_ffi && eval { require ExtUtils::PkgConfig }) {
  my %pkg_config = eval { ExtUtils::PkgConfig -> find('libffi') };

  unless ($@) {
    if (check_lib(header => "ffi.h", LIBS => $pkg_config{libs}, INC => $pkg_config{cflags})) {
      $use_system_ffi = 1;
      $pkg_config = \%pkg_config;
    }
  }
}

sub MY::postamble {
  return if $use_system_ffi;

  if ($^O eq 'MSWin32') {
    return "\t$^X -MAlien::MSYS=msys_run -Minc::MSYSConfigure -e \"configure(); msys_run 'make'\"\n\n";
  }

  return <<'MAKE_LIBFFI';
$(MYEXTLIB):
	cd deps/libffi && ./configure MAKEINFO=true --disable-builddir --with-pic && $(MAKE)

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

$WriteMakefileArgs{CCFLAGS}   = "$Config{ccflags} $Config{cccdlflags}";
$WriteMakefileArgs{LDDLFLAGS} = "$Config{lddlflags}";

if ($^O eq 'MSWin32' && $Config{cc} =~ /cl(\.exe)?$/) {
  for (@WriteMakefileArgs{'MYEXTLIB','OBJECT'}) {
    s/libffi.a/libffi.lib/;
  }

  $WriteMakefileArgs{CCFLAGS}   .= " -DFFI_BUILDING",
  $WriteMakefileArgs{LDDLFLAGS} .= " psapi.lib";

} elsif ($^O =~ /^(MSWin32|cygwin)$/) {
  push @libs, '-L/usr/lib/w32api' if ($^O eq 'cygwin');
  push @libs, '-lpsapi';
}

if ($^O eq 'openbsd' && !$Config{usethreads}) {
  $WriteMakefileArgs{MYEXTLIB} .= ' /usr/lib/libpthread.a';
}

if ($use_system_ffi) {
  $WriteMakefileArgs{OBJECT} = '$(O_FILES)';

  if ($pkg_config) {
    push @libs, $pkg_config -> {libs};
    $WriteMakefileArgs{CCFLAGS} .= " " . $pkg_config -> {cflags};
  } else {
    push @libs, '-lffi';
  }

  delete $WriteMakefileArgs{MYEXTLIB};
}

$WriteMakefileArgs{LIBS} = "@libs" if @libs;

EXTRA
};

my $ccflags = $Config::Config{ccflags} || '';
override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		INC	=> '-I. -Ixs -Ideps -Ideps/libffi/include',
		OBJECT	=> '$(O_FILES) deps/libffi/.libs/libffi.a',
		MYEXTLIB => 'deps/libffi/.libs/libffi.a',
	}
};

__PACKAGE__ -> meta -> make_immutable;
