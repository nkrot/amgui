package AMGui::Wx::MainFrame;
use base qw(AMGui::Wx::Base::MainFrame);

use Wx qw[:everything];
use Wx::Locale gettext => '_T';
use strict;
use warnings;

use Cwd ();
use File::Slurp;
use File::Spec;

use AMGui::AM;
use AMGui::Constant;
use AMGui::DataSet;
use AMGui::Wx::AuiManager;
use AMGui::Wx::Notebook;
use AMGui::Wx::DatasetViewer;

#our @ISA        = qw{};

sub new {
    my( $self, $parent, $id, $title, $pos, $size, $style, $name ) = @_;
    $self = $self->SUPER::new( $parent, $id, $title, $pos, $size, $style, $name );
    $self->SetTitle("AM Gui");

    $self->{aui} = AMGui::Wx::AuiManager->new($self);

    $self->{cwd} = Cwd::cwd();

    # Have to rebind the handlers here
    Wx::Event::EVT_MENU($self, wxID_NEW,           \&onFileNew);
    Wx::Event::EVT_MENU($self, wxID_OPEN,          \&onFileOpen);
    Wx::Event::EVT_MENU($self, wxID_EXIT,          \&onFileQuit);

    Wx::Event::EVT_MENU($self, wxID_RUN,           \&onRun);
    
    Wx::Event::EVT_MENU($self, wxID_HELP_CONTENTS, \&onHelpContents);
    Wx::Event::EVT_MENU($self, wxID_ABOUT,         \&onHelpAbout);

    $self->{notebook} = AMGui::Wx::Notebook->new($self);

    # Set up the pane close event
    #TODO#Wx::Event::EVT_AUI_PANE_CLOSE($self, sub { shift->on_aui_pane_close(@_); }, );

    return $self;
}

use Class::XSAccessor {
    getters => {
        notebook => 'notebook',
        cwd      => 'cwd',
        aui      => 'aui'
    },
};


######################################################################
# Menu event handlers

sub onFileNew {
    my ($self, $event) = @_;
    warn "Event handler (onFileNew) not implemented";
    $event->Skip;
}

sub onFileOpen {
    my ($self, $event) = @_;
    
    my $wildcards = join(
        '|',
 	_T('CSV Files'),  '*.csv;*.CSV',
 	_T('Text Files'), '*.txt;*.TXT'
    );
    
    $wildcards =
        AMGui::Constant::WIN32
        ? _T('All Files') . '|*.*|' . $wildcards
        : _T('All Files') . '|*|' . $wildcards;
    
    my $fileDlg = Wx::FileDialog->new( 
        $self,
        _T('Open Files'),
        $self->cwd,    # Default directory
        '',            # Default file
        $wildcards,
        wxOPEN|wxFILE_MUST_EXIST|wxFD_MULTIPLE
    );

    # If the user really selected a file
    if ($fileDlg->ShowModal == wxID_OK)
    {
        my @filenames = $fileDlg->GetFilenames;
        $self->{cwd} = $fileDlg->GetDirectory;
        
        my @files;
        foreach my $filename (@filenames) {

            # Construct full paths, correctly for each platform
            my $fname = File::Spec->catfile($self->cwd, $filename);

            unless ( -e $fname ) {
                my $ret = Wx::MessageBox(
                    sprintf(_T('File name %s does not exist on disk. Skip it?'), $fname),
                    _T("Open File Warning"),
                    Wx::wxYES_NO|Wx::wxCENTRE,
                    $self,
                );

		next if $ret == Wx::wxYES;
            }

            push @files, $fname
        }
        
	$self->setup_data_viewers(@files) if $#files > -1;
    }
    
    return 1;
}

sub onFileQuit {
    my ($self, $event) = @_;
    $self->Close(1);
}

sub onRun {
    my ($self, $event) = @_;
    
    # TODO
    # if no data was loaded, report it via a dialog
    # if no item was selected, warn that a random item will be selected
    #    and report the random item somewhere
    #if ($self->{lbFileData})
    
    $self->inform("I am running");

    return 1;
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

# TODO: see dialog in Padre::Main::close()
#sub on_close_tab {
#    my $self = shift;
#    
#    my $id = $self->notebook->GetSelection;
#    $self->notebook->DeletePage($id);
#    warn "Closing the tab ";
#    return 1;
#}

######################################################################

=pod

=head3 C<setup_data_viewers>

    $main->setup_data_viewers( @files );

Setup (new) tabs for C<@files>, and update the GUI.

=cut

sub setup_data_viewers {
    my $self  = shift;
    my @files = @_;

    if (@files) {
        foreach my $file (@files) {
            $self->setup_data_viewer($file);
        }
    } else {
        # TODO: open an empty document? for what?
    }
}

=pod

=head3 C<setup_data_viewer>

    $main->setup_data_viewer( $file );

Setup a new tab / buffer and open C<$file>, then update the GUI.

=cut

# TODO:
#Recycle current buffer if there's only one empty tab currently opened.
#If C<$file> is already opened, focus on the tab displaying it.
#Finally, if C<$file> does not exist, create an empty file before opening it.

sub setup_data_viewer {
    my ($self, $file) = @_;
    
    # load exemplars from file
    my %args = (
        path   => $file,
        format => 'commas'  # TODO: set it from GUI control or from file extension?
    );
    my $dataset = AMGui::DataSet->new(%args);
    
    # an instance of AM classifier
    my $classifier = AMGui::AM->new;
    
    # GUI component for showing exemplars and running the classifier
    my $data_viewer = AMGui::DatasetViewer->new($self->notebook, $dataset);
    #$data_dataset->set_dataset($dataset);
    $data_viewer->set_classifier($classifier);
    
    #$dataset->set_viewer($data_viewer); # ???

    # my old code
    # TODO: how Padre stores and accesses tabs?
    # TODO: store $dataFile (listBox) somewhere.
    #  $self->{lbFileData} = $dataFile
    # in onRun, need to access 1) selected line 2) all lines

    #my $dataFile = AMGui::DataFileTab->new($fileDlg, $self->{notebook});

}

######################################################################

sub update_aui {
    my $self = shift;
    #return if $self->locked('refresh_aui');
    $self->aui->Update;
    return;    
}

######################################################################

sub inform {
    my ($self, $msg) = @_;
    Wx::MessageBox($msg, "Informing that", Wx::wxOK);
    return 1;
}


1;
