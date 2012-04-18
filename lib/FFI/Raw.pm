package FFI::Raw;

use strict;
use warnings;

require XSLoader;
XSLoader::load('FFI::Raw', $FFI::Raw::VERSION);

=head1 NAME

FFI::Raw - Raw FFI library for Perl

=head1 SYNOPSIS

    use FFI::Raw;

    my $cos = FFI::Raw -> new(
      'libm.so', 'cos',
      FFI::Raw::double, # return value
      FFI::Raw::double  # arg #1
    );

    say $cos -> call(2.0);

=head1 DESCRIPTION

B<FFI::Raw> provides a raw foreign function interface for Perl. It can access
and call functions exported by shared libraries without the need to write a
single line of XS code.

B<Attention>: this is experimental code, use at your own risk

=head1 METHODS

=head2 new($library, $function, $return_type [, $arg_type ...])

Create a new C<FFI::Raw> object. It loads C<$library>, finds the function
C<$function> with return type C<$return_type> and creates a calling interface.

This function takes also a variable number of types, representing the argument
of the wanted function.

=cut

sub new  { FFI::Raw::_ffi_raw_new(@_)  }

sub DESTROY { FFI::Raw::_ffi_raw_destroy(shift) }

=head2 $self -> call([$arg ...])

Execute the C<FFI::Raw> function C<$self>. This function takes also a variable
number of arguments, which are passed to the called function. The argument types
must match the types passed to C<new>.

=cut

sub call { FFI::Raw::_ffi_raw_call(@_) }

=head2 FFI::Raw::void

Return a FFI::Raw void type.

=cut

sub void   { ord 'v' };

=head2 FFI::Raw::int

Return a FFI::Raw integer type.

=cut

sub int    { ord 'i' };

=head2 FFI::Raw::char

Return a FFI::Raw char type.

=cut

sub char   { ord 'c' };

=head2 FFI::Raw::float

Return a FFI::Raw float type.

=cut

sub float  { ord 'f' };

=head2 FFI::Raw::double

Return a FFI::Raw double type.

=cut

sub double { ord 'd' };

=head2 FFI::Raw::str

Return a FFI::Raw string type.

=cut

sub str    { ord 's' };

=head2 FFI::Raw::ptr

Return a FFI::Raw pointer type.

=cut

sub ptr    { ord 'p' };

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of FFI::Raw
