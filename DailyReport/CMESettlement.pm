package CMESettlement;
use strict;
use warnings;


my $longTemplate =  "A5x3A7x3A7x3A7x3A7x3A7x2A6x5A7x4A7x6A6A*";
my $template =      "A5x3A7x3A7x3A7x3A7x3A7x2A6x5A7x4A7x6A*";
my $shortTemplate = "A5x3A7x3A7x3A7x3A7x3A7x2A6x5A7x4A*";
my @fieldNames = qw(monthyear open high low last settle change vol psettle pvol oi);

#A5       A6        A7        A7        A6        A6      A6         A7          A6           A7     A*
#JUN15     .7854     .7948B    .7815      ----     .7882  +.0016        1188      .7866         242         683
#10000      ----      ----      ----      ----       CAB    UNCH                    CAB

# this prgram needs to parse the settlement numbers from the CME download and also turn the contract labels into the same one used by IB
#             maturity  open      high      low       last     settle  change      vol
              #0         1          2        3         4         5         6         7         8         9         0    
              #01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
#DEC14....1.5911....1.5937 ...1.5771 ...1.5819....1.5777..-.0105..... 141612.....1.5882.......72579      149429";
#MAR15   .161700   .161700   .161700   .161700   .161860     -80           2    .161940           6         176
#MAR15   .161700   .161700   .161700   .161700   .161860     -80           2    .161940           6         176

#10000      ----      ----      ----      ----       CAB    UNCH                    CAB
#my $string2 = "MAR15    1.5900    1.5922B...1.5761A...  ----....1.5765..-.0104.....    416     1.5869         160        2075";
#JUN15    1.5807    1.5901B   1.5751A     ----    1.5752..-.0102           1     1.5854                     112
#SEP15      ----    1.5847B   1.5753A     ----    1.5740..-.0100                 1.5840                      29

#1   2   3  4    5

#doUnpack($string1,"String1",\@fieldNames);
#doUnpack($string2,"String2",\@fieldNames);


my %actions;

my $dbh;
use DBI;

sub new {
    my $class = shift;
    my $self = bless {}, $class;    
    $self->{_pVol} = 0;
    $self->{_vol} = 0;
    $self->{_oi} = 0;
    return $self;
}


sub newFromString {
    my $class = shift;
    my $self = $class->new();
    my $productDescription = shift;
    $self->productDescription ($productDescription);
  
    $self->{_settlementDate} = shift;
    my $type = shift;
    $self->type ($type);
    my $line = shift;
    
    my $symbol;
    my @fields;
    if (length $line == 111) {
       @fields = unpack($longTemplate, $line);  
    }elsif (length $line == 87 ) {
       @fields = unpack($shortTemplate,$line); 
    }elsif (length $line == 99 ) {
       @fields = unpack($template,$line); 
    }
    
    my $strikeValue;
    if ($type eq "F") {
        my $monthyear = $fields[0];
        #$self->year($fields[1]);
        $symbol = getSymbolFuture($productDescription, $monthyear);
    }
    elsif ($type eq "FOP") {
        $strikeValue = $fields[0];
        #$self->strikeValue = $strikeValue
        #$self->year($fields[1]);
        $symbol = getSymbolOption($productDescription, $strikeValue);
    }
   
    $self->open ($fields[1]);
    $self->high ($fields[2]);
    $self->low ($fields[3]);
    $self->last ($fields[4]);
    $self->settle ($fields[5]);
    $self->change ($fields[6]);
    if (defined($fields[7])) {$self->vol ($fields[7])};
    if (defined($fields[8]))  {$self->pSettle ($fields[8])};
    if (defined($fields[9])) {$self->pVol ($fields[9])};
    if (defined($fields[10])) {$self->oi ($fields[10])};
    $self->symbol($symbol);
    $self->{_highSide} = " ";
    $self->{_lowSide} = " ";
    return $self
}

sub getSymbolFuture {
    my $productDesc = shift;
    my $monthyear = shift;
    connectToDB();
    my $sql = "SELECT symbol FROM symbols WHERE product_description = \"$productDesc\" and monthyear = \"$monthyear\";";
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
    my $sql = "SELECT symbol FROM symbols WHERE product_description = \"$productDesc\" and strike_value = $strikeValue ;";
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


sub connectToDB { 
    my $dsn = 'DBI:mysql:daily_report;host=AFT-INT-1;port=3306';
    $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    return;
}

sub disconnectFromDB {
    $dbh->disconnect;
}


sub _translateMonth {
    my $self = shift;
    my $month = shift;
    #print "in translate month - month is $month\n";
    if ($month eq "JAN") {
        return "F";
    }
    if ($month eq "FEB") {
        return "G";
    }
     if ($month eq "MAR") {
        return "H";
    }
     if ($month eq "APR") {
        return "J";
    }
     if ($month eq "MAY") {
        return "K";
    }
     if ($month eq "JUN") {
        return "M";
    }
     if ($month eq "JUL") {
        return "N";
    }
     if ($month eq "AUG") {
        return "Q";
    }
     if ($month eq "SEP") {
        return "U";
    }
     if ($month eq "OCT") {
        return "V";
    }
     if ($month eq "NOV") {
        return "X";
    }
     if ($month eq "DEC") {
        return "Z";
    }
    print "could not parse month code $month\n";
    return undef;
}

sub type {
    my $self = shift;
    if (@_) {
        $self->{_type} = shift;
    }
    return $self->{_type};
}

sub productDescription {
    my $self = shift;
    if (@_) {
        $self->{_productDescription} = shift;
    }
    return $self->{_productDescription};
}

sub strikeValue {
    my $self = shift;
    if (@_) {
        $self->{_strikeValue} = shift;
    }
    return $self->{_strikeValue};
}

sub month {
    my $self = shift;
    if (@_) {
        $self->{_month} = shift;
    }
    return $self->{_month};
}
sub year {
    my $self = shift;
    if (@_) {
        $self->{_year} = shift;
    }
    return $self->{_year};
}


sub symbol {
    my $self = shift;
    if (@_) {
        $self->{_symbol} = shift;
    }
    return $self->{_symbol};
}

sub settlementDate {
    my $self = shift;
    if (@_) {
        $self->{_settlementDate} = shift;
    }
    return $self->{_settlementDate};
}

sub open {
    my $self = shift;
    if (@_) {
        $self->{_open} = shift;
        if ($self->{_open} eq "   ----") {
            $self->{_open} = "NULL";
        }
    }
    return $self->{_open};
}

sub high {
    my $self = shift;
    if (@_) {
        $self->{_high} = shift;
        if ($self->{_high} eq "   ----") {
            $self->{_high} = "NULL";
        }
        my $side;
        $side = substr($self->{_high},-1);
        if (($side eq "A" ) or ($side eq "B")) {
            chop($self->{_high});
        } else {
            $side = " ";
        }
        $self->highSide($side);
    }
    return $self->{_high};
}


sub highSide {
    my $self = shift;
    if (@_) {
        $self->{_highSide} = shift;
        if ( ($self->{_highSide} ne "A" ) and ($self->{_highSide} ne "B") and ($self->{_highSide} ne " ") ) {
            print "got bad high side:" .  $self->{_highSide} . "\n";
            $self->{_highSide} = " ";
        }
    }
    return $self->{_highSide};
}

sub low {
    my $self = shift;
    if (@_) {
        $self->{_low} = shift;
        if ($self->{_low} eq "   ----") {
            $self->{_low} = "NULL";
        }
        my $side = substr($self->{_low},-1);
        if (($side eq "A" ) or ($side eq "B")) {
            chop($self->{_low});
        } else {
            $side = " ";
        }
        $self->lowSide($side);

    }
    return $self->{_low};
}

sub lowSide {
    my $self = shift;
    if (@_) {
        $self->{_lowSide} = shift;
    }
    return $self->{_lowSide};
}

sub last {
    my $self = shift;
    if (@_) {
        $self->{_last} = shift;
         if ($self->{_last} eq "   ----") {
            $self->{_last} = "NULL";
        }
   }
    return $self->{_last};
}

sub settle {
    my $self = shift;
    if (@_) {
        $self->{_settle} = shift;
        if ($self->{_settle} eq "    CAB") {
            $self->{_settle} = 0;
        }
    }
    return $self->{_settle};
}

sub change {
    my $self = shift;
    if (@_) {
        $self->{_change} = shift;
        if ($self->{_change} eq "  UNCH") {
            $self->{_change} = 0;
        }
    }
    return $self->{_change};
}

sub vol {
    my $self = shift;
    if (@_) {
        $self->{_vol} = shift;
    }
    if ($self->{_vol} eq "") {
        return "NULL";
    }
    
    return $self->{_vol};
}

sub pSettle {
    my $self = shift;
    if (@_) {
        $self->{_pSettle} = shift;
        if ($self->{_pSettle} eq "    CAB") {
            $self->{_pSettle} = 0;
        }
    }
    return $self->{_pSettle};
}

sub pVol {
    my $self = shift;
    if (@_) {
        $self->{_pVol} = shift;
    }
    if ($self->{_pVol} eq "") {
        return "NULL";
    }
    
    return $self->{_pVol};
}

sub oi {
    my $self = shift;
    if (@_) {
        $self->{_oi} = shift;
    }
    return $self->{_oi};
}

1;
