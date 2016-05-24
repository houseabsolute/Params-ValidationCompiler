package Params::CheckCompiler::Exception::BadArguments;

use strict;
use warnings;

our $VERSION = '0.02';

use Moo;

extends 'Throwable::Error';

1;

# ABSTRACT: Exception thrown when @_ does not contain a hash or hashref

