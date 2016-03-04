package AMGui::Wx::ResultViewer;
# TODO: perhaps this class should not be under Wx any more
# and can be renamed to, e.g., ReportManager

use strict;
use warnings;

use AMGui::Constant;
use AMGui::Results;

use AMGui::Wx::Report::Predictions;
use AMGui::Wx::Report::AnalogicalSets;
use AMGui::Wx::Report::Gangs;

use Class::XSAccessor {
    getters => {
        results        => 'results', # (list of) AMGui::Result
        dataset_viewer => 'dataset_viewer',
        purpose        => 'purpose',
        reports        => 'reports'
    }
};

sub new {
    my ($class, $main) = @_;

    my $self = bless {}, $class;

    $self->{results} = AMGui::Results->new;
    $self->{purpose} = AMGui::Wx::Viewer::RESULTS;
    $self->{reports} = []; # an array of active reports

    $self->{predictions}    = AMGui::Wx::Report::Predictions->new($main, $self);
    $self->{analogicalsets} = AMGui::Wx::Report::AnalogicalSets->new($main, $self);
    $self->{gangs}          = AMGui::Wx::Report::Gangs->new($main, $self);

    # DatasetViewer associated with this ResultViewer
    $self->{dataset_viewer} = undef;

    return $self;
}

sub close {
    my $self = shift;
    $self->unset_dataset_viewer;
}

# TODO:
sub set_reports {
    my ($self, $reports) = @_;
    # clear all current reports
    # TODO: need to release viewers?
    $self->{reports} = [];

    # set new reports
    while (my ($key, $value) = each %$reports) {
        push @{$self->reports}, $key if $value == TRUE;
    }
    return $self;
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

sub set_classifier {
    my ($self, $classifier) = @_;
    $self->{classifier} = $classifier;
    $classifier->set_result_viewer($self);
    return $self;
}

######################################################################

# TODO: problem! when this method is called as a callback from classify_all
# in order to display results as they are generated, the tab does not get updated
# until the processing has finished. Statusbar however is updated successfully!
sub add {
    my ($self, $result) = @_;
    my $idx = $self->results->add($result);

    my $report = $self->{predictions};
    $report->show(TRUE);  # and switch to this very tab
    my $row = $report->add($idx, $result);
    $report->focus($row); # highlight the the most recent result

    # fill other reports
    $self->{analogicalsets}->show;
    $self->{analogicalsets}->add($idx, $result);
    $self->{gangs}->show;
    $self->{gangs}->add($idx, $result);
    
    return $self;
}

######################################################################
# The following methods are simply forwarded to contained objects
#

sub focus {
    my ($self, $idx) = @_;
    my $report = $self->{predictions}; # TODO: select correct report
    return $report->focus($idx);
}

sub show_in_statusbar {
    my ($self, $msg) = @_;
    my $report = $self->{predictions}; # TODO: select correct report
    return $report->show_in_statusbar($msg);
}

1;
