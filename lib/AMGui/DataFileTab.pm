package AMGui::DataFileTab;

use strict;
use warnings;

use Wx qw[:everything];
use File::Slurp;

sub new {
    my ( $self, $fileDlg, $noteBook ) = @_;

    my $filePath = $fileDlg->GetPath;
    my $fileName = $fileDlg->GetFilename;
    
    my @lines = read_file($filePath, chomp => 1);
    @lines = map { s/\r$//; $_ } @lines;

    my $listBox = Wx::ListBox->new($noteBook, 
	                           wxID_ANY, 
	                           wxDefaultPosition, 
	                           wxDefaultSize, 
	                           \@lines, 
	                           wxLB_SINGLE);

    $noteBook->AddPage($listBox, $fileName, 1);

    return $self;
}

1;
