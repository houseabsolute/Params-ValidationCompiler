use strict;
use warnings;

use Test2::Bundle::Extended;

use Params::CheckCompiler qw( compile );

{
    my $sub = compile(
        params => {
            foo => 1,
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
}

done_testing();
