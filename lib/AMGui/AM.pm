package AMGui::AM;

use strict;
use warnings;

use Algorithm::AM;
use Algorithm::AM::Batch;
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
    
    $self->result_viewer->add( $self->result );
    $self->result_viewer->show_in_statusbar("Predicted class is " . $self->result->result);

    return $self->result;
}

sub classify_all {
    my ($self, $testing) = @_;
    $self->set_testing($testing)  if defined $testing;
    
    my $cnt_total = $self->testing->size;
    my $cnt_correct = 0;
    
    $self->{classifier} = Algorithm::AM::Batch->new(
        training_set  => $self->training->data,
        end_test_hook => sub {
            my ($batch, $test_item, $result) = @_;
            $cnt_correct++  if $result->result eq 'correct'; # TODO: AM::Result->is_correct

            my $msg = "Total: " . $cnt_total . "; Correct: " . $cnt_correct;
            #$self->result_viewer->add_lazily($result); # does not solve the problem
            $self->result_viewer->add($result);
            $self->result_viewer->show_in_statusbar($msg);
            
            #print $test_item->comment . ' ' . $result->result . "\n";
        }
    );

    #my @results = 
    $self->classifier->classify_all( $self->testing->data );
    #$self->result_viewer->show_lazily_added; # does not solve the problem

    return 1;
}

#sub example_from_analogize_pl {
#    my $batch = Algorithm::AM::Batch->new(
#        linear => $args{linear},
#        exclude_given => !$args{include_given},
#        exclude_nulls => !$args{include_nulls},
#
#        training_set => $train,
#        # print the result of each classification at the time it is provided
#        end_test_hook => sub {
#            my ($batch, $test_item, $result) = @_;
#            ++$count if $result->result eq 'correct';
#            say $test_item->comment . ":\t" . $result->result . "\n";
#            for (@print_methods) {
#                if($_ eq 'gang_detailed'){
#                    say ${ $result->gang_summary(1) };
#                }else{
#                    say ${ $result->$_ };
#                }
#            }
#        }
#    );
#    $batch->classify_all($test);
#}

1;
