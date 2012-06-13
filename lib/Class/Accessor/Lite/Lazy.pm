package Class::Accessor::Lite::Lazy;
use strict;
use warnings;
use 5.008_001;
use parent 'Class::Accessor::Lite';
use Carp ();

our $VERSION = '0.02';

my %key_ctor = (
    ro_lazy => \&_mk_ro_lazy_accessors,
    rw_lazy => \&_mk_lazy_accessors,
);

sub import {
    my ($class, %args) = @_;
    my $pkg = caller;
    foreach my $key (sort keys %key_ctor) {
        if (defined (my $value = delete $args{$key})) {
            Carp::croak "value of the '$key' parameter should be an arrayref"
                unless ref($value) eq 'ARRAY';
            $key_ctor{$key}->($pkg, @$value);
        }
    }
    @_ = ($class, %args);
    goto \&Class::Accessor::Lite::import;
}

sub mk_lazy_accessors {
    (undef, my @properties) = @_;
    my $pkg = caller;
    _mk_lazy_accessors($pkg, @properties);
}

sub mk_ro_lazy_accessors {
    (undef, my @properties) = @_;
    my $pkg = caller;
    _mk_ro_lazy_accessors($pkg, @properties);
}

sub _mk_ro_lazy_accessors {
    my $pkg = shift;
    my %decls = map { ref $_ eq 'HASH' ? ( %$_ ) : ( $_ => undef ) } @_;
    no strict 'refs';
    while (my ($name, $builder) = each %decls) {
        *{"$pkg\::$name"} = __m_ro_lazy($pkg, $name, $builder);
    }
}

sub _mk_lazy_accessors {
    my $pkg = shift;
    my %decls = map { ref $_ eq 'HASH' ? ( %$_ ) : ( $_ => undef ) } @_;
    no strict 'refs';
    while (my ($name, $builder) = each %decls) {
        *{"$pkg\::$name"} = __m_lazy($name, $builder);
    }
}

sub __m_ro_lazy {
    my ($pkg, $name, $builder) = @_;
    $builder = "_build_$name" unless defined $builder;
    return sub {
        if (@_ == 1) {
            return $_[0]->{$name} if exists $_[0]->{$name};
            return $_[0]->{$name} = $_[0]->$builder;
        } else {
            my $caller = caller(0);
            Carp::croak("'$caller' cannot access the value of '$name' on objects of class '$pkg'");
        }
    };
}

sub __m_lazy {
    my ($name, $builder) = @_;
    $builder = "_build_$name" unless defined $builder;
    return sub {
        if (@_ == 1) {
            return $_[0]->{$name} if exists $_[0]->{$name};
            return $_[0]->{$name} = $_[0]->$builder;
        } elsif (@_ == 2) {
            return $_[0]->{$name} = $_[1];
        } else {
            return shift->{$name} = \@_;
        }
    };
}

1;

__END__

=head1 NAME

Class::Accessor::Lite::Lazy - Class::Accessor::Lite with lazy accessor feature

=head1 SYNOPSIS

  package MyPackage;

  use Class::Accessor::Lite::Lazy (
      rw_lazy => [ qw(foo) ],
      ro_lazy => [ qw(bar) ],
      # Class::Accessor::Lite functionality is also available
      new => 1,
      rw  => [ qw(baz) ],
  );

  sub _build_foo {
      my $self = shift;
      ...
  }

  sub _build_bar {
      my $self = shift;
      ...
  }

=head1 DESCRIPTION

Class::Accessor::Lite::Lazy provides a "lazy" accessor feature to L<Class::Accessor::Lite>.

If a lazy accessor without any value set is called, a builder method is called to generate a value to set.
The builder for an accessor I<$attr> should be named as _build_I<$attr>.

=head1 THE USE STATEMENT

As L<Class::Accessor::Lite>, the use statement provides the way to create lazy accessors.

=over 4

=item rw_lazy => \@name_of_the_properties

Creates read / write lazy accessors.

=item ro_lazy => \@name_of_the_properties

Creates read-only lazy accessors.

=item new, rw, ro, wo

Same as L<Class::Accessor::Lite>.

=back

=head1 FUNCTIONS

=over 4

=item Class::Accessor::Lite::Lazy->mk_lazy_accessors(@name_of_the_properties);

Creates lazy accessors in current package.

=item Class::Accessor::Lite::Lazy->mk_ro_lazy_accessors(@name_of_the_properties);

Creates read-only lazy accessors in current package.

=back

=head1 AUTHOR

motemen E<lt>motemen@gmail.comE<gt>

=head1 SEE ALSO

L<Class::Accessor::Lite>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
