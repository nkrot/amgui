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
    setters => {
        set_result_viewer => 'result_viewer'
    }
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
    $self->{dataset}       = $dataset;
    $self->{title}         = $dataset->filename;
    $self->{result_viewer} = undef;
    
    $main->notebook->AddPage($self, $self->{title}, 1);

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
    # TODO: unlink ResultViewer, but do not close
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

sub training_data {
    my $self = shift;
    return $self->dataset->training->data; #=> AM::DataSet
}

1;
