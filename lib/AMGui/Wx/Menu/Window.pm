package AMGui::Wx::Menu::Window;

use strict;
use warnings;

use Wx::Locale gettext => '_T';

use AMGui::Constant;

our @ISA = 'Wx::Menu';

sub new {
    my $class = shift;
    my $main  = shift;
    
    my $self = $class->SUPER::new(@_);
    bless $self, $class;

    $self->Append(wxID_NEXT_TAB, _T("Next Tab\tCtrl+PGDN"), "");
    $self->Append(wxID_PREV_TAB, _T("Previous Tab\tCtrl+PGUP"), "");
    #$self->AppendSeparator();
  
    return $self;
}

sub title {
    return _T("&Window");
}

1;
