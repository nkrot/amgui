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

    $self->Append(wxID_RUN,  _T("&Run AM\tCtrl+R"), "");

    return $self;
}

sub title {
    return _T("&Run");
}

1;
