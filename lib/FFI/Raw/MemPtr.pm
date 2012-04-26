package FFI::Raw::MemPtr;

use strict;
use warnings;

use FFI::Raw;

=head1 NAME

FFI::Raw::MemPtr - Memory allocation and pointers for FFI::Raw

=head1 METHODS

=head2 new( $number )

Allocate C<$number> bytes and return a C<FFI::Raw::MemPtr> pointing to the
allocated memory. This can be passed to functions which take a FFI::Raw::ptr
argument.

=cut

sub new     { bless \FFI::Raw::_ffi_raw_new_ptr($_[1])  }
sub DESTROY { FFI::Raw::_ffi_raw_destroy_ptr(@_) }

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of FFI::Raw::MemPtr
