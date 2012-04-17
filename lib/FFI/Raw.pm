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
      'm', 'cos',
      FFI::Raw::double, # return value
      FFI::Raw::double  # arg #1
    );

    say $cos -> call(2.0);

=head1 DESCRIPTION

Some description here...

=head1 METHODS

=head2 new( $library, $function, $return_type [, $arg_type ...] )

Subroutine to do something

=cut

sub new  { FFI::Raw::_ffi_raw_new(@_)  }

=head2 call( [$arg ...])

=cut

sub call { FFI::Raw::_ffi_raw_call(@_) }

sub void    { ord 'v' };
sub integer { ord 'i' };
sub char    { ord 'c' };
sub float   { ord 'f' };
sub double  { ord 'd' };
sub string  { ord 's' };
sub pointer { ord 'p' };

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
