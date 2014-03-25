#!perl

use lib 't';

use FFI::Raw;
use CompileTest;

my $test   = '05-callbacks';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

my $take_one_int_callback = FFI::Raw -> new(
	$shared, 'take_one_int_callback',
	FFI::Raw::void, FFI::Raw::ptr
);

my $func1 = sub {
	my $num = shift;

	print ($num == 42 ? "ok\n" : "not ok\n");
};

my $cb1 = FFI::Raw::callback($func1, FFI::Raw::void, FFI::Raw::int);

$take_one_int_callback -> call($cb1);
$take_one_int_callback -> ($cb1);

print "ok - survived the call\n";

my $return_int_callback = FFI::Raw -> new(
	$shared, 'return_int_callback',
	FFI::Raw::int, FFI::Raw::ptr
);

my $func2 = sub {
	my $num = shift;

	return $num + 15;
};

my $cb2 = FFI::Raw::callback($func2, FFI::Raw::int, FFI::Raw::int);

my $check1 = $return_int_callback -> call($cb2);
my $check2 = $return_int_callback -> ($cb2);

print "ok - survived the call\n";

print ($check1 == (42 + 15) ? "ok\n" : "not ok - returned $check1\n");
print ($check2 == (42 + 15) ? "ok\n" : "not ok - returned $check2\n");

sub func3 {
	my $num = shift;

	return $num + 15;
};

my $cb3 = FFI::Raw::callback(\&func3, FFI::Raw::int, FFI::Raw::int);

$check1 = $return_int_callback -> call($cb3);
$check2 = $return_int_callback -> ($cb3);

print "ok - survived the call (anonymous subroutine)\n";

print ($check1 == (42 + 15) ? "ok\n" : "not ok - returned $check1\n");
print ($check2 == (42 + 15) ? "ok\n" : "not ok - returned $check2\n");

my $str_value = "foo";
my $cb4 = FFI::Raw::callback(sub { \$str_value }, FFI::Raw::str);

print "ok - survived the call\n";

my $return_str_callback = FFI::Raw -> new(
	$shared, 'return_str_callback',
	FFI::Raw::void, FFI::Raw::ptr
);

$return_str_callback -> call($cb4);

my $get_str_value = FFI::Raw -> new(
	$shared, 'get_str_value',
	FFI::Raw::str,
);

my $value = $get_str_value -> call();

print ($value eq 'foo' ? "ok\n" : "not ok - returned $value\n");

eval { $return_str_callback -> call(FFI::Raw::callback(sub { "foo" }, FFI::Raw::str)) };

print ($@ =~ /String return value must be returned as a reference for callback/ ? "ok\n" : "not ok - \$\@ = $@\n");

eval { $return_str_callback -> call(FFI::Raw::callback(sub { \"foo" }, FFI::Raw::str)) };

print ($@ =~ /Reference to string must not be anonymous for callback return value/ ? "ok\n" : "not ok - \$\@ = $@\n");

print "1..13\n";
