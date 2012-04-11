use strict;
use warnings;
use Test::More;
use Test::Fatal;

{
    package L;
    use Class::Accessor::Lite::Lazy (
        new => 1,
        ro  => [ 'foo' ],
        rw  => [ 'bar' ],
        ro_lazy => [ 'hoge' ],
        rw_lazy => [ 'fuga', 'attr_witout_builder' ],
    );

    sub _build_hoge {
        'xxx';
    }

    sub _build_fuga {
        'yyy';
    }
}

my $l = new_ok 'L', [ foo => 1, bar => 2 ];
is $l->foo, 1;
is $l->bar, 2;

$l->bar(3);

is $l->bar, 3;

is_deeply $l, { foo => 1, bar => 3 };

is $l->hoge, 'xxx';
is_deeply $l, { foo => 1, bar => 3, hoge => 'xxx' };

is $l->fuga, 'yyy';
is_deeply $l, { foo => 1, bar => 3, hoge => 'xxx', fuga => 'yyy' };

$l->fuga('zzz');

is $l->fuga, 'zzz';
is_deeply $l, { foo => 1, bar => 3, hoge => 'xxx', fuga => 'zzz' };

ok exception { $l->attr_witout_builder };

done_testing;
