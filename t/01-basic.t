#!/usr/bin/env perl
use warnings;
use strict;
use Music::Etudomatic;
use Test::More;
my $e = Music::Etudomatic->new(key => 'd', mode => 'base');
ok $e->sequences;

is_deeply(dmajor(), $e->sequences->chordscales, "We got d major as expected");
done_testing;

sub dmajor  {
    bless( [
        { 'names' => bless( [ 'd', 'fis', 'a' ], 'Array::Circular' ),
          'nums' => bless( [ 3, 7, 10 ], 'Array::Circular' ) },
        { 'nums' => bless( [ 5, 8, 12 ], 'Array::Circular' ),
          'names' => bless( [ 'e', 'g', 'b' ], 'Array::Circular' ) },
        { 'names' => bless( [ 'fis', 'a', 'cis' ], 'Array::Circular' ),
          'nums' => bless( [ 7, 10, 2 ], 'Array::Circular' ) },
        { 'nums' => bless( [ 8, 12, 3 ], 'Array::Circular' ),
          'names' => bless( [ 'g', 'b', 'd' ], 'Array::Circular' ) },
        { 'names' => bless( [ 'a', 'cis', 'e' ], 'Array::Circular' ),
          'nums' => bless( [ 10, 2, 5 ], 'Array::Circular' ) },
        { 'nums' => bless( [ 12, 3, 7 ], 'Array::Circular' ),
          'names' => bless( [ 'b', 'd', 'fis' ], 'Array::Circular' ) },
        { 'nums' => bless( [ 2, 5, 8 ], 'Array::Circular' ),
          'names' => bless( [ 'cis', 'e', 'g' ], 'Array::Circular' ) }
    ], 'Array::Circular' );
}
