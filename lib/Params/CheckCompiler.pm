package Params::CheckCompiler;

use strict;
use warnings;

our $VERSION = '0.03';

use Params::CheckCompiler::Compiler;

use Exporter qw( import );

our @EXPORT_OK = qw( compile source_for );

sub compile {
    return Params::CheckCompiler::Compiler->new(@_)->subref;
}

sub source_for {
    return Params::CheckCompiler::Compiler->new(@_)->source_for;
}

1;

# ABSTRACT: Build an optimized subroutine parameter validator once, use it forever

__END__

=head1 SYNOPSIS

    use Types::Standard qw( Int Str );
    use Params::CheckCompiler qw( compile );

    {
        my $check = compile(
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
            my %args = $check->(@_);
        }
    }

=head1 DESCRIPTION

B<This is very alpha. The module name could change. Everything could
change. You have been warned.>

Create a customized, optimized, non-lobotomized, uncompromised, and thoroughly
specialized parameter checking subroutine.

=head1 EXPORTS

This module has two options exports, C<compile> and C<source_for>. Both of
these subs accept the same options:

=over 4

=item * params

An arrayref or hashref containing a parameter specification.

If you pass an arrayref, the check will expect positional params. Each member
of the arrayref represents a single parameter to validate.

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

=back

=head2 compile(...)

This returns a subroutine that implements the specific parameter
checking. Pass this the arguments in C<@_> and it will return a hash of
parameters or throw an exception. The compiled subroutine accepts either a
hash or a single hashref.

For now, you must shift off the invocant yourself.

=head2 source_for(...)

This returns a two element list. The first is a string containing the source
code for the generated sub. The second is a hashref of "environment" variables
to be used when generating the subroutine. These are the arguments that are
passed to L<Eval::Closure>.
