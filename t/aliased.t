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
}

my $f = Foo->new(
    foo1 => 'one',
    foo2 => 'two',
);

is( $f->foo_1(), 'one', 'attribute alias returned value' );
is( $f->foo_2(), 'two', 'alias called method' );

done_testing;
