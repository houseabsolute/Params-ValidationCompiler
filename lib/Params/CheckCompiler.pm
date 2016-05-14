package Params::CheckCompiler;

use strict;
use warnings;

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
