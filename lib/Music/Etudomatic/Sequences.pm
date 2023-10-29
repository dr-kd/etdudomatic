package Music::Etudomatic::Sequences;
use Mojo::Base -base;
use Array::Circular;
use Music::Scales ();


has config => sub {
    die "Config is a required attribute and must implement 'key', 'mode' and 'notes_per_chord' attributes";
};

has rootnum => sub {
    my ($self) = @_;
    return $self->note2num->{$self->config->key};
};

has nums      => sub { $_[0]->config->nums };
has note2num  => sub { $_[0]->config->note2num };
has num2note  => sub { $_[0]->config->num2note };


has scale => sub {
    my ($self) = @_;
    my @notes = map { s/#/is/; $_ } Music::Scales::get_scale_notes($self->config->key, $self->config->mode);
    @notes = map { s/b/es/; lcfirst $_ } @notes;
    my @nums = map { $self->note2num->{$_} } @notes;
    return Array::Circular->new(@nums);
};


has chordscales => sub {
    my ($self) = @_;
    my $scale = $self->scale->clone;
    my $numchordnotes = $self->config->notes_per_chord;
    my @chordscale = ();

    for my $root (0 .. $#$scale) {
        my $chord = Array::Circular->new( $scale->current,
                                          map { $scale->peek($_*2) } (1..($numchordnotes-1))
	    );
	my @chordnames;
	for my $c (@$chord) {
	    my $note = $self->num2note->{$c};
	    push @chordnames, $note;
	}
        push @chordscale, {
            nums => $chord,

            names => Array::Circular->new(map { $self->num2note->{$_}} @$chord),
        };
        $scale->next;
    }
    return Array::Circular->new(@chordscale);
};

1;
