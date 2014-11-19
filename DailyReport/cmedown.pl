#!/usr/bin/perl -w
use strict;

use Net::FTP::File;
use Data::Dumper;

my $file = "/pub/settle/stlcur";
my $newfile = "settle.csv";


    my $ftp = Net::FTP->new("ftp.cmegroup.com", Debug => 0)
      or die "Cannot connect to some.host.name: $@";

    $ftp->login("anonymous",'-anonymous@')
      or die "Cannot login ", $ftp->message;

    if($ftp->isfile($file)) {
       $ftp->get($file,$newfile);
       #$ftp->chmod(644, $newfile) or warn $ftp->message;
    } else {
        print "$file does not exist or is a directory";
    }

   #my $dirinfo_hashref = $ftp->dir_hashref;

   #print Dumper $dirinfo_hashref->{$file}; # Dumper() is from Data::Dumper, just FYI

   $ftp->quit;