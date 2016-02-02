package AMGui::Wx::ResultViewer;

use strict;
use warnings;

use AMGui::Constant;
use AMGui::Result;

our @ISA = 'Wx::ListBox';

use Class::XSAccessor {
    getters => {
        result   => 'result', # AMGui::Result (collection)
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

    $self->{result} = AMGui::Result->new;
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
    $self->result->add( $result );

    $self->show(TRUE); # and switch to the tab
    
    # TODO: add lines
    $self->InsertItems( ["Hello"], 0 );

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
