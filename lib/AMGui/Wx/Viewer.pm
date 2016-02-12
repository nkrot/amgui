package AMGui::Wx::Viewer;

use 5.022000;
use strict;
use warnings;

use Wx qw[:everything];
#use Wx::Locale gettext => '_T';

use AMGui::Constant;

our @ISA = 'Wx::ListBox';

use constant GENERAL => 'general';
use constant RESULTS => 'results';

use Class::XSAccessor {
    getters => {
        eol       => 'eol',
        path      => 'path',
        purpose   => 'purpose',
        filename  => 'filename'
    },
    setters => {
        set_eol     => 'eol',
        set_purpose => 'purpose'
    }
};

# TODO: add Statusbar set/restore functionality

sub new {
    my ($class, $parent) = @_;
    
    my $self = $class->SUPER::new (
        $parent,
        wxID_ANY,
        wxDefaultPosition,
        wxDefaultSize,
        [],
        wxLB_SINGLE
    );
    bless $self, $class;
    
    $self->{eol}      = "\n"; # TODO: need something smarter
    $self->{path}     = undef;
    $self->{filename} = undef;

    $self->{purpose} = GENERAL;
    
    return $self;
}

# TODO
# is_testing
# is_training
# is_results
# is_general

sub close {
    return TRUE;
}

sub set_lines {
    my ($self, $lines) = @_;
    $self->InsertItems($lines, 0);
    return $self;
}

#sub path {
#    my $self = shift;
#    return undef;
#}

sub set_path {
    my ($self, $path) = @_;
    $self->{path} = $path;
    return $self; # for method chaining
}

sub save {
    my $self = shift;
    open my $fh, '>', $self->path;
    for (my $i=0; $i < $self->GetCount; $i++) {
        print $fh $self->GetString($i) . $self->eol;
    }
    return CORE::close $fh;
}

1;
