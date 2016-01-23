package AMGui::DataSet;

use strict;
use warnings;

use Algorithm::AM::DataSet;
use File::Spec;

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
    $self->{filename} = ( File::Spec->splitpath( $self->path ) )[-1];
     
    return $self;
}

######################################################################

use Class::XSAccessor {
    getters => {
        path     => 'path',      # full/path/to/filename
        format   => 'format',    # data formats available in AM::DataSet
        filename => 'filename',  # last portion of the path: filename
    },
};

######################################################################

sub size {
    my $self = shift;
    return $self->{data}->size;
}

sub items_as_strings {
    my $self = shift;
    my @lines = map { $self->nth_item_as_string($_) } 0..$self->size-1;
    return \@lines;
}

# Return nth item from the dataset,
# => instance of AM::DataSet::Item
sub nth_item {
    my ($self, $index) = @_;
    my $item = $self->{data}->get_item($index);
    return $item;
}

sub nth_item_as_string {
    my ($self, $index) = @_;
    return $self->item_as_string($self->nth_item($index));
}

# Build a string from an AM::DataSet::Item in 'commas' format only
# TODO: Ideally, we want to have the very original line from the source file
#       unless we switch to wxGrid in future :)
sub item_as_string {
    my ($self, $item) = @_;
    return join ",", (
        $item->class,
        "\t" . join("\t", @{$item->features}) . "\t",
        $item->comment      # can be fake!
    );
}

#sub file {
#    my ($self) = shift;
#    return $self->path;
#}

1;

