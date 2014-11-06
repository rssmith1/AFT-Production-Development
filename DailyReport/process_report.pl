#!/usr/bin/perl -w
use strict;
use Account;
use Position;
use ParseMail;
use DBI;
use Date::Calc qw (:all);


my $userprofile = $ENV{USERPROFILE};
my $dirbase = "$userprofile\\Google Drive\\AFT - Daily Report\\";
my $filename = $dirbase . "EOD (NN).csv";
my $outputFilename = $dirbase . "output.csv";
my $positionHash = {};
my $dateHash = {};
my $reportDate;
my $yesterdayEquity = 0;
my $weekBeginDate = "";


sub assignPortfolio {
    my $positionHash = shift;
    my $position;
    foreach my $symbol (keys %{$positionHash}) {
        if (length($symbol) == 4) {
            $positionHash->{$symbol}->portfolio("HEDGE");
        } else {
            if ($positionHash->{$symbol}->quantity > 0 ) {
                $positionHash->{$symbol}->portfolio("TAIL_RISK_INSURANCE");
            } else {
                $positionHash->{$symbol}->portfolio("SHORT THETA");
            }
        }
    }
}


sub readSection {
    #print STDERR "reading section \n";
    my $processingFunc = shift;
    my $objectHash = shift;
    my $done = 0;
    my $row;
    my @fields;
    my @headerFields;
    my $yesterdayEquity = 0;

    while (!$done) {
        $row = <INPUTFILE>;
        chomp($row);
        $row =~ s/"//g;
        @fields = split /,/,$row;
        if  ($fields[0] eq "EOS" )
        {
            $done = 1;
        } else {
            if ($fields[0] eq "HEADER") {
                @headerFields = split /,/,$row;
            } else {
                if ($fields[0] eq "DATA") {
                    if ($fields[2] ne "--") {
                        &{$processingFunc}(\@fields,$objectHash);    
                    }
                }
            }
        }
    }
    return;
}   


sub processEquity {
    #print STDERR "reading equity section \n";
    my $fields = shift;
    my $dateHash = shift;
    # if the EOD report is run, then the data shows up in two rows - previous day equity and todays equity.
    # all that really has to happen here is to subtract the two.


    my $account = Account->new();
    $account->date($$fields[2]);
    my ($year,$month,$day) = split /-/,$$fields[2];
    my $dow = Day_of_Week($year,$month,$day);
    my ($by,$bm,$bd) = Add_Delta_Days($year,$month,$day, -1 * ($dow-1));
    $weekBeginDate = $by . "-" . $bm . "-" . $bd;    
    #print "week begin date is $weekBeginDate \n";
    $reportDate = ($$fields[2]);
    my $tmpAmt = sprintf "%0.2f", $$fields[3];
    $account->totalEquity($tmpAmt);
    if ($yesterdayEquity == 0 ) {
        $yesterdayEquity = $account->totalEquity;
    } else {
        $tmpAmt = sprintf("%0.2f",$account->totalEquity - $yesterdayEquity);
        $account->equityChange($tmpAmt);   
    }
    $dateHash->{$$fields[2]} = $account;
    return;
}   
    
sub calcWeekBegin {
    my $currentDate = shift;
    
    
    
}

    
sub processMarkToMarket {
    #print STDERR "processing mark-to-market section \n";
    my $fields = shift;
    my $pHash = shift;
    my $position = Position->new();
    $position->symbol($$fields[2]);
    $position->mtmPnL($$fields[3]);
    $pHash->{$position->symbol} = $position;
    return;
}   
    
sub processPositions {
    my $fields = shift;
    my $positionHash = shift;
    #print STDERR $$fields[2] . "\n";
    #print STDERR "processing Position Section\n";
    my $position = $positionHash->{$$fields[2]};
    $position->quantity($$fields[3]);
    $position->markPrice($$fields[4]);
    return;
}

sub processTrades {
    my $fields = shift;
    my $positionHash = shift;
    #print STDERR $$fields[2] . "\n";
    #print STDERR "processing Position Section\n";
    my $position = $positionHash->{$$fields[2]};
    $position->tradedQuantity($$fields[3]);
    return;
}

sub processCommissions {
    my $fields = shift;
    my $positionHash = shift;
    #print STDERR $$fields[2] . "\n";
    #print STDERR "processing Position Section\n";
    my $position = $positionHash->{$$fields[2]};
    $position->totalCommission($$fields[3] + $position->totalCommission());
    return;
}


sub writeOutputToFile {
    open(OUTPUTFILE, ">", $outputFilename) or die "Could not open file";
    print OUTPUTFILE "symbol,portfolio,qty,markPrice,mtmPnL\n";
    foreach my $symbol (keys %{$positionHash}) {
    print OUTPUTFILE $symbol . "," .  $positionHash->{$symbol}->portfolio . "," . $positionHash->{$symbol}->quantity . "," . $positionHash->{$symbol}->markPrice . "," .$positionHash->{$symbol}->mtmPnL . "\n"; 
    }
    close OUTPUTFILE;
}

sub storeReport {

    my $dateHash = shift;    
    my $dsn = 'DBI:mysql:daily_report';
    my $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";

    #my $sql = "select * from report";
    for my $date (keys %{$dateHash}) {
        my $sql = "insert into report values (\"" . $date . "\"," . $dateHash->{$date}->totalEquity . "," . $dateHash->{$date}->equityChange . "," . $dateHash->{$date}->weekEquityChange() . ");"; 
        my $sth = $dbh->prepare($sql);
        #print "inserting rows: $sql\n";
        $sth->execute or warn "SQL Error: $DBI::errstr\n";   
     }
    $dbh->disconnect;
}

sub storePositions {

    my $positionHash = shift;
    my $reportDate = shift;
    my $dsn = 'DBI:mysql:daily_report';
    my $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";

    #my $sql = "select * from report";
    for my $symbol (keys %{$positionHash}) {
        my $sql = "insert into position values (\"" . $reportDate . "\",\"" . $positionHash->{$symbol}->symbol . "\"," .
        "\"" . $positionHash->{$symbol}->portfolio . "\"," .
        $positionHash->{$symbol}->quantity . "\," .
        $positionHash->{$symbol}->markPrice . "\," .
        $positionHash->{$symbol}->mtmPnL . "," . sprintf("%0.2f", $positionHash->{$symbol}->mtmPnLWeek)  .  "," .
        $positionHash->{$symbol}->tradedQuantity . "," . $positionHash->{$symbol}->totalCommission  . ");"; 
        my $sth = $dbh->prepare($sql);
        print STDERR "inserting rows\n";
        $sth->execute or warn "SQL Error: $DBI::errstr\n";   
     }
    $dbh->disconnect
}

sub getWeekMTM {
    my $positionHash = shift;
    my $reportDate = shift;
    my $yesterday = calcYesterday($reportDate);
    my $dsn = 'DBI:mysql:daily_report';
    my $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    foreach my $symbol (keys %{$positionHash}) {        
        my $sql = "SELECT mtm_pnl_week " .
        "FROM position " .
        "WHERE symbol = \"" . $symbol . "\" and position_date  = \"" . $yesterday . "\"";
        my $beginPnL = $dbh->selectrow_array($sql,undef);
        if (!defined($beginPnL)) {
            $beginPnL = 0;
        }
        #print STDERR "Sql is $sql\n";   
        #print STDERR "starting mtmPnLWeek is " . $positionHash->{$symbol}->mtmPnLWeek . " \n";
        $positionHash->{$symbol}->mtmPnLWeek($positionHash->{$symbol}->mtmPnL + $beginPnL);  
    }
    $dbh->disconnect;
    return;
}


sub calcYesterday {
    my $today = shift;
    my ($year,$month,$day) = split /-/,$today;
    my ($by,$bm,$bd) = Add_Delta_Days($year,$month,$day, -1);
    return $by . "-" . $bm . "-" . $bd;    
}

sub getYesterdaysPositions {
    my $positionHash = shift;
    my $weekBeginDate = shift;
    my $reportDate = shift;
    my $dsn = 'DBI:mysql:daily_report';
    my $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    my $yesterday = calcYesterday($reportDate);
    my $sql = "select symbol,portfolio,quantity,mark_price,mtm_pnl,mtm_pnl_week from position where position_date = \"" . $yesterday . "\"";
    my $sth = $dbh->prepare($sql);
    $sth->execute();
    print STDERR "Sql is $sql\n";   
    while (my @data = $sth->fetchrow_array()) {
        # Create a new position object and add it to the hash
         if (!exists $positionHash->{$data[0]}) {    # If you already have it you don't want to over-write it.
             my $position = new Position;
            $position->symbol($data[0]);    
            $position->portfolio($data[1]);
            $position->quantity($data[2]);
            $position->markPrice($data[3]);
            if (defined ($data[5])) {
                $position->mtmPnLWeek($data[5]);
            } else {
                $position->mtmPnLWeek($data[4]);
            }

            $position->mtmPnL(0);
            $positionHash->{$position->symbol} = $position;
        }
    }
     $dbh->disconnect;
    return;
}


sub getWeekBeginEquity {
    my $weekBeginDate = shift;
    my $dsn = 'DBI:mysql:daily_report';
    my $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    my $sql = "SELECT total_equity FROM report WHERE report_date in (select max(report_date) from report where report_date < \"$weekBeginDate\")";
    my $sth  = $dbh->prepare($sql);
    $sth->execute();
    my @results = $sth->fetchrow_array;
    my $beginingEquity;
    if (!defined($results[0])) {
        $beginingEquity = 0;
    } else {
       $beginingEquity = $results[0];
    }
    $sth->finish;
    #print STDERR "Sql is $sql\n";
    #print STDERR "starting Equity is $beginingEquity \n"; 
    $dbh->disconnect;
    return $beginingEquity;
}
################################  MAIN ###################################

my $mailfilename = ParseMail::getFileFromMail();

if ($mailfilename ne "") {
    $filename = $mailfilename;
} else {
    if ($#ARGV != -1) {
        $filename = shift @ARGV;
    } else {
        print "Please ensure the file named \"EOD (??).csv\" is located in \"$userprofile\\Google Drive\\AFT - Daily Report\\\".  Once the file is located there, enter the version number \n";
        print "If there is no version number, rename the file to conform to that format \n";
        print "Enter version number: ";
        my $filenumber = <STDIN>;
        chomp($filenumber);
        $filename =~ s/NN/$filenumber/;
    }
}
print STDERR "filename is $filename\n";
open(INPUTFILE, "<", $filename) or die "Could not open file";


while (my $row = <INPUTFILE>) {
    #print $row;
    $row =~ s/"//g;
    my @fields = split /,/ , $row;
    if ($fields[0] eq "BOF") {
        #print STDERR "begining of file\n";
    }
    if ($fields[0] eq "BOS") {
        # beginning of a section
        if ($fields[1] eq "EQUT") {
            # this is the begining of the Equity section
            readSection(\&processEquity, $dateHash);
        }    
        if ($fields[1] eq "MTMP") {
            readSection(\&processMarkToMarket,$positionHash);
            my $totalMTMPnL = 0;
            foreach my $symbol (keys %{$positionHash}) {
                $totalMTMPnL = sprintf("%0.2f",$totalMTMPnL + $positionHash->{$symbol}->mtmPnL());
            }
            #print STDERR "total MTM PnL is $totalMTMPnL \n";
        }
        if ($fields[1] eq "POST") {
            readSection(\&processPositions, $positionHash);
        }
        if ($fields[1] eq "TRNT") {
            readSection(\&processTrades,$positionHash);
            
        }
        if ($fields[1] eq "UNBC") {
            readSection(\&processCommissions,$positionHash);   
        }
    }
}
close INPUTFILE;

# Now you have the begining day of the week.
# first get the weekly change

$dateHash->{$reportDate}->weekBeginEquity(getWeekBeginEquity($weekBeginDate));
storeReport($dateHash);

assignPortfolio($positionHash);
getWeekMTM($positionHash,$reportDate);
getYesterdaysPositions($positionHash,$weekBeginDate,$reportDate);
storePositions($positionHash,$reportDate);

flush STDERR;
flush STDOUT;

print "Press ENTER to end\n";
my $dummy = <>;


