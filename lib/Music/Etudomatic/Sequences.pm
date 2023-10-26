package Music::Etudomatic::Sequences;
use Mojo::Base -base;
use Array::Circular;
use Music::Scales;

my @notes = ( [ 1 => 'c'], [ 2 => 'cis'], [ 3 => 'd'], [ 4 => 'ees'], [ 5 => 'e'],
              [ 6 => 'f'], [ 7 => 'fis'], [ 8 => 'g'], [ 9 => 'gis'], [ 10 => 'a'],
              [ 11 => 'bes'], [ 12 => 'b'], );

has note2num => sub { +{ map { $_->[1] => $_->[0] } @notes} };
has num2note => sub { +{ map { $_->[0] => $_->[1] } @notes} };
has nums => sub { Array::Circular->new(1 .. keys %{$_[0]->notes} ) };

has config => sub {
    die "Config is a required attribute and must implement 'key', 'mode' and 'notes_per_chord' attributes";
};

has rootnum => sub {
    my ($self) = @_;
    return $self->note2num->{$self->config->key};
};

has scale => sub {
    my ($self) = @_;
    my @notes = map { s/#/is/; $_ } get_scale_notes($self->config->key, $self->config->mode);
    @notes = map { s/b/es/; lcfirst $_ } @notes;
    my @nums = map { $self->note2num->{$_} } @notes;
    return Array::Circular->new(@nums);
};


has sequences => sub {
    my ($self) = @_;
    my $scale = $self->scale->clone;
    my $numchordnotes = $self->config->notes_per_chord;
    my @chordscale = ();
    for my $root (0 .. $#$scale) {
        my $chord = Array::Circular->new( $scale->current,
                                          map { $scale->peek($_*2) } (1..($numchordnotes-1))
                                      );
        push @chordscale, {
            nums => $chord,
            names => Array::Circular->new(map { $self->num2note->{$_}} @$chord),
        };
        $scale->next;
    }
    return Array::Circular->new(@chordscale);
};

1;
