package AMGui::DataSet;

use strict;
use warnings;

use Algorithm::AM::DataSet;

#our @ISA = qw{Algorithm::AM::DataSet};

#
# TODO for AM::DataSet ?
# is it possible to refactor AM::DataSet->new() so that it becomes possible to use it
# like this:
#   my $dataset = Algorithm::AM::DataSet->new(path => ..., format => ...);
# in which case data should be loaded automatically
# In this case this very AMGui::DataSet class could be derived from AM::DataSet
#

sub new {
    my ( $class, %args ) = @_;

    my $self = bless {}, $class;

    # path, format
    while (my ($key,$value) = each %args) {
        $self->{$key} = $value;
    }
    
    $self->{data} = Algorithm::AM::DataSet::dataset_from_file(%args);
     
    return $self;
}

sub path {
    my $self = shift;
    return $self->{path};
}

#sub file {
#    my ($self) = shift;
#    return $self->path;
#}

1;

