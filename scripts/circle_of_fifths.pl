#!/usr/bin/env perl
use warnings;
use strict;
use v5.30;
use IPC::System::Simple qw/capture/;
use Path::Tiny;

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

my @base = ();
my $e = Music::Etudomatic->new(
    %common,
    key => $cof->current,
);

my $num_per_chord = $e->notes_per_chord;
my $pattern_size = scalar @{$common{asc}};
my $s = $e->sequences->chordscales;

# ascending
my $first;
for my $c (map { $_->{names} } @$s) {
    my @this = @$c[@{$e->asc}];
    $first //= \@this;
    push @base, @this;
}
push @base, @$first;

# descending
my @backwards = reverse @$s;
unshift @backwards, $backwards[-1]; # put root at the front as well as end

my $b = Array::Circular->new(@backwards);

for my $c ( map { $_->{names} } @$b) {
    push @base, @$c[@{$e->desc}];
}

push @base, $b->[0]->{names}->[0]; # root note on the end
$base[0] = $base[0] . '8';
$base[-1] = $base[-1] . '1';

my @sections = ();

while ($cof->loops < 1 ) {
    my @line = lilypond_transpose($cof->current, @base);
    my $score = '';
    for ( 0 .. $#line) {
        $line[$_] =~ s/\d$// if $_ != 0 || $_ != $#line;
        my $l = $_ == 0 && $line[$_] !~ /8$/ ? 8 : '';
        $line[$_] =~ s/[',]//;

	# adjust decending to be an octave up
	$DB::single=1 if $_ > 30;
	
	$line[$_] = $line[$_] . "'" if $_ == int (@line / 2);

	# final note is 
        $l = ($_ == $#line) && ($line[-1] !~ /\d$/) ? 1 : $l;
        $score .=  $line[$_] . "$l ";
        $score .=  "\n" if ($_ +1) %4 == 0;
    }
    $score .= "\n";
    push @sections, [$cof->current, $score];
    $cof->next;
}



my @scores = ();
for my $e (@sections) {
    my $root = $e->[0];
    my $score = $e->[1];
    my $part = sprintf q| \markup { "%s" } \score { \relative c' {
             \time 4/4 \key %s \%s
                 %s
    }
    }|, $root, $root, $mode, $score;
    push @scores, $part;
}

my $ out = do { local $/, <DATA>};
 say sprintf $out, $mode, $num_per_chord, $pattern_size, join "\n", @scores;

sub lilypond_transpose {
    my ($key, @score) = @_;
    my $tmp = Path::Tiny->tempfile;
    my $tmppdf = Path::Tiny->tempfile;
    my $lily_transpose = sprintf q|\version "2.24.1" { \displayLilyMusic \transpose c %s { %s } } |, $key, join ' ', @score;
    $tmp->spew($lily_transpose);
    my $out = capture "lilypond -o $tmppdf -l NONE $tmp";
    my @out = grep { $_ =~ /^[a-g]/ } split ' ' , $out;
    return @out;
}


__END__
\version "2.24.1"

\header {
      title = "Chrord scales for %s scale in every key. %s notes per chord, %s notes in each chord pattern"
      composer = "etudomatic"
}
\paper{ ragged-bottom=##t bottom-margin=0\mm page-count=2 }

           %s

\layout {}
\midi {}
