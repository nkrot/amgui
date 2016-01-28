package AMGui::Wx::Notebook;
use base qw(Wx::Notebook);

use 5.022000;
use strict;
use warnings;

use Wx qw[:everything];
use Wx::Locale gettext => '_T';

use AMGui::Wx              ();
use AMGui::Wx::AuiManager  ();

our $VERSION = '1.00';
our @ISA     = qw{
	Wx::AuiNotebook
};

sub new {
    my( $class, $parent, $id, $pos, $size, $style, $name ) = @_;
    $parent = undef              unless defined $parent;
    $id     = -1                 unless defined $id;
    $pos    = wxDefaultPosition  unless defined $pos;
    $size   = wxDefaultSize      unless defined $size;
    $name   = ""                 unless defined $name;

    my $aui = $parent->aui;
    
    #$style = wxNB_TOP unless defined $style;

    my @help = (
        "== USAGE ==",
        "Open a file in 'commas' format. File/Open or Ctrl-O",
        "Once it is loaded, double click an item"
    );

    #$self = $self->SUPER::new( $parent, $id, $pos, $size, $style, $name );

    my $self = $class->SUPER::new(
	$parent,
	-1,
	Wx::wxDefaultPosition,
	Wx::wxDefaultSize,
	Wx::wxAUI_NB_TOP | Wx::wxBORDER_NONE | Wx::wxAUI_NB_SCROLL_BUTTONS | Wx::wxAUI_NB_TAB_MOVE
		| Wx::wxAUI_NB_CLOSE_ON_ACTIVE_TAB | Wx::wxAUI_NB_WINDOWLIST_BUTTON
    );
    
    $aui->AddPane(
        $self,
        AMGui::Wx->aui_pane_info(
            Name           => 'notebook',
            Resizable      => 1,
            PaneBorder     => 0,
            Movable        => 1,
            CaptionVisible => 0,
            CloseButton    => 0,
            MaximizeButton => 0,
            Floatable      => 1,
            Dockable       => 1,
            Layer          => 1,
            )->Center,
    );
	
    $aui->caption('notebook' => _T('Hello'), );

#    Wx::Event::EVT_AUINOTEBOOK_PAGE_CHANGED(
#        $self, $self, 
#        sub { shift->on_auinotebook_page_changed(@_); }, );

    #Wx::Event::EVT_AUINOTEBOOK_PAGE_CLOSE(
#        $parent, $self, 
#        sub { shift->on_close_tab(@_); }, );

   
    $self->{help} = Wx::ListBox->new(
        $self, 
        wxID_ANY, 
        wxDefaultPosition,
        wxDefaultSize, 
        \@help,
        wxLB_SINGLE
    );

    $self->create_tab($self->{help}, _T("Usage"));
 
    $parent->update_aui();

    return $self;
}

sub create_tab {
    my ($self, $obj, $title) = @_;
    $title ||= '(' . _T('Unknown') . ')';

    $self->AddPage($obj, $title, 1);
    $obj->SetFocus;
    return $self->GetSelection;
}

1;

