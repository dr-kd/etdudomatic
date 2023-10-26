#!/usr/bin/env perl
use warnings;
use strict;
use Music::Etudomatic;
use Test::More;
my $e = Music::Etudomatic->new(key => 'd', mode => 'base');
ok $e->sequences;
diag explain $e->sequences->sequences;
done_testing;
