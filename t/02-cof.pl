#!/usr/bin/env perl
use v5.30;
use lib 'lib';
use Mojo::Base -base;
use Test::More;
use Music::Etudomatic::Cof;

my $cof = Music::Etudomatic::Cof->new->circle;
is_deeply(got()->{fourths}, $cof, "Circle of fourths looks right");

$cof = Music::Etudomatic::Cof->new(mode => 'fifths')->circle;
is_deeply(got()->{fifths}, $cof, "Circle of fifths looks right");


done_testing;

# Test fixtures validated by inspection
sub got {
    { fourths => bless( [ 'c', 'f', 'bes', 'ees', 'gis', 'cis', 'fis', 'b', 'e', 'a', 'd', 'g' ], 'Array::Circular' ),
      fifths  => bless( [ 'c', 'g', 'd', 'a', 'e', 'b', 'fis', 'cis', 'gis', 'ees', 'bes', 'f' ], 'Array::Circular' ),
    }
}
