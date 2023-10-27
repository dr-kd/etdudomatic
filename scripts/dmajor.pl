#!/usr/bin/env perl
use warnings;
use strict;
use v5.30;
use lib 'lib';
use Music::Etudomatic;
use Test::More;

=head1 NAME dmajor.pl

This script generates a lilypond sequence for checking the test in t/01-basic is correct.
See dmajor.ly - the newlines and pitch marks were added to make the score readable

=cut

my $e = Music::Etudomatic->new(key => 'd', mode => 'base' => notes_per_chord => 3);

my $s = $e->sequences->chordscales;

my @exercise = ();
# ascending
my $first;
for my $c (map { $_->{names} } @$s) {
    $first //= $c;
    push @exercise, @$c;
}
push @exercise, @$first;

# descending

my @backwards = reverse @$s;
unshift @backwards, pop @backwards; # put root at the front
my $b = Array::Circular->new(@backwards, $backwards[0]); # extra root chord on the end
for my $c ( map { $_->{names} } @$b) {
    push @exercise, ($c->[0], map { $c->[$_] } reverse ( 1 .. $e->notes_per_chord - 1));
}

for ( 0 .. $#exercise) {
    print sprintf '%s ', $exercise[$_];
}

print "\n";

