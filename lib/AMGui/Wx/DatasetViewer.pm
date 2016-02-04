package AMGui::Wx::DatasetViewer;

use strict;
use warnings;

use Wx qw[:everything];

our @ISA = 'Wx::ListBox';

use Class::XSAccessor {
    getters => {
        dataset    => 'dataset',
        classifier => 'classifier'
    },
    setters => {
        set_classifier => 'classifier'
    }
};

sub new {
    my ($class, $parent, $dataset ) = @_;

    my $self = $class->SUPER::new (
        $parent, 
        wxID_ANY, 
        wxDefaultPosition, 
        wxDefaultSize, 
        $dataset->items_as_strings,
        wxLB_SINGLE
    );
    bless $self, $class;
    
    $self->{dataset} = $dataset;
    $self->{title} = $dataset->filename;
    
    $parent->AddPage($self, $self->{title}, 1);

    Wx::Event::EVT_LISTBOX_DCLICK($self, $self->GetId, \&on_double_click_item);

    return $self;
}

sub close {
    my $self = shift;    
    $self->dataset->close;
    $self->classifier->close;
    return 1;
}

# TODO: setting should trigger refreshing the view. which in turn requires asking the user
# if he wants to lose current state
#sub set_dataset {
#    my ($self, $dataset) = @_;
#    $self->{dataset} = $dataset;
#    return $self->{dataset};
#}

#sub set_classifier {
#   my ($self, $classifier) = @_;
#   $self->{classifier} = $classifier;
#}

sub on_double_click_item {
    my ($self, $event) = @_;
    
    my $item_idx = $self->GetSelection();
    my $item = $self->dataset->nth_item($item_idx);
    
    my $training = $self->dataset->training->data;

    $self->classifier->set_dataset($training); # AMGui::DataSet->AM::DataSet
    $self->classifier->classify($item);
}

1;
