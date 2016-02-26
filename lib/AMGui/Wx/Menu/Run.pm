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
    
    # tips are shown in the status bar
    my %tips = (
        linear => _T("For computing scores Linear uses occurrences, Quadratic uses pointers."),
		include_nulls => _T("If checked, treats null variables in a test item as regular variables."),
		include_given => _T("If checked, allows a test item to be included in the data set during classification.")
    );
    
    $self->Append(wxID_RUN_NEXT,   _T("Run AM on the &next item\tCtrl+R"), "");
    $self->Append(wxID_RUN_BATCH,  _T("Run AM on &all items in the current dataset\tCtrl+Shift+R"), "");
    $self->AppendSeparator;
    $self->AppendCheckItem(wxID_TOGGLE_LINEAR, _T("&Linear"), $tips{linear});
    $self->AppendCheckItem(wxID_TOGGLE_INCLUDE_NULLS, _T("Include &nulls"), 
						   $tips{include_nulls});
    $self->AppendCheckItem(wxID_TOGGLE_INCLUDE_GIVEN, _T("Include &given"), 
						   $tips{include_given});
    
    return $self;
}

sub title {
    return _T("&Run");
}

1;
