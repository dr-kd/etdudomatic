use strict;
use warnings;
package Music::Etudomatic;
use Mojo::Base -base;

=head2 NAME

Music::Etudomatic

An offline music sequencer to facilitate the production of chord patterns.


=head2 USAGE

    my $bot = Music::Etudomatic->new(key => 'd', mode => 'major', notes_per_chord => 3 );
    my $sequencer_data = $bot->sequences;
    my $sequence = $bot->sequence_for($pattern);

=head2 TODO

Assumption is that the current output is for lilypond score.

My next steps are to get some test coverage in t/01-basic.t

Implement the sequence_for method

=cut

use Music::Etudomatic::Sequences;

has key => sub { 'c' };
has mode => sub { 'major' };
has notes_per_chord => sub { 3 };

has asc => sub { [ 0 .. $_[0]->notes_per_chord - 1 ] };
has desc => sub {
    my ($self) = @_;
    my @d = @{$self->{asc}};
    unshift @d, pop @d;
    return \@d;
};

has sequences => sub {
    return Music::Etudomatic::Sequences->new(config => $_[0]);
};

1;
