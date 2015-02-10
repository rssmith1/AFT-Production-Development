#!/usr/bin/perl -w
use strict;
use DBI;

use CMESymbol;

my @symbolArray;
my $dbh;

my @monthyearValues = qw{JAN15 FEB15 MAR15 APR15 MAY15 JUN15 JUL15 AUG15 SEP15 OCT15 NOV15 DEC15 JAN16 FEB16 MAR16 APR16 MAY16 JUN16 JUL16 AUG16 SEP16 OCT16 NOV16 DEC16 JAN17 FEB17 MAR17 APR17 MAY17 JUN17 JUL17 AUG17 SEP17 OCT17 NOV17 DEC17 JAN18 FEB18 MAR18 APR18 MAY18 JUN18 JUL18 AUG18 SEP18 OCT18 NOV18 DEC18 JAN19 FEB19 MAR19 APR19 MAY19 JUN19 JUL19 AUG19 SEP19 OCT19 NOV19 DEC19 JAN20 FEB20 MAR20 APR20 MAY20 JUN20 JUL20 AUG20 SEP20 OCT20 NOV20 DEC20 JAN21 FEB21 MAR21 APR21 MAY21 JUN21 JUL21 AUG21 SEP21 OCT21 NOV21 DEC21 JAN22 FEB22 MAR22 APR22 MAY22 JUN22 JUL22 AUG22 SEP22 OCT22 NOV22 DEC22 JAN23 FEB23 MAR23 APR23 MAY23 JUN23 JUL23 AUG23 SEP23 OCT23 NOV23 DEC23 JAN24 FEB24 MAR24 APR24 MAY24 JUN24 JUL24 AUG24 SEP24 OCT24 NOV24 DEC24 JAN25 FEB25 MAR25 APR25 MAY25 JUN25 JUL25 AUG25 SEP25 OCT25 NOV25 DEC25 JAN26 FEB26 MAR26 APR26 MAY26 JUN26 JUL26 AUG26 SEP26 OCT26 NOV26 DEC26 JAN27 FEB27 MAR27 APR27 MAY27 JUN27 JUL27 AUG27 SEP27 OCT27 NOV27 DEC27 JAN28 FEB28 MAR28 APR28 MAY28 JUN28 JUL28 AUG28 SEP28 OCT28 NOV28 DEC28 JAN29 FEB29 MAR29 APR29 MAY29 JUN29 JUL29 AUG29 SEP29 OCT29 NOV29 DEC29 JAN30 FEB30 MAR30 APR30 MAY30 JUN30 JUL30 AUG30 SEP30 OCT30 NOV30 DEC30};
my $OptionsCall = 0;

sub getFutures {
    my $productDesc = shift;
    $productDesc = trim($productDesc);
      
    my $symbolBase;
    $symbolBase = getSymbolBase($productDesc);
  
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
        elsif ($currentLine =~ /FU/i || $currentLine =~ /Variance/i || $currentLine =~ /CROSSRATE/i){
            $done = 1;
            $OptionsCall = 1;
        }
        elsif ($currentLine =~ /CALL/i || $currentLine =~ /PUT/i){
            $done = 1;
            $OptionsCall = 1;
        }
        else {
            my $monthyearValue = substr($_, 0, 5);  
            my $month = "";
            my $year = "";
            my $monthChar = "";
            
            if ($monthyearValue) {
                $month = substr($monthyearValue, 0, 3);
                $year = substr($monthyearValue, -2);
            }
            
            if(defined $month){
                $monthChar = getMonthCodes($month);
            }
        
            my $yearChar;
            if ($year =~ /1/) {
                $yearChar = substr($year, 1);
            }
            else{
                $yearChar = $year;
            }
    
            my $symbolValues = CMESymbol -> symbolValues($symbolBase, "F", $productDesc, $monthyearValue, $monthChar, $yearChar);        
            push @symbolArray, $symbolValues;
        }
    }
    return \@symbolArray;
}

sub getOptions {
    my $productDesc = shift;
    $productDesc = trim($productDesc);
      
    my $symbolBase;
    $symbolBase = getSymbolBase($productDesc);
  
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
    
    if(defined $month){
        $monthChar = getMonthCodes($month);
    }

    my $yearChar;
    if ($year =~ /1/) {
        $yearChar = substr($year, 1);
    }
    else{
        $yearChar = $year;
    }

    my $strikeType;
    if($productDesc =~ /CALL/){
        $strikeType = "CALL";
    }
    else{
        $strikeType = "PUT";
    }
    
    my $week = "";
    if ($strikeType eq "PUT"){
        $week = betweenPut($productDesc);
    }
    elsif ($strikeType eq "CALL"){
        $week = betweenCall($productDesc);
    }

    $week =~ s/\D//g;
    
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
        elsif($currentLine =~ /PUT/i || $currentLine =~ /CALL/i) {
            $done = 1;
            $OptionsCall = 1;
        }
        else {
            my $symbolValues = CMESymbol -> symbolValues($symbolBase, "FOP", $productDesc, $monthyearValue, $monthChar, $yearChar, $_, $week, $strikeType);        
            push @symbolArray, $symbolValues;
        }
    }
    return \@symbolArray;
}

sub trim {
   return $_[0] =~ s/^\s+|\s+$//rg;
}

sub betweenPut {
    my $text = shift;
    if ($text =~ /WEEKLY(.*?)PUT/i || $text =~ /WKLY(.*?)PUT/i || $text =~ /Wk(.*?)PUT/i) {
        my $result = $1;
        return $result;
    } else {
        return "";
    }
}

sub betweenCall {
    my $text = shift;
    if ($text =~ /WEEKLY(.*?)CALL/i || $text =~ /WKLY(.*?)CALL/i || $text =~ /Wk(.*?)CALL/i) {
        my $result = $1;
        return $result;
    } else {
        return "";
    }
}

sub connectToDB { 
    my $dsn = 'DBI:mysql:daily_report;host=AFT-INT-1;port=3306';
    $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    return;
}

sub disconnectFromDB {
    $dbh->disconnect;
}

sub storeSymbols {
    my $symbolListArray = shift;
     foreach my $symbol (@$symbolListArray) {
        my $sql = "insert into symbols values (\"".$symbol->{productDescription} . "\",\"" . $symbol->{symbol} . "\",\"" . $symbol->{monthyear} . "\",\"" . $symbol->{type} . "\",\"" .  $symbol->{strikeType} . "\","  .  $symbol->{strikeValue} . "," .  $symbol->{week} . ");";
        print "sql is " . $sql . "\n";
        my $sth = $dbh->prepare($sql);
        print STDERR "inserting rows\n";
        $sth->execute or warn "SQL Error: $DBI::errstr\n";   
     }
}

sub getSymbolBase {
    my $productDesc = shift;
    connectToDB();
    my $sql = "SELECT symbol FROM product_symbolbase_mapping WHERE product_description = \"$productDesc\";";
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

sub getMonthCodes {
    my $month = shift;
    my $sql = "SELECT month_code FROM month_codes WHERE month = \"$month\";";
    my $sth  = $dbh->prepare($sql);
    $sth->execute();
    my @results = $sth->fetchrow_array;
    my $symbol;
    if (defined($results[0])) {
        $symbol = $results[0];
    }
    $sth->finish;
    return $symbol;
}

####################  MAIN  #################
    my $inputFilename = "data_06022015.txt";
    open(INPUTFILE, "<$inputFilename") or die "could not open file $inputFilename";
    my $firstLine = 0;
        
    my $symbolArray;    
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
            if ($_ =~ /PUT/i || $_ =~ /CALL/i) {
                my $currentLine = $_;
                $symbolArray = getOptions($currentLine);
            }
           elsif ($_ =~ /FU/i || $_ =~ /Variance/i || $_ =~ /CROSSRATE/i){
                my $currentLine = $_;
                $symbolArray = getFutures($currentLine);
            }
        }
    }
    
connectToDB();
storeSymbols($symbolArray);
disconnectFromDB();