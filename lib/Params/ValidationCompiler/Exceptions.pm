package Params::ValidationCompiler::Exceptions;

use strict;
use warnings;

our $VERSION = '0.32';

use Exception::Class (
    'Params::ValidationCompiler::Exception::BadArguments',
    'Params::ValidationCompiler::Exception::Named::Extra' => {
        fields => ['parameters'],
    },
    'Params::ValidationCompiler::Exception::Named::Required' => {
        fields => ['parameter'],
    },
    'Params::ValidationCompiler::Exception::Positional::Extra' => {
        fields => [ 'got', 'maximum' ],
    },
    'Params::ValidationCompiler::Exception::Positional::Required' => {
        fields => [ 'got', 'minimum' ],
    },
    'Params::ValidationCompiler::Exception::ValidationFailedForMooseTypeConstraint'
        => {
        fields => [qw( parameter value type )],
        },
);

1;

# ABSTRACT: Defines exceptions thrown by Params::ValidationCompiler

__END__

=head1 DESCRIPTION

This module defines the following exceptions:

=head2 Params::ValidationCompiler::Exception::BadArguments

Exception thrown when @_ does not contain a hash or hashref.

=head2 Params::ValidationCompiler::Exception::Named::Extra

Exception thrown when @_ contains unexpected extra named arguments.

=head2 Params::ValidationCompiler::Exception::Named::Required

Exception thrown when a required named parameter is not passed.

=head2 Params::ValidationCompiler::Exception::Positional::Extra

Exception thrown when @_ contains unexpected extra arguments.

=head2 Params::ValidationCompiler::Exception::Positional::Required

Exception thrown when a required positional parameter is not passed.

=head2 Params::ValidationCompiler::Exception::ValidationFailedForMooseTypeConstraint

Exception thrown when a Moose type constraint check fails. This class provides
the following methods:

=head3 $e->parameter

This returns a string describing the parameter, something like C<The 'foo'
parameter> or C<Parameter #1>.

=head3 $e->value

This is the value that failed the type constraint check.

=head3 $e->type

This is the type constraint object that did not accept the value.

