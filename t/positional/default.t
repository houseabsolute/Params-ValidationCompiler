use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::ValidationCompiler qw( validation_for );
use Specio::Library::Builtins;

{
    my $validator = validation_for(
        params => [
            { isa => t('Int') },
            { isa => t('Bool'), default => 10, optional => 1 },
        ],
    );

    is(
        [ $validator->(3) ], [ 3, 10 ],
        'able to set defaults on positional validator'
    );

    is(
        [ $validator->( 3, undef ) ], [ 3, undef ],
        'default is only set when element does not exist'
    );

}

done_testing();
