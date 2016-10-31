package Params::ValidationCompiler;

use strict;
use warnings;

our $VERSION = '0.14';

use Params::ValidationCompiler::Compiler;

use Exporter qw( import );

our @EXPORT_OK = qw( compile source_for validation_for );

sub validation_for {
    return Params::ValidationCompiler::Compiler->new(@_)->subref;
}

## no critic (TestingAndDebugging::ProhibitNoWarnings)
no warnings 'once';
*compile = \&validation_for;
## use critic

sub source_for {
    return Params::ValidationCompiler::Compiler->new(@_)->source_for;
}

1;

# ABSTRACT: Build an optimized subroutine parameter validator once, use it forever

__END__

=pod

=for Pod::Coverage compile

=head1 SYNOPSIS

    use Types::Standard qw( Int Str );
    use Params::ValidationCompiler qw( validation_for );

    {
        my $validator = validation_for(
            params => {
                foo => { type => Int },
                bar => {
                    type     => Str,
                    optional => 1,
                },
                baz => {
                    type    => Int,
                    default => 42,
                },
            },
        );

        sub do_something {
            my %args = $validator->(@_);
        }
    }

=head1 DESCRIPTION

B<This is very alpha. The module name could change. Everything could
change. You have been warned.>

Create a customized, optimized, non-lobotomized, uncompromised, and thoroughly
specialized parameter checking subroutine.

=head1 EXPORTS

This module has two options exports, C<validation_for> and C<source_for>. Both
of these subs accept the same options:

=over 4

=item * params

An arrayref or hashref containing a parameter specification.

If you pass an arrayref, the check will expect positional params. If you are
not using C<validate_pairs_to_value_list>, each member of the arrayref
represents a single parameter to validate. If you are using
C<validate_pairs_to_value_list>, the arrayref should consist of a list of
named params in the order in which the values should be returned from the
subroutine; the parameter names are the keys and the specs are the values.

If you pass a hashref then it will expect named params. For hashrefs, the
parameters names are the keys and the specs are the values.

The spec can contain either a boolean or hashref. If the spec is a boolean,
this indicates required (true) or optional (false).

The hashref accepts the following keys:

=over 8

=item * type

A type object. This can be a L<Moose> type (from L<Moose> or
L<MooseX::Types>), a L<Type::Tiny> type, or a L<Specio> type.

If the type has coercions, those will always be used.

=item * default

This can either be a simple (non-reference) scalar or a subroutine
reference. The sub ref will be called without any arguments (for now).

=item * optional

A boolean indicating whether or not the parameter is optional. By default,
parameters are required unless you provide a default.

=back

=item * slurpy

If this is a simple true value, then the generated subroutine accepts
additional arguments not specified in C<params>. By default, extra arguments
cause an exception.

You can also pass a type constraint here, in which case all extra arguments
must be values of the specified type.


=item * validate_pairs_to_value_list

If this is true, the subroutine generated will expect a list of key-value
pairs or a hashref, and it will return a list containing only the values.
C<params> must be a arrayref of key-value pairs in the order of which the
values should be returned.

=back

=head2 validation_for(...)

This returns a subroutine that implements the specific parameter
checking. Pass this the arguments in C<@_> and it will return a list of
the parameter key-value pairs or throw an exception. The generated subroutine
accepts either a list of key-value pairs or a single hashref.

For now, you must shift off the invocant yourself.

This subroutine accepts an additional parameter:

=over 4

=item * name

If this is given, then the generated subroutine will be named using
L<Sub::Util>. This is strongly recommended as it makes it possible to
distinguish different check subroutines when profiling or in stack traces.

Note that you must install L<Sub::Util> yourself separately, as it is not
required by this distribution, in order to avoid requiring a compiler.

=item * name_is_optional

If this is true, then the name is ignored when C<Sub::Util> is not
installed. If this is false, then passing a name when L<Sub::Util> cannot be
loaded causes an exception.

This is useful for CPAN modules where you want to set a name if you can, but
you do not want to add a prerequisite on L<Sub::Util>.

=back

=head2 source_for(...)

This returns a two element list. The first is a string containing the source
code for the generated sub. The second is a hashref of "environment" variables
to be used when generating the subroutine. These are the arguments that are
passed to L<Eval::Closure>.
