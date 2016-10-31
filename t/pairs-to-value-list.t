use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::ValidationCompiler qw( validation_for );

{
    my $sub = validation_for(
        params => [
            bar => 0,
            foo => 1,
        ],
        validate_pairs_to_value_list => 1,
    );

    is(
        [ $sub->( foo => 'test' ) ], [ undef, 'test' ],
        'passing required param returns optional values as undef'
    );

    is(
        [ $sub->( foo => 'test', bar => 'b' ) ], [ 'b', 'test' ],
        'optional params are returned as expected'
    );
}

done_testing();
