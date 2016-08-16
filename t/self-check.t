## no critic (Moose::RequireCleanNamespace)
use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::ValidationCompiler qw( validation_for );

like(
    dies { validation_for() },
    qr/\QYou must provide a "params" parameter when creating a parameter validator/,
    'got expected error message when validation_for is called without parameters'
);

like(
    dies { validation_for( params => 42 ) },
    qr/\QThe "params" parameter when creating a parameter validator must be a hashref or arrayref, you passed a scalar/,
    'got expected error message when validation_for is called with params as a scalar'
);

like(
    dies { validation_for( params => undef ) },
    qr/\QThe "params" parameter when creating a parameter validator must be a hashref or arrayref, you passed an undef/,
    'got expected error message when validation_for is called params as an undef'
);

like(
    dies { validation_for( params => \42 ) },
    qr/\QThe "params" parameter when creating a parameter validator must be a hashref or arrayref, you passed a scalarref/,
    'got expected error message when validation_for is called params as a scalarref'
);

like(
    dies { validation_for( params => {}, foo => 1, bar => 2 ) },
    qr/\QYou passed unknown parameters when creating a parameter validator: [bar foo]/,
    'got expected error message when validation_for is called with extra unknown parameters'
);

like(
    dies { validation_for( params => {}, name => undef, ) },
    qr/\QThe "name" parameter when creating a parameter validator must be a scalar, you passed an undef/,
    'got expected error message when validation_for is called with name as an undef'
);

like(
    dies { validation_for( params => {}, name => [], ) },
    qr/\QThe "name" parameter when creating a parameter validator must be a scalar, you passed a arrayref/,
    'got expected error message when validation_for is called with name as an arrayref'
);

done_testing();
