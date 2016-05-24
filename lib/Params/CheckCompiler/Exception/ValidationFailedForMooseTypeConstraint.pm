package Params::CheckCompiler::Exception::ValidationFailedForMooseTypeConstraint;

use strict;
use warnings;

our $VERSION = '0.02';

use Moo;

extends 'Throwable::Error';

has parameter => (
    is       => 'ro',
    required => 1,
);

has value => (
    is       => 'ro',
    required => 1,
);

has type => (
    is       => 'ro',
    required => 1,
);

1;

# ABSTRACT: Exception thrown when a Moose type constraint check fails

__END__

=head1 DESCRIPTION

This class provides information about type constraint failures.

=head1 METHODS

This class provides the following methods:

=head2 $e->parameter

This returns a string describing the parameter, something like C<The 'foo'
parameter> or C<Parameter #1>.

=head2 $e->value

This is the value that failed the type constraint check.

=head2 $e->type

This is the type constraint object that did not accept the value.

=head1 STRINGIFICATION

This object stringifies to a reasonable error message.
