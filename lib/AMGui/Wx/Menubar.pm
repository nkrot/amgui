package AMGui::Wx::Menubar;
use base qw(Wx::MenuBar);

use strict;
use warnings;

use Wx::Menu ();
use Wx::Locale gettext => '_T';

use AMGui::Wx                 ();
#use AMGui::Wx::Menu::File     ();
#use AMGui::Wx::Menu::Edit     ();
#use AMGui::Wx::Menu::Search   ();
#use AMGui::Wx::Menu::View     ();
#use AMGui::Wx::Menu::Run      ();
#use AMGui::Wx::Menu::Window   ();
#use AMGui::Wx::Menu::Help     ();

our $VERSION = '1.00';

use Class::XSAccessor {
    getters => {
        main    => 'main',
		
        file    => 'file',
#        run     => 'run',
#        window  => 'window',
#        help    => 'help'
    }
};

sub new {
    my ($class, $main) = @_;
    
    #my $self = bless {
#	main => $main
#    }, $class;

    my $self = $class->SUPER::new($main);

    my $menus = {};
    
    $menus->{file} = Wx::Menu->new();
    $menus->{file}->Append(Wx::wxID_NEW, _T("&New\tCtrl+N"), "");
    $menus->{file}->Append(Wx::wxID_OPEN, _T("&Open\tCtrl+O"), "");
    $menus->{file}->AppendSeparator();
    $menus->{file}->Append(Wx::wxID_EXIT, _T("&Quit\tCtrl+Q"), "");
    
    
    #$wxglade_tmp_menu = Wx::Menu->new();
    #$self->{mainFrame_menubar}->Append($wxglade_tmp_menu, _T("&Edit"));
    
    #$wxglade_tmp_menu = Wx::Menu->new();
    #$wxglade_tmp_menu->Append(1000, _T("&Run AM\tCtrl+R"), "");
    #$self->{mainFrame_menubar}->Append($wxglade_tmp_menu, _T("&Run"));
    
    $menus->{help} = Wx::Menu->new();
    $menus->{help}->Append(Wx::wxID_HELP_CONTENTS, _T("Help\tCtrl+H"), "");
    $menus->{help}->AppendSeparator();
    $menus->{help}->Append(Wx::wxID_ABOUT, _T("About"), "");

    $self->Append($menus->{file}, _T("&File"));
    $self->Append($menus->{help}, _T("&Help"));
    
    return $self;
}

#sub append {
#    my ($self, $menu, $label) = @_;
#    $self->Append( $menu, $label );
#}
1;
