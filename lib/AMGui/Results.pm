package AMGui::Results;

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

    $self->{results} = ();

    return $self;
}

sub add {
    my ($self, $result) = @_;
    push @{ $self->{results} }, $result;
    return scalar @{ $self->{results} };
}

sub as_strings {
    my ($self, $result) = @_;
    my $lines = [
        "Tested item:\n" . $self->as_string($result->test_item),
        "Predicted class(es): " . (join ",", @{ $result->winners }),
        ${$result->statistical_summary}
    ];
    return $lines;
}

# TODO: this is shit!
# a method for converting to a string should rather be added to the classes handled here
sub as_string {
    my ($self, $obj) = @_;

    my $str = undef;
    if ( $obj->isa("Algorithm::AM::DataSet::Item") ) {
        $str = $obj->class . ",\t" . join("\t", @{$obj->features}) . "\t," . $obj->comment;
    } else {
        # TODO: raise an error?
    }
    return $str;
}

sub last_n {
    my ($self, $n) = @_;
    $n = 1 unless defined $n;
    return @{$self->results}[-$n .. -1];
}

1;


