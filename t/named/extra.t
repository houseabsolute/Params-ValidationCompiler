use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::CheckCompiler qw( compile );
use Types::Standard qw( Int );

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

{
    my $sub = compile(
        params => {
            foo => 1,
        },
        allow_extra => Int,
    );

    like(
        dies { $sub->() },
        qr/foo is a required parameter/,
        'foo is still required when allow_extra is a type constraint'
    );

    is(
        {
            $sub->(
                foo => 42,
                bar => 43,
            )
        },
        {
            foo => 42,
            bar => 43,
        },
        'extra parameters are returned when they pass the type constraint',
    );

    like(
        dies {
            $sub->( foo => 42, bar => 'string' );
        },
        qr/Value "string" did not pass type constraint "Int"/,
        'extra parameters are type checked with one extra',
    );

    like(
        dies {
            $sub->( foo => 42, baz => 1, bar => 'string' );
        },
        qr/Value "string" did not pass type constraint "Int"/,
        'all extra parameters are type checked with multiple extras',
    );
}

done_testing();
