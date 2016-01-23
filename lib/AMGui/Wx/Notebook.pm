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

    my @help = (
        "== USAGE ==",
        "Open a file in 'commas' format. File/Open or Ctrl-O",
        "Once it is loaded, double click an item"
    );

    $self = $self->SUPER::new( $parent, $id, $pos, $size, $style, $name );
    $self->{help} = Wx::ListBox->new(
        $self, 
        wxID_ANY, 
        wxDefaultPosition,
        wxDefaultSize, 
        \@help,
        wxLB_SINGLE
    );

    $self->__set_properties();
    $self->__do_layout();

    return $self;
}


sub __set_properties {
    my $self = shift;
    $self->AddPage($self->{help}, _T("Usage"));
    $self->{help}->SetSelection(0);
}

sub __do_layout {
    my $self = shift;
    return;
}

1;

