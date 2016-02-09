package AMGui::Wx::Menu::Run;

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

    $self->Append(wxID_RUN_NEXT,   _T("&Run AM on the next item\tCtrl+R"), "");
    $self->Append(wxID_RUN_BATCH,  _T("&Run AM on all items in the current dataset\tCtrl+Shift+R"), "");

    return $self;
}

sub title {
    return _T("&Run");
}

1;
