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

1;

