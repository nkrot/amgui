# generated by wxGlade 0.7.1 on Sat Jan 23 18:23:56 2016
#
# To get wxPerl visit http://www.wxperl.it
#

use Wx 0.15 qw[:allclasses];
use strict;
# begin wxGlade: dependencies
use Wx::Locale gettext => '_T';
# end wxGlade

# begin wxGlade: extracode
# end wxGlade

package AMGui::Wx::Base::MainFrame;

use Wx qw[:everything];
use base qw(Wx::Frame);
use strict;

# begin wxGlade: dependencies
use Wx::Locale gettext => '_T';
# end wxGlade

sub new {
    my( $self, $parent, $id, $title, $pos, $size, $style, $name ) = @_;
    $parent = undef              unless defined $parent;
    $id     = -1                 unless defined $id;
    $title  = ""                 unless defined $title;
    $pos    = wxDefaultPosition  unless defined $pos;
    $size   = wxDefaultSize      unless defined $size;
    $name   = ""                 unless defined $name;

    # begin wxGlade: AMGui::Wx::Base::MainFrame::new
    $style = wxDEFAULT_FRAME_STYLE 
        unless defined $style;

    $self = $self->SUPER::new( $parent, $id, $title, $pos, $size, $style, $name );
    
    $self->{mainFrame_statusbar} = $self->CreateStatusBar(1);
    $self->{window_1} = Wx::SplitterWindow->new($self, wxID_ANY);
    $self->{grid_1} = Wx::Grid->new($self->{window_1}, wxID_ANY);
    #$self->{notebook} = AMGui::Wx::Notebook->new($self->{window_1}, wxID_ANY);

    $self->__set_properties();
    $self->__do_layout();

    # end wxGlade
    return $self;

}


sub __set_properties {
    my $self = shift;
    # begin wxGlade: AMGui::Wx::Base::MainFrame::__set_properties
    $self->SetTitle(_T("Main Frame"));
    $self->SetSize(Wx::Size->new(900, 525));
    $self->{mainFrame_statusbar}->SetStatusWidths(-1);

    # statusbar fields
    my( @mainFrame_statusbar_fields ) = (
        _T("Status Bar"),
    );

    if( @mainFrame_statusbar_fields ) {
        $self->{mainFrame_statusbar}->SetStatusText($mainFrame_statusbar_fields[$_], $_)
        for 0 .. $#mainFrame_statusbar_fields ;
    }
    $self->{grid_1}->CreateGrid(10, 3);
    $self->{grid_1}->SetSelectionMode(wxGridSelectCells);
    # end wxGlade
}

sub __do_layout {
    my $self = shift;
    # begin wxGlade: AMGui::Wx::Base::MainFrame::__do_layout
    $self->{sizer_1} = Wx::BoxSizer->new(wxHORIZONTAL);
    #$self->{window_1}->SplitVertically($self->{grid_1}, $self->{notebook}, );
    $self->{sizer_1}->Add($self->{window_1}, 1, wxEXPAND, 0);
    $self->SetSizer($self->{sizer_1});
    $self->Layout();
    # end wxGlade
}

# end of class AMGui::Wx::Base::MainFrame

1;

