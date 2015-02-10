 use strict;
 use warnings;
 
 
 use ParseMail;
 
 
  my $mailfileArray = ParseMail::getFileFromMail();
  foreach my $filename (@$mailfileArray) {
    print $filename  . "\n";
  }