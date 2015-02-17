#!/usr/bin/perl -w
#use strict;
use DBI;

#my @productArray;
my %productFuHash;
my %productOpHash;
my %products;
my $dbh;

sub getProductSymbol {
    #my $currentLine = shift;
    #my $productDescr = $currentLine;
    #push @productArray, $productDescr;
    #return \@productArray;
    #}

    #sub translateToSymbol {
    
    my $productDesc = shift;
    my $type = shift;
    #$productDesc = uc $productDesc;
    if ($type eq "F") {
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /CAN/i) {
            return "XD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /JAPAN/i) {
            return "XJ";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /POUND/i) {
            return "XB";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /SWISS/i) {
            return "XS";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /AUST/i) {
            return "XAD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /AUST/i && $productDesc =~ /CROSS/i ) {
            return "EAD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /CAN/i && $productDesc =~ /CROSS/i ) {
            return "ECD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /NORWEG/i && $productDesc =~ /CROSS/i ) {
            return "ENK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /SWEDISH/i && $productDesc =~ /CROSS/i ) {
            return "ESK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i) {
            return "XT";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /CAN/i) {
            return "ECD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /AUST/i) {
            return "XAD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /POUND/i) {
            return "RP";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /JAPAN/i) {
            return "RY";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /SWISS/i) {
            return "RF";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /CZECH/i) {
            return "ECK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /HUNGAR/i) {
            return "EHF";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /NORWEG/) {
            return "ENK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /POLISH/i) {
            return "EPZ";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /SWEDISH/i) {
            return "ESK";
        }
         if ($productDesc =~ /TURKISH/i && $productDesc =~ /EURO/i) {
            return "TRE";
        }
        if ($productDesc =~ /CHINE/i && $productDesc =~ /EURO/i) {
            return "RME";
        }
        if ($productDesc =~ /AUST/i && $productDesc =~ /CAN/i) {
            return "ACD";
        }
        if ($productDesc =~ /AUST/i &&  $productDesc =~ /JAPAN/i) {
            return "AJY";
        }
        if ($productDesc =~ /AUST/i && $productDesc =~ /NEW/i) {
            return "ANE";
        }
        if ($productDesc =~ /CAN/i && $productDesc =~ /JAPAN/i) {
            return "CJY";
        }
        if ($productDesc =~ /KOREAN/i && $productDesc =~ /DOLLAR/i) {
            return "KRW";
        }
        if ($productDesc =~ /DOLLAR/i && $productDesc =~ /NORWEG/i) {
            return "NOK";
        }
        if ($productDesc =~ /CHINE/i && $productDesc =~ /DOLLAR/i) {
            return "RMB";
        }
        if ($productDesc =~ /DOLLAR/i && $productDesc =~ /SWEDISH/i) {
            return "SEK";
        }
        if ($productDesc =~ /POUND/i && $productDesc =~ /JAPAN/i) {
            return "PJY";
        }
        if ($productDesc =~ /SWISS/i && $productDesc =~ /JAPAN/i) {
            return "SJY";
        }
        if ($productDesc =~ /POUND/i && $productDesc =~ /SWISS/i) {
            return "PSF";
        }
        if ($productDesc =~ /POLISH/i && $productDesc =~ /EURO/i) {
            return "EPZ";
        }
        if ($productDesc =~ /Dollar/i && $productDesc =~ /Chile/i) {
            return "CHL";
        }
        if ($productDesc =~ /Standard-Size USD/i && $productDesc =~ /Offshore RMB/i) {
            return "CNH";
        }
        if ($productDesc =~ /Standard USD/i && $productDesc =~ /RMB Reminbi/i) {
            return "CNY";
        }
        if ($productDesc =~ /KRX USD/i && $productDesc =~ /KRW FX/i) {
            return "KUF";
        }
        if ($productDesc =~ /E-Micro AD/i) {
            return "M6A";
        }
        if ($productDesc =~ /E-Micro BP/i) {
            return "M6B";
        }
        if ($productDesc =~ /E-Micro CD/i) {
            return "M6C";
        }
        if ($productDesc =~ /E-Micro EC/i) {
            return "M6E";
        }
        if ($productDesc =~ /E-Micro JY/i) {
            return "M6J";
        }
        if ($productDesc =~ /E-Micro SF/i) {
            return "M6S";
        }
        if ($productDesc =~ /E-Micro CAD/i && $productDesc =~ /USD/i) {
            return "MCD";
        }
        if ($productDesc =~ /E-micro INR/i && $productDesc =~ /USD/i) {
            return "MIR";
        }
        if ($productDesc =~ /E-Micro JPY/i && $productDesc =~ /USD/i) {
            return "MJY";
        }
        if ($productDesc =~ /E-micro Size USD/i && $productDesc =~ /Offshore RMB/i) {
            return "MNH";
        }
        if ($productDesc =~ /E-Micro USD/i && $productDesc =~ /RMB Reminbi/i) {
            return "MNY";
        }
        if ($productDesc =~ /E-Micro CHF/i && $productDesc =~ /USD/i) {
            return "MSF";
        }
        if ($productDesc =~ /Aust/i && $productDesc =~ /U.S Dollar/i) {
            return "M6A";
        }
        if ($productDesc =~ /Euro/i && $productDesc =~ /U.S Dollar/i) {
            return "M6E";
        }
        if ($productDesc =~ /Japan/i && $productDesc =~ /U.S Dollar/i) {
            return "M6J";
        }
        if ($productDesc =~ /British/i && $productDesc =~ /U.S Dollar/i) {
            return "M6B";
        }
        if ($productDesc =~ /E-MINI/i && $productDesc =~ /JAPAN/i) {
            return "J7";
        }
        if ($productDesc =~ /South/i && $productDesc =~ /U.S. Dollar/i) {
            return "6Z";
        }
        if ($productDesc =~ /POUND/i || $productDesc =~ /BRITISH/i) {
            return "6B";
        }
        if ($productDesc =~ /JAPAN/i || $productDesc =~ /YEN/i) {
            return "6J";
        } 
        if ($productDesc =~ /E-MINI/i) {
            return "E7";
        }
        if ($productDesc =~ /SOUTH/i) {
            return "6Z";
        }
        if ($productDesc =~ /MEXICAN/i) {
            return "6M";
        }
        if ($productDesc =~ /EURO/i) {
            return "6E";
        }
        if ($productDesc =~ /CAN/i) {
            return "6C";
        }
        if ($productDesc =~ /AUST/i) {
            return "6A";
        }
        if ($productDesc =~ /NEW/i) {
            return "6N";
        }
        if ($productDesc =~ /SWISS/i) {
            return "6S";
        }
        if ($productDesc =~ /BRAZILIAN/i) {
            return "6L";
        }
        if ($productDesc =~ /CZECH/i) {
            return "CZK";
        }
        if ($productDesc =~ /HUNGARIAN/i) {
            return "HUF"; 
        }
        if ($productDesc =~ /ISRAELI/i) {
            return "ILS";   
        }
        if ($productDesc =~ /POLISH/i) {
            return "PLN"; 
        }
        if ($productDesc =~ /Turkish/i) {
            return "TRY"; 
        }
        if ($productDesc =~ /INR/i) {
            return "SIR"; 
        }
        if ($productDesc =~ /RUSSIAN/i) {
            return "6R"; 
        }
        if ($productDesc =~ /INDEX/i) {
            return "DX"; 
        }
    }
    elsif ($type eq "FOP"){
           if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /CAN/i) {
            return "XD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /JAPAN/i) {
            return "XJ";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /POUND/i) {
            return "XB";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /SWISS/i) {
            return "XS";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i && $productDesc =~ /AUST/i) {
            return "XAD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /AUST/i && $productDesc =~ /CROSS/i ) {
            return "EAD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /CAN/i && $productDesc =~ /CROSS/i ) {
            return "ECD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /NORWEG/i && $productDesc =~ /CROSS/i ) {
            return "ENK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /SWEDISH/i && $productDesc =~ /CROSS/i ) {
            return "ESK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /CZECH/i && $productDesc =~ /CROSS/i) {
            return "ECK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /STYLE/i) {
            return "XT";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /CAN/i) {
            return "ECD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /AUST/i) {
            return "XAD";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /POUND/i) {
            return "RP";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /JAPAN/i) {
            return "RY";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /SWISS/i) {
            return "RF";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /CZECH/i) {
            return "ECK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /HUNGAR/i) {
            return "EHU";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /NORWEG/) {
            return "ENK";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /POLISH/i) {
            return "EPZ";
        }
        if ($productDesc =~ /EURO/i && $productDesc =~ /SWEDISH/i) {
            return "ESK";
        }
         if ($productDesc =~ /TURKISH/i && $productDesc =~ /EURO/i) {
            return "TRE";
        }
        if ($productDesc =~ /CHINE/i && $productDesc =~ /EURO/i) {
            return "RME";
        }
        if ($productDesc =~ /AUST/i && $productDesc =~ /CAN/i) {
            return "ACD";
        }
        if ($productDesc =~ /AUST/i &&  $productDesc =~ /JAPAN/i) {
            return "AJY";
        }
        if ($productDesc =~ /AUST/i && $productDesc =~ /NEW/i) {
            return "ANE";
        }
        if ($productDesc =~ /CAN/i && $productDesc =~ /JAPAN/i) {
            return "CJY";
        }
        if ($productDesc =~ /KOREAN/i && $productDesc =~ /DOLLAR/i) {
            return "KRW";
        }
        if ($productDesc =~ /DOLLAR/i && $productDesc =~ /NORWEG/i) {
            return "NOK";
        }
        if ($productDesc =~ /CHINE/i && $productDesc =~ /DOLLAR/i) {
            return "RMB";
        }
        if ($productDesc =~ /DOLLAR/i && $productDesc =~ /SWEDISH/i) {
            return "SEK";
        }
        if ($productDesc =~ /POUND/i && $productDesc =~ /JAPAN/i) {
            return "PJY";
        }
        if ($productDesc =~ /SWISS/i && $productDesc =~ /JAPAN/i) {
            return "SJY";
        }
        if ($productDesc =~ /POUND/i && $productDesc =~ /SWISS/i) {
            return "PSF";
        }
        if ($productDesc =~ /POLISH/i && $productDesc =~ /EURO/i) {
            return "EPZ";
        }
        if ($productDesc =~ /Dollar/i && $productDesc =~ /Chile/i) {
            return "CHL";
        }
        if ($productDesc =~ /Standard-Size USD/i && $productDesc =~ /Offshore RMB/i) {
            return "CNH";
        }
        if ($productDesc =~ /Standard USD/i && $productDesc =~ /RMB Reminbi/i) {
            return "CNY";
        }
        if ($productDesc =~ /KRX USD/i && $productDesc =~ /KRW FX/i) {
            return "KUF";
        }
        if ($productDesc =~ /E-Micro AD/i) {
            return "M6A";
        }
        if ($productDesc =~ /E-Micro BP/i) {
            return "M6B";
        }
        if ($productDesc =~ /E-Micro CD/i) {
            return "M6C";
        }
        if ($productDesc =~ /E-Micro EC/i) {
            return "M6E";
        }
        if ($productDesc =~ /E-Micro JY/i) {
            return "M6J";
        }
        if ($productDesc =~ /E-Micro SF/i) {
            return "M6S";
        }
        if ($productDesc =~ /E-Micro CAD/i && $productDesc =~ /USD/i) {
            return "MCD";
        }
        if ($productDesc =~ /E-micro INR/i && $productDesc =~ /USD/i) {
            return "MIR";
        }
        if ($productDesc =~ /E-Micro JPY/i && $productDesc =~ /USD/i) {
            return "MJY";
        }
        if ($productDesc =~ /E-micro Size USD/i && $productDesc =~ /Offshore RMB/i) {
            return "MNH";
        }
        if ($productDesc =~ /E-Micro USD/i && $productDesc =~ /RMB Reminbi/i) {
            return "MNY";
        }
        if ($productDesc =~ /E-Micro CHF/i && $productDesc =~ /USD/i) {
            return "MSF";
        }
        if ($productDesc =~ /Aust/i && $productDesc =~ /U.S Dollar/i) {
            return "M6A";
        }
        if ($productDesc =~ /Euro/i && $productDesc =~ /U.S Dollar/i) {
            return "M6E";
        }
        if ($productDesc =~ /Japan/i && $productDesc =~ /U.S Dollar/i) {
            return "M6J";
        }
        if ($productDesc =~ /British/i && $productDesc =~ /U.S Dollar/i) {
            return "M6B";
        }
        if ($productDesc =~ /E-MINI/i && $productDesc =~ /JAPAN/i) {
            return "J7";
        }
        if ($productDesc =~ /South/i && $productDesc =~ /U.S. Dollar/i) {
            return "6Z";
        }
        if ($productDesc =~ /POUND/i || $productDesc =~ /BRITISH/i) {
            return "6B";
        }
        if ($productDesc =~ /JAPAN/i || $productDesc =~ /YEN/i) {
            return "6J";
        } 
        if ($productDesc =~ /E-MINI/i) {
            return "E7";
        }
        if ($productDesc =~ /SOUTH/i) {
            return "6Z";
        }
        if ($productDesc =~ /MEXICAN/i) {
            return "6M";
        }
        if ($productDesc =~ /EURO/i) {
            return "6E";
        }
        if ($productDesc =~ /CAN/i) {
            return "6C";
        }
        if ($productDesc =~ /AUST/i) {
            return "6A";
        }
        if ($productDesc =~ /NEW/i) {
            return "6N";
        }
        if ($productDesc =~ /SWISS/i) {
            return "6S";
        }
        if ($productDesc =~ /BRAZILIAN/i) {
            return "6L";
        }
        if ($productDesc =~ /CZECH/i) {
            return "CZK";
        }
        if ($productDesc =~ /HUNGARIAN/i) {
            return "HUF"; 
        }
        if ($productDesc =~ /ISRAELI/i) {
            return "ILS";   
        }
        if ($productDesc =~ /POLISH/i) {
            return "PLN"; 
        }
        if ($productDesc =~ /Turkish/i) {
            return "TRY"; 
        }
        if ($productDesc =~ /INR/i) {
            return "SIR"; 
        }
        if ($productDesc =~ /RUSSIAN/i) {
            return "6R"; 
        }
        if ($productDesc =~ /INDEX/i) {
            return "DX"; 
        }
    }
    die("could not symbol for product description: $productDesc\n");
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
    #my %productHash = shift;
    #foreach my $productDes (@$productArray) {
    #my $productDes = trim($productDes);
    #my $symbol = translateToSymbol($productDes);
    #my %productFuHash = shift;
    #my %productOpHash = shift;
    
    if (keys %productFuHash) {
        foreach my $key (keys %productFuHash )
        {
           my $productDes = $key;
           my $symbol = $productFuHash{$productDes};
           my $type = "F";
           
           print "product desc : $productDes, symbol : $symbol, type : $type\n";
           
           my $sql = "insert into product_symbolbase_mapping values (\"" .$productDes. "\",\"" .$symbol. "\",\"" .$type. "\") on duplicate key update symbol = values(symbol), type = values(type);";
           print "sql is " . $sql . "\n";
           my $sth = $dbh->prepare($sql);
           print STDERR "inserting rows\n";
           $sth->execute or warn "SQL Error: $DBI::errstr\n";
        }
    }    
    if (keys %productOpHash) {
        foreach my $key (keys %productOpHash )
        {
           my $productDes = $key;
           my $symbol = $productOpHash{$productDes};
           my $type = "FOP";
            
           print "product desc : $productDes, symbol : $symbol, type : $type\n";
            
           my $sql = "insert into product_symbolbase_mapping values (\"" .$productDes. "\",\"" .$symbol. "\",\"" .$type. "\") on duplicate key update symbol = values(symbol), type = values(type);";
           print "sql is " . $sql . "\n";
           my $sth = $dbh->prepare($sql);
           print STDERR "inserting rows\n";
           $sth->execute or warn "SQL Error: $DBI::errstr\n";
        }
    }
}

####################  MAIN  #################
    #my $inputFilename = "settle.csv";
    my $inputFilename = "data_12022015.txt";
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
       #elsif (length $_ < 86 && $_ !~ /TOTAL/) {
       #     my $currentLine = $_;
         #   %productHash = getProductInfo($currentLine);
        #}
        else {
            if ($_ =~ /FU/i || $_ =~ /Variance/i || $_ =~ /CROSSRATE/i){
                my $productDes = $_;
                $productDes = trim($productDes);
                my $symbolBase = getProductSymbol($productDes, "F");
                $productFuHash{$productDes} = $symbolBase;
            }
            elsif ($_ =~ /PUT/i || $_ =~ /CALL/i) {
                my $productDes = $_;
                $productDes = trim($productDes);
                my $symbolBase = getProductSymbol($productDes, "FOP");
                $productOpHash{$productDes} = $symbolBase;
            }
        }
    }

connectToDB();
storeProducts(%productFuHash, %productOpHash);
disconnectFromDB();
%productOpHash ={};
%productFuHash = {};