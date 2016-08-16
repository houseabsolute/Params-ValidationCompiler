use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::ValidationCompiler qw( validation_for );
use Specio::Library::Builtins;

{
    my $sub = validation_for(
        params => [
            1,
            {
                type     => t('Int'),
                optional => 1,
            },
        ],
    );

    is(
        dies { $sub->(42) },
        undef,
        'lives when given 1st param but no 2nd'
    );

    is(
        dies { $sub->( 42, 42 ) },
        undef,
        'lives when given 1st and 2nd params'
    );

    like(
        dies { $sub->() },
        qr/got 0 parameters but expected at least 1/,
        'dies when not given any params'
    );
}

done_testing();
