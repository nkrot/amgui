package AMGui::AM;

use strict;
use warnings;

use Algorithm::AM;
use Algorithm::AM::Batch;
use AMGui::Results;

#use Data::Dumper;

use Class::XSAccessor {
    getters => {
        classifier    => 'classifier',
        training      => 'training',      # training dataset, AM::DataSet
        testing       => 'testing',       # testing dataset, AM::DataSet
        result        => 'result',        # last result, AM::Result
        result_viewer => 'result_viewer', # many results, AMGui::Results
        options       => 'options'        # options that AM accepts (linear, include_nulls, include_given)
    },
    setters => {
        set_result_viewer => 'result_viewer'
    }
};

sub new {
    my ($class, $opts) = @_;

    my $self = bless {
        options => {%$opts} # copy options
    }, $class;

    #print Dumper($self->options);
    
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
    
    my %options = ((
        training_set => $self->training->data
    ), %{$self->options});

    $self->{classifier} = Algorithm::AM->new(%options);
    $self->{result} = $self->classifier->classify( $test_item ); #=> AM::Result

    $self->result_viewer->add( $self->result );
    $self->result_viewer->show_in_statusbar("Predicted class is " . $self->result->result);

    return $self->result;
}

sub classify_all {
    my ($self, $testing) = @_;
    $self->set_testing($testing)  if defined $testing;

    my %options = ((
        training_set  => $self->training->data,
        end_test_hook => $self->am_end_test_hook
    ), %{$self->options});
    
    $self->{classifier} = Algorithm::AM::Batch->new(%options);
    $self->classifier->classify_all( $self->testing->data );
    $self->result_viewer->focus(0);

    return 1;
}

sub am_end_test_hook {
    my ($self) = @_;
    my ($cnt_total, $cnt_correct) = ($self->testing->size, 0);

    return sub {
        my ($batch, $test_item, $result) = @_;
        $cnt_correct++  if $result->result eq 'correct'; # TODO: AM::Result->is_correct

        my $msg = "Total: " . $cnt_total . "; Correct: " . $cnt_correct;
        $self->result_viewer->add($result);
        $self->result_viewer->show_in_statusbar($msg);

        #print $test_item->comment . ' ' . $result->result . "\n";
    }    
}

1;
