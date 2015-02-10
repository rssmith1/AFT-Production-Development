#!/usr/bin/perl -w
#use strict;
use DBI;

my @productArray;
my $dbh;

sub getProductInfo {
    my $currentLine = shift;
    my $productDescr = $currentLine;
    push @productArray, $productDescr;
    return \@productArray;
}

sub translateToSymbol {
    my $productDesc = shift;
    #$productDesc = uc $productDesc;
    if ($productDesc =~ /EURO/ && $productDesc =~ /CAN/) {
        return "ECD";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /AUST/) {
        return "EAD";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /JAPAN/) {
        return "RY";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /POUND/) {
        return "RP";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /AUST/) {
        return "EAD";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /SWISS/) {
        return "RF";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /CZECH/) {
        return "ECK";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /HUNGAR/) {
        return "EHU";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /NORWEG/) {
        return "ENK";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /POLISH/) {
        return "EPZ";
    }
    if ($productDesc =~ /EURO/ && $productDesc =~ /SWEDISH/) {
        return "EPZ";
    }
     if ($productDesc =~ /TURKISH/ && $productDesc =~ /EURO/) {
        return "TRE";
    }
    if ($productDesc =~ /CHINE/ && $productDesc =~ /EURO/) {
        return "RME";
    }
    if ($productDesc =~ /AUST/ && $productDesc =~ /CAN/) {
        return "ACD";
    }
    if ($productDesc =~ /AUST/ &&  $productDesc =~ /JAPAN/) {
        return "AJY";
    }
    if ($productDesc =~ /AUST/ && $productDesc =~ /NEW/) {
        return "ANE";
    }
    if ($productDesc =~ /CAN/ && $productDesc =~ /JAPAN/) {
        return "CJY";
    }
    if ($productDesc =~ /KOREAN/ && $productDesc =~ /DOLLAR/) {
        return "KRW";
    }
    if ($productDesc =~ /DOLLAR/ && $productDesc =~ /NORWEG/) {
        return "NOK";
    }
    if ($productDesc =~ /CHINE/ && $productDesc =~ /DOLLAR/) {
        return "RMB";
    }
    if ($productDesc =~ /DOLLAR/ && $productDesc =~ /SWEDISH/) {
        return "SEK";
    }
    if ($productDesc =~ /POUND/ && $productDesc =~ /JAPAN/) {
        return "PJY";
    }
    if ($productDesc =~ /SWISS/ && $productDesc =~ /JAPAN/) {
        return "SJY";
    }
    if ($productDesc =~ /POUND/ && $productDesc =~ /SWISS/) {
        return "PSF";
    }
    if ($productDesc =~ /POLISH/ && $productDesc =~ /EURO/) {
        return "EPZ";
    }
    if ($productDesc =~ /Dollar/ && $productDesc =~ /Chile/) {
        return "CHL";
    }
    if ($productDesc =~ /Standard-Size USD/ && $productDesc =~ /Offshore RMB/) {
        return "CNH";
    }
    if ($productDesc =~ /Standard USD/ && $productDesc =~ /RMB Reminbi/) {
        return "CNY";
    }
    if ($productDesc =~ /KRX USD/ && $productDesc =~ /KRW FX/) {
        return "KUF";
    }
    if ($productDesc =~ /E-Micro AD/) {
        return "M6A";
    }
    if ($productDesc =~ /E-Micro BP/) {
        return "M6B";
    }
    if ($productDesc =~ /E-Micro CD/) {
        return "M6C";
    }
    if ($productDesc =~ /E-Micro EC/) {
        return "M6E";
    }
    if ($productDesc =~ /E-Micro JY/) {
        return "M6J";
    }
    if ($productDesc =~ /E-Micro SF/) {
        return "M6S";
    }
    if ($productDesc =~ /E-Micro CAD/ && $productDesc =~ /USD/) {
        return "MCD";
    }
    if ($productDesc =~ /E-micro INR/ && $productDesc =~ /USD/) {
        return "MIR";
    }
    if ($productDesc =~ /E-Micro JPY/ && $productDesc =~ /USD/) {
        return "MJY";
    }
    if ($productDesc =~ /E-micro Size USD/ && $productDesc =~ /Offshore RMB/) {
        return "MNH";
    }
    if ($productDesc =~ /E-Micro USD/ && $productDesc =~ /RMB Reminbi/) {
        return "MNY";
    }
    if ($productDesc =~ /E-Micro CHF/ && $productDesc =~ /USD/) {
        return "MSF";
    }
    if ($productDesc =~ /Aust/ && $productDesc =~ /U.S Dollar/) {
        return "M6A";
    }
    if ($productDesc =~ /Euro/ && $productDesc =~ /U.S Dollar/) {
        return "M6E";
    }
    if ($productDesc =~ /Japan/ && $productDesc =~ /U.S Dollar/) {
        return "MJY";
    }
    if ($productDesc =~ /British/ && $productDesc =~ /U.S Dollar/) {
        return "M6B";
    }
     if ($productDesc =~ /South/ && $productDesc =~ /U.S. Dollar/) {
        return "6Z";
    }
    if ($productDesc =~ /POUND/ || $productDesc =~ /BRITISH/) {
        return "6B";
    }
    if ($productDesc =~ /JAPAN/ || $productDesc =~ /YEN/) {
        return "6J";
    }
    if ($productDesc =~ /EURO/) {
        return "6E";
    }
    if ($productDesc =~ /CAN/) {
        return "6C";
    }
    if ($productDesc =~ /AUST/) {
        return "6A";
    }
    if ($productDesc =~ /NEW/) {
        return "6N";
    }
    if ($productDesc =~ /SWISS/) {
        return "6S";
    }
    if ($productDesc =~ /BRAZILIAN/) {
        return "6L";
    }
    if ($productDesc =~ /CZECH/) {
        return "CZK";
    }
    if ($productDesc =~ /HUNGARIAN/) {
        return "EHF"; 
    }
    if ($productDesc =~ /ISRAELI/) {
        return "ILS";   
    }
    if ($productDesc =~ /POLISH/) {
        return "PLN"; 
    }
    if ($productDesc =~ /Turkish/) {
        return "TRY"; 
    }
    if ($productDesc =~ /INR/) {
        return "SIR"; 
    }
    if ($productDesc =~ /RUSSIAN/) {
        return "6R"; 
    }
    if ($productDesc =~ /INDEX/) {
        return "DX"; 
    }
    
    print "could not parse product description $productDesc\n";
    return undef;
}

sub connectToDB { 
    my $dsn = 'DBI:mysql:daily_report;host=AFT-INT-1;port=3306';
    $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    return;
}

sub disconnectFromDB {
    $dbh->disconnect;
}

sub trim {
   return $_[0] =~ s/^\s+|\s+$//rg;
}

sub storeProducts {
    my @productArray = shift;
    foreach my $productDes (@$productArray) {
    my $productDes = trim($productDes);
    my $symbol = translateToSymbol($productDes);
    my $sql = "insert into product_symbol_mapping values (\"" .$productDes. "\",\"" .$symbol. "\") on duplicate key update symbol = values(symbol);";
        print "sql is " . $sql . "\n";
        my $sth = $dbh->prepare($sql);
        print STDERR "inserting rows\n";
        $sth->execute or warn "SQL Error: $DBI::errstr\n";
    }
}

####################  MAIN  #################
    #my $inputFilename = "settle.csv";
    my $inputFilename = "data_23012015.txt";
    open(INPUTFILE, "<$inputFilename") or die "could not open file $inputFilename";
    my $firstLine = 0;
  
    my $done = 0;
    $_ = <INPUTFILE>;
     while (!$done) {
        $_ = <INPUTFILE>;
        if ($_ =~ /END/) {
            $done = 1;
        }
       # elsif ($_ =~ /DOLLAR/ || /EURO/ || /SWISS/ || /POUND/ || /YEN/ || /FUTURE/ || /PUT/ || /CALL/) {
       elsif (length $_ < 86 && $_ !~ /TOTAL/) {
            my $currentLine = $_;
            $productArray = getProductInfo($currentLine);
        }
    }

connectToDB();
storeProducts($productArray);
disconnectFromDB();
$productArray = {};