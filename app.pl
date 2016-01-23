#!/usr/bin/env perl

# # #
# USAGE: perl -Ilib ./app.pl
#

package main;

use 5.022000;
use strict;
use warnings;

use AMGui;

unless(caller){
    my $app = AMGui->new();
    $app->MainLoop();
}

