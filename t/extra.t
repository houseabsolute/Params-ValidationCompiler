use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::CheckCompiler qw( compile );

{
    my $sub = compile(
        params => {
            foo => 1,
            bar => { optional => 1 },
        },
    );

    like(
        dies { $sub->( foo => 42, extra => [] ) },
        qr/found extra parameters: \[extra\]/,
        'dies when given one extra parameter'
    );

    like(
        dies { $sub->( foo => 42, extra => [], more => 0 ) },
        qr/found extra parameters: \[extra, more\]/,
        'dies when given two extra parameters'
    );
}

{
    my $sub = compile(
        params => {
            foo => 1,
        },
        allow_extra => 1,
    );

    like(
        dies { $sub->() },
        qr/foo is a required parameter/,
        'foo is still required when allow_extra is true'
    );

    is(
        {
            $sub->(
                foo => 42,
                bar => 'whatever',
            )
        },
        {
            foo => 42,
            bar => 'whatever',
        },
        'extra parameters are returned',
    );
}

done_testing();
