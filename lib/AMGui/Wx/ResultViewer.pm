package AMGui::Wx::ResultViewer;

use strict;
use warnings;

use AMGui::Constant;
use AMGui::Results;

our @ISA = 'Wx::ListBox';

use Class::XSAccessor {
    getters => {
        results  => 'results', # AMGui::Result (collection)
        notebook => 'notebook',
        index    => 'index'
    }
};

sub new {
    my ($class, $parent) = @_;
    
    my $self = $class->SUPER::new (
        $parent, 
        Wx::wxID_ANY, 
        Wx::wxDefaultPosition, 
        Wx::wxDefaultSize, 
        [],
        Wx::wxLB_SINGLE
    );
    bless $self, $class;

    $self->Hide;

    $self->{results} = AMGui::Results->new;
    $self->{title} = "Result";

    $self->{notebook} = $parent;
    $self->{visible} = FALSE;

    return $self;
}

sub show {
    my ($self, $select) = @_;
    $select = FALSE  unless defined $select;
    
    unless ( $self->{visible} ) {
        $self->{index} = $self->notebook->GetPageCount();
        $self->{notebook}->AddPage($self, $self->{title}, TRUE);
        $self->{visible} = TRUE;
    }
    
    if ( $select ) {
        $self->select;
    }
    
    return $self;
}

sub add {
    my ($self, $result) = @_;
    $self->results->add( $result );

    $self->show(TRUE); # and switch to this very tab
    
    my $count = $self->GetCount;

    my $items = $self->results->as_strings( $result );
    $self->InsertItems( $items, $count );
    
    # focus the most recent result
    $self->SetSelection($count); # highlight the first line of the added result
    $self->SetFirstItem($count); # scrolls to the item

    return $self;
}

sub select {
    my $self = shift;
    $self->notebook->SetSelection($self->index);
    return $self;
}

sub set_classifier {
    my ($self, $classifier) = @_;
    $self->{classifier} = $classifier;
    $classifier->set_result_viewer( $self );
}

1;
