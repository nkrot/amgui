package AMGui::Wx::DatasetViewer;

use strict;
use warnings;

use Wx qw[:everything];
use Wx::Locale gettext => '_T';

use AMGui::Constant;

our @ISA = 'Wx::ListView';

use Class::XSAccessor {
    getters => {
        main          => 'main',
        dataset       => 'dataset',
        result_viewer => 'result_viewer'
    },
    # setters => {
        # set_result_viewer => 'result_viewer'
    # }
};

sub new {
    my ($class, $main, $dataset) = @_;

    my $self = $class->SUPER::new (
        $main->notebook,
        wxID_ANY,
        wxDefaultPosition,
        wxDefaultSize,
        wxLC_REPORT|wxLC_SINGLE_SEL|wxLC_HRULES|wxLC_VRULES
    );
    bless $self, $class;

    $self->{main}          = $main;
    $self->{dataset}       = $dataset; # AMGui::Dataset
    $self->{title}         = $dataset->filename;
    $self->{result_viewer} = undef;

    # Build the list, make it look like a spreadsheet
    $self->InsertColumn(0, _T("Index"),    wxLIST_FORMAT_LEFT, wxLIST_AUTOSIZE_USEHEADER);
    $self->InsertColumn(1, _T("Class"),    wxLIST_FORMAT_LEFT, wxLIST_AUTOSIZE_USEHEADER);
    $self->InsertColumn(2, _T("Features"), wxLIST_FORMAT_LEFT, wxLIST_AUTOSIZE_USEHEADER);
    $self->InsertColumn(3, _T("Comment"),  wxLIST_FORMAT_LEFT, wxLIST_AUTOSIZE_USEHEADER);
    
    # Populate the list with items from the dataset
    for (my $i=0; $i < $self->dataset->size; $i++) {
        my $data_item = $self->dataset->nth_item($i); # AM::DataSet::Item
        
        my $idx = $self->InsertStringItem($i, $i);
        $self->SetItemData($idx, $i); # position of this item in AM::DataSet
        $self->SetItem($idx, 1, $data_item->class);
        $self->SetItem($idx, 2, join(" ", @{$data_item->features})); # TODO: do it somewhere else?
        $self->SetItem($idx, 3, $data_item->comment);
    }
    for (my $i; $i < $self->GetColumnCount; $i++) {
        $self->SetColumnWidth($i, wxLIST_AUTOSIZE);
    }

    $main->notebook->AddPage($self, $self->{title}, 1);
    $self->Select(0, FALSE); # ensure nothing selected

    Wx::Event::EVT_LIST_ITEM_ACTIVATED($self, $self->GetId, \&on_double_click_item);

    return $self;
}

sub purpose {
   my $self = shift;
   return $self->dataset->purpose;
}

sub close {
    my $self = shift;
    $self->dataset->close;
    $self->unset_result_viewer;
    return 1;
}

sub set_result_viewer {
    my ($self, $viewer) = @_;
    $self->{result_viewer} = $viewer;
    $viewer->set_dataset_viewer($self); # create a backlink ResultViewer->DatasetViewer
    return 1;
}

sub unset_result_viewer {
    my $self = shift;
    if (defined $self->result_viewer) {
        my $viewer = $self->{result_viewer};
        $self->{result_viewer} = undef;
        $viewer->unset_dataset_viewer;
    }
    return 1;
}

# TODO: setting should trigger refreshing the view. which in turn requires asking the user
# if he wants to lose current state
#sub set_dataset {
#    my ($self, $dataset) = @_;
#    $self->{dataset} = $dataset;
#    return $self->{dataset};
#}

sub on_double_click_item {
    my ($self, $event) = @_;
    #$event->GetItem->GetData; #=> position of clicked item in AM::DataSet
    $self->main->classify_item($self);
    $event->Skip;
}

sub current_data_item {
    my $self = shift;
    return $self->dataset->nth_item( $self->GetFirstSelected );
}

sub advance_selection {
    my $self = shift;

    my $curr_idx = $self->GetFirstSelected; # also GetFocused?
    my $next_idx;

    if ( $curr_idx == -1 ) {
        $next_idx = 0;
    } elsif ($curr_idx+1 == $self->GetItemCount) {
        # looking at the last item, keep it selected
    } else {
        $next_idx = $curr_idx+1;
    }

    if (defined $next_idx) {
        $self->Select($next_idx, TRUE); # this also deselects previous item
        $self->Focus($next_idx);
    }

    return defined $next_idx;
}

sub training {
    my $self = shift;
    return $self->dataset->training; #=> AMGui::DataSet
}

1;
