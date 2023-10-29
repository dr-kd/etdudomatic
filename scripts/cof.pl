#!/usr/bin/env perl
use warnings;
use strict;
use v5.30;
use lib 'lib';
use Music::Etudomatic;
use Music::Etudomatic::Cof;

my $cof = Music::Etudomatic::Cof->new->circle;
my $mode = 'major';

my %common = (
    mode => $mode,
    asc =>  [ map { $_ - 1 } (1,2,3,2) ],
    desc => [ map { $_ - 1 } (1,3,2,3) ],
);

my @each = ();

my $num_per_chord;
while ($cof->loops < 1) {
    my $e = Music::Etudomatic->new(
	%common,
	key => $cof->current,
    );
    $num_per_chord //= $e->notes_per_chord;
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
    unshift @backwards, $backwards[-1]; # put root at the front as well as end

    my $b = Array::Circular->new(@backwards);

    for my $c ( map { $_->{names} } @$b) {
	push @exercise, @$c[@{$e->desc}];
    }

    push @exercise, $b->[0]->{names}->[0];
    push @each, \@exercise;
    $cof->next;
}


my @scores = ();
for my $e (@each) {
    my $score = '';
    for ( 0 .. $#$e) {
      my $l = $_ == 0 ? 8 : '';
	$score .=  $e->[$_] . "$l ";
	$score .=  "\n" if ($_ +1) %4 == 0;
    }
    print "\n\n";
    my $root = $e->[0];
    my $part = q|\score { \relative c' {
             \time 4/4 \key __KEY__ \__MODE__
    __SCORE__
    }
    }|;
    $part =~ s/__KEY__/$root/m;
    $part =~ s/__MODE__/$mode/m;
    $part =~ s/__SCORE__/$score/m;
    push @scores, $part;
}
my $ out = do { local $/, <DATA>};
$out =~ s/__MODE__/$mode/m;
$out =~ s/__NUM__/$num_per_chord/m;
my $parts = join "\n", @scores;
$out =~ s/__SCORES__/$parts/m;
say $out;

__END__
\version "2.18.2"

 \header {
       title = "Chrord scales for __MODE__ in each key.  __NUM__ notes per chord"
       composer = "etudomatic"
     }
%% \paper{ ragged-bottom=##t bottom-margin=0\mm page-count=1 }


__SCORES__

\layout {}
\midi {}
