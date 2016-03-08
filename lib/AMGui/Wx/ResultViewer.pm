package AMGui::Wx::ResultViewer;
# TODO: perhaps this class should not be under Wx any more
# and can be renamed to, e.g., ReportManager

use strict;
use warnings;

#use Data::Dumper;

use AMGui::Constant;

use AMGui::Wx::Report::Predictions;
use AMGui::Wx::Report::AnalogicalSets;
use AMGui::Wx::Report::Gangs;

use Class::XSAccessor {
    getters => {
        main           => 'main',
        results        => 'results',
        dataset_viewer => 'dataset_viewer',
        purpose        => 'purpose',
        reports        => 'reports'
    }
};

sub new {
    my ($class, $main, $reports) = @_;

    my $self = bless {
        main    => $main,
        purpose => AMGui::Wx::Viewer::RESULTS,
        reports => [], # an array of active reports
        results => [], # (arrayref of) AM::Result objects
        dataset_viewer => undef  # DatasetViewer associated with this ResultViewer
    }, $class;

    $self->{report_classes} = {
        wxID_REPORT_PREDICTION     => "AMGui::Wx::Report::Predictions",
        wxID_REPORT_ANALOGICAL_SET => "AMGui::Wx::Report::AnalogicalSets",
        wxID_REPORT_GANGS          => "AMGui::Wx::Report::Gangs"
    };

    $self->set_reports($reports) if defined $reports;

    return $self;
}

sub close {
    my $self = shift;
    $self->unset_dataset_viewer;
}

sub set_reports {
    my ($self, $reports) = @_;
    # TODO: need to close no longer necessary tabs? or just grey them out
    #       to show they are no longer used?
    # TODO: instead of clearing all reports, need to keep those that already
    #       exit
    # Take into account Results
    $self->{reports} = [];
    # set new reports
    foreach my $report_id (@{$self->main->order_of_reports}) {
        if ( $reports->{$report_id} ) {
            push @{$self->reports}, {
                class  => $self->{report_classes}->{$report_id},
                object => undef,
                state  => FALSE # unused for the time being
            };
        }
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

# return the report that is displayed in the active tab
#sub active_report {
#}

# return the report by the given index
# If the report does not exist, create it
sub get_report {
    my ($self, $idx) = @_;
    my $report_data  = $self->reports->[$idx];
    unless ( defined $report_data->{object} ) {
        $report_data->{object} = $report_data->{class}->new($self->main, $self);
    }
    return $report_data->{object};
}

######################################################################

sub add {
    my ($self, $result) = @_;

    my $last = -1 + push(@{$self->results}, $result);

    # prepare tabs for the reports
    for (my $idx=0; $idx < scalar @{$self->reports}; $idx ++) {
        $self->get_report($idx)->show;
    }

    my $report = $self->get_report(0);
    $report->show(TRUE); # and switch to the tab with the first report

    $report->add($last, $result);

    # highlight the the most recent result
    # TODO: oops, will not work for gangs report. maybe focus_last?
    #TODO#$report->focus($row);

    return $self;
}

# TODO: preferably do it in the background so that the users can work
# with other tabs
sub show_reports {
    my ($self) = @_;
    # skip the very 1st report since it was already built in add method
    for (my $idx = 1; $idx < scalar @{$self->reports}; $idx++) {
        my $report = $self->get_report($idx);
        while ( my ($result_id, $result) = each(@{$self->results}) ) {
            $report->add($result_id, $result);
        }
        #$report->show;
    }
    return $self;
}

######################################################################
# The following methods are simply forwarded to contained objects
#

sub focus {
    my ($self, $idx) = @_;
    my $report = $self->get_report(0); # TODO: select correct report
    return $report->focus($idx);
}

sub show_in_statusbar {
    my ($self, $msg) = @_;
    my $report = $self->get_report(0); # TODO: select correct report
    return $report->show_in_statusbar($msg);
}

1;
