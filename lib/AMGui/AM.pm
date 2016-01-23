package AMGui::AM;

use strict;
use warnings;

use Algorithm::AM;
 
use Class::XSAccessor {
    getters => {
        classifier => 'classifier',
        dataset    => 'dataset',
        result     => 'result'
    },
    setters => {
        set_dataset => 'dataset'
    }
};

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;

    return $self;
}

# Classify given test item using preset training set
# 
# >print @{ $self->result->winners }
# >print ${ $self->result->statistical_summary }
sub classify {
   my ($self, $test_item) = @_;
   $self->{classifier} = Algorithm::AM->new(training_set => $self->{dataset});
   $self->{result} = $self->classifier->classify($test_item);
   return $self->result;
}

1;
