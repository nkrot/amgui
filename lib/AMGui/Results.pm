package AMGui::Results;

use strict;
use warnings;

use Algorithm::AM::Result;

use Class::XSAccessor {
    getters => {
        results => 'results',  # array of instances of AM::Result
        viewer  => 'viewer'    # GUI component that renders results
    }
};

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{results} = [];
    return $self;
}

sub add {
    my ($self, $result) = @_;
    my $count = scalar @{ $self->{results} };
    push @{ $self->{results} }, $result;
    return $count; # position of the newly added item
}

# TODO: if $part equals 0 then the outputted value is 0.000. is it okey? -- yes
sub to_pct {
    my ($self, $part, $whole) = @_;
    $part = 0 unless defined $part;
    my $percentage_format = '%.3f'; # also defined in Algorithm::AM::Result
    return sprintf($percentage_format, 100 * $part / $whole);
}

1;

