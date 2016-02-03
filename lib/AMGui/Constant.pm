package AMGui::Constant;
use base qw( Exporter );

#BEGIN { $Exporter::Verbose = 1 }

use strict;
use warnings;

#our @ISA = qw(Exporter);

our @EXPORT = qw(
    wxID_RUN
    wxID_OPEN_PROJECT
    wxID_NEXT_TAB
    wxID_PREV_TAB
    FALSE TRUE);
#our @EXPORT_OK = qw( wxID_RUN SHILO );

use constant wxID_RUN          => 1000;
use constant wxID_OPEN_PROJECT => 1001;
use constant wxID_NEXT_TAB     => 1002;
use constant wxID_PREV_TAB     => 1003;

use constant WIN32 => !!( ( $^O eq 'MSWin32' ) or ( $^O eq 'cygwin' ) );

use constant FALSE => 0;
use constant TRUE  => 1;

#1;
