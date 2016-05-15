use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Require::Module 'Type::Tiny';

use Params::CheckCompiler qw( compile );
use Types::Standard qw( ArrayRef Int );

subtest(
    'type can be inlined',
    sub {
        _test_int_type(Int);
    }
);

subtest(
    'type cannot be inlined',
    sub {
        my $int = Type::Tiny->new(
            name       => 'MyInt',
            constraint => sub {/\A-?[0-9]+\z/},
        );
        _test_int_type($int);
    }
);

subtest(
    'type and coercion can be inlined',
    sub {
        my $type = ( ArrayRef [Int] )->plus_coercions(
            Int, '[$_]',
        );

        _test_arrayref_int_coercion($type);
    }
);

subtest(
    'type can be inlined but coercion cannot',
    sub {
        my $type = ( ArrayRef [Int] )->plus_coercions(
            Int, sub { [$_] },
        );

        _test_arrayref_int_coercion($type);
    }
);

# XXX - if the type cannot be inlined then the coercion reports itself as
# uninlinable as well, but that could change in the future.
subtest(
    'type cannot be inlined but coercion can',
    sub {
        my $int = Type::Tiny->new(
            name       => 'MyInt',
            constraint => sub {/\A-?[0-9]+\z/},
        );
        my $type = ( ArrayRef [$int] )->plus_coercions(
            $int, '[$_]',
        );

        _test_arrayref_int_coercion($type);
    }
);

subtest(
    'neither type not coercion can be inlined',
    sub {
        my $int = Type::Tiny->new(
            name       => 'MyInt',
            constraint => sub {/\A-?[0-9]+\z/},
        );
        my $type = ( ArrayRef [$int] )->plus_coercions(
            $int, sub { [$_] },
        );

        _test_arrayref_int_coercion($type);
    }
);

done_testing();

sub _test_int_type {
    my $type = shift;

    my $sub = compile(
        params => {
            foo => { type => $type },
        },
    );

    ok(
        lives { $sub->( foo => 42 ) },
        'lives when foo is an integer'
    );

    my $name = $type->display_name;
    like(
        dies { $sub->( foo => [] ) },
        qr/\QReference [] did not pass type constraint "$name"/,
        'dies when foo is an arrayref'
    );
}

sub _test_arrayref_int_coercion {
    my $type = shift;

    my $sub = compile(
        params => {
            foo => { type => $type },
        },
    );

    ok(
        lives { $sub->( foo => 42 ) },
        'lives when foo is an integer'
    );

    ok(
        lives { $sub->( foo => [ 42, 1 ] ) },
        'lives when foo is an arrayref of integers'
    );

    my $name = $type->display_name;
    like(
        dies { $sub->( foo => {} ) },
        qr/\QReference {} did not pass type constraint "$name"/,
        'dies when foo is a hashref'
    );
}
