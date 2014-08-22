#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

use Test::More;

{
    package Foo;

    use Moo;
    use MooX::AliasedAttributes;

    has foo1 => (
        is => 'rw',
        alias => 'foo_1',
    );

    has foo2 => (
        is => 'rw',
    );
    alias foo_2 => 'foo2',

    has foo3 => (
        is => 'rw',
        writer => 'set_foo3',
        alias => 'foo_3',
    );
}

my $f = Foo->new(
    foo1 => 'one',
    foo2 => 'two',
    foo3 => 'three',
);

is( $f->foo_1(), 'one', 'attribute alias returned value' );
is( $f->foo_2(), 'two', 'alias called method' );
is( $f->foo_3(), undef, 'attribute writer alias returned undef' );
is( $f->foo_3('THREE'), 'THREE', 'attribute writer, with value, alias returned value' );

done_testing;
