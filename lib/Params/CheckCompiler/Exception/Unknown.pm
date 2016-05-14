package Params::CheckCompiler::Exception::Unknown;

use strict;
use warnings;

use Moo;

extends 'Throwable::Error';

has parameters => (
    is       => 'ro',
    required => 1,
);

1;
