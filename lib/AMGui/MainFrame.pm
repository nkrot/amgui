package AMGui::MainFrame;

#use Wx qw[:allclasses];
use Wx qw[:everything];
use Wx::Locale gettext => '_T';

use File::Slurp;
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

sub inform {
    my ($self, $msg) = @_;
    Wx::MessageBox($msg, "Informing that", Wx::wxOK);
    return 1;
}

sub onFileOpen {
    my ($self, $event) = @_;
    
    my $fileDlg = Wx::FileDialog->new( $self,
                                       'Open File',
                                       '',            # Default directory
                                       '',            # Default file
                                       "CSV file (*.csv)|*.csv",
                                       wxOPEN|wxFILE_MUST_EXIST);
    # If the user really selected one
    if ($fileDlg->ShowModal==wxID_OK)
    {
        
        my $filePath = $fileDlg->GetPath;
        
        my @lines = read_file($filePath, chomp => 1);
        @lines = map { s/\r$//; $_ } @lines;
        
        #$self->inform("file " . $filepath . " contains " . $#lines . " lines");
        #$self->inform("<" . $lines[0] . ">");

        $self->{lbFileData}->Set(\@lines);
 
        # set the tab name
        my $fileName = $fileDlg->GetFilename;
        my $nb = $self->{rightWindow};
        $nb->SetPageText(0, $fileName);
    }
    
    return 1;
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
