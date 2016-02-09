package AMGui::Wx::DatasetViewer;

use strict;
use warnings;

use Wx qw[:everything];

our @ISA = 'Wx::ListBox';

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
        $dataset->items_as_strings,
        wxLB_SINGLE
    );
    bless $self, $class;
    
    $self->{main}          = $main;
    $self->{dataset}       = $dataset; # AMGui::Dataset
    $self->{title}         = $dataset->filename;
    $self->{result_viewer} = undef;
    
    $main->notebook->AddPage($self, $self->{title}, 1);
    $self->Deselect(0); 

    Wx::Event::EVT_LISTBOX_DCLICK($self, $self->GetId, \&on_double_click_item);

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
    warn "Unsetting ResultViewer";
    if (defined $self->result_viewer) {
        warn "Yeah, really unsetting the ResultViewer";
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
    $self->main->classify_item($self);
    $event->Skip;
}

sub current_item {
    my $self = shift;
    return $self->dataset->nth_item( $self->GetSelection );
}

sub training {
    my $self = shift;
    return $self->dataset->training; #=> AMGui::DataSet
}

1;
