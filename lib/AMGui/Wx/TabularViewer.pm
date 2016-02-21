package AMGui::Wx::TabularViewer;

use strict;
use warnings;

use Wx qw[:everything];
use Wx::Locale gettext => '_T';

# TODO: no need to use it as a base class? use association instead
our @ISA = 'Wx::ListView';

sub new {
    my ($class, $parent) = @_;

    my $self = $class->SUPER::new (
        $parent,
        wxID_ANY,
        wxDefaultPosition,
        wxDefaultSize,
        wxLC_REPORT|wxLC_SINGLE_SEL|wxLC_HRULES|wxLC_VRULES
    );
    bless $self, $class;

	return $self;
}

sub add_columns {
    my ($self, $labels) = @_;
    my $col   = $self->GetColumnCount;
	my $width = wxLIST_AUTOSIZE_USEHEADER;
    foreach my $label (@{$labels}) {
        $self->InsertColumn($col++, _T($label), wxLIST_FORMAT_LEFT, $width);
    }
	return $self->GetColumnCount;
}

sub add_row {
	my ($self, $data) = @_;
	return 0;
}

sub adjust_column_widths {
    my ($self) = @_;
    for (my $i=0; $i < $self->GetColumnCount; $i++) {
        $self->SetColumnWidth($i, $self->best_column_width($i));
    }
	return 1;
}

sub best_column_width {
    my ($self, $col) = @_;

    #my $width = wxLIST_AUTOSIZE_USEHEADER; # in a bugless world this whould be enough
    my $width = wxLIST_AUTOSIZE;

    # TODO: something wrong here, can not get to the text stored in a cell
#    for (my $i=0; $i < $self->GetItemCount; $i++) {
#        my $item = $self->GetItem($i);
#        warn Dumper($item->GetColumn);
#        #warn $cell->GetText;
#        #warn join(",", $self->GetTextExtent($cell->GetText));
#    }

    return $width;
}

1;
