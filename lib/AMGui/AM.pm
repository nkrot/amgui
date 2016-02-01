package AMGui::AM;

use strict;
use warnings;

use Algorithm::AM;
use AMGui::Result;
 
use Class::XSAccessor {
    getters => {
        classifier    => 'classifier',
        dataset       => 'dataset',
        result        => 'result',        # last result
        result_viewer => 'result_viewer'  # many results
    },
    setters => {
        set_dataset       => 'dataset',
        set_result_viewer => 'result_viewer'
    }
};

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;

    return $self;
}

sub close {
    my $self = shift;
    $self->{dataset}       = undef;
    $self->{result}        = undef;
    $self->{classifier}    = undef;
    $self->{result_viewer} = undef;
    return 1;
}

# Classify given test item using preset training set
sub classify {
    my ($self, $test_item) = @_;
    $self->{classifier} = Algorithm::AM->new(training_set => $self->{dataset});
    $self->{result} = $self->classifier->classify( $test_item ); # AM::Result
    $self->{result_viewer}->add( $self->result );
    return $self->result;
}

1;
