use FFI::Raw;

my $buf = FFI::Raw::malloc(42);
FFI::Raw::free($buf);
