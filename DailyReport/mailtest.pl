#!/usr/bin/perl -w
use strict;
use warnings;
use Net::IMAP::Simple;
use Email::Simple;

    # Create the object
    #my $imap = Net::IMAP::Simple->new('imap.example.com') ||
    my $imap = Net::IMAP::Simple->new('imap.gmail.com') ||
       die "Unable to connect to IMAP: $Net::IMAP::Simple::errstr\n";

    # Log on
    if(!$imap->login('rssmith2g@gmail.com','buttons1')){
        print STDERR "Login failed: " . $imap->errstr . "\n";
        exit(64);
    }

    # Print the subject's of all the messages in the INBOX
    my $nm = $imap->select('INBOX');

    for(my $i = 1; $i <= $nm; $i++){
        if($imap->seen($i)){
            print "*";
        } else {
            print " ";
        }

        my $es = Email::Simple->new(join '', @{ $imap->top($i) } );

        printf("[%03d] %s\n", $i, $es->header('Subject'));
    }

    $imap->quit;