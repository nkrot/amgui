package AMGui::Result;

use strict;
use warnings;

use Algorithm::AM::Result;

use Class::XSAccessor {
    getters => {
        results => 'results',  # array of instances of AM::Result
        viewer  => 'viewer'    # GUI component that renders results
    }
};

sub new {
    my $class = shift;
    
    my $self = bless {}, $class;

    # each Result
    # > print @{ $self->results[0]->winners }
    # > print ${ $self->results[0]->statistical_summary }
    $self->{results} = ();
  
    return $self;
}

sub add {
    my ($self, $result) = @_;
    push @{ $self->{results} }, $result;
    return scalar @{ $self->{results} };
}

1;


