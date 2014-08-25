package MooX::AliasedAttributes;
$MooX::AliasedAttributes::VERSION = '0.03';
use strictures 1;

=head1 NAME

MooX::AliasedAttributes - Make aliases to your attributes, and methods.

=head1 SYNOPSIS

    package Foo;
    use Moo;
    use MooX::AliasedAttributes;
    
    has color => (
        is    => 'rw',
        alias => 'colour',
    );

    alias bar => 'color';
    
    my $foo = Foo->new( color=>'red' );
    
    print $foo->colour(); # red
    $foo->colour('green');
    print $foo->color(); # green
    
    print $foo->bar(); # green

=head1 DESCRIPTION

Aliases a method to an attribute's C<name>.  Note that if you set either
C<writer> or C<reader> that this has no affect onthe alias, the alias
will still point at the attribute name.

This module came to life to help port L<Moose> code using L<MooseX::Aliases>
to L<Moo>.  In order to port you existing code from L<Moose> to L<Moo> you
should just be able to replace C<use MooseX::Aliases;> with
C<use MooX::AliasedAttributes;>.

=cut

use Class::Method::Modifiers qw( install_modifier );

sub import {
    my $target = caller();

    my $around = $target->can('around');
    my $fresh = sub{ install_modifier( $target, 'fresh', @_ ) };

    $fresh->(
        alias => sub{
            my ($aliases, $method) = @_;
            $aliases = [ $aliases ] if !ref $aliases;

            foreach my $alias ($aliases) {
                $fresh->( $alias => sub{ shift()->$method(@_) } );
            }
        },
    );

    my $alias = $target->can('alias');

    $around->(
        has => sub{
            my ($orig, $name, %attributes) = @_;

            my $aliases = delete $attributes{alias};
            $orig->( $name, %attributes );
            return if !$aliases;

            $alias->( $aliases, $name );

            return;
        },
    );

    return;
}

1;
__END__

=head1 AUTHOR

Aran Clary Deltac <bluefeet@gmail.com>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
