#!/usr/bin/perl -w
use strict;
use DBI;

use CMESettlement;

my @settleArray;
my $dbh;

sub getFutures {
    my $currentLine = shift;
    my $symbol;
    if ($currentLine =~ /NB CME BRITISH POUND FUTURES/) {
        $symbol = "6B";
    }    
    my $firstTotalLine = 0;
    my $done = 0;
    while (!$done) {
        $_ = <INPUTFILE>;        
        if ($_ =~ /TOTAL/) {
            if ($firstTotalLine == 1) {
                $done = 1;
            } else {
                $firstTotalLine = 1;
            }
        } else {
            #print "\n" . $_;
            #print "\nlength is: " . length $_;
            my $cmeSettle = CMESettlement->newFromString($symbol,"2014-11-12",$_);        
            push @settleArray, $cmeSettle;
        }
    }
    return \@settleArray;
}

sub connectToDB { 
    my $dsn = 'DBI:mysql:daily_report;host=AFT-INT-1;port=3306';
    $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    return;
}

sub disconnectFromDB {
    $dbh->disconnect;
}

sub storeSettlements {
    my $settlementArray = shift;
    foreach my $settlement (@$settlementArray) {
        my $sql = "insert into settlement values (\"" . $settlement->settlementDate . "\",\"" . $settlement->symbol . "\"," .
        $settlement->open . "," .
        $settlement->high . "," .
        $settlement->low . "," .
        $settlement->last . "," . $settlement->settle  .  "," .
        $settlement->change . "," . $settlement->vol  .   "," .
        $settlement->pSettle . "," . $settlement->pVol  .   "," .
         $settlement->oi . ",\"" . $settlement->highSide . "\"" .
         ",\"" . $settlement->lowSide . "\"" .
         ");";
        print "sql is " . $sql . "\n";
        my $sth = $dbh->prepare($sql);
        print STDERR "inserting rows\n";
        $sth->execute or warn "SQL Error: $DBI::errstr\n";   
     }
}

####################  MAIN  #################
    my $inputFilename = "settle.csv";
    open(INPUTFILE, "<$inputFilename") or die "could not open file $inputFilename";
    my $firstLine = 0;
        
    my $settleArray;    
    my $done = 0;
    while (!$done) {
        $_ = <INPUTFILE>;
        if ($_ =~ /END/) {
            $done = 1;
        } elsif ($_ =~ /NB CME BRITISH POUND/) {
            my $currentLine = $_;
            $settleArray = getFutures($currentLine);
        }
    }

foreach my $settle (@$settleArray) {
    print $settle->settlementDate() . " " . $settle->symbol() . " ";
    print $settle->open() . " " . $settle->high() . " " . $settle->low() . " ";
    print $settle->last() . " " . $settle->settle() ." " . $settle->change() . " ";
    print $settle->vol() . " ";
    print $settle->pSettle() ." ";
    print $settle->pVol() ." ";
    print $settle->oi .
    print $settle->highSide . " " . $settle->lowSide . "\n";
}

connectToDB();
storeSettlements($settleArray);
disconnectFromDB();

