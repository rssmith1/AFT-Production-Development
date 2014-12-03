package ParseMail;
use strict;
use warnings;

use Mail::IMAPClient;
use Email::MIME;
use IO::Socket::SSL;
use POSIX qw /strftime/;
my $today = strftime "%Y%m%d", localtime $^T;
my $msg;
my $n = 1;
my $name;

sub processParts {
  my($part) = @_;
  return unless $part->content_type =~ /\bname=([^\s]+)/;  # " grr...

  $name = "./$today-$msg-" . $n++ . "-$1";
  print "$0: writing $name...\n";
  open my $fh, ">", $name
    or die "$0: open $name: $!";
  print $fh $part->content_type =~ m!^text/!
      ? $part->body_str
      : $part->body
      or die "$0: print $name: $!";
  close $fh
    or warn "$0: close $name: $!";
}

sub saveFile {
  my ($str) = shift;
  Email::MIME->new($str)->walk_parts(\&processParts);
  return;
}

sub getFileFromMail {
  
  my $server = 'imap.gmail.com';
  my $port = 993;
  my $username = 'rssmith2g@gmail.com';
  my $password = 'buttons1';
  my $ssl = 1;
  
  # Connect to IMAP server
  my $client = Mail::IMAPClient->new();
  #Server   => 'imap.gmail.com',
  #User     => 'rssmith2g@gmail.com',
  #Password => 'buttons1',
  #Port     => 993,
  #Ssl      =>  1,
  #)
  
  if (!defined($client)) {
    print "Could not create client \n";
    return undef;
  }
  print "Created Client\n";
  
  $client->Server($server);
  $client->Port($port);
  $client->Ssl($ssl);
  $client->User($username);
  $client->Password($password);
  
  my $connectOK = $client->connect();
  print "LastError is: " . $client->LastError() . "\n";
  
  my @results = $client->Escaped_history;
  print @results;
  
  if (!defined($connectOK)) {
    return undef;
  }
  
  
  
  
  # List folders on remote server (see if all is ok)
  if ( $client->IsAuthenticated() ) {
    my @folderList = @{$client->folders};
    $client->select("INBOX");
    # Get a list of messages in the current folder:
    my @msgs = $client->messages or die "Could not messages: $@\n";
    #print "messages: " . @msgs  . "\n";
    foreach $msg (@msgs) {
      #print $msg . ":" ;   # This looks like a message sequence number
      my $subject = $client->subject($msg);
      if ($subject =~ /Activity Flex/) {
        print "Found subject $subject \n";
        my $str = $client->message_string($msg);
        saveFile($str); 
      }
    }
  }
  # Say so long 
  $client->logout();
  return $name;
}

1;
