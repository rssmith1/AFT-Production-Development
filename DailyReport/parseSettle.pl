#!/usr/bin/perl -w
use strict;
use DBI;

use CMESettlement;

my @settleArray;
my $dbh;

my %symbolsHash;
my %monthHash;

my $date;

my @monthyearValues = qw{JAN15 FEB15 MAR15 APR15 MAY15 JUN15 JUL15 AUG15 SEP15 OCT15 NOV15 DEC15 JAN16 FEB16 MAR16 APR16 MAY16 JUN16 JUL16 AUG16 SEP16 OCT16 NOV16 DEC16 JAN17 FEB17 MAR17 APR17 MAY17 JUN17 JUL17 AUG17 SEP17 OCT17 NOV17 DEC17 JAN18 FEB18 MAR18 APR18 MAY18 JUN18 JUL18 AUG18 SEP18 OCT18 NOV18 DEC18 JAN19 FEB19 MAR19 APR19 MAY19 JUN19 JUL19 AUG19 SEP19 OCT19 NOV19 DEC19 JAN20 FEB20 MAR20 APR20 MAY20 JUN20 JUL20 AUG20 SEP20 OCT20 NOV20 DEC20 JAN21 FEB21 MAR21 APR21 MAY21 JUN21 JUL21 AUG21 SEP21 OCT21 NOV21 DEC21 JAN22 FEB22 MAR22 APR22 MAY22 JUN22 JUL22 AUG22 SEP22 OCT22 NOV22 DEC22 JAN23 FEB23 MAR23 APR23 MAY23 JUN23 JUL23 AUG23 SEP23 OCT23 NOV23 DEC23 JAN24 FEB24 MAR24 APR24 MAY24 JUN24 JUL24 AUG24 SEP24 OCT24 NOV24 DEC24 JAN25 FEB25 MAR25 APR25 MAY25 JUN25 JUL25 AUG25 SEP25 OCT25 NOV25 DEC25 JAN26 FEB26 MAR26 APR26 MAY26 JUN26 JUL26 AUG26 SEP26 OCT26 NOV26 DEC26 JAN27 FEB27 MAR27 APR27 MAY27 JUN27 JUL27 AUG27 SEP27 OCT27 NOV27 DEC27 JAN28 FEB28 MAR28 APR28 MAY28 JUN28 JUL28 AUG28 SEP28 OCT28 NOV28 DEC28 JAN29 FEB29 MAR29 APR29 MAY29 JUN29 JUL29 AUG29 SEP29 OCT29 NOV29 DEC29 JAN30 FEB30 MAR30 APR30 MAY30 JUN30 JUL30 AUG30 SEP30 OCT30 NOV30 DEC30};
my $OptionsCall = 0;

sub getFutures {
    my $productDesc = shift;
    $productDesc = trim($productDesc);
    
    my $type = "F";
    
    if (!exists $symbolsHash{$productDesc} ) {
        %symbolsHash = getSymbolBase ($type);
    }
    my $symbol = $symbolsHash{$productDesc};
    
    my $firstTotalLine = 0;
    my $done = 0;
    while (!$done) {
        $_ = <INPUTFILE>;
        my $currentLine = $_; 
        if ($currentLine =~ /TOTAL/) {
            if ($firstTotalLine == 1) {
                $done = 1;
            } else {
                $firstTotalLine = 1;
            }
        }
        elsif ($currentLine =~ /FU/i || /Variance/i){
            $done = 1;
            $OptionsCall = 1;
        }
        elsif ($currentLine =~ /CALL/i || /PUT/i){
            $done = 1;
            $OptionsCall = 1;
        }
        else {               
            my $cmeSettle = CMESettlement->newFromString($symbol, $productDesc, "2015-01-28", $type, $_, %monthHash);        
            push @settleArray, $cmeSettle;
        }
    }
    return \@settleArray;
}

sub getOptions {
    my $productDesc = shift;
    $productDesc = trim($productDesc);
      
     my $type = "FOP";
    
    if (!exists $symbolsHash{$productDesc} ) {
        %symbolsHash = getSymbolBase ($type);
    }
    my $symbol = $symbolsHash{$productDesc};
    
    my $monthyearValue;
    foreach my $monthyear (@monthyearValues) {
        $monthyearValue = $monthyear;
        last if ($productDesc =~ /$monthyearValue/i);
    }
    
    my $month = "";
    my $year = "";
    my $monthChar = "";
    if ($monthyearValue) {
        $month = substr($monthyearValue, 0, 3);
        $year = substr($monthyearValue, -2);
    }
    
    my $firstTotalLine = 0;
    my $done = 0;
    while (!$done) {
         $_ = <INPUTFILE>;
        my $currentLine = $_;
        if ($currentLine =~ /TOTAL/) {
            if ($firstTotalLine == 1) {
                $done = 1;
            } else {
                $firstTotalLine = 1;
            }
        }
        elsif($currentLine =~ /PUT/i || /CALL/i) {
            $done = 1;
            $OptionsCall = 1;
        }
        else {
            my $cmeSettle = CMESettlement->newFromString($productDesc, "2015-01-28", $type, $_, %monthHash);        
            push @settleArray, $cmeSettle;
        }
    }
    return \@settleArray;
}

sub trim {
   return $_[0] =~ s/^\s+|\s+$//rg;
}

sub connectToDB { 
    my $dsn = 'DBI:mysql:daily_report;host=AFT-INT-1;port=3306';
    $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    return;
}

sub disconnectFromDB {
    $dbh->disconnect;
}

sub getSymbolBase {
    #my $productDesc = shift;
    my $type = shift;
    my $sql = "SELECT product_description, symbol FROM product_symbolbase_mapping WHERE type = \"$type\";";
    # prepare your statement for connecting to the database
    my $sth  = $dbh->prepare($sql);
    $sth->execute();
    my $productDesc;
    my $symbol;
    my @data;
    my %symbols;
    if ($sth) {
    while (@data = $sth->fetchrow_array()) {
        if (defined ($data[0])) {
               $productDesc = $data[0];
            }
            if (defined ($data[1])) {
               $symbol = $data[1];
            }
            $symbols{$productDesc} = $symbol;
        }
    }
    else{
        die "Error: Can't get symbol for product_description!: $!";
    }
    $sth->finish;
    return %symbols;
}

sub getMonthCodes {
    connectToDB();
    my $sql = "SELECT month, month_code FROM month_codes;";
    my $sth  = $dbh->prepare($sql);
    $sth->execute();
    my @results = $sth->fetchrow_array;
    my $month;
    my $monthCode;
    my @data;
    my %monthCodes;
   if ($sth) {
    while (@data = $sth->fetchrow_array()) {
        if (defined ($data[0])) {
               $month = $data[0];
            }
            if (defined ($data[1])) {
               $monthCode = $data[1];
            }
            $monthCodes{$month} = $monthCode;
        }
    }
    else{
        die "Error: Can't get symbol for product_description!: $!";
    }
    $sth->finish;
    return %monthCodes;
}

sub getSymbolFuture {
    my $productDesc = shift;
    my $monthyear = shift;
    connectToDB();
    my $sql = "SELECT symbol FROM symbols WHERE product_description = \"$productDesc\", and monthyear = \"$monthyear\";";
    my $sth  = $dbh->prepare($sql);
    $sth->execute();
    my @results = $sth->fetchrow_array;
    my $symbol;
    if (defined($results[0])) {
        $symbol = $results[0];
    }
    else{
       die "Error: Can't get symbol for product_description!: $!";
    }
    $sth->finish;
    return $symbol;
}

sub getSymbolOption {
    my $productDesc = shift;
    my $strikeValue = shift;
    #connectToDB();
    my $sql = "SELECT symbol FROM symbols WHERE product_description = \"$productDesc\", and strike_value = $strikeValue ;";
    my $sth  = $dbh->prepare($sql);
    $sth->execute();
    my @results = $sth->fetchrow_array;
    my $symbol;
    if (defined($results[0])) {
        $symbol = $results[0];
    }
    else{
       die "Error: Can't get symbol for product_description!: $!";
    }
    $sth->finish;
    return $symbol;
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
    #my $inputFilename = "settle.csv";
    my $inputFilename = "data_06022015.txt";
    open(INPUTFILE, "<$inputFilename") or die "could not open file $inputFilename";
    my $firstLine = 0;
    
    #if ($date =~ /WEEKLY(.*?)PUT/i || $date =~ /WKLY(.*?)PUT/i || $date =~ /Wk(.*?)PUT/i) {
      #  $date = $1;
    #}

    my $settleArray;    
    my $done = 0;
    while (!$done) {
        if (!$OptionsCall) {
            $_ = <INPUTFILE>;
        }
        else{
            $OptionsCall = 0;
        }
        
        if ($_ =~ /END/) {
            $done = 1;
        }
        else {
            if (!keys %monthHash) {
                %monthHash = getMonthCodes ();
            }
                
            if ($_ =~ /FU/i || $_ =~ /Variance/i || $_ =~ /CROSSRATE/i){
                my $currentLine = $_;
                $settleArray = getFutures($currentLine);
            }elsif ($_ =~ /PUT/i || $_ =~ /CALL/i) {
                my $currentLine = $_;
                $settleArray = getOptions($currentLine);
            }
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

