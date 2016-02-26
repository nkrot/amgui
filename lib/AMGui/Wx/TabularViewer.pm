package AMGui::Wx::TabularViewer;

use strict;
use warnings;

use Text::CSV;

use Wx qw[:everything];
use Wx::Locale gettext => '_T';

use AMGui::Constant;
use AMGui::Wx::Viewer;

our @ISA = ('Wx::ListView', 'AMGui::Wx::Viewer');

use Class::XSAccessor {
    getters => {
        main => 'main',
    },
};

sub new {
    my ($class, $main) = @_;

    my $self = $class->SUPER::new (
        $main->notebook,
        wxID_ANY,
        wxDefaultPosition,
        wxDefaultSize,
        wxLC_REPORT|wxLC_SINGLE_SEL|wxLC_HRULES|wxLC_VRULES
    );
    bless $self, $class;
    
    $self->{main} = $main;
    $self->{statusbar_message} = '';

    return $self;
}

sub notebook {
    my $self = shift;
    return $self->main->notebook;
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
    my ($self, $str_item, $columns) = @_;
    my $row = $self->GetItemCount;

    $self->InsertStringItem($row, $str_item);

    for (my $col=0; $col < scalar @{$columns}; $col++) {
        $self->SetItem($row, $col, $columns->[$col]);
    }

    return $row;
}

sub rows {
    my $self = shift;
    my @rows;
    for (my $r = 0; $r < $self->GetItemCount; $r++) {
        my @cols = ();
        for (my $c=0; $c < $self->GetColumnCount; $c++) {
            my $cell = $self->GetItem($r, $c); #=> Wx::ListItem
            $cell = $cell->GetText if defined $cell;
            push @cols, $cell;
        }
        push @rows, \@cols;
    }
    return @rows;
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

# https://metacpan.org/pod/Text%3a%3aCSV
# TODO: when saving to CSV
# ? always_quote
#   By default the generated fields are quoted only, if they need to, for example, if they contain the separator. If you set this attribute to a TRUE value, then all defined fields will be quoted. This is typically easier to handle in external applications.
# ? how to add column names?
sub save {
    my $self = shift;
    my %csv_opts = ( binary => 1 ); #, always_quote => 1 );
    my $csv = Text::CSV->new( \%csv_opts )
        or die "Cannot use CSV: " . Text::CSV->error_diag(); # TODO: this should be shown as a dialog

    open my $fh, '>', $self->path;

    $csv->eol($self->eol);
    $csv->print($fh, $_) for $self->rows;

    return CORE::close $fh;
}

sub focus {
    my ($self, $rowid) = @_;
    $self->Select($rowid, TRUE);
    $self->Focus($rowid);
    return TRUE;
}

sub show_in_statusbar {
    my ($self, $msg) = @_;
    $self->{statusbar_message} = $msg;
    $self->main->statusbar->say($msg);
    return $self;
}

1;
