package Params::CheckCompiler::Exception::Named::Extra;

use strict;
use warnings;

our $VERSION = '0.02';

use Moo;

extends 'Throwable::Error';

has parameters => (
    is       => 'ro',
    required => 1,
);

1;

# ABSTRACT: Exception thrown when @_ contains unexpected extra named arguments

__END__

=for Pod::Coverage .*
