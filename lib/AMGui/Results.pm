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
    $self->{results} = [];
    return $self;
}

sub add {
    my ($self, $result) = @_;
    my $count = scalar @{ $self->{results} };
    push @{ $self->{results} }, $result;
    return $count; # position of the newly added item
}

sub to_pct {
    my ($self, $part, $whole) = @_;
    my $percentage_format = '%.3f'; # also defined in Algorithm::AM::Result
    return sprintf($percentage_format, 100 * $part / $whole);
}

# TODO: unused
sub as_strings {
    my ($self, $result) = @_;
    my $lines = [
        "Tested item:\n"        . $self->as_string($result->test_item),
        "Predicted class(es): " . join(",", @{ $result->winners}),
        ${$result->config_info},
        ${$result->statistical_summary}
    ];

    push @{$lines}, "Hoho! I can extract it!";

    my %scores = %{$result->scores};
    for my $class (sort keys %scores) {
        push @{$lines}, join("\t", $class,
                                   %scores{$class},
                                   $self->to_pct( $scores{$class}, $result->total_points ));
    }

    return $lines;
}

# TODO: this is shit! probably no longer used and can be deleted
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

