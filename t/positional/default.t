use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::ValidationCompiler qw( validation_for );
use Specio::Declare;
use Specio::Library::Builtins;

{
    my $validator = validation_for(
        params => [
            { type => t('Int') },
            {
                default  => 10,
                optional => 1,
            },
        ],
    );

    is(
        [ $validator->(3) ],
        [ 3, 10 ],
        'able to set defaults on positional validator'
    );

    is(
        [ $validator->( 3, undef ) ],
        [ 3, undef ],
        'default is only set when element does not exist'
    );
}

{
    my $validator = validation_for(
        params => [
            1,
            { default => 0 },
        ],
    );

    is(
        [ $validator->(0) ],
        [ 0, 0 ],
        'positional params with default are optional'
    );
}

done_testing();
