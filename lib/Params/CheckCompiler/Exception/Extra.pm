package Params::CheckCompiler::Exception::Extra;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;

extends 'Throwable::Error';

has parameters => (
    is       => 'ro',
    required => 1,
);

1;
