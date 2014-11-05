#!/usr/bin/perl -w
use strict;
use warnings;
use Mail::IMAPClient;

# Connect to IMAP server
my $client = Mail::IMAPClient->new(
  Server   => 'imap.gmail.com',
  User     => 'rssmith2g@gmail.com',
  Password => 'buttons1',
  Port     => 993,
  Ssl      =>  1,
  )
  or die "Cannot connect through IMAPClient: $!";

# List folders on remote server (see if all is ok)
if ( $client->IsAuthenticated() ) {
  print "Folders:\n";
  print "- ", $_, "\n" for @{ $client->folders() };  
};

# Say so long
$client->logout();
