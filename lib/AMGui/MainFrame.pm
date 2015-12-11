package AMGui::MainFrame;

use strict;
use warnings;

use base 'Wx::Frame';

use Wx;
use Wx::Event;
use Wx::XRC;

sub new {
    my $self = shift->SUPER::new(@_);

    Wx::Event::EVT_BUTTON(
        $self,
        Wx::XmlResource::GetXRCID('CloseButton'),
        sub { $self->Close(1) }
    );

    return $self;
}

1;
