use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

use Params::CheckCompiler qw( compile );

{
    my $sub = compile(
        name   => 'Check for X',
        params => { foo => 1 },
    );

    like(
        dies { $sub->() },
        qr/main::Check for X/,
        'got expected sub name in stack trace',
    );
}

done_testing();
