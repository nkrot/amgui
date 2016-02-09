package AMGui::Constant;
use base qw( Exporter );

#BEGIN { $Exporter::Verbose = 1 }

use strict;
use warnings;

#our @ISA = qw(Exporter);

our @EXPORT = qw(
    wxID_RUN_BATCH
    wxID_OPEN_PROJECT
    wxID_NEXT_TAB
    wxID_PREV_TAB
    FALSE TRUE
    MSG_TRAINING_NOT_FOUND
    );
#our @EXPORT_OK = qw( wxID_RUN SHILO );

use constant wxID_RUN_BATCH    => 1000;
use constant wxID_OPEN_PROJECT => 1001;
use constant wxID_NEXT_TAB     => 1002;
use constant wxID_PREV_TAB     => 1003;

use constant WIN32 => !!( ( $^O eq 'MSWin32' ) or ( $^O eq 'cygwin' ) );

use constant FALSE => 0;
use constant TRUE  => 1;

# I know this is a bad idea
use constant MSG_TRAINING_NOT_FOUND => 
    "Could not find associated Training dataset.\nPerhaps you have closed the tab?";

1;
