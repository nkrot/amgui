package AMGui::Wx::ResultViewer;

use strict;
use warnings;

use AMGui::Constant;
use AMGui::Result;

our @ISA = 'Wx::ListBox';

use Class::XSAccessor {
    getters => {
        result => 'result', # AMGui::Result (collection)
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

    $self->{parent} = $parent;
    $self->{visible} = FALSE;

    return $self;
}

sub show {
    my $self = shift;
    unless ( $self->{visible} ) {
        $self->{parent}->AddPage($self, $self->{title}, TRUE);
        $self->{visible} = TRUE;
    }
}

sub add {
    my ($self, $result) = @_;
    $self->result->add( $result );

    $self->show;
    
    # TODO: add lines
    # TODO: switch to the tab with results
    # TODO: set focus to the last result
    $self->InsertItems( ["Hello"], 0 );

    return $self;
}

sub set_classifier {
    my ($self, $classifier) = @_;
    $self->{classifier} = $classifier;
    $classifier->set_result_viewer( $self );
}

1;
