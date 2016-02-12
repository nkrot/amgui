package AMGui::Wx::DatasetViewer;

use strict;
use warnings;
#use Data::Dumper;

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
    my ($col, $width) = (0, wxLIST_AUTOSIZE_USEHEADER);
    # The table header
    $self->InsertColumn($col++, _T("Index"), wxLIST_FORMAT_LEFT, $width);
    $self->InsertColumn($col++, _T("Class"), wxLIST_FORMAT_LEFT, $width);
    for (my $i=0; $i < $self->dataset->cardinality; $i++) {
        # a separate column for every feature
        $self->InsertColumn($col++, _T("F" . (1+$i)), wxLIST_FORMAT_LEFT, $width);
    }
    $self->InsertColumn($col++, _T("Comment"), wxLIST_FORMAT_LEFT, $width);
    
    # Populate the table (rows) with items from the dataset
    for (my $i=0; $i < $self->dataset->size; $i++) {
        my $data_item = $self->dataset->nth_item($i); # AM::DataSet::Item

        my $idx = $self->InsertStringItem($i, $i);

        # fill in the columns
        $col = 1;
        $self->SetItemData($idx, $i);                      # position of this item in AM::DataSet
        $self->SetItem($idx, $col++, $data_item->class);   # expected class
        foreach my $feature (@{$data_item->features}) {
            $self->SetItem($idx, $col++, $feature);        # features, each in its own column
        }
        $self->SetItem($idx, $col++, $data_item->comment); # comment, often the word itself
    }
    for (my $i=0; $i < $self->GetColumnCount; $i++) {
        $self->SetColumnWidth($i, $self->best_column_width($i));
    }

    $self->main->notebook->AddPage($self, $self->{title}, 1);
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
    $viewer->set_dataset_viewer($self); # a backlink from ResultViewer to DatasetViewer
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

sub best_column_width {
    my ($self, $col) = @_;

    #my $width = wxLIST_AUTOSIZE_USEHEADER; # in a bugless world this whould be enough
    my $width = wxLIST_AUTOSIZE;

    # TODO: something wrong here, can not get to the text stored in a cell
#    for (my $i=0; $i < $self->GetItemCount; $i++) {
#        my $item = $self->GetItem($i);
#        warn Dumper($item->GetColumn);
#        #warn $cell->GetText;
#        #warn join(",", $self->GetTextExtent($cell->GetText));
#    }

    return $width;
}
1;
