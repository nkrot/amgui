package AMGui::Wx::StatusBar;

use strict;
use warnings;

our @ISA = 'Wx::StatusBar';

# status bar fields
use constant {
	MAIN    => 0,
	FIELD1  => 1,
	FIELD2  => 2,
	FIELD3  => 3,
};

sub new {
    my ($class, $main) = @_;

	my $self = $class->SUPER::new(
		$main,
		-1,
		Wx::wxST_SIZEGRIP | Wx::wxFULL_REPAINT_ON_RESIZE
	);

	$self->{main} = $main;
	
	$self->SetFieldsCount(4);
    $self->SetStatusWidths(-1); # TODO: now equal size
    
    $self->say("Status bar or cafe");
    
    return $self;
}

sub say {
	my ($self, $msg) = @_;
	$self->SetStatusText($msg, MAIN);
}

1;
