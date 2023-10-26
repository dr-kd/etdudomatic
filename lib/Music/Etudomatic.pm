use strict;
use warnings;
package Music::Etudomatic;

use Mojo::Base -base;

use Music::Etudomatic::Sequences;

=head2 Music::Etudomatic

Generate musical exercises based on chords and scale modes


=head2 USAGE

    my $bot = Music::Etudomatic->new(key => 'd', mode => 'major', notes_per_chord => 3 );

=cut

has key => sub { 'c' };
has mode => sub { 'major' };
has notes_per_chord => sub { 3 };

has sequences => sub {
    return Music::Etudomatic::Sequences->new(config => $_[0]);
};

1;
