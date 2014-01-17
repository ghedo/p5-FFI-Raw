package FFI::Raw::Ptr;

use strict;
use warnings;

sub new {
	my($class, $ptr) = @_;
	bless \$ptr, $class;
}

1; # End of FFI::Raw::Ptr
