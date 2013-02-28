package FFI::Raw::MemPtr;

use strict;
use warnings;

=head1 NAME

FFI::Raw::MemPtr - FFI::Raw memory pointer type

=head1 DESCRIPTION

A B<FFI::Raw::MemPtr> represents a memory pointer which can be passed to
functions taking a C<FFI::Raw::ptr> argument.

=head1 METHODS

=head2 new( $number )

Allocate a new C<FFI::Raw::MemPtr> of size C<$number> bytes.

=head2 new_from_buf( $buffer, $number )

Allocate a new C<FFI::Raw::MemPtr> of size C<$number> bytes and copy C<$buffer>
into it. This can be used, for example, to pass a pointer to a function that
takes a C struct pointer, by using C<pack()> or the L<Convert::Binary::C> module
to create the actual struct content.

For example, consider a C function:

    struct some_struct {
      int some_int;
      char some_str[];
    };

    extern void take_one_struct(struct some_struct *arg) {
      if (arg -> some_int == 42)
        puts(arg -> some_str);
    }

It can be called using FFI::Raw as follows:

    use FFI::Raw;

    my $struct = pack('iZ', 42, 'hello');
    my $arg = FFI::Raw::MemPtr -> new_from_buf($packed, 13);

    my $take_one_struct = FFI::Raw -> new(
      $shared, 'take_one_struct',
      FFI::Raw::void, FFI::Raw::ptr
    );

    $take_one_struct -> ($arg);

Which would print C<hello>.

=head2 tostr( [$number] )

Convert a C<FFI::Raw::MemPtr> to a Perl string.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of FFI::Raw::MemPtr
