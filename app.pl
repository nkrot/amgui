#!/usr/bin/env perl

# # #
# USAGE: perl -Ilib ./app.pl
#

package main;

use strict;
use warnings;

use AMGui;

unless(caller){
#    my $local = Wx::Locale->new("English", "en", "en"); # replace with ??
#    $local->AddCatalog("AMGui"); # replace with the appropriate catalog name

    my $app = AMGui->new();
    $app->MainLoop();
}

