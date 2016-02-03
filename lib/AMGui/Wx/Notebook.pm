package AMGui::Wx::Notebook;

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

use Class::XSAccessor {
    getters => {
        main => 'main'
    },
};

#http://docs.wxwidgets.org/trunk/classwx_aui_notebook.html

# TODO
# 1. after tabs were rearranged by dragging, their retain their initial index.
#    the effect is that NextTab and PreviousTab are incorrect.
#    This seems to be a lang-lasting BUG
# 2. Only a few events are actually dispatched

sub new {
    my( $class, $main, $id, $pos, $size, $style, $name ) = @_;
    $main  = undef              unless defined $main;
    $id    = -1                 unless defined $id;
    $pos   = wxDefaultPosition  unless defined $pos;
    $size  = wxDefaultSize      unless defined $size;
    $name  = ""                 unless defined $name;

    my $aui = $main->aui;
    
    my @help = (
        "== USAGE ==",
        "1. Open a file in 'commas' format. File/Open or Ctrl-O",
        "Once it is loaded, double click an item. It will be classified and results will appear in another tab",
        "2. TODO: Open a project (data and test files) at once.",
        "TODO: Then press Run or Ctrl+R to run the classification on all items in test set"
    );

    my $self = $class->SUPER::new(
        $main,
        -1,
        Wx::wxDefaultPosition,
        Wx::wxDefaultSize,
        Wx::wxAUI_NB_TOP | Wx::wxBORDER_NONE | Wx::wxAUI_NB_SCROLL_BUTTONS | Wx::wxAUI_NB_TAB_MOVE
            | Wx::wxAUI_NB_CLOSE_ON_ACTIVE_TAB | Wx::wxAUI_NB_WINDOWLIST_BUTTON
    );
    
    $self->{main} = $main;
    
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

    Wx::Event::EVT_AUINOTEBOOK_PAGE_CHANGED(
        $self, $self, 
        sub { shift->on_auinotebook_page_changed(@_); }, );

    #Wx::Event::EVT_AUINOTEBOOK_PAGE_CLOSE(
#        $main, $self, 
#        sub { shift->on_close_tab(@_); }, );

    # this event does not happen, thank you, AUINotebook developers
#    Wx::Event::EVT_AUINOTEBOOK_DRAG_MOTION(
#        $self, $self, 
#        sub { shift->on_auinotebook_drag_motion(@_)}, );

    Wx::Event::EVT_AUINOTEBOOK_DRAG_DONE(
        $self, $self, 
        sub { shift->on_auinotebook_drag_done(@_)}, );

    # this event does not happen, thank you, AUINotebook developers
#    Wx::Event::EVT_AUINOTEBOOK_BEGIN_DRAG(
#        $self, $self, 
#        sub { shift->on_auinotebook_begin_drag(@_)}, );
    
    # this event does not happen, thank you, AUINotebook developers
#    Wx::Event::EVT_AUINOTEBOOK_END_DRAG(
#        $self, $self, 
#        sub { shift->on_auinotebook_end_drag(@_)}, );

    $self->{help} = Wx::ListBox->new(
        $self, 
        wxID_ANY, 
        wxDefaultPosition,
        wxDefaultSize, 
        \@help,
        wxLB_SINGLE
    );

    $self->create_tab($self->{help}, _T("Usage"));
 
    $main->update_aui();

    return $self;
}

sub create_tab {
    my ($self, $obj, $title) = @_;
    $title ||= '(' . _T('Unknown') . ')';

    $self->AddPage($obj, $title, 1);
    $obj->SetFocus;
    return $self->GetSelection;
}

sub page_ids {
    my $self = shift;
    return ($self->first_page_id..$self->last_page_id);
}

sub first_page_id {
    my $self = shift;
    return 0;
}

sub last_page_id {
    my $self = shift;
    return $self->GetPageCount-1;
}

sub select_next_tab {
    my $self = shift;
    $self->AdvanceSelection();
    return $self->GetSelection;
}

sub select_previous_tab {
    my $self = shift;
    $self->AdvanceSelection(0);
    return $self->GetSelection;
}

######################################################################
# event handlers

sub on_auinotebook_page_changed {
    my ($self, $event) = @_;
    #$self->main->inform("Page Changed");
    $event->Skip;
}

#sub on_auinotebook_begin_drag {
#    my ($self, $event) = @_;
#    $event->Skip;
#}

#sub on_auinotebook_end_drag {
#    my ($self, $event) = @_;
#    warn @_;
#    $self->main->inform("End drag");
#    $event->Skip;
#}

# happens
sub on_auinotebook_drag_done {
    my ($self, $event) = @_;
#    warn @_;
#    warn "Current tab id=" . $self->GetSelection;
    $event->Skip;
}

1;
