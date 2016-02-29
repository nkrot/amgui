package AMGui::Wx::ResultViewer;

use strict;
use warnings;

use AMGui::Constant;
use AMGui::Results;
use AMGui::Wx::TabularViewer;
use AMGui::Wx::Viewer;

our @ISA = 'AMGui::Wx::TabularViewer';

use Class::XSAccessor {
    getters => {
        results        => 'results', # (list of) AMGui::Result
        dataset_viewer => 'dataset_viewer',
        purpose        => 'purpose'
    }
};

sub new {
    my ($class, $main) = @_;

    my $self = $class->SUPER::new($main);
    bless $self, $class;

    $self->{results} = AMGui::Results->new;
    $self->{title}   = "Result";
    $self->{purpose} = AMGui::Wx::Viewer::RESULTS;

#	$self->Hide;

    # DatasetViewer associated with this ResultViewer
    $self->{dataset_viewer} = undef;

    #$self->{notshown} = 0;

    return $self;
}

sub close {
    my $self = shift;
    $self->unset_dataset_viewer;
}

sub set_dataset_viewer {
    my ($self, $viewer) = @_;
    $self->{dataset_viewer} = $viewer;

    # CAREFUL a DatasetViewer can have more than one ResultViewers,
    # one for batch mode and another one for simple classify-one mode.
    # Most likely, setting a backlink here does not make sense, since
    # a ResultViewer is never created *before* a DatasetViewer has been
    # created.
    #$viewer->set_result_viewer($self); #will cause infinite mutual recursion
}

sub unset_dataset_viewer {
    my $self = shift;
    if (defined $self->{dataset_viewer}) {
        my $viewer = $self->dataset_viewer;
        $self->{dataset_viewer} = undef;
        $viewer->unset_result_viewer; # TODO: what is several result viewers?
    }
    return 1;
}

# TODO: problem! when this method is called as a callback from classify_all
# in order to display results as they are generated, the tab does not get updated
# until the processing has finished. Statusbar however is updated successfully!
sub add {
    my ($self, $result) = @_;
    my $idx = $self->results->add( $result );
    $self->show(TRUE);  # and switch to this very tab
    my $row = $self->add_row($idx, $result);
    $self->focus($row); # highlight the the most recent result
    return $self;
}

sub add_row {
    my ($self, $pos_in_results, $result) = @_;

#   warn "Inserting at pos=" . $pos_in_results;

    my @columns;
    my @colnames unless $self->has_header;

    # add features as separate columns
    push @columns, @{$result->test_item->features};
    unless ( $self->has_header ) {
        # feature columns will be named F1,F2,..,Fn
        push @colnames, map { "F" . ++$_ } 0..$#{$result->test_item->features};
    }

    # add the word being classified, conventionally placed in the comment
    push @columns, $result->test_item->comment;
    unless ( $self->has_header ) {
        push @colnames, "Comment";
    }

    # expected class and the result of prediction (correct, tie, incorrect)
    push @columns, ($result->test_item->class, $result->result);
    unless ( $self->has_header ) {
        push @colnames, ("Expected", "Predicted");
    }
    
    # for each class in the dataset...
    my @classes = $result->training_set->classes; # contains all classes
    my %scores = %{$result->scores}; # contains only classes for this item
    my $i = 0;
    for my $class (sort @classes) {
        push @columns, $class;                 # class name
        push @columns, ($scores{$class} || 0); # score of this particular class (number of pointers)
        # the score expressed in %
        # TODO: would be good to get it from AM::Result
        #       use AM::Result::scores_normalized for it?
        push @columns, AMGui::Results->to_pct($scores{$class}, $result->total_points);

        unless ( $self->has_header ) {
            push @colnames, ("Class ". ++$i, "${class}_ptrs", "${class}_pct");
        }
    }

    push @columns, ($result->exclude_nulls  ? 'excluded' : 'included');
    push @columns, ($result->given_excluded ? 'excluded' : 'included');
    push @columns, $result->count_method;
    push @columns, $result->training_set->size;
    push @columns, $result->cardinality;
    #warn join(",", @columns);

    unless ( $self->has_header ) {
        push @colnames, ("Nulls", "Given", "Gang", "Size of training set", "Cardinality");
    }

#    warn "Num columns: " . scalar @columns;
#    warn join(",", @columns);

    unless ( $self->has_header ) {
#       warn "Num colnames: " . scalar @colnames;
#       warn join(",", @colnames);
        #my $colcount = 
        $self->add_columns(\@colnames);
        #warn "Number of columns: " . $colcount;
    }

    my $row = $self->SUPER::add_row($pos_in_results, \@columns);
    $self->adjust_column_widths;

    return $row;
}

sub set_classifier {
    my ($self, $classifier) = @_;
    $self->{classifier} = $classifier;
    $classifier->set_result_viewer( $self );
}

1;
