package Params::CheckCompiler::Compiler;

use strict;
use warnings;

use Eval::Closure;
use Params::CheckCompiler::Exception::Required;
use Params::CheckCompiler::Exception::Unknown;

use Moo;

has params => (
    is       => 'ro',
    required => 1,
);

has allow_unknown => (
    is      => 'ro',
    default => 0,
);

has _source => (
    is      => 'ro',
    default => sub { [] },
);

has _env => (
    is      => 'ro',
    default => sub { {} },
);

sub subref {
    my $self = shift;
    $self->_compile;
    return eval_closure(
        source => 'sub { ' . ( join q{}, @{ $self->_source } ) . ' };',
        environment => $self->_env,
    );
}

sub source_for {
    my $self = shift;
    $self->_compile;
}

sub _compile {
    my $self = shift;

    push @{ $self->_source },
        q<my $args = @_ == 1 && Scalar::Util::reftype( $_[0] ) eq 'HASH' ? $_[0] : {@_};>;

    my $params = $self->params;

    for my $name ( keys %{$params} ) {
        my $spec  = $params->{$name};
        my $qname = B::perlstring($name);

        unless ( $spec->{optional} ) {
            push @{ $self->_source }, (
                #<<<
                'Params::CheckCompiler::Exception::Required->throw(',
                    qq{message   => $qname . ' is a required parameter',},
                    qq{parameter => $qname,},
                ") unless exists \$args->{$qname};",
                #>>>
            );
        }
    }

    $self->_add_check_for_unknown
        unless $self->allow_unknown;

    return;
}

sub _add_check_for_unknown {
    my $self = shift;

    $self->_env->{'%known'} = { map { $_ => 1 } keys %{ $self->params } };
    push @{ $self->_source },
        (
        #<<<
        'my @unknown = grep { ! $known{$_} } keys %{$args};',
        'if ( @unknown ) {',
            q{my $u = join ', ', sort @unknown;},
            'Params::CheckCompiler::Exception::Unknown->throw(',
                'message    => "found unknown parameters: [$u]",',
                'parameters => \@unknown,',
            ');',
        '}',
        #>>>
        );

    return;
}

1;
