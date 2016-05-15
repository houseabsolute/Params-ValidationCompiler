package Params::CheckCompiler::Exception::Required;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;

extends 'Throwable::Error';

has parameter => (
    is       => 'ro',
    required => 1,
);

1;
