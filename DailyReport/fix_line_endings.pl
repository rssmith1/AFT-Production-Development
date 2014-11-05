#!/usr/bin/perl -w
use strict;

my $filename = $ARGV[0]; 

print "filename is $filename";
my $outstring; 
while (<>) {
    $outstring = $_;
    $outstring =~ s/\r/\n/g;
}

print $outstring;

open(OUTFILE, ">".$filename) or die "couldnt open file";
print OUTFILE $outstring;
close OUTFILE;
