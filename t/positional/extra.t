use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::CheckCompiler qw( compile );
use Types::Standard qw( Int );

{
    my $sub = compile(
        params => [
            1,
            { optional => 1 },
        ],
    );

    like(
        dies { $sub->( 42, 43, 44 ) },
        qr/got 1 extra parameter/,
        'dies when given one extra parameter'
    );

    like(
        dies { $sub->( 42, 43, 44, 'whuh' ) },
        qr/got 2 extra parameters/,
        'dies when given two extra parameters'
    );
}

{
    my $sub = compile(
        params => [
            1,
        ],
        allow_extra => 1,
    );

    like(
        dies { $sub->() },
        qr/got 0 parameters but expected at least 1/,
        'foo is still required when allow_extra is true'
    );

    is(
        [ $sub->( 42, 'whatever' ) ],
        [ 42, 'whatever' ],
        'extra parameters are returned',
    );
}

{
    my $sub = compile(
        params => [
            1,
        ],
        allow_extra => Int,
    );

    like(
        dies { $sub->() },
        qr/got 0 parameters but expected at least 1/,
        'foo is still required when allow_extra is a type constraint'
    );

    is(
        [ $sub->( 42, 43 ) ],
        [ 42, 43 ],
        'one extra parameter is returned when they pass the type constraint',
    );

    is(
        [ $sub->( 42, 43, 44 ) ],
        [ 42, 43, 44 ],
        'two extra parameters are returned when they pass the type constraint',
    );
}

done_testing();
