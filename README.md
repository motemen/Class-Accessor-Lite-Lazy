# NAME

Class::Accessor::Lite::Lazy - Class::Accessor::Lite with lazy accessor feature

# SYNOPSIS

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

# DESCRIPTION

Class::Accessor::Lite::Lazy provides a "lazy" accessor feature to [Class::Accessor::Lite](http://search.cpan.org/perldoc?Class::Accessor::Lite).

If a lazy accessor without any value set is called, a builder method is called to generate a value to set.
The builder for an accessor _$attr_ should be named as \_build\__$attr_.

# THE USE STATEMENT

As [Class::Accessor::Lite](http://search.cpan.org/perldoc?Class::Accessor::Lite), the use statement provides the way to create lazy accessors.

- rw\_lazy => \\@name\_of\_the\_properties

Creates read / write lazy accessors.

- ro\_lazy => \\@name\_of\_the\_properties

Creates read-only lazy accessors.

- new, rw, ro, wo

Same as [Class::Accessor::Lite](http://search.cpan.org/perldoc?Class::Accessor::Lite).

# FUNCTIONS

- Class::Accessor::Lite::Lazy->mk\_lazy\_accessors(@name\_of\_the\_properties);

Creates lazy accessors in current package.

- Class::Accessor::Lite::Lazy->mk\_ro\_lazy\_accessors(@name\_of\_the\_properties);

Creates read-only lazy accessors in current package.

# AUTHOR

motemen <motemen@gmail.com>

# SEE ALSO

[Class::Accessor::Lite](http://search.cpan.org/perldoc?Class::Accessor::Lite)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.