package Music::Etudomatic::Cof;
use Mojo::Base -base;
use Music::Etudomatic;

=head1 NAME

Music::Etudomatic::Cof

=head2 DESCRIPTION

Circle of fourths or fifths represenation / iterator.

=cut

has start => sub { 'c' };

has config => sub { Music::Etudomatic->new(key => 'c' ) };

has mode => sub { 'fourths' };
has steps => sub { $_[0]->mode eq 'fourths' ? 5 : 7 };

sub next_step {
    my ($self) = @_;
    $self->config->nums->next($self->steps);
}


has circle => sub {
    my ($self) = @_;
    my @cof;
    while (1) {
	my $now =  $self->config->num2note->{$self->config->nums->current};
	last if $now eq $self->start && $self->config->nums->loops;
	push @cof, $now;
	$self->next_step;
    };
    return Array::Circular->new(@cof);
};




1;


