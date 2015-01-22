#!/usr/bin/perl

use strict;

my $tpldir;

$tpldir = $ARGV[0];

print "OS is $^O\n";
if (-e $tpldir) {
   print $tpldir . " exists\n";
}
else {
   print $tpldir . " doesn't exist\n";
}

