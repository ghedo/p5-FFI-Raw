package FFI::Raw::MemPtr;

use strict;
use warnings;

use FFI::Raw;

sub new     { bless \FFI::Raw::_ffi_raw_new_ptr($_[1])  }
sub DESTROY { FFI::Raw::_ffi_raw_destroy_ptr(@_) }

1; # End of FFI::Raw::MemPtr
