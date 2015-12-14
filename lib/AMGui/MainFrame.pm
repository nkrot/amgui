package AMGui::MainFrame;

#use Wx qw[:allclasses];
use Wx qw[:everything];
use Wx::Locale gettext => '_T';

use strict;
use warnings;

use base qw(AMGui::Base::MainFrame);

sub new {
    my( $self, $parent, $id, $title, $pos, $size, $style, $name ) = @_;
    $self = $self->SUPER::new( $parent, $id, $title, $pos, $size, $style, $name );

    # Have to rebind the handlers here
    Wx::Event::EVT_MENU($self, wxID_NEW,           \&onFileNew);
    Wx::Event::EVT_MENU($self, wxID_OPEN,          \&onFileOpen);
    Wx::Event::EVT_MENU($self, wxID_EXIT,          \&onFileQuit);

    Wx::Event::EVT_MENU($self, wxID_ANY,           \&onRun);
    
    Wx::Event::EVT_MENU($self, wxID_HELP_CONTENTS, \&onHelpContents);
    Wx::Event::EVT_MENU($self, wxID_ABOUT,         \&onHelpAbout);

    return $self;
}

sub onFileNew {
    my ($self, $event) = @_;
    warn "Event handler (onFileNew) not implemented";
    $event->Skip;
}


sub onFileOpen {
    my ($self, $event) = @_;
    warn "Event handler (onFileOpen) not implemented";
    $event->Skip;
}

sub onFileQuit {
    my ($self, $event) = @_;
    $self->Close(1);
}

sub onRun {
    my ($self, $event) = @_;
    warn "Event handler (onRun) not implemented";
    $event->Skip;
}

sub onHelpContents {
    my ($self, $event) = @_;
    warn "Event handler (onHelpContents) not implemented";
    $event->Skip;
}


sub onHelpAbout {
    my ($self, $event) = @_;
    warn "Event handler (onHelpAbout) not implemented";
    $event->Skip;
}


1;
