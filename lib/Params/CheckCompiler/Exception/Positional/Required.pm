package Params::CheckCompiler::Exception::Positional::Required;

use strict;
use warnings;

our $VERSION = '0.03';

use Moo;

extends 'Throwable::Error';

has minimum => (
    is       => 'ro',
    required => 1,
);

has got => (
    is       => 'ro',
    required => 1,
);

1;

# ABSTRACT: Exception thrown when a required positional parameter is not passed

__END__

=for Pod::Coverage .*
