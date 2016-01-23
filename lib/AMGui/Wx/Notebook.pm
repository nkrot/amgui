package AMGui::Wx::Notebook;
use base qw(Wx::Notebook);

use 5.022000;
use strict;
use warnings;

use Wx qw[:everything];
use Wx::Locale gettext => '_T';

sub new {
    my( $self, $parent, $id, $pos, $size, $style, $name ) = @_;
    $parent = undef              unless defined $parent;
    $id     = -1                 unless defined $id;
    $pos    = wxDefaultPosition  unless defined $pos;
    $size   = wxDefaultSize      unless defined $size;
    $name   = ""                 unless defined $name;

    $style = wxNB_TOP unless defined $style;

    $self = $self->SUPER::new( $parent, $id, $pos, $size, $style, $name );
    $self->{lbFileData} = Wx::ListBox->new($self, 
                                            wxID_ANY, 
                                            wxDefaultPosition,
                                            wxDefaultSize, 
                                            [_T("Load data 2 from a file")],
                                            wxLB_SINGLE);

    $self->__set_properties();
    $self->__do_layout();

    return $self;
}


sub __set_properties {
    my $self = shift;
    $self->AddPage($self->{lbFileData}, _T("NoFile"));
    $self->{lbFileData}->SetSelection(0);
}

sub __do_layout {
    my $self = shift;
    return;
}

1;

