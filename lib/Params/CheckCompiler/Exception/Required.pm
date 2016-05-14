package Params::CheckCompiler::Exception::Required;

use strict;
use warnings;

use Moo;

extends 'Throwable::Error';

has parameter => (
    is       => 'ro',
    required => 1,
);

1;
