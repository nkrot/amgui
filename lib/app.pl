#!/usr/bin/perl -w -- 
#
# generated by wxGlade 0.6.8 on Wed Dec 23 14:57:56 2015
#
# To get wxPerl visit http://wxPerl.sourceforge.net/
#

# This is an automatically generated file.
# Manual changes will be overwritten without warning!

use Wx 0.15 qw[:allclasses];
use strict;
package AMGui;

use base qw(Wx::App);
use strict;

use AMGui::Base::MainFrame;

sub OnInit {
    my( $self ) = shift;

    Wx::InitAllImageHandlers();

    my $mainFrame = AMGui::Base::MainFrame->new();

    $self->SetTopWindow($mainFrame);
    $mainFrame->Show(1);

    return 1;
}
# end of class AMGui

package main;

unless(caller){
    my $local = Wx::Locale->new("English", "en", "en"); # replace with ??
    $local->AddCatalog("app"); # replace with the appropriate catalog name

    my $app = AMGui->new();
    $app->MainLoop();
}
