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
        index          => 'index',
        results        => 'results', # (list of) AMGui::Result
        dataset_viewer => 'dataset_viewer',
        purpose        => 'purpose'
    }
};

sub new {
    my ($class, $main) = @_;

    my $self = $class->SUPER::new($main);
    bless $self, $class;

    #$self->Hide;

    $self->{results} = AMGui::Results->new;
    $self->{title}   = "Result";
    $self->{purpose} = AMGui::Wx::Viewer::RESULTS;

    $self->{visible}  = FALSE;

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
        $viewer->unset_result_viewer;
    }
    return 1;
}

sub show {
    my ($self, $select) = @_;
    $select = FALSE  unless defined $select;

    unless ( $self->{visible} ) {
        $self->{index} = $self->notebook->GetPageCount();
        $self->notebook->AddPage($self, $self->{title}, TRUE);
        $self->{visible} = TRUE;
    }

    if ( $select ) {
        $self->select;
    }

    return $self;
}

# TODO: problem! when this method is called as a callback from classify_all
# in order to display results as they are generated, the tab does not get updated
# until the processing has finished. Statusbar however is updated successfully!
sub add {
    my ($self, $result) = @_;
    my $idx = $self->results->add( $result );

    $self->show(TRUE); # and switch to this very tab

    my $row = $self->add_row($idx, $result);
    #warn ${$result->statistical_summary};

    $self->focus($row); # highlight the the most recent result

    #$self->main->update_aui;
    #$self->notebook->Update;

    return $self;
}

sub add_row {
    my ($self, $pos_in_results, $result) = @_;

#   warn "Inserting at pos=" . $pos_in_results;

    my @columns;

    # add features as separate columns
    push @columns, @{$result->test_item->features};
    push @columns, $result->test_item->comment;

    # for each class in the dataset...
    my %scores = %{$result->scores};
    for my $class (sort keys %scores) {
        # score of this particular class
        push @columns, $scores{$class};
        # the score expresses in %
        push @columns, AMGui::Results->to_pct($scores{$class},
                                              $result->total_points);
    }

#   warn join(",", @columns);

    if ( $self->GetColumnCount == 0 ) {
        my $i = 0;
        my @labels = map { "C" . ++$i } @columns;
        $self->add_columns(\@labels);
    }

    my $row = $self->SUPER::add_row($pos_in_results, \@columns);
    $self->adjust_column_widths;

    return $row;
}

# TODO: same as TabularViewer::focus?
sub select {
    my $self = shift;
    $self->notebook->SetSelection( $self->index );
    return $self;
}

sub set_classifier {
    my ($self, $classifier) = @_;
    $self->{classifier} = $classifier;
    $classifier->set_result_viewer( $self );
}

1;
