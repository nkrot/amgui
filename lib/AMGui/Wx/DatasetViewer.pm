package AMGui::DatasetViewer;

use strict;
use warnings;

use Wx qw[:everything];
#use File::Slurp;

sub new {
    my ( $class, $parent, $dataset ) = @_;

    my $self = bless {}, $class;
    
    $self->{dataset} = $dataset;
    $self->{title} = $dataset->filename;
    
    $self->{listbox} = Wx::ListBox->new(
        $parent, 
        wxID_ANY, 
	    wxDefaultPosition, 
	    wxDefaultSize, 
	    $dataset->items_as_strings,
	    wxLB_SINGLE
    );

    $parent->AddPage($self->{listbox}, $self->{title}, 1);

    return $self;
}

use Class::XSAccessor {
    getters => {
        dataset => 'dataset'
    },
};

# TODO: setting should trigger reloading. which in turn requires asking the user
# if he wants to refresh/lose current state
#sub set_dataset {
#    my ($self, $dataset) = @_;
#    $self->{dataset} = $dataset;
#    return $self->{dataset};
#}

1;
