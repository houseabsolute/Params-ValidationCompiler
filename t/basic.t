use strict;
use warnings;

use Test2::Bundle::Extended;

use Params::CheckCompiler qw( compile );

{
    my $sub = compile(
        params => {
            foo => {},
            bar => { optional => 1 },
        },
    );

    ok(
        lives { $sub->( foo => 42 ) },
        'lives when given foo param but no bar'
    );

    ok(
        lives { $sub->( foo => 42, bar => 42 ) },
        'lives when given foo and bar params'
    );

    like(
        dies { $sub->( bar => 42 ) },
        qr/foo is a required parameter/,
        'dies when not given foo param'
    );

    like(
        dies { $sub->( foo => 42, extra => [] ) },
        qr/found unknown parameters: \[extra\]/,
        'dies when given one unknown parameter'
    );

    like(
        dies { $sub->( foo => 42, extra => [], more => 0 ) },
        qr/found unknown parameters: \[extra, more\]/,
        'dies when given two unknown parameters'
    );
}

done_testing();
