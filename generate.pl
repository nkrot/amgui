#!/usr/bin/env perl

use strict;
use warnings;

my ($project_file, $root_dir) = @ARGV;
die "Usage: <project_file> <dir>\n" unless $project_file && $root_dir;
die "'$project_file' does not exist\n" unless -e $project_file;
die "'$root_dir' does not exist\n"     unless -d $root_dir;

use File::Slurp qw(write_file);
use File::Spec::Functions qw(catfile);
use File::Path qw(make_path);
use File::Basename qw(dirname);
use FBP;
use FBP::Perl;

my $fbp = FBP->new;
$fbp->parse_file($project_file);

my $project = $fbp->project;

my $generator = FBP::Perl->new(project => $project);

foreach my $form ($project->forms) {
    my $content = $generator->flatten($generator->frame_class($form));

    write_class($form->name, $content);
}

foreach my $dialog ($project->dialogs) {
    my $content = $generator->flatten($generator->dialog_class($dialog));

    write_class($dialog->name, $content);
}

sub write_class {
    my ($class_name, $content) = @_;

    my $path = join('/', split /::/, $class_name) . '.pm';
    $path = catfile($root_dir, $path);

    my $dir = dirname($path);
    make_path($dir);

    write_file $path, $content;
}

