# NAME

Params::ValidationCompiler - Build an optimized subroutine parameter validator once, use it forever

# VERSION

version 0.08

# SYNOPSIS

    use Types::Standard qw( Int Str );
    use Params::ValidationCompiler qw( validation_for );

    {
        my $check = validation_for(
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

# DESCRIPTION

**This is very alpha. The module name could change. Everything could
change. You have been warned.**

Create a customized, optimized, non-lobotomized, uncompromised, and thoroughly
specialized parameter checking subroutine.

# EXPORTS

This module has two options exports, `validation_for` and `source_for`. Both
of these subs accept the same options:

- params

    An arrayref or hashref containing a parameter specification.

    If you pass an arrayref, the check will expect positional params. Each member
    of the arrayref represents a single parameter to validate.

    If you pass a hashref then it will expect named params. For hashrefs, the
    parameters names are the keys and the specs are the values.

    The spec can contain either a boolean or hashref. If the spec is a boolean,
    this indicates required (true) or optional (false).

    The hashref accepts the following keys:

    - type

        A type object. This can be a [Moose](https://metacpan.org/pod/Moose) type (from [Moose](https://metacpan.org/pod/Moose) or
        [MooseX::Types](https://metacpan.org/pod/MooseX::Types)), a [Type::Tiny](https://metacpan.org/pod/Type::Tiny) type, or a [Specio](https://metacpan.org/pod/Specio) type.

        If the type has coercions, those will always be used.

    - default

        This can either be a simple (non-reference) scalar or a subroutine
        reference. The sub ref will be called without any arguments (for now).

    - optional

        A boolean indicating whether or not the parameter is optional. By default,
        parameters are required unless you provide a default.

- slurpy

    If this is a simple true value, then the generated subroutine accepts
    additional arguments not specified in `params`. By default, extra arguments
    cause an exception.

    You can also pass a type constraint here, in which case all extra arguments
    must be values of the specified type.

## validation\_for(...)

This returns a subroutine that implements the specific parameter
checking. Pass this the arguments in `@_` and it will return a hash of
parameters or throw an exception. The generated subroutine accepts either a
hash or a single hashref.

For now, you must shift off the invocant yourself.

This subroutine accepts an additional parameter:

- name

    If this is given, then the generated subroutine will be named using
    [Sub::Name](https://metacpan.org/pod/Sub::Name). This is strongly recommended as it makes it possible to
    distinguish different check subroutines when profiling or in stack traces.

    Note that you must install [Sub::Name](https://metacpan.org/pod/Sub::Name) yourself separately, as it is not
    required by this distribution, in order to avoid requiring a compiler.

## source\_for(...)

This returns a two element list. The first is a string containing the source
code for the generated sub. The second is a hashref of "environment" variables
to be used when generating the subroutine. These are the arguments that are
passed to [Eval::Closure](https://metacpan.org/pod/Eval::Closure).

# SUPPORT

Bugs may be submitted through [the RT bug tracker](http://rt.cpan.org/Public/Dist/Display.html?Name=Params-ValidationCompiler)
(or [bug-params-validationcompiler@rt.cpan.org](mailto:bug-params-validationcompiler@rt.cpan.org)).

I am also usually active on IRC as 'drolsky' on `irc://irc.perl.org`.

# DONATIONS

If you'd like to thank me for the work I've done on this module, please
consider making a "donation" to me via PayPal. I spend a lot of free time
creating free software, and would appreciate any support you'd care to offer.

Please note that **I am not suggesting that you must do this** in order for me
to continue working on this particular software. I will continue to do so,
inasmuch as I have in the past, for as long as it interests me.

Similarly, a donation made in this way will probably not make me work on this
software much more, unless I get so many donations that I can consider working
on free software full time (let's all have a chuckle at that together).

To donate, log into PayPal and send money to autarch@urth.org, or use the
button at [http://www.urth.org/~autarch/fs-donation.html](http://www.urth.org/~autarch/fs-donation.html).

# AUTHOR

Dave Rolsky <autarch@urth.org>

# COPYRIGHT AND LICENCE

This software is Copyright (c) 2016 by Dave Rolsky.

This is free software, licensed under:

    The Artistic License 2.0 (GPL Compatible)
