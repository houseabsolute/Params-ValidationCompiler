package Params::CheckCompiler::Exception::Positional::Extra;

use strict;
use warnings;

our $VERSION = '0.02';

use Moo;

extends 'Throwable::Error';

has maximum => (
    is       => 'ro',
    required => 1,
);

has got => (
    is       => 'ro',
    required => 1,
);

1;

# ABSTRACT: Exception thrown when @_ contains unexpected extra arguments

__END__

=for Pod::Coverage .*
