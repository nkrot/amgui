package AMGui::AM;

use strict;
use warnings;

use Algorithm::AM;
use AMGui::Results;
 
use Class::XSAccessor {
    getters => {
        classifier    => 'classifier',
        training      => 'training',      # training dataset
        testing       => 'testing',       # testing dataset
        result        => 'result',        # last result
        result_viewer => 'result_viewer'  # many results
    },
    setters => {
        set_result_viewer => 'result_viewer'
    }
};

sub new {
    my $class = shift;
    my $self = bless {}, $class;

    return $self;
}

sub set_training {
    my ($self, $dataset) = @_;
    $self->{training} = $dataset;
    return $self;
}

sub set_testing {
    my ($self, $dataset) = @_;
    $self->{testing} = $dataset;
    return $self;
}

#sub set_datasets {
#    my ($self, $training, $testing) = @_;
#    $self->{training} = $training;
#    $self->{testing}  = $testing;
#    return $self;
#}

sub close {
    my $self = shift;
    $self->{training}      = undef;
    $self->{testing}       = undef;
    $self->{result}        = undef;
    $self->{classifier}    = undef;
    $self->{result_viewer} = undef;
    return 1;
}

# Classify given test item using preset training set
sub classify {
    my ($self, $test_item) = @_;
    $self->{classifier} = Algorithm::AM->new(training_set => $self->training);
    $self->{result} = $self->classifier->classify( $test_item ); #=> AM::Result
    $self->{result_viewer}->add( $self->result ); # TODO: do it outside?
    return $self->result;
}

1;
