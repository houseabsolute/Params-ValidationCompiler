use strict;
use warnings;

use Test2::V0;
use Test2::Plugin::NoWarnings;
use Test2::Require::Module 'Specio::Library::Builtins';

use Params::ValidationCompiler qw( validation_for );
use Specio::Library::Builtins;

{
    my $sub = validation_for(
        params => [ { type => t('Str') } ],
    );

    like(
        dies { $sub->( 'foo', 'bar' ) },
        qr{got 1 extra parameter.+called at t/exceptions\.t line \d+}s,
        'exception includes stack trace',
    );
}

done_testing();
