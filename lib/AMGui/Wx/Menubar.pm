package AMGui::Wx::Menubar;

use strict;
use warnings;

use Wx::Menu ();
use Wx::Locale gettext => '_T';

use AMGui::Wx                 ();
use AMGui::Wx::Menu::File     ();
#use AMGui::Wx::Menu::Edit     ();
#use AMGui::Wx::Menu::Search   ();
use AMGui::Wx::Menu::Report   ();
use AMGui::Wx::Menu::Run      ();
use AMGui::Wx::Menu::Window   ();
use AMGui::Wx::Menu::Help     ();

#use Data::Dumper;

our $VERSION = '1.00';

use Class::XSAccessor {
    getters => {
        main    => 'main',
        menubar => 'menubar',

        # individual menus
        file    => 'file',
        report  => 'report',
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
    $self->{report} = AMGui::Wx::Menu::Report->new($main);
    $self->{run}    = AMGui::Wx::Menu::Run->new($main);
    $self->{window} = AMGui::Wx::Menu::Window->new($main);
    $self->{help}   = AMGui::Wx::Menu::Help->new($main);

    $self->append($self->{file});
    $self->append($self->{report});
    $self->append($self->{run});
    $self->append($self->{window});
    $self->append($self->{help});

    return $self;
}

sub append {
    my ($self, $menu) = @_;
    $self->menubar->Append($menu, $menu->title);
}

#sub FindItem {
#    my ($self, $id) = @_;
#    return $self->menubar->FindItem($id);
#}

#sub IsChecked {
#    my ($self, $id) = @_;
#    my $item = $self->FindItem($id);
#    {
#        no strict 'refs';
#        print "Instance METHOD IS  " . Dumper( \%{ref ($item)."::" }) ;
#    }
#    return $self->menubar->IsChecked($id);
#}

1;
