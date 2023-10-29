#!/usr/bin/env perl
use warnings;
use strict;
use v5.30;
use lib 'lib';
use Music::Etudomatic;
use Test::More;

use Getopt::Long;


my $key = 'g';
my $mode = 'major';
my $notes_per_chord = 3;


GetOptions ('key=s' => \$key,
	    'mode=s' => \$mode,
	    'chord=s' => \$notes_per_chord,
	    'notes_per_chord=s', \$notes_per_chord,
    );



my $e = Music::Etudomatic->new(
    key => $key,
    mode => $mode,
    asc =>  [ map { $_ - 1 } (1,2,3,2) ],
    desc => [ map { $_ - 1 } (1,3,2,3) ],
    );

my $s = $e->sequences->chordscales;

my @exercise = ();

# ascending

my $first;
for my $c (map { $_->{names} } @$s) {
    my @this = @$c[@{$e->asc}];
    $first //= \@this;
    push @exercise, @this;
}
push @exercise, @$first;
# descending

my @backwards = reverse @$s;
unshift @backwards, pop @backwards; # put root at the front
my $b = Array::Circular->new(@backwards, $backwards[0]); # extra root chord on the end

print "\n";
for my $c ( map { $_->{names} } @$b) {
    push @exercise, @$c[@{$e->desc}];
}

push @exercise, $b->[0]->{names}->[0];

my $out = '';

for ( 0 .. $#exercise) {
    my $extra = $_ == 0 ? "8" : '';
    $out .=  sprintf '%s%s ', $exercise[$_], $extra;
    $out .=  "\n" if ( $_ + 1) % 4 == 0;
}

my $score = do { local $/; <DATA> };
$score =~ s/__NOTES__/$out/m;
$score =~ s/__KEY__/$key/m;
$score =~ s/__MODE__/$mode/m;
say $score;
    
__DATA__
\version "2.18.2"

 \header {
       title = "Score ... "
       composer = "etudomatic"
     }
\paper{
        ragged-bottom=##t
        bottom-margin=0\mm
        page-count=1
  }


\score {
  \relative c' {
    \time 4/4 \key __KEY__ \__MODE__
    __NOTES__
  }
  \layout {}
  \midi {}
}



