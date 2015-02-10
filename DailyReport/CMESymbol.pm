package CMESymbol;
use strict;
use warnings;

#my $futureTemplate = "A3A2A*";
my $optionTemplate = "A7A*";

my %actions;

sub new {
    my $class = shift;
    my $self = bless {}, $class;    
    $self->{strikeType} = "NA";
    $self->{strikeValue} = 0;
    $self->{week} = "";
    return $self;
}

sub symbolValues {
    my $class = shift;
    my $self = $class->new();
  
    my $symbolBase = shift;  
    my $type = shift;
    $self->{type} = $type;
    $self->{productDescription} = shift;
  
    $self->{monthyear} = shift;
    my $monthChar = shift;
    my $yearChar = shift;
    
    my @fields;
    my $strikeSymbol = "";
    if ($type eq "FOP") {
        my $line = shift;
        my $week = shift;
        if (defined$week && $week gt 0) {
            $self->{week} = $week;
        }
        else{
            $self->{week} = 0;
        }
        
        my $strikeType = shift;
        if (defined $strikeType) {      
            $self->{strikeType} = $strikeType;
        }
        if ($strikeType eq "CALL") {
            $strikeSymbol = "C";
        }
        elsif ($strikeType eq "PUT") {
            $strikeSymbol = "P";
        }

        if (defined $line) {
            @fields = unpack($optionTemplate, $line);
        }
        
        if (defined$fields[0]) {       
            $self->{strikeValue} = $fields[0];
        }
        $self->{symbol} = $symbolBase . $week . $monthChar . $yearChar. " " .$strikeSymbol . $self->{strikeValue};
    }
    elsif($type eq "F"){
        $self->{strikeType} = "NA";
        $self->{strikeValue} = "0";
        $self->{week} = 0;
        $self->{symbol} = $symbolBase . $monthChar . $yearChar;
    }
    return $self
}

sub monthyear {
    my $self = shift;
    if (@_) {
        $self->{_monthyear} = shift;
    }
    return $self->{_monthyear};
}
sub type {
    my $self = shift;
    if (@_) {
        $self->{_type} = shift;
    }
    return $self->{_type};
}


sub symbol {
    my $self = shift;
    if (@_) {
        $self->{_symbol} = shift;
    }
    return $self->{_symbol};
}

sub productDescription {
    my $self = shift;
    if (@_) {
        $self->{_productDescription} = shift;
    }
    return $self->{_productDescription};
}

sub week {
    my $self = shift;
    if (@_) {
        $self->{_week} = shift;
    }
    return $self->{_week};
}

sub strikeType {
    my $self = shift;
    if (@_) {
        $self->{_strikeType} = shift;
    }
    return $self->{_strikeType};
}

sub strikeValue {
    my $self = shift;
    if (@_) {
        $self->{_strikeValue} = shift;
    }
    return $self->{_strikeValue};
}

1;