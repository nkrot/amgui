package AMGui::Wx::Menubar;

use strict;
use warnings;

use Wx::Menu ();
use Wx::Locale gettext => '_T';

use AMGui::Wx                 ();
use AMGui::Wx::Menu::File     ();
#use AMGui::Wx::Menu::Edit     ();
#use AMGui::Wx::Menu::Search   ();
#use AMGui::Wx::Menu::View     ();
use AMGui::Wx::Menu::Run      ();
use AMGui::Wx::Menu::Window   ();
use AMGui::Wx::Menu::Help     ();

our $VERSION = '1.00';

use Class::XSAccessor {
    getters => {
        main    => 'main',
        menubar => 'menubar',

	# individual menus
        file    => 'file',
        run     => 'run',
        window  => 'window',
        help    => 'help'
    }
};

sub new {
    my ($class, $main) = @_;
    
    my $self = bless {
	main    => $main,
	menubar => Wx::MenuBar->new
    }, $class;

    $self->{file}   = AMGui::Wx::Menu::File->new($main);
    $self->{run}    = AMGui::Wx::Menu::Run->new($main);
    $self->{window} = AMGui::Wx::Menu::Window->new($main);
    $self->{help}   = AMGui::Wx::Menu::Help->new($main);
    
   
    $self->append($self->{file});
    $self->append($self->{run});
    $self->append($self->{window});
    $self->append($self->{help});
    
    return $self;
}

sub append {
    my ($self, $menu) = @_;
    $self->menubar->Append($menu, $menu->title);
}

1;
